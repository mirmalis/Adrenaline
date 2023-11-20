unit sdpThreads;
interface
  uses threadMapMaker, threadStopCasters;
type
  TBeDashing = class
    private
      FId: Integer;
      FTimeLeft: Integer;
      FDoTargetSelf: Boolean;
      FIsGoing: Boolean;
      procedure BeDashing();
    public
      constructor Create(const AId, ATimeLeft: Integer);
      procedure Start();
      procedure Stop();
      property Id: Integer read FId;
      property TimeLeft: Integer read FTimeLeft;
      property DoTargetSelf: Boolean read FDoTargetSelf write FDoTargetSelf;
    end;
var
  dash: TBeDashing;
  stealth: TBeDashing;
function doStopCasters(vSchemaNormal: String; vSchemaPassive: String; spellsToStop: String; vPrintMuch: Boolean = false): TStopCaster;
procedure doFindChampions(range: Integer);
procedure doAnnounceChampion;
procedure doShadowItemON(vID: Integer);
procedure doTarget(vID: Integer = 0);
procedure doTargetChampions(range: Integer);
procedure doPathRecord();
procedure doAutoSweep();
procedure doMapMaker(zoneName: string);


procedure Help;
implementation
uses SysUtils, sdpSTRINGS, sdpItem, sdpSL, sdpMATH;
var
  spoil_ignoredMobsIDs : Array of Integer;
  spoil_staticIgnoredMobsIDs: Array of Integer;
  spoil_midPriorityMobsIDs: Array of Integer;
  spoil_sweepID: Integer;
  spoil_pause_interface: Boolean;
  spoil_above_hp: Integer;
// StopCasting
  function doStopCasters(vSchemaNormal: String; vSchemaPassive: String; spellsToStop: String; vPrintMuch: Boolean = false): TStopCaster;
    begin
      Result := 
        threadStopCasters.TStopCaster.Create(vSchemaNormal, vSchemaPassive, SL(spellsToStop), vPrintMuch)
      ;
      Script.NewThread(
        @threadStopCasters.TStopCaster.Thread, 
        Result
      );
    end;
// Shadow item
  procedure doShadowItemON(vID: Integer);
    var id: Integer;
    begin
      Script.NewThread(@ShadowItemONThread, Pointer(vID));
    end;
  procedure ShadowItemONThread(vID: Integer);
    var p1,p2: Integer;
    begin
      while Equip(vID, true) do begin
        Engine.WaitAction([laInvUpdate], p1, p2);
      end;
      Print('No more Shadow Items - ShadowItemONThread exiting.');
    end;
// AnnounceChampions
  procedure doAnnounceChampion;
    begin
      Script.NewThread(@AnnounceChamion)
    end;
  procedure AnnounceChamion;
    var p1, p2: integer;
    begin
      while true do begin
        Engine.WaitAction([laSpawn], p1, p2);
        case TL2Live(p1).Team of
          1: PlaySound('Sounds/Matthew/Blue.wav');
          2: PlaySound('Sounds/Matthew/Red.wav');
        end;
      end;
    end;
// Target
  procedure doTarget(vID: Integer = 0);
    begin
      if (vID = 0) then
      begin
        vID := User.Target.ID;
        Print(vID);
        
      end;
      Script.NewThread(@TargetThread, Pointer(vID));
    end;
  procedure TargetThread(vID: Integer);
    begin
      while true do begin
        if User.Target.Dead or (User.Target = nil) then
        begin
          xTarget(vID, 5000, 1000);
        end;
        while not (
             (User.Target.Dead and not User.Target.Sweepable)
          or (User.Target = nil) 
        ) do delay(100);
        Delay(350);
      end;
    end;
  function xTarget(vID: Integer; range: Integer; zRange: Integer): Boolean;
    var i: Integer;
    begin
      Result := false;
      for i := 0 to NPCList.Count do begin
        if  (NPCList.Items(i).ID = vID)
        and (not NPCList.Items(i).Dead) 
        and NPCList.Items(i).InRange(User.X, User.Y, User.Z, range, zRange)
        then
        begin
          Engine.SetTarget(NPCList.Items(i));
          Result := true;
          Break;
        end;
      end;
    end;
// TargetChampions
  procedure doTargetChampions(range: Integer);
    begin
      Script.NewThread(@TargetChampsThread, @range);
    end;
  procedure TargetChampsThread(range: Integer = 1500);
    
    begin
      while true do begin
      if User.Target.Dead or (User.Target = nil) then
      begin
        TargetChamp(range);
      end;
      while not (
            User.Target.Dead 
        or (User.Target = nil) 
      ) do delay(100);
      Delay(350);
      end;
    end;
  function TargetChamp(range: Integer = 1500; zRange: Integer = 750): Boolean;
    var i: Integer;
    begin
      Result := false;
      for i := 0 to NPCList.Count do begin
          if  (NPCList.Items(i).Team <> 0)
          and (not NPCList.Items(i).Dead) 
          and NPCList.Items(i).InRange(User.X, User.Y, User.Z, range, zRange)
          then
          begin
            Engine.SetTarget(NPCList.Items(i));
            Result := true;
            Break;
          end;
        end;
    end;
// FindChamps
  procedure doFindChampions(range: Integer);
    begin
      Script.NewThread(@FindChampionsThread, Pointer(range));
    end;
  procedure FindChampionsThread(R: integer = 2000);
    var 
      i: integer;   
      point: TXYZ;
    begin
      while delay(555) do begin
        if (Engine.Status = lsOnline) then begin
          for i:= 0 to NpcList.Count-1 do begin
            if (User.Target.Team = 0)
              and (NpcList(i).Team <> 0)
              and (User.DistTo(NpcList(i)) < R)
              and (Abs(User.Z - NpcList(i).Z) < 500)
              and (NpcList(i).InZone)
              and (User.Target <> NpcList(i))
              and (not NpcList(i).Dead)
            
            then begin   // the difference in absolute value of the Z coordinate of the bot and mob is < 500, then
              Print('Detected champion: '+NpcList(i).Name+', [HP: '+IntToStr(NpcList(i).CurHP)+'], Dist: '+IntToStr(User.DistTo(NpcList(i))));
              // then we do what is needed, the following will be enough simple steps without special checks
              Engine.FaceControl(1, false);                 // turn off combat in bot
              point:= CalcXYZ(User, NpcList(i), -500);       // calculate coordinates where it is necessary to run up to the champion
              Engine.MoveTo(point.X, point.Y, point.Z);     // run to the mob
              Engine.SetTarget(NpcList(i));                 // take it to target 
              Engine.FaceControl(1, true);                  // turn on combat back

              break;                                        // do not forget to exit the loop
            end;
          end;
        end;
      end;
    end;

// AutoSweep
  procedure doAutoSweep();
    begin
      Script.NewThread(@AutoSweepThread);
    end;
  procedure AutoSweepThread();
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

// PathRecord
  procedure doPathRecord();
    begin
      Script.NewThread(@PathRecordThread);
    end;
  procedure PathRecordThread();
    var
      p1: cardinal; p2: pointer;
      str: String;
      i: Integer;
    begin
      Print('PathRecord hotkeys:');
      Print('Numpad0: Clear recording.');
      Print('Numpad1: Simple pointer.');
      Print('Numpad2: Point (name = ''kill_'').');
      Print('Numpad3: Point (name = ''provoke'').');
      Print('Numpad4: Point (x,y,z = User.Target(.x,.y,.z), name = User.Target.Name).');
      Print('Numpad5: Point (name = ''tlp:___'').');
      Print('NumpadMinus: Stop');
      Print('-------------------------');
      str := '';
      while (engine.status = lsOnline) do
      begin
        Engine.WaitAction([laKey], p1, p2);
        case p1 of
          96: // Numpad0
          begin
            str := '';
            i := 0;
            print(str);
          end;
          97: // Numpad1
          begin
            str := str +  ToStr(User.X) + ', ' + ToStr(User.Y) + ', ' + ToStr(User.Z) + ',0,' + AnsiString(#13#10);
            print(str);
          end;
          98: // Numpad2
          begin
            str := str +  ToStr(User.X) + ', ' + ToStr(User.Y) + ', ' + ToStr(User.Z) + ',0,kill_' + AnsiString(#13#10);
            print(str);
          end;
          99: // Numpad3
          begin
            str := str +  ToStr(User.X) + ', ' + ToStr(User.Y) + ', ' + ToStr(User.Z) + ',0,rbs:' + AnsiString(#13#10);
            print(str);
          end;
          100: // Numpad4
          begin
            str := str +  ToStr(User.Target.X) + ', ' + ToStr(User.Target.Y) + ', ' + ToStr(User.Target.Z) + ',0,npc:' + User.Target.Name + AnsiString(#13#10);
            print(str);
          end;
          101: // Numpad5
          begin
            str := str +  ToStr(User.X) + ', ' + ToStr(User.Y) + ', ' + ToStr(User.Z) + ',0,tlp:___' + AnsiString(#13#10);
            print(str);
          end;
          109: // NumpadMinus
          begin
            break;
          end;
          else begin
            // Print(p1);
          end; // else
        end; // case
      end; // while
      Print('PathRecord thread ended.')
    end; // procedure

// MapMaker
  procedure doMapMaker(zoneName: string);
    begin
      Script.NewThread(@threadMapMaker.TMapMaker.Thread, threadMapMaker.TMapMaker.Create(zoneName));
    end;
procedure Help;
  begin
    Print('doFindChampions(2000); // (Range: Integer)');
    Print('doAutoSweep;');
    Print('doPathRecord;');
    Print('doMapMaker(''aden eg 55 right''); // (zoneName:string)');
  end;
// Dasher
  
  constructor TBeDashing.Create(const AId, ATimeLeft: Integer);
    begin
      inherited Create;
      FId := AId;
      FTimeLeft := ATimeLeft;
      FDoTargetSelf := false;
    end;
  procedure TBeDashing.BeDashing();
    var
      skill: TL2Skill;
      buff: TL2Buff;
      x,y,z: Integer;
    begin
      while self.FIsGoing do begin
        SkillList.ById(self.Id, skill);
        if (skill <> nil)
        then Delay(Max(0, skill.EndTime)) // wait to reuse
        else break; // use has no such skill - dont continue.
        
        User.Buffs.ById(self.Id, buff);
        if(buff <> nil) then Delay(Max(0, (buff.EndTime - self.TimeLeft)));
        if not self.FIsGoing then break;
        if(self.FDoTargetSelf) 
        then Engine.SetTarget(user);
        x := User.ToX;
        y := User.ToY;
        z := User.ToZ;
        Engine.UseSkill(self.Id);
        if(User.DistTo(x,y,z) > 50)
        then Engine.DMoveTo(x,y,z);
      end;
    end;
  procedure TBeDashing.Stop();
    begin
      self.FIsGoing := false;
    end;
  procedure TBeDashing.Start();
    begin
      if(self.FIsGoing) 
      then print('already started')
      else begin
        self.FIsGoing := true;
        Script.NewThread(
          @callBeDashing, Pointer(self)
        );
      end;
    end;
  procedure callBeDashing(params: TBeDashing);
    begin
      params.BeDashing;
    end;
  

initialization
// AutoSweep
  spoil_ignoredMobsIDs := [0];
  spoil_staticIgnoredMobsIDs := [21411, 21408, 21407, 20824, 20820, 20818, 20982, 20981, 22106,22111, 22118];
  spoil_midPriorityMobsIDs := [0];
  spoil_sweepID := 42;
  spoil_pause_interface := True;
  spoil_above_hp := 70;
  dash := TBeDashing.Create(4, 0);
  stealth := TBeDashing.Create(411, 10*1000);
end.