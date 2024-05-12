{ pkgs }:

let
  # myImg = "/home/ari/al.jpg";

  # imgLink = "https://github.com/arilebedey/time-precise-wallpaper-switcher/blob/main/wallpapers/altai-mountains-valley-hills-river-landscape-19372.jpg";
  image = "path:/home/ari/altai-mountains-valley-hills-river-landscape-19372.jpg";
  # image = pkgs.fetchurl {
  #   url = imgLink;
  #   sha256 = "sha256-o1IkNdtKim7wDB4ye/0iBkeuy+GVntNsJhhA170dTNc=";
  # };

in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "3ximus";
    repo = "aerial-sddm-theme";
    rev = "c8d2a8f50decd08cb30f2fe70205901014985c9e";
    sha256 = "0csyw1vz76f1glz832jwss433pjbhpjxnlfww4rsxkc827v8d644";
  };
  installPhase = ''
    mkdir -p $out
    # recurcive copy of git directory to our Nix output
    cp -R ./* $out/
    cd $out/
    # rm background.jpg
    # cp -r ${image} $out/background.jpg
   '';
}
