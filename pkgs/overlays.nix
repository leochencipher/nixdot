inputs: _: prev: {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  discord-canary = prev.callPackage ./discord.nix {
    pkgs = prev;
    inherit inputs;
    inherit (prev) lib;
  };

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  material-symbols = prev.callPackage ./material-symbols.nix {};

  TL = prev.callPackage ./TL {};

  waveform = prev.callPackage ./waveform {};

  spotify = prev.callPackage ./spotify {};

}
