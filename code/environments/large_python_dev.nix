with (import <nixpkgs> {}).pkgs;
with lib;

let
  myPyPkgs = python39Packages.override {
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
        version = "0.90.1";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "17mkb1h65jp41g84v8ip5ri0icdwn4jwcpgkfmw8kk9f222h287r";
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

      counterpartner = super.buildPythonPackage rec {
        pname = "counterpartner";
        version = "0.10.2";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0sfc59ycpq2j4y0c8k002h23arz6kidbvamhlmxfgrj38kxry0nx";
        };
        buildInputs = with super;
          [ pandas numpy statsmodels scikitlearn scipy ];
      };
    };
  };
in

stdenv.mkDerivation rec {
  name = "large-python-development";
  buildInputs = ( with myPyPkgs ;
    [
      python impetuous-gfa scikitlearn
      scipy numpy pandas bokeh numba
      statsmodels networkx ipython
      jupyter unidecode pytorch
      counterpartner
      righteuous-fa
      setuptools
      tensorflow
      Keras
      spark
    ]);
  src = null;  
  shellHook = ''
    # Allow the use of wheels.
    SOURCE_DATE_EPOCH=$(date +%s)

    # Augment the dynamic linker path
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib:${readline}/lib

    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit_10_1}/lib:${pkgs.cudnn_cudatoolkit_10_1}/lib:${pkgs.cudatoolkit_10_1.lib}/lib:$LD_LIBRARY_PATH
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' TMPDIR='$HOME' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.9/site-packages:$PYTHONPATH"
    export PATH="$(pwd)/_build/pip_packages/bin:$PATH"
    unset SOURCE_DATE_EPOCH

    echo "*****************************"
    echo "* WELCOME TO ${toUpper name} SHELL *"
    echo "*****************************"
    echo " PySpark shell is enabled enter with:"
    echo " user@computer ~/work$ pyspark "
    echo " Keras, pytorch and tensorflow are accesible"
  '';

}
