{
  description = ".NET8 tool chain";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
  };

  outputs = { self, nixpkgs }@inputs:
  let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
  in
  {
      # Because azure-function-core-tools uses a hardcoded /bin/bash path I need to make a symlink in NixOS
      # sudo ln -s /run/current-system/sw/bin/bash /bin/bash
      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = with pkgs; [
          bash
          netcoredbg
          azure-functions-core-tools
          (with dotnetCorePackages; combinePackages [
            sdk_6_0_1xx # need for function cli???
            sdk_8_0_1xx
          ])
        ];

        NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          openssl
          icu
          bash
          stdenv.cc.cc
        ];

        NIX_LD = builtins.readFile "${pkgs.stdenv.cc}/nix-support/dynamic-linker";

        shellHook = ''
          echo ".NET8 tools loaded"
        '';

        postShellHook = ''
        '';
      };
  };
}
