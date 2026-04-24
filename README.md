# nixos-config

## Re-install existing hosts

- git clone ssh://git@gitlab.mbraptor.tech:2222/raptor/nixos-config.git
- cd nixos-config
- echo -n "lukspw" > /tmp/secret.key
- sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --yes-wipe-all-disks ./hosts/HOSTNAME/disk-configuration.nix
- [...]
- sudo nixos-install --flake .#hostname

## Add new host

- git clone ssh://git@gitlab.mbraptor.tech:2222/raptor/nixos-config.git
- cd nixos-config
- echo -n "lukspw" > /tmp/secret.key
- sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --yes-wipe-all-disks ./hosts/HOSTNAME/disk-configuration.nix
- sudo nixos-generate-config --no-filesystems --root /mnt
- [...]
- sudo nixos-install --flake .#hostname

## Upgrade host


# stuff

- mkdir -p copy/var/lib/sops-nix
- age-keygen
- cp age-key.txt copy/var/lib/sops-nix/key.txt
- echo -n "lukspw" > /tmp/secret.key
- nix run github:nix-community/nixos-anywhere -- --flake .#vm-nixos-test --disk-encryption-keys /tmp/secret.key /tmp/secret.key --extra-files ./copy --target-host root@192.168.8.157
- nix run github:nix-community/nixos-anywhere -- --flake .#vm-nixos-test --build-on remote --build-on-remote --disk-encryption-keys /tmp/secret.key /tmp/secret.key --extra-files ./copy --target-host root@192.168.8.157
