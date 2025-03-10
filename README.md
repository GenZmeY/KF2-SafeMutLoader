# KF2-SafeMutLoader

[![Downloads](https://img.shields.io/github/downloads/GenZmeY/KF2-SafeMutLoader/total)](https://github.com/GenZmeY/KF2-SafeMutLoader/releases)
[![MegaLinter](https://github.com/GenZmeY/KF2-SafeMutLoader/actions/workflows/mega-linter.yml/badge.svg?branch=master)](https://github.com/GenZmeY/KF2-SafeMutLoader/actions/workflows/mega-linter.yml)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/GenZmeY/KF2-SafeMutLoader)](https://github.com/GenZmeY/KF2-SafeMutLoader/releases)
[![GitHub](https://img.shields.io/github/license/GenZmeY/KF2-SafeMutLoader)](LICENSE)

## Description
Use non-whitelisted mutators and stay ranked.  

## Legal
SafeMutLoader is legal and does not violate the [KF2 EULA](https://store.steampowered.com/eula/232090_eula_0). Here's why in detail: [LEGAL.md](LEGAL.md).  
However, for some reason SML is getting banned in the steam workshop, so **use it at your own risk**.  

## Usage (server only)
1. Add SML to your server. There are two ways:  
* **without workshop:** download `SML.u` from [releases](https://github.com/GenZmeY/KF2-SafeMutLoader/releases) and put it to `KFGame/BrewedPC`  
* **with workshop:** Use the [instructions below](https://github.com/GenZmeY/KF2-SafeMutLoader#build--upload) to build the SML and upload it to your workshop, then subscribe your server to SML  
2. Add `SML.Mut` **first** to your list of mutators, example:  
```text
?Mutator=SML.Mut,FriendlyHUD.FriendlyHUDMutator,YAS.Mut,CTI.Mut,CVC.Mut,AAL.Mut
```
(add/remove **compatible** mutators you need)  

⚠️ Doesn't work in single player  
⚠️ SML must be first in the mutators list or it won't work.  
⚠️ SML only has an effect when **compatible** mutators are used (the list below). If you use incompatible mutators you will lose ranked status.  
⚠️ SML is a server-side mutator, clients never download it. Therefore, no one will know about you using SML if you don’t tell yourself (or if you share with the whole world the `BrewedPC` folder where you put the SML, lol).  
⚠️ SML is incompatible with [AccessPlus](https://github.com/th3-z/kf2-acpp) and other mods based on it. If you need something from there, implement it as an SML compatible mutator using [developer guide](https://github.com/GenZmeY/KF2-SafeMutLoader/blob/master/DEV.md).  

## Compatible mutators
🟢 Any whitelisted mutators  
🟢 [Admin Auto Login](https://steamcommunity.com/sharedfiles/filedetails/?id=2848836389)  
🟢 [AmmoMulti](https://steamcommunity.com/sharedfiles/filedetails/?id=3026449204)  
🟢 [Controlled Vote Collector](https://steamcommunity.com/sharedfiles/filedetails/?id=2847465899)  
🟡 [Custom Trader Inventory](https://steamcommunity.com/sharedfiles/filedetails/?id=2830826239)  
Using `UnlockDLC=ReplaceFilter` will unrank the server when someone buys DLC weapons. Use `UnlockDLC=ReplaceWeapons` to get around this.  
Since KF2 [v1133](https://wiki.killingfloor2.com/index.php?title=Update_1133_(Killing_Floor_2)) the content preload causes the server to unrank for some reason. Disable it in CTI settings (`bPreloadContent=False`) to stay ranked.  
🟢 [Discord Link [Edited]](https://steamcommunity.com/sharedfiles/filedetails/?id=2891475864)  
🟢 [FriendlyHUD](https://steamcommunity.com/sharedfiles/filedetails/?id=1819268190)  
🟢 [Looted Trader Inventory](https://steamcommunity.com/sharedfiles/filedetails/?id=2864857909)  
🟡 [StartWave](https://github.com/GenZmeY/KF2-StartWave)  
`mutate startwave X` command not working.  
🟢 [True Random Boss](https://steamcommunity.com/sharedfiles/filedetails/?id=3047331564)  
🟡 [Unofficial Killing Floor 2 Patch](https://steamcommunity.com/sharedfiles/filedetails/?id=2875147606)  
Should work, but no guarantees. Use at your own risk.  
🟢 [WorkshopTool](https://steamcommunity.com/sharedfiles/filedetails/?id=3047217103)  
🟢 [Yet Another Scoreboard](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)  
🟡 [Zed Spawner](https://steamcommunity.com/sharedfiles/filedetails/?id=2811290931)  
Since KF2 [v1133](https://wiki.killingfloor2.com/index.php?title=Update_1133_(Killing_Floor_2)) zed preload causes the server to unrank for some reason. Disable it in ZedSpawner settings (`bPreloadContentServer=False`) to stay ranked.  

## Making SML-compatible mutators
See [developer guide](https://github.com/GenZmeY/KF2-SafeMutLoader/blob/master/DEV.md)  

## Build & Upload
**Note:** If you want to build/test/brew/publish a mutator without git-bash and/or scripts, follow [these instructions](https://tripwireinteractive.atlassian.net/wiki/spaces/KF2SW/pages/26247172/KF2+Code+Modding+How-to) instead of what is described here.
1. Install [Killing Floor 2](https://store.steampowered.com/app/232090/Killing_Floor_2/), Killing Floor 2 - SDK and [git for windows](https://git-scm.com/download/win);
2. open git-bash and go to any folder where you want to store sources:  
`cd <ANY_FOLDER_YOU_WANT>`  
3. Clone this repository and go to the source folder:  
`git clone https://github.com/GenZmeY/KF2-SafeMutLoader && cd KF2-SafeMutLoader`
4. Download dependencies:  
`git submodule init && git submodule update`  
5. Build and upload to steam workshop:  
`./tools/builder -cbu`
6. Find `SafeMutLoader` in your workshop and change `Visibility` to `Unlisted` so your server can download it (don't use `Public` visibility)

## Contributing
If you make a mod compatible with SML I'll be happy to add it to the list of compatible mutators.  
Contact me in any convenient way (for example, create an [issue](https://github.com/GenZmeY/KF2-SafeMutLoader/issues))  

## License
[![license](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)](LICENSE)
