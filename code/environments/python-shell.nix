{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    buildInputs = [ pkgs.python37 
                    pkgs.python37Packages.pandas 
                    pkgs.python37Packages.numpy 
                    pkgs.python37Packages.scikitlearn
                    pkgs.python37Packages.statsmodels ];
}
