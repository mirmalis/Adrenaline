unit raidDancerUnit;
interface
uses sdpRaidUnit, Classes;
var
  ind: Integer;
  procedure DanceSong(dancesIds: TStringList; songsIds: TStringList; catId: Integer);
implementation
  uses sdpMath, sdpSlaveMaster, sdpStrings;
  
  
  procedure DanceSong(dancesIds: TStringList; songsIds: TStringList; catId: Integer);
    var i: Integer;
    begin
      while user.Sitting or GetControl(sws).GetUser.Sitting do begin
        Engine.Stand;
        GetControl(sws).Stand;
        Delay(2000);
      end;
      
      
      for i := Max(dancesIds.Count, songsIds.Count) - 1 downto 0 do begin
        if(dancesIds.Count > i) then
        begin
          Engine.DUseSkill(ToInt(dancesIds[i]), false, false);
        end;
        
        if(songsIds.count > i) then begin
          GetControl(sws).DUseSkill(ToInt(songsIds[i]), false ,false);
        end;
        if(i <= 1) then begin
          if(catId <> 0) then begin
            GetControl(wlk).UseAction(catId);
          end;
        end;
        Delay(2000);
      end;
      Engine.Sit;
      GetControl(sws).Sit;
    end; 
initialization
  
end.