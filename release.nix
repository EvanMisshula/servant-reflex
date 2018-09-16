{ pkgs ? import <nixpkgs> {}, compiler ? "ghcjs" }:

let
  reflexPlatform =
    import ./nix/reflex-platform.nix {
      fetchFromGitHub = pkgs.fetchFromGitHub;
    };

in rec {
  inherit reflexPlatform;
  hspec-webdriver = reflexPlatform.ghc8_0.callPackage ../hspec-webdriver-1.2.0 {};
  servant-reflex  = import ./nix/servant-reflex.nix {
    reflexPlatform = reflexPlatform;
    compiler       = compiler;
  };
  testserver = import ./nix/testserver.nix
    { reflexPlatform = reflexPlatform;
      servant-reflex = servant-reflex ;
    };
  testdriver = import ./nix/testdriver.nix
    { reflexPlatform = reflexPlatform; 
    };
  testresults = import ./nix/testresults.nix
    { inherit reflexPlatform testserver testdriver;
      inherit (pkgs) curl;
      phantomjs = pkgs.phantomjs2;
    };
  }