unit sdpRaidUnit;
interface
const
  standCommand: Integer = 44;
  followMasterCommand: Integer = 50;
  // Destr commands
  getLowCommand: Integer = -20;
  getLastLowCommand: Integer = -25;
  doLowerCommand: Integer = 20;
  doLastLowerCommand: Integer = 25;
  moveToRaidCommand: Integer = 90;
  frenzyCommand: Integer = 95;
  doNothingCommand: Integer = 155;
  // Start
  startCommand: Integer = 2;
  dsCommand: Integer = moveToRaidCommand;

  // Nicks
  master: string = 'lllhp';
  bd: string = 'lllbd';
  sws: string = 'lllsws';
  wlk: string = 'tol2';
  de1: string = 'lll1';
  de2: string = 'lll2';
  de3: string = 'lll3';
  de4: string = 'lll4';
  wc: string = 'ldc';
  bsp: string = 'lllhp';
  procedure ControlRaid();
  function DoRaid(x: Integer): Boolean;

implementation
  uses sdpSlaveMaster;
  function DoRaid(x: Integer): Boolean;
    begin
      Result := true;
      if (x = 0) then Print('Yes raid master')
      else if x = standCommand then Engine.Stand
      else if x = followMasterCommand then begin
        Engine.MoveTo(User.X, User.Y, user.Z);
        Engine.SetTarget(GetControl(master).GetUser.Target);
        Delay(500);
        Engine.Attack(100, false);
      end
      else Result := false;
    end;
procedure ControlRaid();
  var p1: Cardinal; p2: Pointer;
  begin
    while Engine.Status = lsOnline do begin
      Engine.WaitAction([laKey], p1, p2);
      Print(p1);
      case p1 of
        110: //NumpadDot
        begin
          CommandSlave([bd, sws, wlk], standCommand);
        end;
        96: // Numbad0
        begin
          SetAll(0);
          CommandSlave([de1, de2, de3, de4], getLowCommand);
          Delay(1000);
          CommandSlave([de1, de2, de3, de4], doLowerCommand);
        end;
        97: begin // Numpad1
          CommandSlave([sws, bd], startCommand);
        end;
        98: begin // Numpad2
          CommandSlave([sws, bd], dsCommand);
        end;
        99: begin // Numpad3

        end;
        100: begin // Numpad4
          CommandSlave([de1, de2, de3, de4], moveToRaidCommand);
          CommandSlave([bd, sws, wlk], standCommand);
        end;
        101: begin // Numpad5
          CommandSlave([de1, de2, de3, de4], frenzyCommand);
        end;
        102: begin // Numpad6
          CommandSlave([de1, de2, de3, de4, sws, bd, wlk, wc, bsp], doNothingCommand);
        end;
        103: begin // Numpad7

        end;
        104: begin // Numpad8
          if(User.Name <> master) then begin
            GetControl(master).SetTarget(User.Target);
            Delay(1000);
          end;
          CommandSlave([de1,de2,de3,de4], followMasterCommand);
        end;
        105: begin // Numpad9
          if(User.Name <> master) then begin
            GetControl(master).SetTarget(User.Target);
            Delay(1000);
          end;
          CommandSlave([de1,de2,de3,de4,bd,sws,wlk,wc], followMasterCommand);
        end;
      end;
    end;
  end;
  procedure setAll(val: Integer);
    begin
      ShMem[0] := val;
      ShMem[1] := val;
      ShMem[2] := val;
      ShMem[3] := val;
    end;
  procedure waitAll(val: Integer);
    begin
      Repeat 
        // Print('---'); Print(ShMem[0]); Print(ShMem[1]); Print(ShMem[2]); Print(ShMem[3]);
        Delay(1000);
      until (ShMem[0] = val) and (ShMem[1] = val) and (ShMem[2] = val) and (ShMem[3] = val);
    end;
initialization
end.