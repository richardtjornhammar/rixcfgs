#{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/commit/9b8530e3721fc008bacac61b6c50a29712ee2f2f.tar.gz") {} }:
#https://github.com/NixOS/nixpkgs/archive/3590f02e7d5760e52072c1a729ee2250b5560746.tar.gz
#") {} }:
with (import <nixpkgs> {}).pkgs;
with lib;

let
  myPyPkgs = python38Packages.override {
    overrides = self: super: {
      righteuous-fa = super.buildPythonPackage rec {
        pname = "righteous-fa";
        version = "1.2.1";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1qrbk8v2bxm8k6knx33vajajs8y2lsn77j4byviy7mh354xwzsc4";
        };
        buildInputs = with super;
          [ pandas numpy statsmodels scikitlearn scipy patsy ];
      };
      impetuous-gfa = super.buildPythonPackage rec {
        pname = "impetuous-gfa";
        version = "0.53.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "03drx1haf7lzr1jcczmqb3s6z4jc98g9f6z009dksfwaqxkdpibk";
        };
        buildInputs = with super;
          [ pandas numpy statsmodels scikitlearn scipy patsy ];
      };
      pypi-matplotlib = super.buildPythonPackage rec {
        pname = "matplotlib";
        version = "3.3.3";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1v5xwk8amb9b8lx383yy0mgkvzbnfh9d7c4arzjykky4frj0rdmi";
        };
        buildInputs = with super;
          [ numpy certifi ];
      };
    };
  };
in

stdenv.mkDerivation rec {
  name = "impetuous";
  buildInputs = (with myPyPkgs;
    [
      python impetuous-gfa scikitlearn
      scipy numpy pandas bokeh numba
      statsmodels networkx ipython
      jupyter righteuous-fa
    ]);
  src = null;  
  shellHook = ''
      # Allow the use of wheels.
    SOURCE_DATE_EPOCH=$(date +%s)

    # Augment the dynamic linker path
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib:${readline}/lib
    
    echo "*****************************"
    echo "* WELCOME TO ${toUpper name} SHELL *"
    echo "*****************************"
  '';

}
