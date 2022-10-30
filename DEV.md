# [SML] Developer Guide

**SML compatible mutator development guide**

# Mutator template

You can use this template to make the mutator compatible with SML.
Here I will use `Example` as mutator name. **Replace it with yours.**

**ExampleMut.uc**
```unrealscript
class ExampleMut extends KFMutator;
	
var private Example Example;

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if (WorldInfo.NetMode == NM_Client) return;
	
	foreach WorldInfo.DynamicActors(class'Example', Example)
	{
		break;
	}
	
	if (Example == None)
	{
		Example = WorldInfo.Spawn(class'Example');
	}
	
	if (Example == None)
	{
		`Log("Example: FATAL: Can't Spawn 'Example'");
		SafeDestroy();
	}
}

public function AddMutator(Mutator Mut)
{
	if (Mut == Self) return;
	
	if (Mut.Class == Class)
		Mut.Destroy();
	else
		Super.AddMutator(Mut);
}

public function NotifyLogin(Controller C)
{
	Example.NotifyLogin(C);
	
	Super.NotifyLogin(C);
}

public function NotifyLogout(Controller C)
{
	Example.NotifyLogout(C);
	
	Super.NotifyLogout(C);
}

static function String GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return String(class'Example');
}

defaultproperties
{

}
```

**Example.uc**
```unrealscript
class Example extends Info;

public event PreBeginPlay()
{
	Super.PreBeginPlay();

	// do some initialization here
}

public event PostBeginPlay()
{
	Super.PostBeginPlay();

	// do some initialization here
}

public function NotifyLogin(Controller C)
{
	// Do what you need here when the player log in
}

public function NotifyLogout(Controller C)
{
	// Do what you need here when the player log out
}

public simulated function vector GetTargetLocation(optional actor RequestedBy, optional bool bRequestAlternateLoc)
{
	local Controller C;
	C = Controller(RequestedBy);
	if (C != None) { bRequestAlternateLoc ? NotifyLogout(C) : NotifyLogin(C); }
	return Super.GetTargetLocation(RequestedBy, bRequestAlternateLoc);
}

defaultproperties
{

}
```

That's all. You can create new classes and add any code to `Example.uc` (yay!), but refrain from implementing anything else in `ExampleMut.uc` because it will not be used.  

# Limitations
❌ Can't make ranked game mode this way;  
❌ SML can only emulate [`NotifyLogin(...)`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/Engine/Classes/Mutator.uc#L147) and [`NotifyLogout(...)`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/Engine/Classes/Mutator.uc#L141), other functions of the [`Mutator`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/master/Engine/Classes/Mutator.uc) and [`KFMutator`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/master/KFGame/Classes/KFMutator.uc) classes are not supported - look for workarounds in this case.  

# Tips
## Alternative to the InitMutator(...) function
Even though the [`InitMutator(...)`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/KFGame/Classes/KFMutator.uc#L22) function is not supported, you can still parse the startup string if you need to:  
Refer to [`WorldInfo.Game.ServerOptions`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/Engine/Classes/GameInfo.uc#L209) or [`WorldInfo.GetLocalURL()`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/Engine/Classes/WorldInfo.uc#L1315) and get the option from there. It's best to do this in `PreBeginPlay()` or `PostBeginPlay()` of your `Example.uc` (as well as other initializations).  

## XP for custom Zeds / Weapons
While custom weapons and zeds won't make your server unranked, the [`ValidateForXP(...)`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/KFGame/Classes/KFGameInfo.uc#L2564) function will not allow you to gain experience if it detects a custom zed or custom damage type.  
Therefore, if you want to gain experience - make sure that [`ValidateForXP(...)`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/KFGame/Classes/KFGameInfo.uc#L2564) does not receive custom zed classes or custom damage types.  
For example you can change your custom weapon to use only default damage types or try changing the `DamageHistory` and/or `MonsterClass` before it gets into [`DistributeMoneyAndXP(...)`](https://github.com/GenZmeY/KF2-Dev-Scripts/blob/23d1ca3a9a2f62692741e77039f03fe0a913be1d/KFGame/Classes/KFGameInfo.uc#L2489).  

## Replacing base classes to bypass restrictions
In some cases, changing the base classes of the game can help. For example, we cannot make [TAWOD](https://steamcommunity.com/sharedfiles/filedetails/?id=2379769040) and SML compatible because the [PreventDeath(...)](https://github.com/GenZmeY/KF2-TAWOD/blob/master/TAWOD/Classes/TAWODMut.uc#L19) function is not supported. But this can be bypassed by replacing the player's Pawn base class with custom Pawn class:  
```unrealscript
WorldInfo.Game.DefaultPawnClass = class'ExamplePawn_Human'; // Put this to `PostBeginPlay()` of your Example.uc
```

And now we can implement all weapons drop in `ExamplePawn_Human.uc` (create one):
```unrealscript
class TAWODPawn_Human extends KFPawn_Human;

public function ThrowWeaponOnDeath()
{
	local KFWeapon KFW;
	
	if (InvManager != None)
		foreach InvManager.InventoryActors(class'KFWeapon', KFW)
			if (KFW != None && KFW.bDropOnDeath && KFW.CanThrow())
				KFP.TossInventory(KFW);
}
```

***

**Good luck and happy modding! 🙃**
