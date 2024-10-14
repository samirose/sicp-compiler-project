{
  description = "Development shell for samirose/sicp-compiler-project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.bash
          pkgs.gnumake
          pkgs.guile
          pkgs.wabt
          pkgs.wasmtime
        ];
      };
      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
