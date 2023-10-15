unit x1DelfQuests;
interface
uses sdpGPS, sdpBYPASS, sdpITEM, sdpCounter, sdpSharing, sdpSTRINGS, SysUtils;
var 
  endTime: TDateTime;
  unstuckCastTime: Integer;
  shroom: Integer = 8;
  zombie: Integer = 13;
  skelet: Integer = 14;
function Main(): Integer;
procedure OnFree;
implementation
const
  questId_spiritOfCraftman: Integer = 103;
  questId_forgottenTruth: Integer = 106;
  questId_tradeWithTheIvoryTover: Integer = 262;
  questId_scentOfDeath: Integer = 319;
  questId_bonesTellTheFuture: Integer = 320;
  questId_offspringOfNightmares: Integer = 169;
  questId_dangerousSeduction: Integer = 170;
function Main(): Integer;
  begin
    Result := 0;
    while true do begin
    if(User.Dead) then begin
      Engine.GoHome;
      Delay(3500);
    end;
    ResetState;
    Engine.FaceControl(0, false);
    InTown;
    if (now >= Endtime) then begin
      Print('Time to sleep, its ' + DateTimeToStr(now));
      GPS_MoveTo(12104, 16600, -4584);
      break;
    end;
    StockSSN(2000);
    OutsideTown;
    Result := Result + 1;
    if (User.Dead) then begin
      Engine.GoHome;
    end else begin
      Engine.Unstuck;
      Delay(unstuckCastTime);
    end;
    Delay(10000);
    end;
    Delay(8000);
    Engine.GameClose;
  end;
procedure OnFree;
  begin
    ResetState;
  end;
function GoAndStartFarming(x: Integer; y: Integer; z: Integer; zoneName: String): boolean;
  begin
    Engine.FaceControl(0, false);
    Engine.FaceControl(1, false);
    Result := GPS_MoveTo(x, y, z);
    if(zoneName = '')
    then Engine.ClearZone
    else Engine.LoadZone(zoneName);
    Engine.FaceControl(0, true);
    Engine.FaceControl(1, true);
  end;
function somethingToDoInTown(): Boolean;
  begin
    Result := true;
    if false then begin end
    else if (itemCount(988) > 0) then begin
      // finish forgottenTruth
      GPS_MoveTo('delf temple');
      TalkTo('Thifiell', 'Quest');
    end
    else if (User.Level >= 10) and (User.Level <= 13)
        and (CorrectQuestState(questId_forgottenTruth) = 0)
    then begin
      GPS_MoveTo('delf temple');
      TalkTo('Thifiell', 'Quest;1;1');
    end
    else if (User.Level >= 10) and (User.Level <= 13) and (CorrectQuestState(questId_spiritOfCraftman) = 0)
    then begin
      GPS_MoveTo('npc:Karrod');
      TalkTo('Karrod', 'Quest;1;1');
    end
    else if // Spirit of the Craftman
      (CorrectQuestState(questId_spiritOfCraftman) = 2) // Cecktinon's Virst Voucher
      or
      (CorrectQuestState(questId_spiritOfCraftman) = 4)
    then begin 
      GPS_MoveTo('npc:Harne');
      TalkTo('Harne', 'Quest');
    end
    else if (sdpItem.ItemCount(974) > 0) then // zombiu galva priduota
    begin
      GPS_MoveTo('npc:Karrod');
      TalkTo('Karrod', 'Quest');
    end
    else if (BothQuestsNeedFarRun) then begin
      GPS_MoveTo('Shilen Temple S');
      TalkTo('Kartia', 'Quest');
      TalkTo('Cecktinon', 'Quest');
    end
    else if(CorrectQuestState(questId_tradeWithTheIvoryTover)=2) then begin
      GPS_MoveTo(11880, 15784, -4552);
      TalkTo('Vollodos', 'Quest'); // Finish "Trade with the Ivory Tover"
    end
    else if (shroom > 0) and (User.Level >= 8) and (CorrectQuestState(questId_tradeWithTheIvoryTover) = 0) then begin
      GPS_MoveTo(11880, 15784, -4552);
      TalkTo('Vollodos', 'Quest;1'); // Take "Trade with the Ivory Tover"
    end
    else if CorrectQuestState(questId_scentOfDeath) = 2 then begin
      GPS_MoveTo(11880, 15784, -4552);
      TalkTo('Minaless', 'Quest');
    end
    else if (User.Level >= 11) and (User.Level >= zombie) and (CorrectQuestState(questId_scentOfDeath) = 0) then begin
      GPS_MoveTo(11880, 15784, -4552);
      TalkTo('Minaless', 'Quest;1');
    end
    else if(CorrectQuestState(questId_bonesTellTheFuture) = 2) then begin
      GPS_MoveTo(11208, 14104, -4240);
      TalkTo('Kaitar', 'Quest');
    end
    else if (User.Level >= 10) and (User.Level >= skelet) and (CorrectQuestState(questId_bonesTellTheFuture) = 0) then begin
      GPS_MoveTo(11208, 14104, -4240);
      TalkTo('Kaitar', 'Quest;1');
    end
    else Result := false;
  end;
procedure InTown();
  begin
    if (buffCount('Wind Walk', 60*1000*10) = 0) then begin
      GPS_MoveTo(12088, 16712, -4584);
      TalkTo('Newbie Helper', 'magic');
    end;
    repeat 
      Delay(100);
    until not somethingToDoInTown;
    GPS_MoveTo(12088, 16712, -4584);
    TalkTo('Newbie Helper', 'magic');
  end;
function KillForQuest(questId: Integer; questPartAtStart: Integer): Boolean;
  begin
    Engine.LoadConfig('delf-quest');
    while not User.Dead
      and (CorrectQuestState(questId) = questPartAtStart) 
    do Delay(333);
    SetState(0, 0, 0);
    FinishCombat;
  end;
function CorrectQuestState(id: Integer): Integer;
  begin
    Result := Engine.QuestStatus(id);
    case id of 
      questId_forgottenTruth: case true of 
        ((ItemCount(986) > 0) and (ItemCount(987) > 0)): Result := 3; // Ancient Scroll, Ancient Clay Tabled collected
        (itemCount(985) > 0): Result := 2;
        (Result = 0): begin end;
        else Print('Forgotten Truth: ' + ToStr(Result) + ' (Guess)');
      end;
      questId_spiritOfCraftman: case true of 
        (ItemCount(974) > 0): Result := 7; //  Zombio galva (kažkokia kita) in inventory, goto Cecktinon
        (ItemCount(973) > 0): Result := 7; // Zombie Head in inventory, goto Cecktinon
        (ItemCount(972) > 0): Result := 6; // Preserving Oil in inventory, gohunt zombies
        (ItemCount(1107) >= 10): Result := 4; // 10 skelet bones in inventory, goto harne please
        (ItemCount(970) > 0) : Result := 3; // 1 Cecktinon's Second Woucher in inventory, gohunt skeletons please
        (ItemCount(969) > 0) : Result := 2; // Cecktinon's First Woucher, goto harne please
        (Result = 0): begin end;
        else Print('Spirit of Craftman: ' + ToStr(Result) + ' (Guess)');
      end;
    end;
  end;
function StockSSN(desiredCount: Integer): Boolean;
  var newbieSSNCount: Integer;
  begin
    newbieSSNCount := ItemCount(5789);
    Result := StockItem(1835, (desiredCount-newbieSSNCount));
  end;

function StockItem(id: Integer; desiredCount: Integer): Boolean;
  var haveCount: Integer;
  begin
    haveCount := ItemCount(id);
    if (desiredCount > 0) 
    and (haveCount < desiredCount) then 
    begin
      Engine.ByPassToServer('_bbsgetfav');
      Delay(1000);
      B('Consumables');
      Delay(1000);
      Engine.NPCExchange(1835, (desiredCount - haveCount), false);
    end;
    Result := ItemCount(id) >= desiredCount;
  end;
function ForgottenTruthNeedsFarRun(): Boolean;
  begin
    Result := false    // todo
//    or ((sdpItem.ItemCount(986) > 0 ) and (sdpItem.ItemCount(987)>0))
    or true
    ;
  end;
function CraftmanNeedsFarRun(): Boolean;
  begin
    Result := false
      or (CorrectQuestState(questId_spiritOfCraftman) =  1)
      or (sdpItem.ItemCount(971) > 0) // Undeadai buvo sumedzioti, bazinycioj pakalbeta
      or (sdpItem.ItemCount(973) > 0) // Zombie head in inventory
    ;
  end;
function BothQuestsNeedFarRun(): Boolean;
  begin
    Result := ForgottenTruthNeedsFarRun and CraftmanNeedsFarRun;
  end;
function FinishCombat(): Boolean;
  begin
    Engine.LoadConfig('dd-fightoff');
    Engine.CancelTarget;
    // Engine.MoveTo(User.X+25, User.Y+25, User.Z);
    Delay(999);
    repeat
      Delay(100);
    until ((countMobArround(300) = 0) and Delay(1000))
      or User.Dead
      or (
      (User.Target = nil) and Delay(200)
  and (User.Target = nil) and Delay(200)
  and (User.Target = nil)
    );

  end;
procedure OutsideTown();
  begin
    if(CorrectQuestState(questId_tradeWithTheIvoryTover) = 1) then begin
      GPS_MoveTo(-8557, 22137, -3716); // prie grybu
      while true do begin
        if TakeIfAvailable(1,1) then begin
          GoAndStartFarming(-6648, 22712, -3544, 'delf darkforest spores (is miesto)');
          break;
        end 
        else if TakeIfAvailable(1,2) 
        then begin
          GoAndStartFarming(-11560, 22072, -3656, 'delf spores (is miesto) 2');
          break;
        end
        else Delay(1000);
      end;
      KillForQuest(questId_tradeWithTheIvoryTover, 1);
    end;
    // Zombies
    if(User.Level >= zombie) then begin
      if (CorrectQuestState(questId_scentOfDeath)=1) then begin
        GPS_MoveTo(-17504, 31209, -3630);
        while true do begin
          if TakeIfAvailable(2,1) then begin
            GoAndStartFarming(-16728, 33368, -3600, '');
            break;
          end 
          else if TakeIfAvailable(2,2) 
          then begin
            GoAndStartFarming(-22552, 39960, -3024, '');
            break;
          end
          else Delay(1000);
        end;
        KillForQuest(questId_scentOfDeath, 1);
      end;
      if (CorrectQuestState(questId_offspringOfNightmares) = 1) then begin
        GoAndStartFarming(-27870, 46141, -3688, '');
        KillForQuest(questId_offspringOfNightmares, 1);
      end;
      if (CorrectQuestState(questId_forgottenTruth) = 2) then begin
        GoAndStartFarming(-47385, 71995, -3553, '');
        KillForQuest(questId_forgottenTruth, 2);
      end;
    end;
    if (User.Level >= skelet) and (CorrectQuestState(questId_bonesTellTheFuture) = 1) then begin
      if not GPS_MoveTo(-47111, 56356, -3894) then begin
        Delay(5000);
        if (not GPS_MoveTo(-47111, 56356, -3894)) then begin
          Engine.BlinkWindow(true);
          Print('failed to go to SODA');

        end;
      end;
      while true do begin
        if TakeIfAvailable(3,1) then begin
          GameStart;
          GoAndStartFarming(-49544, 55944, -4768, 'delf soda l-2,3+');
          Engine.MoveTo(-43910, 54724, -4528);
          break;
        end 
        else if TakeIfAvailable(3,2) 
        then begin
          GameStart;
          GoAndStartFarming(-45664, 55558, -4922, 'delf soda r-2,3+');
          break;
        end
        else begin 
          Delay(1000);
          GameRestart;
          

        end;
      end;
      KillForQuest(questId_bonesTellTheFuture, 1);
    end;
    
    if (CorrectQuestState(questId_dangerousSeduction) = 1) then begin
      Engine.LoadConfig('dd-fightoff');
      GPS_MoveToClosest('hnt:merkenis1;hnt:merkenis2');
      Engine.BlinkWindow(true);
      Delay(60000);
      Engine.LoadConfig('delf-quest');
      while
        not User.Dead
        and (CorrectQuestState(questId_dangerousSeduction) = 1)
        do delay(100);
    end;
    Engine.LoadConfig('dd-fightoff');
    if (User.Level >= 10) and (User.Level >= Skelet) then begin
      GPS_MoveToClosest('safe1;safe2;safe3;safe4;safe5;safe6;safe7;safe8;safe9;safe10;safe11;safe12;mob:Quest forgotten truth;hnt:merkenis1;hnt:merkenis2');
      Delay(5000);
    end;
    Delay(3000);
    FinishCombat;
  end;
function GameStart(): Boolean;
  begin
    if (Engine.Status = lsOffline) and (Engine.LoginStatus = 2) 
    then begin
      Engine.GameStart;
      Delay(5000);
    end;
  end;
function GameRestart(): Boolean;
  begin
    // if (not User.InCombat) 
    // then Engine.Restart;

    Result := (Engine.Status = lsOffline) and (Engine.LoginStatus = 2);
  end;
initialization
  SetScriptID(500);
  Print('--- x1DelfQuests config (START): ---');
  unstuckCastTime := 60000;
  Print('unstuckCastTime := ' + ToStr(unstuckCastTime));
  endTime := StrToDateTime('2024-01-01 22:00:00'); 
  Print('endTime := ' + 'StrToDateTime(DateToStr(Date)+ '' 22:00:00''); // StrToDateTime(DateToStr(Date)+ '' 22:00:00'');');
  shroom := 8;
  Print('shroom := ' + ToStr(shroom) + '; // level at which Trade with Ivory Tover quest will be started.');
  zombie := 13;
  Print('zombie := ' + ToStr(zombie) + '; //  level at which Scent of Death quest will be started.');
  skelet := 14;
  Print('skelet := ' + ToStr(skelet) + '; // level at which Bones Tell the Future will be started.');
  Print('--- x1DelfQuests config (END): ---');
end.