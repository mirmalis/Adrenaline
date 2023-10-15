unit threadAUTOSWEEP;
interface
  var
    spoil_ignoredMobsIDs : Array of Integer;
    spoil_staticIgnoredMobsIDs: Array of Integer;
    spoil_midPriorityMobsIDs: Array of Integer;
    spoil_sweepID: Integer;
    spoil_pause_interface: Boolean;
    spoil_above_hp: Integer;
  procedure AutoSweep();
implementation
  uses sdpSTRINGS;
  procedure AutoSweep();
    var 
      aMob:TL2Npc; aSkill:TL2Skill; i:Integer;
      state_before_change: Boolean;
    begin
      while true do
      begin
        for i := 0 to NPCList.Count - 1 do
        begin
          if (User.Hp < spoil_above_hp) then break;
          aMob := NPCList.Items(i);
          if (User.DistTo(aMob) < 300) then
          begin
            if   aMob.Valid 
             and aMob.Dead 
             and aMob.Sweepable 
             and not is_in(aMob.ID, spoil_ignoredMobsIDs)
             and not is_in(aMob.ID, spoil_staticIgnoredMobsIDs)
             and (SkillList.ByID(spoil_sweepID,aSkill))
            then
            begin
              if (spoil_pause_interface) then begin
                state_before_change := Engine.GetFaceState(0);
                Engine.FaceControl(0, False);
              end;
              Engine.SetTarget(aMob); Delay(250);
              if (aSkill.EndTime < 1000) then Delay(aSkill.EndTime + 10);
              Engine.UseSkill(aSkill);
            end;
          end;
        end;
        if (spoil_pause_interface) then Engine.FaceControl(0, state_before_change);
        Delay(100);
      end;
    end;
initialization
  spoil_ignoredMobsIDs := [0];
  spoil_staticIgnoredMobsIDs := [21411, 21408, 21407, 20824, 20820, 20818, 20982, 20981, 22106,22111, 22118];
  spoil_midPriorityMobsIDs := [0];
  spoil_sweepID := 42;
  spoil_pause_interface := True;
  spoil_above_hp := 70;
end.