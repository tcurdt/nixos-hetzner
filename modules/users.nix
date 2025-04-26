{
  # pkgs,
  ...
}:
{
  security.sudo.wheelNeedsPassword = false;
  security.sudo.execWheelOnly = true;

  users.mutableUsers = false;
}
