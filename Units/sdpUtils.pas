unit sdpUtils;
interface
uses sdpFunc;
function doRealDelay(vMiliseconds: Integer): Integer;
function ZRange(vFrom, vTo: TL2Spawn; abs: Boolean = true): integer;
function CounAlivetMobsInZone(): Integer;
function aWait(f: TAnonOfBool; timeout: Integer): Boolean;
procedure cmd(command: String; params: string = '');
function AuthLogin(control: TL2Control; path, login, password: String; characterIndex: Integer = 0): Boolean;
function SetForegroundWindow(hwnd: Cardinal): cardinal;
implementation
function doRealDelay(vMiliseconds: Integer): Integer;
    begin
      if vMiliseconds > 0 then
      begin
        Delay(vMiliseconds);
        Result := vMiliseconds;
      end
      else
        Result := 0;
    end;
function ZRange(vFrom, vTo: TL2Spawn; abs: Boolean = true): integer;
  begin
    Result := vFrom.Z - vTo.Z;
    if (Result < 0) then
      Result := -Result;
  end;
function CounAlivetMobsInZone(): Integer;
  var i: Integer; aNPC: TL2NPC;
  begin
    Result := 0;
    for i := 0 to NPCList.Count do begin
      aNPC := NPCList(i);
      if true
        and (aNPC.InZone)
        and (not aNPC.Dead)
        and (aNPC.Attackable)
        and (ZRange(User, aNPC) < 1000) 
      then
      begin
        Result := Result + 1;
      end;
    end;
  end;
function aWait(f: TAnonOfBool; timeout: Integer): Boolean;
  var startTick: Integer;
  begin
    startTick := getTickCount;
    repeat
      delay(10);
    until f() or (getTickCount - startTick > timeout);
  end;
procedure cmd(command: String; params: string);
  begin
    if(params = '') 
    then ShellExecuteW(0, 'open', PChar(command), nil, nil, 0)
    else ShellExecuteW(0, 'open', PChar(command), PChar(params), nil, 0);
  end;

function ShellExecuteW(hwnd: integer; lpOperation, lpFile, lpParameters, lpDirectory: PChar;  nShowCmd: integer): integer; stdcall; external 'Shell32.dll';
function AuthLogin(control: TL2Control; path, login, password: String; characterIndex: Integer = 0): Boolean;
  begin
    if control.Status = lsOnline then begin
      control.GameClose;
      Delay(7000);
    end;
    if (control.LoginStatus = -1) then begin
      cmd(path);
      while control.LoginStatus = -1 do delay(500);
    end;
    while control.LoginStatus = 0 do
    begin
      control.AuthLogin(login, password);
      Delay(3000);
    end;
    while control.LoginStatus = 1 do
    begin
      control.EnterText('$0D'); // Enter
      Delay(3000);
    end;
    if control.LoginStatus = 2 then begin
      control.GameStart(characterIndex);
    end;
  end;
function SetForegroundWindow(hwnd: Cardinal): cardinal; stdcall; external 'User32.dll' name 'SetForegroundWindow';
end.