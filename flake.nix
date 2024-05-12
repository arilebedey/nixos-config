{
  description = "A very basic flake";

  inputs = {
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
  };

  outputs = { self, nixpkgs }:
  # outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      # pkgs = "nixpkgs.legacyPackages.${system}";
      # pkgs-unstable = "nixpkgs-unstable.legacyPackages.${system}";
      # overlay-davinci-resolve = old: prev: {
      #   davinci-resolve = prev.davinci-resolve.override (old: {
      #     buildFHSEnv = a: (old.buildFHSEnv (a // {
      #       extraBwrapArgs = a.extraBwrapArgs ++ [
      #         "--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL"
      #       ];
      #     }));
      #   });
      # };
    in {
      nixosConfigurations = {
        ncs = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
          # specialArgs = {
          #   inherit pkgs-unstable;
          # };
        };
      };
    };
}
