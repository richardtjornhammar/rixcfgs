# THIS FILE WAS AUTHORED SOLELY BY EDWARD TJÖRNHAMMAR
let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/NixOS/nixpkgs/archive/d5b5ff5ae5460ecc05ce86e50eeda0b5cc164ace.tar.gz";
    sha256 = "1vnqgg7rr69as93q01hym8n0v2m4i3sh5zw8c4hlnq5c3ha0cmpb";
  };
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (self: super: {
        # Try and update the version of openblas
        openblas = super.openblas.overrideAttrs (attrs: rec {
          name = pname + "-" + version;
          pname = "openblas";
          version = "0.3.3";
          src = super.fetchFromGitHub {
            owner = "xianyi";
            repo = "OpenBLAS";
            rev = "v" + version;
            sha256 = "ndPJ06D5R+AI51rkQ+8DB+eNbk4h1exiTbWTwLbb8zI=";
          };
        });
        rPackages = super.rPackages.override {
          overrides = {
            oligo = super.rPackages.oligo.overrideDerivation (oldAttrs: {
              PKG_LIBS = "-L${super.blas}/lib -lblas";
              nativeBuildInputs = super.lib.filter (e: (e) != super.openblas) (oldAttrs.nativeBuildInputs);
              buildInputs = super.lib.filter (e: (e) != super.openblas) (oldAttrs.buildInputs);
            });
            affy = super.rPackages.affy.overrideDerivation (oldAttrs: {
              PKG_LIBS = "-L${super.blas}/lib -lblas";
              nativeBuildInputs = super.lib.filter (e: (e) != super.openblas) (oldAttrs.nativeBuildInputs);
            });
          };
        };
      })
    ];
  };
in

with pkgs ;

mkShell {
  buildInputs = let
    R-with-packages = rWrapper.override {
      packages = with rPackages ;
        [
          R rmarkdown affycoretools affy
          pd_hg_u133_plus_2 
          clusterProfiler DOSE
          oligo pd_hta_2_0 glibc blas
        ];
      };
    in
  [
    R-with-packages
  ];
}
