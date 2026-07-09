{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = inputs@{ self, nixpkgs, noctalia, home-manager, ... }: {
    nixosConfigurations.minhchaupc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.default
        {
          home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.minhchau = import ./home.nix; # replace <USERNAME> with your actual username
              backupFileExtension = "bak";
            };
        }
      ];
    };
  };
}

