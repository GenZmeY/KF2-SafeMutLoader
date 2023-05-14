class SafeMutLoader extends KFAccessControl
	config(SML);

struct CMR
{
	var String Mutator;
	var String Replacement;
};

var private Array<Actor>         ActiveMutators;
var private Array<Actor>         ActiveServerActors;
var private Array<CMR>           CustomMutReplacements;
var private Array<String>        SystemServerActors;
var private config E_LogLevel    LogLevel;
var private config Array<String> Mutators;
var private config Array<String> ServerActors;

public function PreBeginPlay()
{
	LogLevel = GetLogLevel();

	`Log_Trace();

	Super.PreBeginPlay();

	LoadMutators();
	LoadServerActors();
}

public function PostBeginPlay()
{
	local KFGI_Access KFGIA;

	`Log_Trace();

	Super.PostBeginPlay();

	RestoreServerActors();

	KFGIA = GetKFGIA();
	if (KFGIA == None)
	{
		`Log_Error("Can't check ranked status");
	}
	else if (KFGIA.IsRankedGame())
	{
		`Log_Info("Mutators and server actors successfully loaded! Your server is RANKED!");
	}
	else
	{
		`Log_Warn("Your server is UNRANKED! Check the mutators and server actors you are using. Maybe some of them are incompatible with SML");
	}
}

private function KFGI_Access GetKFGIA()
{
	local KFGameInfo KFGI;

	if (WorldInfo == None || WorldInfo.Game == None)
	{
		return None;
	}

	KFGI = KFGameInfo(WorldInfo.Game);
	if (KFGI == None)
	{
		return None;
	}

	return new(KFGI) class'KFGI_Access';
}

private function LoadMutators()
{
	local String         MutString;
	local class<Mutator> MutClass;
	local class<Actor>   ActClass;
	local Actor          ServerActor;

	`Log_Trace();

	foreach Mutators(MutString)
	{
		MutClass = class<Mutator>(DynamicLoadObject(MutString, class'Class'));
		if (MutClass == None)
		{
			`Log_Error("Can't load mutator:" @ MutString);
			continue;
		}

		ActClass = GetMutReplacement(MutClass);
		if (ActClass == None)
		{
			`Log_Warn("Incompatible:" @ MutString @ "(skip)");
			continue;
		}

		ServerActor = WorldInfo.Spawn(ActClass);
		if (ServerActor == None)
		{
			`Log_Error("Can't spawn:" @ MutString);
			continue;
		}

		ActiveMutators.AddItem(ServerActor);
		`Log_Info("Loaded:" @ MutString);
	}
}

private function LoadServerActors()
{
	local String       ActorString;
	local class<Actor> ActorClass;
	local Actor        ServerActor;

	foreach ServerActors(ActorString)
	{
		ActorClass = class<Actor>(DynamicLoadObject(ActorString, class'Class'));
		if (ActorClass == None)
		{
			`Log_Error("Can't load server actor:" @ ActorString);
			continue;
		}

		ServerActor = WorldInfo.Spawn(ActorClass);
		if (ServerActor == None)
		{
			`Log_Error("Can't spawn:" @ ActorString);
			continue;
		}

		ActiveServerActors.AddItem(ServerActor);
		`Log_Info("Loaded:" @ ActorString);
	}
}

private function RestoreServerActors()
{
	local GameEngine GameEngine;
	local String     ActorString;
	local int        PrevServerActorsCount;

	GameEngine = GameEngine(Class'Engine'.static.GetEngine());

	if (GameEngine == None)
	{
		`Log_Error("GameEngine is None! Can't restore ServerActors!");
		return;
	}

	PrevServerActorsCount = GameEngine.ServerActors.Length;
	foreach ServerActors(ActorString)
	{
		if (GameEngine.ServerActors.Find(ActorString) != INDEX_NONE)
		{
			GameEngine.ServerActors.AddItem(ActorString);
		}
	}

	if (GameEngine.ServerActors.Length != PrevServerActorsCount)
	{
		GameEngine.SaveConfig();
	}
}

public static function bool AddServerActor(String ServerActor)
{
	local class<Actor> ActorClass;

	if (default.SystemServerActors.Find(ServerActor) != INDEX_NONE)
	{
		return false;
	}

	ActorClass = class<Actor>(DynamicLoadObject(ServerActor, class'Class'));

	if (ActorClass == None)
	{
		return false;
	}

	if (ClassIsChildOf(ActorClass, class'Mutator'))
	{
		return false;
	}

	if (default.ServerActors.Find(ServerActor) == INDEX_NONE)
	{
		default.ServerActors.AddItem(ServerActor);
	}

	return true;
}

public static function bool AddMutator(String MutString)
{
	if (GetMutStringReplacement(MutString) != None)
	{
		if (default.Mutators.Find(MutString) == INDEX_NONE)
		{
			default.Mutators.AddItem(MutString);
		}
		return true;
	}

	return false;
}

public static function ClearMutators()
{
	default.Mutators.Length = 0;
}

public static function ClearServerActors()
{
	default.ServerActors.Length = 0;
}

public static function bool WantsToSpawn()
{
	return (default.Mutators.Length > 0);
}

public static function String GetName(optional Object O)
{
	if (O == None)
	{
		return (default.class.GetPackageName() $ "." $ String(default.class));
	}
	else
	{
		return (O.class.GetPackageName() $ "." $ String(O.class));
	}
}

public static function String GetMutName(class<Mutator> CMut)
{
	if (CMut == None) return "";

	return CMut.GetPackageName() $ "." $ String(CMut);
}

public function PostLogin(PlayerController C)
{
	local Actor A;

	`Log_Trace();

	if (C != None)
	{
		foreach ActiveMutators(A)
		{
			A.GetTargetLocation(C, false);
		}
	}

	Super.PostLogin(C);
}

public function OnClientConnectionClose(Player ClientConnection)
{
	local Controller C;
	local Actor      A;

	`Log_Trace();

	C = ClientConnection.Actor;
	if (C != None)
	{
		foreach ActiveMutators(A)
		{
			A.GetTargetLocation(C, true);
		}
	}

	Super.OnClientConnectionClose(ClientConnection);
}

public static function E_LogLevel GetLogLevel()
{
	if (default.LogLevel == LL_WrongLevel)
	{
		default.LogLevel = LL_Info;
		StaticSaveConfig();
	}

	return default.LogLevel;
}

private static function class<Actor> GetMutReplacement(class<Mutator> MutClass)
{
	local int    Index;
	local String Replacement;

	if (MutClass == None) return None;

	Index = default.CustomMutReplacements.Find('Mutator', GetMutName(MutClass));
	if (Index != INDEX_NONE)
	{
		Replacement = default.CustomMutReplacements[Index].Replacement;
	}
	else if (MutClass.static.GetLocalString() == "")
	{
		return None;
	}
	else
	{
		Replacement = MutClass.GetPackageName() $ "." $ MutClass.static.GetLocalString();
	}

	return class<Actor>(DynamicLoadObject(Replacement, class'Class'));
}

private static function class<Actor> GetMutStringReplacement(String MutString)
{
	return GetMutReplacement(class<Mutator>(DynamicLoadObject(MutString, class'Class')));
}

defaultproperties
{
	CustomMutReplacements.Add({(
		Mutator="UnofficialKFPatch.UKFPMutator",
		Replacement="UnofficialKFPatch.UKFPReplicationInfo"
	)})
	CustomMutReplacements.Add({(
		Mutator="UnofficialKFPatch.UKFPMutatorNW",
		Replacement="UnofficialKFPatch.UKFPReplicationInfo"
	)})

	SystemServerActors.Add("IpDrv.WebServer")
}