{
  # config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.root = {

    shell = pkgs.bash;

    # openssh.authorizedKeys.keyFiles = [ ../keys/tcurdt.pub ];
    openssh.authorizedKeys.keyFiles = [ inputs.ssh-keys.outPath ];

    # promptInitialPassword = true;
    # password = "secret";
    # hashedPassword = "*"; # no password allowed

  };
}
