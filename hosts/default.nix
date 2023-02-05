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
          {home-manager.users.schen.imports = homeImports."schen@gramnix";}
          inputs.waveforms-flake.nixosModule
        ]
        ++ sharedModules
        ++ desktopModules;
    };

  });
}
