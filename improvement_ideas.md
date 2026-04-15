# NixOS Config — Improvement Ideas

Organized by priority. Each item explains **what the problem is**, **why it matters**, and **how to fix it**.

---

## 🔴 Security — Fix First

### 1. Secret Management with `sops-nix`

**Problem:** Two secrets currently live unsafely:
- The LUKS password is typed in plaintext (`echo -n "lukspw" > /tmp/secret.key`) during installation
- The hashed password in `system-modules/users/default.nix` is stored in the git repo — a hash leak

**Why it matters:** Anyone with read access to your git repo gets the password hash. Hash cracking is feasible.

**Fix:** Add [`sops-nix`](https://github.com/Mic92/sops-nix) to your flake. It encrypts secrets with your SSH/GPG key; they're only decryptable on the machine that has the private key.

```nix
# flake.nix inputs
sops-nix.url = "github:Mic92/sops-nix";

# system-modules/users/default.nix — instead of hashedPassword = "..."
users.users.${userProperties.username} = {
  hashedPasswordFile = config.sops.secrets."user-password".path;
};

sops.secrets."user-password" = {};  # reads from .sops.yaml encrypted file
```

You'd create one encrypted `.yaml` file per host containing its secrets, committed safely to git.

---

## 🟠 Structure — High Value

### 2. Make `systemProperties` a Typed NixOS Option

**Problem:** `systemProperties` is a plain Nix attrset passed as `specialArgs`. This means:
- No type checking — typo `"Destkop"` silently fails
- No documentation
- Modules can't validate it or set defaults

**Fix:** Define it as a submodule option in `options.nix`:

```nix
# system-modules/options.nix — add at the top
options.systemProperties = {
  architecture = lib.mkOption {
    type = lib.types.enum [ "x86_64-linux" "aarch64-linux" ];
    default = "x86_64-linux";
  };
  type = lib.mkOption {
    type = lib.types.enum [ "desktop" "laptop" "server" ];
    description = "Machine role — controls most module defaults";
  };
  hostname = lib.mkOption {
    type = lib.types.str;
  };
};
```

Then in `hosts/<name>/default.nix`, set it via the module system:
```nix
# configuration.nix or a new host-meta.nix
systemProperties.type = "desktop";
systemProperties.hostname = "my-machine";
```

> [!NOTE]
> This is a bigger refactor. The current approach works fine for now — do this when you add a second host, since the friction of the refactor pays off more with multiple machines.

### 3. Move Wayland/Hyprland Variables Out of `user-modules/default.nix`

**Problem:** The base `user-modules/default.nix` hardcodes Hyprland session variables for **every** user on **every** host, including servers.

```nix
# currently in user-modules/default.nix — wrong place!
sessionVariables = {
  XDG_SESSION_TYPE    = "wayland";
  XDG_CURRENT_DESKTOP = "Hyprland";
  NIXOS_OZONE_WL      = "1";
  # ...
};
```

**Fix:** Create `user-modules/hyprland/default.nix` and move these there. The base `default.nix` should only contain truly universal settings (e.g. `EDITOR`).

```nix
# user-modules/hyprland/default.nix
{ ... }:
{
  home.sessionVariables = {
    XDG_SESSION_TYPE    = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL      = "1";
    QT_QPA_PLATFORM     = "wayland";
    SDL_VIDEODRIVER     = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
```

This follows the same pattern as everything else and makes the Hyprland user module actually toggle-able later.

### 4. Add Home Manager Impermanence for the User

**Problem:** The system-side impermanence is well set up, but your **home directory** (`/home/raptor`) isn't persisted. After a reboot, all user state that isn't managed by Home Manager declaratively would be lost.

**Fix:** Add a `user-modules/impermanence/default.nix`:

```nix
{ userProperties, ... }:
{
  home.persistence."/persisted/home/${userProperties.username}" = {
    allowOther = true;
    directories = [
      "Downloads"
      "Documents"
      "Pictures"
      "Videos"
      ".ssh"
      ".gnupg"
      ".config/spotify"
      ".mozilla"
      # add more as needed
    ];
    files = [
      ".bash_history"
      ".zsh_history"
    ];
  };
}
```

> [!IMPORTANT]
> This requires the `impermanence` HM module to be imported. In `user-modules/default.nix` add:
> `imports = [ inputs.impermanence.homeManagerModules.impermanence ];`

### 5. Actually Use `nixos-hardware`

**Problem:** `nixos-hardware` is in `flake.inputs` but never referenced anywhere. It provides pre-made hardware quirk modules for many laptops/desktops.

**Fix:** In each host's `default.nix` modules list, add the relevant hardware module:

```nix
# Example for a ThinkPad X1 Carbon Gen 9
inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-carbon-gen9
```

Browse available modules at: https://github.com/NixOS/nixos-hardware

---

## 🟡 Quality of Life

### 6. Add a Formatter to the Flake

**Problem:** There's no standard formatter enforced. Nix code style can drift as the repo grows.

**Fix:** Add `alejandra` (the de-facto Nix formatter) as a flake output:

```nix
# flake.nix outputs
formatter = nixpkgs.legacyPackages.x86_64-linux.alejandra;
```

Then run `nix fmt` from the repo root to auto-format everything.

### 7. Add `nixos-anywhere` to the README

**Problem:** The README install flow requires being on a live NixOS boot, which is cumbersome.

**Fix:** [`nixos-anywhere`](https://github.com/nix-community/nixos-anywhere) lets you provision a new machine entirely over SSH from any machine (including your mac/windows box with WSL). Works well with disko.

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#new-hostname \
  root@<target-ip>
```

### 8. Add an Empty `userOptions` in `options.nix`

**Problem:** `userProperties` has no validation (same issue as `systemProperties`). Small additions like `shell`, `sshKeys`, or `gpgKey` currently have to be tracked manually.

**Fix:** Add a `userOptions` section to `options.nix` (similar to `systemOptions`) that at minimum declares the user's GPG key and default shell, so modules like `git/` can read it cleanly:

```nix
options.userOptions = with lib; {
  gpgKey = mkOption {
    type = types.str;
    description = "Primary GPG key fingerprint for signing";
  };
  defaultShell = mkOption {
    type = types.enum [ "bash" "zsh" "fish" ];
    default = "bash";
  };
};
```

The `git/` user module currently hardcodes the GPG key inline — that would move here.

### 9. Extract the `boot` and `display` Options

**Problem:** `system-modules/options.nix` has empty sections for `AUDIO`, `BLUETOOTH`, `BOOT`, `COMPATIBILITY`, `DISPLAY`, and `USERS` — module directories exist but no options are declared, so the modules have no toggle mechanism.

**Fix:** This isn't urgent, but as you flesh out those modules, add the corresponding options to `options.nix`. The pattern is already established — it's just a matter of doing it consistently.

---

## Summary Table

| # | What | Priority | Effort |
|---|---|---|---|
| 1 | Secret management (`sops-nix`) | 🔴 Security | Medium |
| 2 | `systemProperties` as typed option | 🟠 Structure | Medium |
| 3 | Move Hyprland vars to its own module | 🟠 Structure | Low |
| 4 | HM impermanence for user home | 🟠 Structure | Low |
| 5 | Actually use `nixos-hardware` | 🟠 Structure | Low |
| 6 | Add `alejandra` formatter | 🟡 QoL | Trivial |
| 7 | Add `nixos-anywhere` to README | 🟡 QoL | Trivial |
| 8 | `userOptions` in `options.nix` | 🟡 QoL | Low |
| 9 | Fill in empty `options.nix` sections | 🟡 QoL | Ongoing |

> [!TIP]
> **Suggested order:** Do #3 and #4 now since they're low-effort and needed before adding real hosts. Do #1 (sops-nix) before you commit any real passwords. Do #2 later when you have 2+ hosts and feel comfortable with the module system.
