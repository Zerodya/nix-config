# Secrets
This directory and its subdirectories (as defined in `.sops.yaml`) contain secrets that will be decrypted by the hosts that require them.

### Location of sops-nix configs
Actual sops-nix configuration is defined at the root directory of **each host**, for example:
- `hosts/server/HOSTNAME/sops.nix`

### Location of secrets decryption
Secrets are decrypted in a different `secrets.nix` file next to the service that needs them, for example: 
- `hosts/server/HOSTNAME/SERVICE/secrets.nix` should decrypt secrets required by services defined in `hosts/server/HOSTNAME/SERVICE/default.nix`

### How to add host keys
To add a key for a host so that it can access secrets, generate a new key for the host at `~/.config/sops/age/keys.txt`
- `mkdir -p ~/.config/sops/age/`
- `nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt`

get the public key:
- `nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt`

and add it to [`.sops.yaml`](../.sops.yaml) in this flake.

### How to update secrets
When adding a new host key to [`.sops.yaml`](../.sops.yaml), you may want to make old secrets accessible to the new host; to do so, you must update the secrets.

Inside a host that already has access to a secret, go to the flake directory (where [`.sops.yaml`](../.sops.yaml) is):
- `cd ~/nix-config/`

then update the keys of that secret with the new keys:
- `sops updatekeys ./secrets/SERVICE/mysecret.yaml`