unit sdpCounter;
interface
uses Classes;
procedure setToggles(arr: Array of String; vState: Boolean); Overload;
procedure setToggles(SL: TStringList; vState: Boolean); Overload;
function setToggle(name: String; vState: Boolean): Boolean;
procedure waitFinishCasting(caster: TL2Live);

function Follow(name: String): Boolean;
// Engine.UseAction(1007); // Blessing of Queen
procedure useBuffs(slString: string); Overload;
procedure useBuffs(SL: TStringList); Overload;
procedure useSkills(                      SL: TStringList; vMaxWaitReuse: Integer = 0); Overload;
procedure useSkills(vNick: string; vSLString: String; vMaxWaitReuse: Integer = 0); Overload;
procedure useSkills(vControl: TL2Control; SL: TStringList; vMaxWaitReuse: Integer = 0); Overload;
procedure useActionInRange(actionID: Integer; vName: String; range: Integer; moveTimes: Integer = 5); Overload;
procedure useSkillsInRange(                      SL: TStringList; vName: String; range: Integer; moveTimes: Integer = 5; vMaxWaitReuse: Integer = 0); Overload;
procedure useSkillsInRange(vControl: TL2Control; SL: TStringList; vName: string; range: Integer; moveTimes: Integer = 5; vMaxWaitReuse: Integer = 0); Overload;

function countChars(vRange: Integer): Integer; Overload;
function countChars(vRange: Integer; vControl: TL2Control): Integer; Overload;
function countChars(x,y,z: Integer; vRange: Integer): Integer; Overload;
function countMobTargetors(): Integer; Overload;
function countMobTargetors(vParam1: TL2Live): Integer; Overload;
function countMobArround(vRange: Integer = 300): Integer; Overload;
function countMobArround(x,y,z: Integer; vRange: Integer = 300): Integer; Overload;
function countMobsInZone(z: Integer = 500): Integer; Overload;
function countSpoiledMobs(vRange: Integer = 300): Integer; Overload;
function skillReuse(vName: String): Integer; Overload;

function botHasSummon(vNick: String): Boolean;
function HasBuff(vLive: TL2Live; vID: Integer; vLevel: Integer = -1; vDuration: Integer = 0): Boolean; Overload;
function HasBuff(vLive: TL2Live; vName: String; vLevel: Integer = -1; vDuration: Integer = 0): Boolean; Overload;
function summonBuffCount(vNick: String; SL: TStringList; time: Integer = 60000): Integer; Overload;
function buffCount(SLString: String; time: Integer = 60000): Integer; Overload;
function buffCount(SL: TStringList; time: Integer = 60000): Integer; Overload;
function buffCount(nick: String; SLString: String; time: Integer = 60000): Integer; Overload;
function buffCount(nick: String; SL: TStringList; time: Integer = 60000): Integer; Overload;
function buffCount(vBuffs: TBuffList; SL: TStringList; time: Integer = 60000): Integer; Overload;
function buffCount(vBuffs: TBuffList; arr: Array of String; time: Integer = 60000): Integer; Overload;
function buffCount(vBuffs: TBuffList; arr: Array of Integer; time: Integer = 60000): Integer; Overload;
function buffCount(arr: Array of Integer; time: Integer = 60000): Integer; Overload;
function countItems(vID: Integer): Integer; Overload;
function countItems(vName: String): Integer; Overload;
function ItemCount(id: integer): int64;  overload;
function ItemCount(const Name: string): int64;  overload;

implementation
Uses sdpStrings, sdpSL;
procedure setToggles(arr: Array of String; vState: Boolean); Overload;
  var part: String;    
  begin
    for part in arr do 
    begin
      setToggle(part, vState);
    end;
  end;
procedure setToggles(SL: TStringList; vState: Boolean); Overload;
  var i: Integer;
  begin
    if (SL <> nil) then
      for i := 0 to SL.Count - 1 do 
      begin
        setToggle(SL[i], vState);
      end;
  end;
function setToggle(name: String; vState: Boolean): Boolean; Overload;
  var
    aBuff: TL2Buff;
    aSkill: TL2Skill;
  begin
    Result := false;
    if ((User.Buffs.ByName(name, aBuff) and not vState) or (not User.Buffs.ByName(name, aBuff) and vState)) and (Engine.GetSkillList.ByName(name, aSkill)) then 
    begin
      Result := true;
      Engine.UseSkill(name);
    end;
  end;
procedure waitFinishCasting(caster: TL2Live);
  begin
    Delay(caster.Cast.EndTime);
  end;
function Follow(name: String): Boolean;
  begin
    Engine.SetTarget(name);
    Engine.Attack;
  end;
function WaitSkillReuse(vControl: TL2Control; vName: String; vMaxWait: Integer): Boolean;
  var
    aSpell: TL2Skill;
  begin
    vControl.GetSkillList.ByName(vName, aSpell);
    if (aSpell.EndTime <= vMaxWait) then delay(aSpell.EndTime);
  end;
function skillReuse(vName: String): Integer; Overload;
  var aSkill: TL2Skill;
  begin
    if SkillList.ByName(vName, aSkill) then Result := aSKill.EndTime
    else 
    begin
      Print('Could not find skill ' + vName + '.');
      Result := 0;
    end;
  end;
function botHasSummon(vNick: String): Boolean;
  begin
    Result := (GetControl(vNick).GetPetList.Items(0) <> nil) and (not GetControl(vNick).GetPetList.Items(0).Dead);
  end;
// Buffs.
function HasBuff(vLive: TL2Live; vID: Integer; vLevel: Integer = -1; vDuration: Integer = 0): Boolean; Overload;
  var aBuff: TL2Buff;
  begin
    Result := 
          vLive.Buffs.ByID(vID, aBuff) 
      and ((vLevel < 0) or (aBuff.Level = vLevel)) // lvl nenurodytas or lvl exact
      and (aBuff.EndTime >= vDuration)
    ;
  end;
function HasBuff(vLive: TL2Live; vName: String; vLevel: Integer = -1; vDuration: Integer = 0): Boolean; Overload;
  var aBuff: TL2BUff;
  begin
    Result := 
          vLive.Buffs.ByName(vName, aBuff) 
      and ((vLevel < 0) or (aBuff.Level = vLevel)) // lvl nenurodytas or lvl exact
      and (aBuff.EndTime >= vDuration)
    ;
  end;
function summonBuffCount(vNick: String; SL: TStringList; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(GetControl(vNick).GetPetList.Items(0).Buffs, SL, time);
  end;
function buffCount(vBuffs: TBuffList; SL: TStringList; time: Integer = 60000): Integer; Overload;
  var aBuff: TL2Buff; i: Integer; 
  begin

    Result := 0;
    for i := 0 to SL.Count - 1 do
    begin
      if vBuffs.ByName(SL[i], aBuff) then
        if (aBuff.EndTime >= time) then 
          Result := Result + 1;
    end;
  end;
function buffCount(SL: TStringList; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(User.Buffs, SL, time);
  end;
function buffCount(SLString: String; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(SL(SLString), time);
  end;
function buffCount(nick: String; SLString: String; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(GetControl(nick).GetUser.Buffs, SL(SLString), time);
  end;
function buffCount(nick: String; SL: TStringList; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(GetControl(nick).GetUser.Buffs, SL, time);
  end;
  
function buffCount(vBuffs: TBuffList; arr: Array of String; time: Integer = 60000): Integer; Overload;
  var aBuff: TL2Buff; i: Integer; 
  begin
    Result := 0;
    for i := 0 to vBuffs.Count - 1 do
    begin
      aBuff := vBuffs.Items(i);
      if (aBuff.EndTime > time) and is_in(aBuff.Name, arr) then
        Result := Result + 1;
    end;
  end;
function buffCount(arr: Array of Integer; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(User.Buffs, arr, time);
  end;
function buffCount(vBuffs: TBuffList; arr: Array of Integer; time: Integer = 60000): Integer; Overload;
  var aBuff: TL2Buff; i: Integer; 
  begin
    Result := 0;
    for i := 0 to vBuffs.Count - 1 do
    begin
      aBuff := vBuffs.Items(i);
      if (aBuff.EndTime > time) and is_in(aBuff.ID, arr) then
        Result := Result + 1;
    end;
  end;
// Casting
procedure useBuffs(slString: string); Overload;
  begin
    useBuffs(SL(slString));

  end;
procedure useBuffs(SL: TStringList); Overload;
  begin
    Engine.SetTarget(User);
    UseSkills(SL);
  end;

procedure useActionInRange(actionID: Integer; vName: String; range: Integer; moveTimes: Integer = 5); Overload;
  var aSpawn: TL2Char;
  begin
    if (actionID <> 0) then
    begin
      CharList.ByName(vName, aSpawn);
      moveInRange(Engine, aSpawn, range, moveTimes);
      Engine.UseAction(actionID); 
      Delay(10);
    end;
  end;
procedure useSkillsInRange(                      SL: TStringList; vName: String; range: Integer; moveTimes: Integer = 5; vMaxWaitReuse: Integer = 0); Overload;
  begin
    useSkillsInRange(Engine, SL, vName, range, moveTimes, vMaxWaitReuse);
  end;

procedure useSkillsInRange(vControl: TL2Control; SL: TStringList; vName: string; range: Integer; moveTimes: Integer = 5; vMaxWaitReuse: Integer = 0); Overload;
  var part: String; i: Integer; aChar: TL2Char;
  begin
    CharList.ByName(vName, aChar);
    if SL.Count > 0 then begin
      if User.Sitting then begin
        Engine.Stand;
        Delay(3000);
      end;
      for i := 0 to SL.Count - 1 do
      begin
        part := SL[i];
        if (part <> '') then
        begin
          Print(part);
          if (vMaxWaitReuse > 0) then WaitSkillReuse(vControl, part, vMaxWaitReuse);
          moveInRange(vControl, aChar, range, moveTimes);
          vControl.UseSkill(part);
          Delay(vControl.GetUser().Cast.Endtime);
          Delay(10);
        end;
      end;
    end;
  end;
procedure useSkills(                      SL: TStringList; vMaxWaitReuse: Integer = 0); Overload;
  begin
    useSkills(Engine, SL, vMaxWaitReuse);
  end;
procedure useSkills(vNick: string; vSLString: String; vMaxWaitReuse: Integer = 0); Overload;
  begin
    useSkills(GetControl(vNick), SL(vSLString), vMaxWaitReuse);
  end;
procedure useSkills(vControl: TL2Control; SL: TStringList; vMaxWaitReuse: Integer = 0); Overload;
  var 
    part: String; i: Integer;
    waitTime: Integer;
  begin
    if SL.Count > 0 then
      for i := 0 to SL.Count - 1 do
      begin
        part := SL[i];
        if (part <> '') then
        begin
          Delay(vControl.GetUser().Cast.EndTime);
          if (vMaxWaitReuse > 0) then WaitSkillReuse(vControl, part, vMaxWaitReuse);
          vControl.UseSkill(part); 
          Delay(50);
        end;
      end;      
  end;

procedure moveInRange(vControl: TL2Control; vChar: TL2Char; range: Integer; moveTimes: Integer = 5);
  var i: Integer;
  begin

    i:=0;
    while (i < moveTimes) and (User.DistTo(vChar) > range) do 
    begin
      vControl.MoveTo(vChar, -range);
      i := i + 1;
    end;
  end;


function countChars(vRange: Integer): Integer; Overload;
  begin
    Result := countChars(vRange, Engine);
  end;
function countChars(vRange: Integer; vControl: TL2Control): Integer; Overload;
  var aUser: TL2User;
  begin
    aUser := vControl.GetUser;
    Result := countChars(aUser.X, aUser.Y, aUser.Z, vRange);
  end;
function countChars(x,y,z: Integer; vRange: Integer): Integer; Overload;
  var i: Integer; aChar: TL2Char;
  begin
    Result := 0;
    for i := 0 to CharList.Count - 1 do begin
      aChar := CharList.Items(i);
      if aChar.DistTo(x,y,z) <= vRange then begin
        Result := Result + 1;
      end 
      else break; // List is sorted
    end;
  end;
// CountingMobs
function countMobTargetors(): Integer; Overload;
  begin
    Result := countMobTargetors(User as TL2Live);
  end;
function countMobTargetors(vParam1: TL2Live): Integer; Overload;
  var 
    i, sum: Integer;
    aMob: TL2Npc;
  begin
    sum := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if (aMob.Target <> Nil) then Print(aMob.Target.Name);
      if (aMob.Target as TL2Live = vParam1) then sum := sum + 1;
      
    end;
    Result := sum;
  end;
function countMobArround(vRange: Integer = 300): Integer; Overload;
  // var 
  //   i: Integer;
  //   aMob: TL2Npc;
  //   aNpcList: TNpcList;
  begin
    Result := countMobArround(User.X, User.Y, User.Z, vRange);
  //   Result := 0;
  //   aNpcList := NpcList;
  //   for i := 0 to aNpcList.Count - 1 do 
  //   begin

  //     aMob := aNpcList.Items(i);
  //     if ((User.DistTo(aMob) < vRange) and (not aMob.Dead)) then Result := Result + 1;
  //   end;
  end;
function countMobArround(x,y,z: Integer; vRange: Integer = 300): Integer; Overload;
  var 
    i: Integer;
    aMob: TL2Npc;
    aNpcList: TNpcList;
  begin
    Result := 0;
    aNpcList := NpcList;
    for i := 0 to aNpcList.Count - 1 do 
    begin
      aMob := aNpcList.Items(i);
      if ((aMob.DistTo(x,y,z) < vRange) and (not aMob.Dead)) then Result := Result + 1;
    end;
  end;
function countMobsInZone(z: Integer = 500): Integer; Overload;
  var 
    i: Integer;
    aMob: TL2Npc;
  begin
    Result := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if (aMob.InZone) and (not aMob.Dead) and (Abs(User.Z - aMob.Z) < z) then 
        Result := Result + 1;
    end;
  end;
function countSpoiledMobs(vRange: Integer = 300): Integer; Overload;
  var 
    i: Integer;
    aMob: TL2Npc;
  begin
    Result := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if ((User.DistTo(aMob) < vRange) and (aMob.Sweepable)) then Result := Result + 1;
    end;
  end;

// CountingItems
function countItems(vID: Integer): Integer; Overload;
  var aItem: TL2Item;
  begin
    Result := ItemCount(vID);
    Print('use ItemCount instead of countItems');
    exit;
    if not Inventory.User.ByID(vID, aItem) then 
      Inventory.Quest.ByID(vID, aItem);
    Result := aItem.Count;
  end;
function countItems(vName: String): Integer; Overload;
  var aItem: TL2Item;
  begin
    Result := ItemCount(vName);
    Print('use ItemCount instead of countItems');
    exit;
    if not Inventory.User.ByName(vName, aItem) then 
      Inventory.Quest.ByName(vName, aItem);
    Result := aItem.Count;
  end;



function ItemCount(id: integer): int64;  overload;     // counting items by ID
  var i: integer;
  begin
    result:= 0;                                          
    for i:= 0 to Inventory.User.Count-1 do begin         // running over the user's inventory
      if (Inventory.User.Items(i).ID = id) then          // if id matched, then
        Inc(result, Inventory.User.Items(i).Count);      // increase the result by the number of items in the stack
    end; 
    for i:= 0 to Inventory.Quest.Count-1 do begin        // similarly for quest inventory
      if (Inventory.Quest.Items(i).ID = id) then
        Inc(result, Inventory.Quest.Items(i).Count); 
    end;
  end;

function ItemCount(const Name: string): int64;  overload;   // counting items by name
  var i: integer;
  begin
    result:= 0;
    for i:= 0 to Inventory.User.Count-1 do begin         // running over the user's inventory
      if (Inventory.User.Items(i).Name = Name) then      // if names matched, then
        Inc(result, Inventory.User.Items(i).Count);      // increase the result by the number of items in the stack
    end; 
    for i:= 0 to Inventory.Quest.Count-1 do begin        // similarly for quest inventory
      if (Inventory.Quest.Items(i).Name = Name) then
        Inc(result, Inventory.Quest.Items(i).Count); 
    end;
  end;

end.