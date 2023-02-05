{
  inputs,
  withSystem,
  module_args,
  ...
}: let
  sharedModules = [
    ../.
    ../shell
    module_args
  ];

  homeImports = {
    "schen@gramnix" =
      [
        inputs.hyprland.homeManagerModules.default
        ./gramnix
      ]
      ++ sharedModules;
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "schen@gramnix" = homeManagerConfiguration {
        modules = homeImports."schen@gramnix" ++ module_args;
        inherit pkgs;
      };
    });
  };
}
