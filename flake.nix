{
  description = "syntaxSemanticsAdjoint description";
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs-stable }:
    let
      pkgs = import nixpkgs-stable { system = "x86_64-linux"; };
      haskellPackages =  pkgs.haskell.packages."ghc924";
      myAgda = pkgs.agda.withPackages (ps: [
        ps.standard-library
      ]);
      syntaxSemanticsAdjoint = pkgs.agdaPackages.mkDerivation {
        pname = "syntaxSemanticsAdjoint";
        version = "0.1";
        meta = { };
        src = ./.;
        buildInputs = [ myAgda ];
      };
    in
    {
      packages.x86_64-linux.default = syntaxSemanticsAdjoint;
      defaultPackage = syntaxSemanticsAdjoint;
      devShell."x86_64-linux" = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          myAgda
          emacsPackages.agda2-mode
          # (pkgs.haskellPackages.callHackage "agda-language-server" "0.2.1" {}) # This fails
        ];
      };

      # devShells."x86_64-linux".default = with pkgs; mkShell {
      #   packages = [ (agda.withPackages [ agdaPackages.standard-library ])
      #              ];
      # };
      # packages.x86_64-linux.default = with pkgs; (agda.withPackages [ agdaPackages.standard-library ]);

    };
}
