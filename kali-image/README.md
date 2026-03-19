# Custom Kali Image

This directory turns the repo into a reproducible source for a custom Kali installer ISO.

The design is simple:

- Keep personal assets and install logic in this repo.
- Sync them into an upstream Kali `live-build-config` checkout before build.
- Build an Installer ISO with a rendered `preseed.cfg`.

## What gets installed

These existing repo assets are staged onto the ISO and copied into the installed system during `late_command`:

- `Scripts/ip_panel.sh` -> `/usr/local/bin/ip_panel.sh`
- `Scripts/WireGuard_cfg_batch_import.sh` -> `/usr/local/bin/WireGuard_cfg_batch_import.sh`
- `Scripts/.zhrc` -> `/etc/skel/.zshrc` and the created user's home
- `BrowserSetup/FireFox/bookmarks.html` -> `/usr/local/share/osint/browser/bookmarks.html` and `~/Documents/OSINT/Firefox/bookmarks.html`

## Why this uses `includes.binary`

For unattended installer images, the practical path is:

- stage repo-managed files onto the ISO under `kali-config/common/includes.binary/`
- copy them into `/target` from the installer with `preseed/late_command`

That is more reliable for installer ISOs than treating the build like a live image overlay.

## Quick start

1. Install the builder prerequisites on a Kali or Debian-based host:

```bash
sudo apt update
sudo apt install -y git live-build simple-cdd cdebootstrap curl whois
```

2. Generate a password hash:

```bash
mkpasswd -m sha-512
```

3. Build a VM-oriented unattended installer:

```bash
INSTALL_USERNAME=analyst \
INSTALL_FULLNAME="OSINT Analyst" \
INSTALL_PASSWORD_HASH='$6$replace_me' \
./kali-image/scripts/build-installer.sh
```

4. Build a bare-metal unattended installer:

```bash
PROFILE=baremetal \
INSTALL_DISK=/dev/nvme0n1 \
INSTALL_USERNAME=analyst \
INSTALL_FULLNAME="OSINT Analyst" \
INSTALL_PASSWORD_HASH='$6$replace_me' \
./kali-image/scripts/build-installer.sh
```

## Important variables

- `PROFILE=vm|baremetal`
- `INSTALL_DISK=/dev/vda|/dev/sda|/dev/nvme0n1`
- `INSTALL_USERNAME`
- `INSTALL_FULLNAME`
- `INSTALL_PASSWORD_HASH`
- `INSTALL_HOSTNAME` default: `kali`
- `INSTALL_DOMAIN` default: `local.lan`
- `INSTALL_LOCALE` default: `en_US.UTF-8`
- `INSTALL_KEYMAP` default: `us`
- `INSTALL_TIMEZONE` default: `Etc/UTC`
- `GRUB_BOOTDEV` default: `default` for VMs, `INSTALL_DISK` for bare metal
- `KALI_LIVE_DIR` default: `kali-image/upstream/live-build-config`

## Files you are expected to edit

- [extra-packages.txt](packages/extra-packages.txt)
- [vm.preseed.tmpl](preseed/vm.preseed.tmpl)
- [baremetal.preseed.tmpl](preseed/baremetal.preseed.tmpl)

## Notes

- Default VM disk is `/dev/vda`.
- Bare metal intentionally requires an explicit `INSTALL_DISK`.
- The automated boot entry is scaffolded in `isolinux`, which covers BIOS boot. Kali's installer-side UEFI menu customization is less clean in the current build pipeline, so BIOS automation is the guaranteed path in this scaffold.
- If you later want fully reproducible VM artifacts, add Packer on top of this ISO rather than replacing it.
