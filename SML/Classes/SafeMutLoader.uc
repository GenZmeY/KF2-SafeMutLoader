class SafeMutLoader extends KFAccessControl
	config(SML);

struct CMR
{
	var String Mutator;
	var String Replacement;
};

var private Array<Actor>         ServerActors;
var private Array<CMR>           CustomMutReplacements;
var private config E_LogLevel    LogLevel;
var private config Array<String> Mutators;

public function PreBeginPlay()
{
	`Log_Trace();
	
	LogLevel = GetLogLevel();
	
	LoadActors();
	
	Super.PreBeginPlay();
}

private function LoadActors()
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
		
		ServerActors.AddItem(ServerActor);
		`Log_Info("Loaded:" @ MutString);
	}
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
		foreach ServerActors(A)
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
		foreach ServerActors(A)
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
}