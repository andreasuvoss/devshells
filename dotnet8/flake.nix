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

        shellHook = ''
          echo ".NET8 tools loaded"
        '';

        postShellHook = ''
        '';
      };
  };
}
