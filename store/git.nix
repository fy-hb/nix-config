 {pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user.signingkey="58F0009E76DB637F";
      user.email="fyhb233@gmail.com";
      user.name="F. ICE";
      commit.gpgsign=true;
    };
  };
#   programs.gpg = {
#     enable = true;
#     package = pkgs.pinentry-all;
#     settings = {
# #       pinentry-mode="loopback";
#       keyid-format="0xlong";
#       with-fingerprint=true;
#     };
#   };
}

