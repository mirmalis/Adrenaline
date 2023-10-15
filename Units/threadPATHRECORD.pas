unit threadPATHRECORD;
// , threadPathRecord in 'Libraries\Threads\threadPathRecord.pas'
interface
procedure PathRecord();
procedure PathRecordSQL();
implementation
Uses sdpSTRINGS;
procedure PathRecordInfo();
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
  end;
procedure PathRecordSQL();
  p1: cardinal; p2: pointer;
  begin
    while (engine.status = lsOnline) do begin
      Engine.WaitAction([laKey], p1, p2);
      case p1 of 
        96: // Numpad0
        begin
          
        end;
        else Print(p1);
      end;
    end;
  end;
procedure PathRecord();
  var
    p1: cardinal; p2: pointer;
    str: String;
    i: Integer;
  begin
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
  initialization
  PathRecordInfo;
end.