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

