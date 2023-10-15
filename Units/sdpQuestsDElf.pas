unit sdpQuestsDElf;
interface
  const
  questId_forgottenTruth: Integer = 106;
  questId_spiritOfCraftsman: Integer = 103;
  questId_tradeWithTheIvoryTover: Integer = 262;
  questId_scentOfDeath: Integer = 319;
  questId_bonesTellTheFuture: Integer = 320;
  function ForgottenTruth(): Boolean;
function SpiritOfCraftman(take: Boolean = false): Boolean;

implementation
  uses sdpGPS, sdpBYPASS, sdpITEM;

function ForgottenTruth(): Boolean;
  var state: Integer;
  begin
    state := Engine.QuestStatus(questId_forgottenTruth);
    Print('ForgottenTruth');
    Print(state);
    Result := true;
  
  if(sdpItem.itemCount(988) > 0) // Translation of the Completed Revalations (Finish)
  then begin
    GPS_MoveTo('delf temple');
    TalkTo('Thifiell', 'Quest');
  end;

  end;

function SpiritOfCraftman(take: Boolean = false): Boolean;
  var state: Integer;
  begin
    Result := true;
    Print('Spirit of Craftsman');
    state := Engine.QuestStatus(questId_spiritOfCraftsman);
    if(state = 0)  // Quest not taken
      then begin 
        if(take)
        then begin
          GPS_MoveTo('npc:Karrod');
          TalkTo('Karrod', 'Quest;1;1');
        end
      end
    else if (sdpItem.itemCount(968) > 0) // Spirit of Craftsman: Right after taking Quest
      then begin
        
      end
    else if (sdpItem.itemCount(972) > 0) // Spirit of Craftsman: Needs zombies @ Swamplands
    then begin
      Result := false;
      Print('Craftman''s quest needs zombies');
    end
    else begin
      Print('Unsupported state of Quest ''Spirit of Craftman''');
      Print(state);
    end;
  end;

initialization
  
end.