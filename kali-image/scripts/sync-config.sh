#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "${script_dir}/.." && pwd)"
repo_root="$(cd "${root_dir}/.." && pwd)"

upstream_dir="${KALI_LIVE_DIR:-${root_dir}/upstream/live-build-config}"

profile="${PROFILE:-vm}"
install_hostname="${INSTALL_HOSTNAME:-kali}"
install_domain="${INSTALL_DOMAIN:-local.lan}"
install_locale="${INSTALL_LOCALE:-en_US.UTF-8}"
install_keymap="${INSTALL_KEYMAP:-us}"
install_timezone="${INSTALL_TIMEZONE:-Etc/UTC}"
install_username="${INSTALL_USERNAME:-kali}"
install_fullname="${INSTALL_FULLNAME:-Kali Operator}"
install_password_hash="${INSTALL_PASSWORD_HASH:-}"
grub_bootdev="${GRUB_BOOTDEV:-}"

case "${profile}" in
    vm)
        template="${root_dir}/preseed/vm.preseed.tmpl"
        install_disk="${INSTALL_DISK:-/dev/vda}"
        grub_bootdev="${grub_bootdev:-default}"
        ;;
    baremetal)
        template="${root_dir}/preseed/baremetal.preseed.tmpl"
        install_disk="${INSTALL_DISK:-}"
        if [[ -z "${install_disk}" ]]; then
            printf 'PROFILE=baremetal requires INSTALL_DISK to be set.\n' >&2
            exit 1
        fi
        grub_bootdev="${grub_bootdev:-${install_disk}}"
        ;;
    *)
        printf 'Unsupported PROFILE: %s\n' "${profile}" >&2
        exit 1
        ;;
esac

if [[ -z "${install_password_hash}" ]]; then
    printf 'INSTALL_PASSWORD_HASH is required. Generate one with: mkpasswd -m sha-512\n' >&2
    exit 1
fi

"${script_dir}/bootstrap-upstream.sh"

if [[ ! -x "${upstream_dir}/build.sh" ]]; then
    printf 'Expected build.sh in upstream checkout: %s\n' "${upstream_dir}" >&2
    exit 1
fi

escape_sed() {
    printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

package_list="$(
    sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "${root_dir}/packages/extra-packages.txt" |
        tr '\n' ' ' |
        sed -e 's/[[:space:]][[:space:]]*/ /g' -e 's/[[:space:]]*$//'
)"

preseed_target="${upstream_dir}/kali-config/common/debian-installer/preseed.cfg"
custom_root_target="${upstream_dir}/kali-config/common/includes.binary/custom-root"
bootcfg_target="${upstream_dir}/kali-config/common/includes.binary/isolinux/install.cfg"

mkdir -p "${upstream_dir}/kali-config"
cp -a "${root_dir}/kali-config/." "${upstream_dir}/kali-config/"

mkdir -p "${custom_root_target}/usr/local/bin"
mkdir -p "${custom_root_target}/usr/local/share/osint/browser"
mkdir -p "${custom_root_target}/etc/skel/Documents/OSINT/Firefox"

cp -f "${repo_root}/Scripts/ip_panel.sh" "${custom_root_target}/usr/local/bin/ip_panel.sh"
cp -f "${repo_root}/Scripts/WireGuard_cfg_batch_import.sh" "${custom_root_target}/usr/local/bin/WireGuard_cfg_batch_import.sh"
cp -f "${repo_root}/Scripts/.zhrc" "${custom_root_target}/etc/skel/.zshrc"
cp -f "${repo_root}/BrowserSetup/FireFox/bookmarks.html" "${custom_root_target}/usr/local/share/osint/browser/bookmarks.html"
cp -f "${repo_root}/BrowserSetup/FireFox/bookmarks.html" "${custom_root_target}/etc/skel/Documents/OSINT/Firefox/bookmarks.html"

chmod 0755 \
    "${custom_root_target}/usr/local/bin/ip_panel.sh" \
    "${custom_root_target}/usr/local/bin/WireGuard_cfg_batch_import.sh" \
    "${custom_root_target}/usr/local/sbin/osint-postinstall"

chmod 0644 \
    "${custom_root_target}/etc/skel/.zshrc" \
    "${custom_root_target}/usr/local/share/osint/browser/bookmarks.html" \
    "${custom_root_target}/etc/skel/Documents/OSINT/Firefox/bookmarks.html" \
    "${custom_root_target}/usr/local/share/osint/README.txt"

mkdir -p "$(dirname "${preseed_target}")"
sed \
    -e "s|@@LOCALE@@|$(escape_sed "${install_locale}")|g" \
    -e "s|@@KEYMAP@@|$(escape_sed "${install_keymap}")|g" \
    -e "s|@@HOSTNAME@@|$(escape_sed "${install_hostname}")|g" \
    -e "s|@@DOMAIN@@|$(escape_sed "${install_domain}")|g" \
    -e "s|@@TIMEZONE@@|$(escape_sed "${install_timezone}")|g" \
    -e "s|@@FULLNAME@@|$(escape_sed "${install_fullname}")|g" \
    -e "s|@@USERNAME@@|$(escape_sed "${install_username}")|g" \
    -e "s|@@PASSWORD_HASH@@|$(escape_sed "${install_password_hash}")|g" \
    -e "s|@@INSTALL_DISK@@|$(escape_sed "${install_disk}")|g" \
    -e "s|@@GRUB_BOOTDEV@@|$(escape_sed "${grub_bootdev}")|g" \
    -e "s|@@PKGSEL_INCLUDE@@|$(escape_sed "${package_list}")|g" \
    "${template}" > "${preseed_target}"

sed \
    -e "s|@@BOOT_LOCALE@@|$(escape_sed "${install_locale}")|g" \
    -e "s|@@BOOT_KEYMAP@@|$(escape_sed "${install_keymap}")|g" \
    -e "s|@@BOOT_HOSTNAME@@|$(escape_sed "${install_hostname}")|g" \
    -e "s|@@BOOT_DOMAIN@@|$(escape_sed "${install_domain}")|g" \
    "${root_dir}/kali-config/common/includes.binary/isolinux/install.cfg" > "${bootcfg_target}"

printf 'Synced Kali image config to %s\n' "${upstream_dir}"
printf 'Profile: %s\n' "${profile}"
printf 'Install disk: %s\n' "${install_disk}"
printf 'Rendered preseed: %s\n' "${preseed_target}"
