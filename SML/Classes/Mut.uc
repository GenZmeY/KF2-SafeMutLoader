class Mut extends KFMutator;

const SML = class'SafeMutLoader';

const OptAC  = "AccessControl";
const OptMut = "Mutator";

var private E_LogLevel LogLevel;

public function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	LogLevel = SML.default.LogLevel;
	if (LogLevel == LL_WrongLevel)
	{
		LogLevel = LL_Info;
	}

	`Log_Trace();
	
	if (CorrectLoadOrder())
	{
		ModifyLoad();
	}
	else
	{
		`Log_Fatal(SML.static.GetName(Self) @ "must be loaded first.");
	}
}

public function AddMutator(Mutator Mut)
{
	`Log_Trace();
	
	if (CorrectLoadOrder() || Mut == Self) return;
	
	if (Mut.Class == Class)
		Mut.Destroy();
	else
		Super.AddMutator(Mut);
}

private function bool CorrectLoadOrder()
{
	`Log_Trace();
	
	return (
		WorldInfo.Game.BaseMutator == None ||
		WorldInfo.Game.BaseMutator == Self);
}

private function ModifyLoad()
{
	local String LoadURL;
	local String LoadParams;
	local String MutatorsRaw;
	local String AccessControlRaw;
	local Array<String> Mutators;
	local int Index;
	
	`Log_Trace();
	
	LoadURL          = WorldInfo.GetLocalURL();
	LoadParams       = Mid(LoadURL, InStr(LoadURL, "?"));
	MutatorsRaw      = WorldInfo.Game.ParseOption(LoadParams, OptMut);
	AccessControlRaw = WorldInfo.Game.ParseOption(LoadParams, OptAC);
	
	LoadURL = Repl(LoadURL, Subst(OptMut) $ MutatorsRaw, "");
	LoadURL = Repl(LoadURL, Subst(OptAC)  $ AccessControlRaw, "");
	
	SML.static.ClearMutators();
	ParseStringIntoArray(MutatorsRaw, Mutators, ",", true);

	Index = 0;
	while (Index < Mutators.Length)
	{
		if (SML.static.AddMutator(Mutators[Index]) ||
			Mutators[Index] ~= SML.static.GetName(Self))
		{
			Mutators.Remove(Index, 1);
		}
		else
		{
			++Index;
		}
	}
	
	JoinArray(Mutators, MutatorsRaw);
	LoadURL $= (Subst(OptMut) $ MutatorsRaw);
	if (SML.static.WantsToSpawn())
	{
		SML.static.StaticSaveConfig();
		LoadURL $= (Subst(OptAC) $ SML.static.GetName());
	}

	`Log_Info("Loader modified, do server travel...");
	
	WorldInfo.ServerTravel(LoadURL, true);
}

private static function String Subst(String Option)
{
	return ("?" $ Option $ "=");
}

defaultproperties
{

}