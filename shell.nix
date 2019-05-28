{ pkgs ? import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixos-unstable-2018-09-12";
    # Commit hash for nixos-unstable as of 2019-05-28
    url = https://github.com/nixos/nixpkgs/archive/e2883c31628ea0f3e00f899062327468a20d1aa1.tar.gz;
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "1xrpd8ykr8g3h4b33z69vngh6hfayi51jajbnfm6phhpwgd6mmld";
  }) {}
}:

let
  my-python3-packages = python-packages: with python-packages; [
    pyyaml
    jinja2
    pdfkit
    # other python packages you want
  ];
  python3-with-my-packages = pkgs.python3.withPackages my-python3-packages;

  my-python2-packages = python-packages: with python-packages; [
    pyyaml
    jinja2
    pdfkit
    # other python packages you want
  ];
  python2-with-my-packages = pkgs.python2.withPackages my-python2-packages;


in
pkgs.mkShell {
  buildInputs = with pkgs; [
    #python-with-my-packages
    python3-with-my-packages
    python2-with-my-packages
    docker-compose # requires Docker daemon to be up and running
    pssh
    awscli
    wkhtmltopdf
  ];
}
