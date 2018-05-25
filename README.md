# Config files for the lazy home admin

Mostly I'm just tired of configuring individual Raspberry Pi machines each time I want to start a new project or tinker a bit.  Also, documenting it makes life a little easier.  Folders do pretty much what you'd expect them to - DHCP stuff is in the dhcp folder, etc.


### Machines
- Media Pi:  A Raspberry Pi model 2 that runs Kodi (on Arch Linux) and has a big drive hooked up for movies and such.
- Pi Hole:  [This](https://pi-hole.net) awesome project on a a Raspberry Pi (model B+) running Raspbian blocks ads by being a DNS server.  Currently, this adlist blocks about 1.2 million domains (including most major social media sites).  This machine also hosts the DHCP server.
- My desktop:  Fedora 28, using PCI passthrough with the [vfio patch](https://vfio.blogspot.com) to give one of two identical graphics card to a Windows VM for gaming.  Runs libvirt for the gaming VM, plus Docker for a bunch of homelab experimentation ([Portainer](https://portainer.io), [GitLab CE](https://gitlab.com/gitlab-org/gitlab-ce), and [SaltStack](https://saltstack.com/community/) to start).
