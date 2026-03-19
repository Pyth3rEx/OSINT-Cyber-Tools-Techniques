# OSINT-Cyber-Tools-Techniques

Curated OSINT references, operator-focused helper scripts, and a reproducible scaffold for building a custom Kali installer ISO.

This repository is organized as a working toolkit rather than a traditional software application. It combines:

- A large Firefox bookmark collection for OSINT and cyber investigation workflows
- Shell helpers for day-to-day Kali usage
- A repo-managed Kali image pipeline for unattended VM and bare-metal installs

## Overview

The project is intended to keep frequently used research resources and workstation bootstrap material in one place. The current repo centers on three practical areas:

- `BrowserSetup/`
  Firefox bookmarks for OSINT, monitoring, recon, mapping, verification, and country-specific research
- `Scripts/`
  Small utilities and shell configuration used on Kali systems
- `kali-image/`
  A reproducible scaffold for building a custom Kali installer ISO with unattended install support

## Repository Layout

```text
.
├── BrowserSetup/
│   └── FireFox/
│       └── bookmarks.html
├── Scripts/
│   ├── .zhrc
│   ├── ip_panel.sh
│   └── WireGuard_cfg_batch_import.sh
└── kali-image/
    ├── kali-config/
    ├── packages/
    ├── preseed/
    ├── scripts/
    └── README.md
```

## Included Components

### Firefox OSINT Bookmarks

The Firefox bookmark export in [`BrowserSetup/FireFox/bookmarks.html`](BrowserSetup/FireFox/bookmarks.html) is the main reference asset in this repo.

It is structured around practical investigation categories such as:

- Search engines and advanced searching
- Social media and forum research
- Person-of-interest search
- Area and event monitoring
- Corporate profiling and website OSINT
- Image, mapping, and geospatial tools
- Country-specific registries
- AI, crypto, reporting, and verification tools

### Helper Scripts

The `Scripts/` directory contains a small set of Kali-focused utilities:

- [`Scripts/ip_panel.sh`](Scripts/ip_panel.sh)
  Emits local IP, VPN status, and public IP for XFCE Genmon
- [`Scripts/WireGuard_cfg_batch_import.sh`](Scripts/WireGuard_cfg_batch_import.sh)
  Batch-imports WireGuard `.conf` files into NetworkManager
- [`Scripts/.zhrc`](Scripts/.zhrc)
  Personal `zsh` configuration for Kali shells

## Custom Kali Image

The repo includes a build scaffold for producing a custom Kali installer ISO from repo-managed configuration.

The design goal is straightforward:

- Keep customizations in this repository
- Sync them into an upstream Kali `live-build-config` checkout
- Render a profile-specific `preseed.cfg`
- Build an unattended installer ISO for VMs or bare-metal installs

The image scaffold lives in [`kali-image/`](kali-image/) and is documented in [`kali-image/README.md`](kali-image/README.md).

### What the image scaffold currently handles

- VM-oriented unattended installs
- Bare-metal unattended installs with explicit disk selection
- Inclusion of repo-managed shell config and helper scripts
- Staging of the Firefox bookmark export into the installed system
- Basic package list customization

### Quick start

```bash
INSTALL_USERNAME=analyst \
INSTALL_FULLNAME="OSINT Analyst" \
INSTALL_PASSWORD_HASH='your_sha512_hash' \
./kali-image/scripts/build-installer.sh
```

For full variables, profiles, and build notes, see [`kali-image/README.md`](kali-image/README.md).

## Usage Notes

- This repository is best treated as a personal or team toolkit baseline, not a finished product.
- The bookmark collection is intentionally broad; you should still validate operational relevance, trust, and legality for your environment.
- The unattended installer path is designed to be practical and reproducible, but you should test any profile in a VM before using it on hardware.

## Requirements

For the Kali image build workflow, you will need a Kali or Debian-based build host with the required packaging tools installed. The detailed package list and setup flow are documented in [`kali-image/README.md`](kali-image/README.md).

## License

This repository is licensed under the terms in [`LICENSE`](LICENSE).
