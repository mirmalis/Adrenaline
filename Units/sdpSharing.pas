unit sdpSharing;
interface
type 
  TState = class
    private
    public
      A: Integer;
      B: Integer;
      C: Integer;
      Constructor Create(a, b, c: Integer);
    end;
function StatesAreTaken(a: Integer; _bs: Array of Integer): Boolean;
procedure SetScriptID(id: Integer);
procedure PrintState(nick: String);
procedure ResetState();
function SetState(a: Integer; b: Integer = 0; c: Integer = 0): Boolean;
function StateIsTaken(a: Integer; b:Integer = 0; c: Integer = 0): Boolean;
function TakeIfAvailable(a: Integer; b: Integer = 0; c: Integer = 0) : Boolean;
implementation
uses sdpSTRINGS;
const
  SIndex: Integer = 0;
  AIndex: Integer = 1;
  BIndex: Integer = 2;
  CIndex: Integer = 3;
  Constructor TState.Create(a,b,c: Integer);  
    begin inherited Create;
      self.A := a;
      self.B := b;
      self.C := c;
    end;
var scriptId: Integer = 0;
function TakeIfAvailable(a: Integer; b: Integer = 0; c: Integer = 0) : Boolean;
  begin
    Result := not StateIsTaken(a,b,c);
    if Result // if available
      then SetState(a,b,c);
  end;
procedure SetScriptID(id: Integer);
  begin
    scriptId := id;
  end;
procedure PrintState(nick: String); Overload;
  var vUser: TL2User;
  begin
    vUser := GetControl(nick).GetUser;
    Print('('+ToStr(vUser.GetVar(AIndex))+', '+ToStr(vUser.GetVar(BIndex))+', '+ToStr(vUser.GetVar(CIndex))+')@' + ToStr(vUser.GetVar(SIndex)));
  end;
// procedure PrintState(); Overload;
//   begin
//     Print('('+ToStr(User.GetVar(AIndex))+', '+ToStr(User.GetVar(BIndex))+', '+ToStr(User.GetVar(CIndex))+')@' + ToStr(User.GetVar(SIndex)));
//   end;
procedure  ResetState();
    begin
      SetState(0,0,0);
    end;
function SetState(a: Integer; b: Integer = 0; c: Integer = 0): Boolean;
  begin
    User.SetVar(scriptId, SIndex);
    User.SetVar(a, AIndex);
    User.SetVar(b, BIndex);
    User.SetVar(c, CIndex);
    Print('SetState(' + ToStr(a) + ',' + ToStr(b) + ',' + ToStr(c) + ');');
    Result := true;
  end;
// function CountAtState(a: Integer; b: Integer; c: Integer): integer;
//   var i: Integer; vUser: TL2User;
//   begin
//     Result := 0;
//     for i := 0 to BotList.Count - 1 do begin
//       vUser := TBot(BotList(i)).Control.GetUser;
//       if (vUser = User)  // dont check yourself
//         then continue;
//       if(vUser <> nil)
//       and (vUser.GetVar(AIndex) = a)
//       and (vUser.GetVar(BIndex) = b)
//       and (vUser.GetVar(CIndex) = c)
//       then begin
//         Result := Result + 1;
//         Print(vUser.Name + ' already doing that.');
//       end;
//     end;
function StatesAreTaken(a: Integer; _bs: Array of Integer): Boolean;
  var b: Integer;
  begin
    Result := false;
    for b in _bs do begin
    end;
  end;
function StateIsTaken(a: Integer; b: Integer = 0; c: Integer = 0): Boolean;
  var i: Integer; vUser: TL2User;
  begin
    Result := false;
    for i := 0 to BotList.Count - 1 do begin
      vUser := TBot(BotList(i)).Control.GetUser;
      if (vUser = User)  // dont check yourself
        then continue;
      if(vUser <> nil)
      and (vUser.GetVar(SIndex) = scriptId)
      and (vUser.GetVar(AIndex) = a)
      and (vUser.GetVar(BIndex) = b)
      and (vUser.GetVar(CIndex) = c)
      then begin
        Result := true;
        Print('('+ToStr(a)+','+ToStr(b)+','+ToStr(c)+') taken by '''+ vUser.Name + '''');
        break;
      end;
    end;
  end;
initialization
//Print('sharing is caring');
  
end.