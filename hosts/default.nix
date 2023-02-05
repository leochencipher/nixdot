{
  inputs,
  withSystem,
  sharedModules,
  desktopModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({system, ...}: {
    gramnix = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./gramnix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          inputs.hm.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.schen.imports = homeImports."schen@gramnix";
          }
        ]
        ++ sharedModules
        ++ desktopModules;
    };
  });
}
