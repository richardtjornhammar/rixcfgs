with (import <nixpkgs> {}).pkgs;
with lib;

let
  myPyPkgs = python3Packages.override {
    overrides = self: super: {
      graphtastic = super.buildPythonPackage rec {
        pname = "graphtastic";
        version = "0.11.5";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0lz4z6r115gs3lqxiz47ly48lzvi02mcrp4al3k71gicjrfwdvjc";
        };
        buildInputs = with super;
          [ pytoml pytest jinja2 ];
      };
    };
  };
in

stdenv.mkDerivation rec {
  name = "flutter";
  buildInputs = (with myPyPkgs;
    [
      yarn yarn2nix
      python
      graphtastic
      glslang
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers
      flutter
      beautifulsoup4
      requests
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
