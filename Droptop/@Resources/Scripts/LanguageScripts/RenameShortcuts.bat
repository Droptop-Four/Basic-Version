@echo off

cd %~dp0
cd ..
cd ..
cd ..
cd ..
cd "Droptop Folders\Bookmarks\News & Media"

ren "Far-Left" %newsmediafol1%
ren "Far-Right" %newsmediafol2%
ren "International" %newsmediafol3%

cd ..
cd "Online tools"

ren "Diagnostic" %onlinetools1fol%

cd ..
cd "Podcasts"

ren "Crime & Drama" %podcastsfol1%
ren "Politics" %podcastsfol2%
ren "Science & Technology" %podcastsfol3%
ren "Sex & Psychology" %podcastsfol4%
ren "Sports" %podcastsfol5%
ren "Talk shows" %podcastsfol6%

cd ..

ren "News & media" %bookmarksfol1%
ren "Online tools" %bookmarksfol2%
ren "Podcasts" %bookmarksfol3%
ren "Shopping" %bookmarksfol4%
ren "Facebook.url" %bookmarks1%.url
ren "Gmail.url" %bookmarks2%.url
ren "Google Keep.url" %bookmarks3%.url
ren "Google Maps.url" %bookmarks4%.url
ren "Google Photos.url" %bookmarks5%.url
ren "Hulu.url" %bookmarks6%.url
ren "Netflix.url" %bookmarks7%.url
ren "Reddit.url" %bookmarks8%.url
ren "Steam.url" %bookmarks9%.url
ren "Twitch.url" %bookmarks10%.url
ren "YouTube.url" %bookmarks11%.url

cd ..
cd "Control\Advanced controls"

ren "Command prompt.lnk" %advanced1%.lnk
ren "Device manager.lnk" %advanced2%.lnk
ren "Disk cleanup.lnk" %advanced3%.lnk
ren "Disk management.lnk" %advanced4%.lnk
ren "Registry editor.lnk" %advanced5%.lnk
ren "Resource monitor.lnk" %advanced6%.lnk
ren "Startup apps.url" %advanced7%.url
ren "Storage spaces.lnk" %advanced8%.lnk
ren "System configuration.lnk" %advanced9%.lnk
ren "Windows firewall.lnk" %advanced10%.lnk
ren "Windows PowerShell.lnk" %advanced11%.lnk
ren "Windows services.lnk" %advanced12%.lnk

cd ..

ren "Advanced controls" %controlfol1%
ren "Desktop background.lnk" %control1%.lnk
ren "Display settings.url" %control2%.url
ren "Magnify.lnk" %control3%.lnk
ren "On-screen keyboard.lnk" %control4%.lnk
ren "Power options.lnk" %control5%.lnk
ren "Recycle bin.lnk" %control6%.lnk
ren "Switch display.lnk" %control7%.lnk
ren "System information.lnk" %control8%.lnk
ren "Task manager.lnk" %control9%.lnk
ren "Uninstall a program.url" %control10%.url
ren "User accounts.lnk" %control11%.lnk

cd ..
cd "Games\Campaign"

ren "Action" %gamescamfol1%
ren "Horror" %gamescamfol2%
ren "Relaxed" %gamescamfol3%
ren "RPG" %gamescamfol4%
ren "Survival" %gamescamfol5%

cd ..
cd "Local multiplayer"

ren "Co-op" %gameslocfol1%
ren "Party" %gameslocfol2%
ren "Versus" %gameslocfol3%

cd ..
cd "Online multiplayer"

ren "Battle Royal" %gamesonlfol1%
ren "MMO" %gamesonlfol2%
ren "Shooter" %gamesonlfol3%
ren "Strategy" %gamesonlfol4%

cd ..

ren "Browser games" %gamesfol1%
ren "Campaign" %gamesfol2%
ren "Casual" %gamesfol3%
ren "Indie" %gamesfol4%
ren "Local multiplayer" %gamesfol5%
ren "Online multiplayer" %gamesfol6%
ren "Simulation" %gamesfol7%
ren "Sports & racing" %gamesfol8%
ren "Virtual Reality" %gamesfol9%