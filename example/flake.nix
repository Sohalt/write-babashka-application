{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.wbba.url = "github:sohalt/write-babashka-application";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    nixpkgs,
    flake-utils,
    wbba,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [wbba.overlays.default];
      };
      hello-babashka = pkgs.writeBabashkaApplication {
        runtimeInputs = with pkgs; [
          # add your dependencies here
          cowsay
        ];
        name = "hello";
        text = ''
          (ns hello
            (:require [babashka.process :refer [sh]]))

          (-> (sh ["cowsay" "hello from babashka"])
               :out
               print)
        '';
      };
    in {
      apps.default = { type = "app"; program = "${hello-babashka}/bin/hello"; };
      defaultPackage = hello-babashka;
      packages.default = hello-babashka;
    });
}
