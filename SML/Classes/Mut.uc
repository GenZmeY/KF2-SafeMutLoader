// This file is part of Safe Mut Loader.
// Safe Mut Loader - a mutator loader for Killing Floor 2
//
// Copyright (C) 2022-2023 GenZmeY (mailto: genzmey@gmail.com)
//
// Safe Mut Loader is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Safe Mut Loader is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Safe Mut Loader. If not, see <https://www.gnu.org/licenses/>.

class Mut extends KFMutator;

const SML = class'SafeMutLoader';

const OptAC  = "AccessControl";
const OptMut = "Mutator";

var private E_LogLevel LogLevel;

public function PreBeginPlay()
{
	Super.PreBeginPlay();

	LogLevel = SML.static.GetLogLevel();

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
	{
		Mut.Destroy();
	}
	else
	{
		Super.AddMutator(Mut);
	}
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
	local int PrevServerActorsCount;
	local int Index;
	local GameEngine GameEngine;

	`Log_Trace();

	LoadURL          = WorldInfo.GetLocalURL();
	LoadParams       = Mid(LoadURL, InStr(LoadURL, "?"));
	MutatorsRaw      = WorldInfo.Game.ParseOption(LoadParams, OptMut);
	AccessControlRaw = WorldInfo.Game.ParseOption(LoadParams, OptAC);

	LoadURL = Repl(LoadURL, Subst(OptMut) $ MutatorsRaw, "");
	LoadURL = Repl(LoadURL, Subst(OptAC)  $ AccessControlRaw, "");

	SML.static.ClearMutators();
	SML.static.ClearServerActors();
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

	GameEngine = GameEngine(Class'Engine'.static.GetEngine());
	if (GameEngine == None)
	{
		`Log_Error("GameEngine is None, skip loading server actors");
	}
	else
	{
		PrevServerActorsCount = GameEngine.ServerActors.Length;

		Index = 0;
		while (Index < GameEngine.ServerActors.Length)
		{
			if (SML.static.AddServerActor(GameEngine.ServerActors[Index]))
			{
				GameEngine.ServerActors.Remove(Index, 1);
			}
			else
			{
				++Index;
			}
		}

		if (GameEngine.ServerActors.Length != PrevServerActorsCount)
		{
			GameEngine.SaveConfig();
		}
	}

	SML.static.StaticSaveConfig();

	JoinArray(Mutators, MutatorsRaw);
	LoadURL $= (Subst(OptMut) $ MutatorsRaw);
	if (SML.static.WantsToSpawn())
	{
		LoadURL $= (Subst(OptAC) $ SML.static.GetName());
	}

	`Log_Info("Loader modified, do server travel...");

	WorldInfo.ServerTravel(LoadURL, true);
	WorldInfo.ForceGarbageCollection(true);
}

private static function String Subst(String Option)
{
	return ("?" $ Option $ "=");
}

defaultproperties
{
	GroupNames.Add("AccessControl")
}