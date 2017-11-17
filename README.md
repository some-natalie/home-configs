# Config files for the lazy home admin

Mostly I'm just tired of configuring individual Raspberry Pi machines each time I want to start a new project or tinker a bit.  Also, documenting it makes life a little easier.  Folders do pretty much what you'd expect them to - DHCP stuff is in the dhcp folder, etc.


### Machines
- Media Pi:  A Raspberry Pi model 2 that runs Kodi (on Arch Linux) and has a big drive hooked up for movies and such.
- Pi Hole:  [This](https://pi-hole.net) awesome project on a a Raspberry Pi (model B+) running Raspbian blocks ads by being a DNS server.  Currently, this adlist blocks about 1.2 million domains (including most major social media sites).  This machine also hosts the DHCP server.
- My desktop:  Fedora 26, using PCI passthrough to give one graphics card to a Windows VM for gaming.
