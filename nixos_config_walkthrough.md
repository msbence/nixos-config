# NixOS Config — Repo Walkthrough

## Big Picture

This is a **NixOS flake** that manages one or more machines declaratively.
The flake auto-discovers host directories and wires together per-host config with shared, reusable system- and user-level modules.

```
nixos-config-wip/
├── flake.nix              ← entry point, auto-discovers hosts/
├── flake.lock
├── hosts/
│   └── vm-nixos-test/     ← one directory per machine
│       ├── default.nix            (host entry point & properties)
│       ├── configuration.nix      (nix/nixpkgs base settings)
│       ├── disk-configuration.nix (disko partition layout)
│       ├── hardware-configuration.nix (nixos-generate-config output)
│       └── overrides.nix          (host-specific option overrides)
├── system-modules/        ← NixOS (system-level) modules
│   ├── default.nix        (auto-imports every subdirectory)
│   ├── options.nix        (declares all systemOptions.* options)
│   ├── audio/
│   ├── bluetooth/
│   ├── boot/
│   ├── compatibility/
│   ├── display/
│   ├── fonts/
│   ├── hardware/
│   ├── impermanence/
│   ├── locale/
│   ├── networking/
│   ├── power/
│   ├── printing/
│   ├── security/
│   ├── users/
│   └── virtualisation/
└── user-modules/          ← Home Manager (user-level) modules
    ├── default.nix        (HM entry point, auto-imports subdirs)
    └── git/
        └── default.nix
```

---

## How the Flake Wires Everything Together

### `flake.nix`

```
hosts/ directory
  → filter for directories only          (each dir = one host)
  → map hostname → nixosSystem call      (calls hosts/<name>/default.nix)
  → listToAttrs                          (produces nixosConfigurations attrset)
```

**Inputs used:**
| Input | Purpose |
|---|---|
| `nixpkgs` (24.11) | Core package set |
| `nixos-hardware` | Hardware quirk modules |
| `disko` | Declarative disk partitioning |
| `impermanence` | Ephemeral root / persisted paths |
| `home-manager` (24.11) | Per-user dotfile management |

---

## Per-Host Layout (`hosts/<hostname>/`)

### `default.nix` — the host entry point

This is where a host's **identity** is declared:

```nix
systemProperties = {
  architecture = "x86_64-linux";
  hostname     = builtins.baseNameOf ./.;   # derived from directory name!
  type         = "desktop";                 # or "server"
};

userProperties = rec {
  username   = "raptor";
  fullName   = "Bence Madarasz";
  emailUser  = "msbence.kfg";
  emailDomain = "gmail.com";
  email      = "${emailUser}@${emailDomain}";
};
```

Both property sets are passed as `specialArgs` and become available in **every** module via the function argument list.

It also assembles the full module list:

```nix
modules = [
  ./hardware-configuration.nix   # nixos-generate-config output
  disko.nixosModules.disko
  ./disk-configuration.nix       # partition layout
  impermanence.nixosModules.impermanence
  ./configuration.nix            # nix settings + stateVersion
  ../../system-modules/default.nix
  home-manager.nixosModules.home-manager
  ../../user-modules/default.nix
  ./overrides.nix                # last-word, host-specific overrides
];
```

### `configuration.nix`
Global nix daemon settings: flakes, auto-optimise-store, GC, `allowUnfree`. Kept minimal — everything feature-related lives in system-modules.

### `overrides.nix`
Uses `mkForce` to override the defaults set by system-modules. For `vm-nixos-test` this enables fingerprint auth, disables the firewall, caps CPU perf, and forces SSH on.

---

## System Modules (`system-modules/`)

### `default.nix` — auto-importer

```nix
imports =
  lib.lists.map (dir: ./${dir})
    (builtins.attrNames (lib.attrsets.filterAttrs (_: t: t == "directory") (builtins.readDir ./.)))
  ++ [ ./options.nix ];
```

Every **subdirectory** is imported automatically. You just create a new folder with a `default.nix` and it's picked up — no registration needed.

### `options.nix` — the control panel

Declares all `systemOptions.*` options with smart defaults based on `systemProperties.type`:

| Option | Desktop default | Server default |
|---|---|---|
| `enableNetworkManager` | `true` | `false` |
| `enableSsh` | `false` | `true` |
| `enableDocker` | `true` | `false` |
| `enableAutologin` | `true` | `false` |
| `timeZone` | `Europe/Vienna` | `Etc/UTC` |
| `enableFirewall` | `true` | `true` |
| … | … | … |

Each module then reads `config.systemOptions.*` to conditionally apply its settings.

### Example — `networking/default.nix`

```nix
networking.networkmanager.enable = config.systemOptions.enableNetworkManager;
networking.hostName               = systemProperties.hostname;   # auto-named!

users.users.${userProperties.username}.extraGroups =
  lib.optionals config.systemOptions.enableNetworkManager [ "networkmanager" ]
  ++ lib.optionals config.systemOptions.enableWireshark   [ "wireshark" ];

environment.persistence."/persisted/system".directories =
  lib.optionals config.systemOptions.enableNetworkManager
    [ "/etc/NetworkManager/system-connections" ];
```

Note how **impermanence** persistence entries are added inline by the module that needs them — a clean pattern.

---

## User Modules (`user-modules/`)

### `default.nix` — Home Manager entry

Sets up the HM configuration for the user defined in `userProperties`:
- Sets `homeDirectory`, `username`, `stateVersion`
- Sets Wayland/Hyprland session variables
- Auto-imports every subdirectory (same pattern as system-modules)

```nix
home-manager.users.${userProperties.username} = {
  home.username      = userProperties.username;
  home.homeDirectory = "/home/${userProperties.username}";

  imports = lib.lists.map (dir: ./${dir})
    (builtins.attrNames (lib.attrsets.filterAttrs (_: t: t == "directory") (builtins.readDir ./.)));
};
```

### Currently implemented user modules
- **`git/`** — configures `programs.git` with name, email, GPG signing key from `userProperties`

---

## Impermanence

The setup uses an ephemeral `/` (wiped on boot) with a persistent `/persisted` mountpoint.
- **System state** → `/persisted/system` (e.g. SSH host keys, machine-id, NetworkManager connections, logs)
- **User home** → `/persisted/home/<user>` (managed by HM's persistence — not yet visible but the HM module is the right place)
- Each system module contributes its own persistence entries where relevant

---

## Adding a New Host

1. Create `hosts/<new-hostname>/` directory (the flake picks it up automatically from the dir name).
2. Copy `hosts/vm-nixos-test/default.nix` and adjust `systemProperties` and `userProperties`.
3. Generate `hardware-configuration.nix` with `nixos-generate-config --no-filesystems --root /mnt`.
4. Write `disk-configuration.nix` (disko format) for the machine's disk layout.
5. Keep `configuration.nix` as-is (or copy it).
6. Add an `overrides.nix` for anything that differs from the module defaults.
7. Install: `nixos-install --flake .#<new-hostname>`.

---

## Adding a New User Module

1. Create `user-modules/<name>/default.nix`.
2. Accept `{ pkgs, userProperties, ... }:` (and `inputs` if needed).
3. Write the Home Manager config inside the file body — it's already scoped to the right user by `user-modules/default.nix`.
4. No registration needed — the auto-importer picks it up.

**Example skeleton:**
```nix
{ pkgs, userProperties, ... }:
{
  programs.myapp = {
    enable = true;
    # ...
  };
}
```

---

## Adding a New System Module

1. Create `system-modules/<name>/default.nix`.
2. If the module needs a toggle, add an option to `system-modules/options.nix` first.
3. Accept `{ config, lib, pkgs, systemProperties, userProperties, ... }:`.
4. Use `lib.mkIf config.systemOptions.<yourOption>` to guard the settings.
5. Add persistence entries inline if the module creates stateful data.

**Example skeleton:**
```nix
{ config, lib, pkgs, ... }:
{
  services.myservice = lib.mkIf config.systemOptions.enableMyService {
    enable = true;
  };

  environment.persistence."/persisted/system".directories =
    lib.optionals config.systemOptions.enableMyService [ "/var/lib/myservice" ];
}
```
