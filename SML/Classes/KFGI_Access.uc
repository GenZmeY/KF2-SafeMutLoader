class KFGI_Access extends Object within KFGameInfo;

public function bool IsRankedGame()
{
	return !IsUnrankedGame();
}

defaultproperties
{

}
