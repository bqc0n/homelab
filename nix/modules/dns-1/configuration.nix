{
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;

    settings = {
      # CF public DNS
      server = [ "2606:4700:4700::1111" "2606:4700:4700::1001" ];

      port = 53;
      domain-needed = true;
      bogus-priv = true;
      dnssec = true;
      no-resolv = true;
      no-poll = true;
      bind-interfaces = true;
      local = "/home/";
      domain = "home";

      dhcp-range = [ "192.168.1.100,192.168.1.200,255.255.255.0,12h" ];
      dhcp-option = "option:router,192.168.1.1";
    };
  };
}
