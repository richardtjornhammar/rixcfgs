with (import <nixpkgs> {}).pkgs;
with lib;

let
  myPyPkgs = python37Packages.override {
    overrides = self: super: {
      pandas-datareader = super.buildPythonPackage rec {
        pname = "pandas-datareader";
        version = "0.9.0";
        doCheck = false;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "14gq0kx5b0dpvw5x0fw242dapgir52ljxbk7s4ggzfbadbhw3jxj";
        };
        buildInputs = with super;
          [ pandas numpy requests ];
      };
      impetuous-gfa = super.buildPythonPackage rec {
        pname = "impetuous-gfa";
        version = "0.22.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1n0sla7ha2c1akvcb63n7q09k63fdd8wjzi2vbrsa32jqdnfilzh";
        };
        buildInputs = with super;
          [ pandas numpy statsmodels scikitlearn scipy patsy ];
      };
    };
  };
in

stdenv.mkDerivation rec {
  name = "impetuous";
  buildInputs = (with myPyPkgs;
    [
      python impetuous-gfa scikitlearn
      scipy numpy pandas matplotlib bokeh
      statsmodels networkx ipython pandas-datareader
      jupyter
    ]);
  shellHook = ''
    echo "*****************************"
    echo "* WELCOME TO ${toUpper name} SHELL *"
    echo "*****************************"
  '';

}
