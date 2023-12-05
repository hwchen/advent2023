{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };


  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      # TODO: only needed when nixpkgs is not up to date.
      odin-overlay = self: super: {
        odin = super.odin.overrideAttrs (old: rec {
          version = "dev-2023-11";
          src = super.fetchFromGitHub {
            owner = "odin-lang";
            repo = "Odin";
            rev = "${version}";
            sha256 = "sha256-5plcr+j9aFSaLfLQXbG4WD1GH6rE7D3uhlUbPaDEYf8=";
          };

          nativeBuildInputs = with super; [ makeWrapper which ];

          LLVM_CONFIG = "${super.llvmPackages.llvm.dev}/bin/llvm-config";
          postPatch = ''
            sed -i 's/^GIT_SHA=.*$/GIT_SHA=/' build_odin.sh
            sed -i 's/LLVM-C/LLVM/' build_odin.sh
            patchShebangs build_odin.sh
          '';

          installPhase = old.installPhase + "cp -r vendor $out/bin/vendor";
        });
      };

      ols-overlay = self: super: {
        ols = super.ols.overrideAttrs (old: rec {
          version = "nightly-2023-11-28-f0744a6";
          src = super.fetchFromGitHub {
            owner = "DanielGavin";
            repo = "ols";
            rev = "f0744a676a1806cbb7ffd55ad657163fc73e83e0";
            sha256 = "sha256-7GQUkzn5+JuSE1+aNr3W4rLdZ2UEBmt+VpKjKvz4bAY=";
          };

          installPhase = old.installPhase;
        });
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (odin-overlay) (ols-overlay)
        ];
      };

      lib = pkgs.lib;
      in {
        devShells.default = pkgs.mkShell {
        nativeBuildInputs = [
        pkgs.odin
        pkgs.ols
        ];
        # for ols
        ODIN_ROOT = "${pkgs.odin}/share";
      };
    });
}
