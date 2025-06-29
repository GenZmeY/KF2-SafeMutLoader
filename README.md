# Safe Mut Loader

[![Downloads](https://img.shields.io/github/downloads/GenZmeY/KF2-SafeMutLoader/total)](https://github.com/GenZmeY/KF2-SafeMutLoader/releases)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/GenZmeY/KF2-SafeMutLoader)](CHANGELOG.md)
[![GitHub](https://img.shields.io/github/license/GenZmeY/KF2-SafeMutLoader)](COPYING)

## Description
Use non-whitelisted mutators and stay ranked.  

## Legal
Safe Mut Loader is legal and does not violate the [KF2 EULA](https://store.steampowered.com/eula/232090_eula_0). Here's why in detail: [LEGAL.md](LEGAL.md).  
However, for some reason SML is getting banned in the steam workshop, so **use it at your own risk**.  

## Usage
1. Add SML to your server. There are two ways:  
- **without workshop:** download `SML.u` from [releases](https://github.com/GenZmeY/KF2-SafeMutLoader/releases) and put it to `KFGame/BrewedPC`  
- **with workshop:** Use the [instructions below](https://github.com/GenZmeY/KF2-SafeMutLoader#build--upload) to build the SML and upload it to your workshop, then subscribe your server to SML  
2. Add `SML.Mut` **first** to your list of mutators, example:  
```text
?Mutator=SML.Mut,FriendlyHUD.FriendlyHUDMutator,YAS.Mut,CTI.Mut,CVC.Mut,AAL.Mut
```
(add/remove **compatible** mutators you need)  

⚠️ Doesn't work in single player  
⚠️ SML must be first in the mutators list or it won't work.  
⚠️ SML only has an effect when **compatible** mutators are used. If you use incompatible mutators you will lose ranked status.  
⚠️ SML is a server-side mutator, clients never download it. No one will know about you using SML if you don’t tell yourself.  
⚠️ SML is incompatible with [AccessPlus](https://forums.tripwireinteractive.com/index.php?threads/utility-admin-access-plus-manager.118740/) and other mods based on it. If you need something from there, implement it as an SML compatible mutator using [developer guide](DEV.md).  

## Compatible mutators
See [compatible mutators list](COMPATIBLE.md)  

## Making SML-compatible mutators
See [developer guide](DEV.md)  

## Build & Upload
**Note:** If you want to build/brew/publish/test a mutator without git-bash and external scripts, follow [these instructions](https://tripwireinteractive.atlassian.net/wiki/spaces/KF2SW/pages/26247172/KF2+Code+Modding+How-to) instead of what is described here.  
1. Install [Killing Floor 2](https://store.steampowered.com/app/232090/Killing_Floor_2/), Killing Floor 2 - SDK and [git for windows](https://git-scm.com/download/win)  
2. open git-bash and go to any folder where you want to store sources:  
`cd <ANY_FOLDER_YOU_WANT>`  
3. Clone this repository and its dependencies:  
`git clone --recurse-submodules https://github.com/GenZmeY/KF2-SafeMutLoader`  
4. Go to the source folder:  
`cd KF2-SafeMutLoader`
5. Build and upload to steam workshop:  
`./tools/builder -cbu`
6. Find `SafeMutLoader` in your workshop and change `Visibility` to `Unlisted` so your server can download it (don't use `Public` visibility)  

## Credits
- The cat on [the cover](PublicationContent/preview.png) is [Meawbin](https://x.com/meawbinneko) (original character by [Cotton Valent](https://x.com/horrormove))  

## Status: Completed
- The mutator works with the current version of the game (v1150) and I have implemented everything I planned.  
- Development has stopped: I no longer have the time or motivation to maintain this mod. No further updates or bug fixes are planned.  

## Mirrors
- https://github.com/GenZmeY/KF2-SafeMutLoader  
- https://codeberg.org/GenZmeY/KF2-SafeMutLoader  

## License
**GPL-3.0-or-later**  
  
[![license](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)](COPYING)  