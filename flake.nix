{
  inputs = {
    coq-nix-toolbox.flake = false;
    coq-nix-toolbox.url = "github:coq-community/coq-nix-toolbox/447fd9da2820c66dee263a327d62f3f3e9da2688";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
    systems = inputs.nixpkgs.lib.systems.flakeExposed;
    perSystem = { pkgs, config, system, ... }: rec {
      overlayAttrs = { inherit (config.packages) trocq; };
      packages.trocq = import inputs.coq-nix-toolbox { src = ./.; };
      devShells.default = pkgs.mkShell { nativeBuildInputs = [ packages.trocq ]; };
    };
  };
}
