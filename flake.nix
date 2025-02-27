{
  inputs = {
    hm.url = "github:nix-community/home-manager/release-24.11";
    lix.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    wsl.url = "github:nix-community/nixos-wsl/main";
    wsl.inputs.nixpkgs.follows = "nixpkgs";
    lix.inputs.nixpkgs.follows = "nixpkgs";
    hm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, wsl, lix, hm }@inputs: {
    nixosConfigurations.amethyst = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";

      modules = [
        hm.nixosModules.default
        lix.nixosModules.default
        wsl.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
