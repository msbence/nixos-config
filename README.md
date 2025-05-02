# nixos-config

## Re-install existing hosts

## Add new host

- echo -n "lukspw" > /tmp/secret.key
- sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /nixos-config/hosts/HOSTNAME/disk-config.nix
- nixos-generate-config --no-filesystems --root /mnt
- [...]
- mv ./cloned_dir /mnt/etc/nixos/
- nixos-install (--flake github:owner/repo#hostname)

## Upgrade host
