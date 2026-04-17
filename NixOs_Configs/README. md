# NixOS Config — DESKTOP-K7M2PQR

## Structure

```
nixos-config/
├── flake.nix                        # Entry point
├── hosts/
│   └── default/
│       ├── configuration.nix        # Main system config
│       └── hardware-configuration.nix  # Generated on install (DO NOT commit UUIDs)
├── home/
│   └── default.nix                  # Home-manager entry point
└── modules/
    ├── nixos/
    │   ├── desktop.nix              # KDE Plasma, audio, packages
    │   ├── networking.nix           # NetworkManager, firewall
    │   └── security.nix            # Sudo, polkit, SSH
    └── home/
        ├── shell.nix               # Bash, aliases
        └── git.nix                 # Git identity
```

## Post-Install Steps

### 1. Copy config to /etc/nixos
```bash
sudo cp -r /path/to/nixos-config/* /etc/nixos/
```

### 2. Replace hardware-configuration.nix
After install, NixOS generates this automatically. Replace the placeholder:
```bash
sudo cp /etc/nixos/hardware-configuration.nix hosts/default/hardware-configuration.nix
```

### 3. Fill in LUKS UUIDs
Edit `hosts/default/configuration.nix` and replace:
- `REPLACE-WITH-ROOT-UUID` → UUID of your root LUKS partition
- `REPLACE-WITH-SWAP-UUID` → UUID of your swap LUKS partition

Find them with: `blkid`

### 4. Fill in Git identity
Edit `modules/home/git.nix`:
- Replace name and email

### 5. First rebuild
```bash
sudo nixos-rebuild switch --flake /etc/nixos#DESKTOP-K7M2PQR
```

### 6. Push to GitHub
```bash
cd /etc/nixos
git init
git add .
git commit -m "initial config"
git remote add origin git@github.com:YOUR-USERNAME/nixos-config.git
git push -u origin main
```

## Useful Aliases (after rebuild)
- `rebuild` — apply config changes
- `upgrade` — rebuild + upgrade nixpkgs

## Adding Tools Later
Add packages to `modules/nixos/desktop.nix` (system-wide) or `modules/home/shell.nix` (user-only).
