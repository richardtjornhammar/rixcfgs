let
  # use a specific version of the Nix package collection
  default_pkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/c6b3881520feb0c837cf5ae16d95d32277f41f60.tar.gz";
    sha256 = "10df7dl6h0dpfxkh22vgz4bn3wsd0yp2iyimmx3lwzwwf6y4ggf9";
  };
# function header: we take one argument "pkgs" with a default defined above
in { pkgs ? import default_pkgs { } }:
with pkgs;
##
##with (import <nixpkgs> {}).pkgs;
with lib;
let

  myPyPkgs = python39Packages.override {

    overrides = self: super: {

      localimpetuous = super.buildPythonPackage rec {
        name = "myimp";
        version = "0.97.0";
        src = ./impetuous-master;
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels ];
      };

      graphtastic = super.buildPythonPackage rec {
        pname = "graphtastic";
        version = "0.12.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "023dq9s8hdn0a6562f5520ck6wnh6kxdm4hwngh7c6lnlwvnkgqw";
        };
        buildInputs = with super;
          [ numpy scipy ];
      };

      impetuous = super.buildPythonPackage rec {
        pname = "impetuous-gfa";
        version = "0.97.2";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "17fkjiwq1lnv9mkypfkw6b47vqjpampxa4y8gxl7mifgn4kf0dai";
        };
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels ];
      };

    };
  };

  pythonBundle =
    python39.withPackages (ps: with ps; [ 
      numba scikit-learn numpy 
      ipython statsmodels 
      tensorflow tensorflow-probability tensorflow-tensorboard
      bokeh hvplot holoviews plotly 
      beautifulsoup4
      matplotlib seaborn graphviz
      datashader param colorcet
      panel pillow openpyxl imageio
      umap-learn
      pyspark pytorch
  ]);
in stdenv.mkDerivation rec {
  name = "OptClust";
  buildInputs = (with myPyPkgs;
    [
        pythonBundle #myPyPkgs.localimpetuous 
	myPyPkgs.impetuous 
	#myPyPkgs.graphtastic
    ]);
  src = null;
  shellHook = ''
    # Allow the use of wheels.
    SOURCE_DATE_EPOCH=$(date +%s)

    # Augment the dynamic linker path
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib:${readline}/lib

    echo "********************************"
    echo "* WELCOME TO ${name} SHELL *"
    echo "********************************"
    echo "HELLO DEAR DEV"
    echo "FOR CUSTOM PYTHON INCLUDE LIKE THIS:"
    echo ">>> import os,sys"
    # python3 test.py
  '';
}
