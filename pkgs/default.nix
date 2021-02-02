{ overlays ? [ ], ... }@args:
let
  lock = builtins.fromJSON (builtins.readFile ../flake.lock);

  nixpkgs = fetchTarball (with lock.nodes.nixpkgs.locked; {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  });

  androidPkgs = fetchTarball (with lock.nodes.androidPkgs.locked; {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  });

in
import nixpkgs ({
  overlays = overlays ++ [
    (self: super: {
      androidPkgs = import androidPkgs {};
    })
    (import ./overlay.nix)
  ];
} // builtins.removeAttrs args [ "overlays" ])
