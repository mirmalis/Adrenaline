//------¬ --¬   --¬    --¬--¬   --¬ -----¬ ---¬   --¬--¬--¬   --¬-------¬-------¬ --¬
//--г==--¬L--¬ --г-    --¦--¦   --¦--г==--¬----¬  --¦--¦--¦   --¦--г====---г====----¦
//------г- L----г-     --¦--¦   --¦-------¦--г--¬ --¦--¦--¦   --¦-------¬-------¬L--¦
//--г==--¬  L--г-      --¦L--¬ --г---г==--¦--¦L--¬--¦--¦--¦   --¦L====--¦L====--¦ --¦
//------г-   --¦       --¦ L----г- --¦  --¦--¦ L----¦--¦L------г--------¦-------¦ --¦
//L=====-    L=-       L=-  L===-  L=-  L=-L=-  L===-L=- L=====- L======-L======- L=-
//Script by Ivanius51 - http://AutoProg.ORG
 
uses SysUtils, Classes;
var
  SkillsList: TStringList;
 
procedure CheckLSSkill;
  var
    i:integer;
    skill : TL2Skill;
  begin
    for i := 0 to SkillList.count-1 do
    begin
      if SkillsList.values(SkillList.items(i).ID.ToString) <> '' then
      begin
        Engine.Msg('Found '+SkillList.items(i).name,'',0);
        Engine.Restart;
        Script.Stop;
      end;
    end;
  end;
 
procedure OnFree;
  begin
    if assigned(SkillsList) then SkillsList.free;
    engine.Msg('AutoProg.org','Thanks for using our scripts with uv. AutoProg.org team',200);
  end;
 
begin
  SkillsList:=TStringList.Create;
  
  try
    SkillsList.LoadFromFile(script.path+'LSIDs.txt');
    while delay(1000) do
    begin
      CheckLSSkill;
    end;
  finally
    SkillsList.Free;
  end;
end.