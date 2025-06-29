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

class KFGI_Access extends Object within KFGameInfo;

public function bool IsRankedGame()
{
	return !IsUnrankedGame();
}

defaultproperties
{

}
