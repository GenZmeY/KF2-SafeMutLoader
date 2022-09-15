# KF2-SafeMutLoader

[![Steam Workshop](https://img.shields.io/static/v1?message=workshop&logo=steam&labelColor=gray&color=blue&logoColor=white&label=steam%20)](https://steamcommunity.com/sharedfiles/filedetails/?id=2863226847)
[![Steam Downloads](https://img.shields.io/steam/downloads/2863226847)](https://steamcommunity.com/sharedfiles/filedetails/?id=2863226847)
[![Steam Favorites](https://img.shields.io/steam/favorites/2863226847)](https://steamcommunity.com/sharedfiles/filedetails/?id=2863226847)
[![Steam Update Date](https://img.shields.io/steam/update-date/2863226847)](https://steamcommunity.com/sharedfiles/filedetails/?id=2863226847)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/GenZmeY/KF2-SafeMutLoader)](https://github.com/GenZmeY/KF2-SafeMutLoader/tags)
[![GitHub](https://img.shields.io/github/license/GenZmeY/KF2-SafeMutLoader)](LICENSE)

# Description
Use non-whitelisted mutators and stay ranked

# Usage
```
?Mutator=SML.Mut,AAL.AALMut,YAS.YASMut,CTI.CTIMut,CVC.CVCMut,ZedSpawner.ZedSpawnerMut
```
(replace the map and add/remove compatible mutators you need)

❗️ SML must be first in the mutators list or it won't work.  
❗️ SML is a server-side mutator, clients never download it. Therefore, no one will know about SML if you don’t tell yourself. You can also accidentally give it to the whole world if you use a redirect and share the folder where it's located. Be careful about this.  

# Build
**Note:** If you want to build/test/brew/publish a mutator without git-bash and/or scripts, follow [these instructions](https://tripwireinteractive.atlassian.net/wiki/spaces/KF2SW/pages/26247172/KF2+Code+Modding+How-to) instead of what is described here.
1. Install [Killing Floor 2](https://store.steampowered.com/app/232090/Killing_Floor_2/), Killing Floor 2 - SDK and [git for windows](https://git-scm.com/download/win);
2. open git-bash and go to any folder where you want to store sources:  
`cd <ANY_FOLDER_YOU_WANT>`  
3. Clone this repository and go to the source folder:  
`git clone https://github.com/GenZmeY/KF2-SafeMutLoader && cd KF2-SafeMutLoader`
4. Download dependencies:  
`git submodule init && git submodule update`  
5. Compile:  
`./tools/builder -c`  
5. The compiled files will be here:  
`C:\Users\<USERNAME>\Documents\My Games\KillingFloor2\KFGame\Unpublished\BrewedPC\Script\`

# License
[GNU GPLv3](LICENSE)  
