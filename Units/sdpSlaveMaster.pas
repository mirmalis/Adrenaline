unit sdpSlaveMaster;
Interface
procedure CommandSlave(vSlaves: Array of String; vNumber: Integer); Overload;
procedure CommandSlave(vSlaves: Array of String; vNumbers: Array of Integer); Overload;
procedure CommandSlave(vSlaveName: String; vNumbers: Array of Integer); Overload;
procedure CommandSlave(vSlaveName: String; vNumber: Integer); Overload;
Implementation
procedure CommandSlave(vSlaves: Array of String; vNumber: Integer); Overload;
  var i: Integer;
  begin
    for i:=0 to Length(vSlaves)-1 do
      CommandSlave(vSlaves[i], vNumber);
  end;
procedure CommandSlave(vSlaves: Array of String; vNumbers: Array of Integer); Overload;
  var i: Integer;
  begin
    for i:=0 to Length(vSlaves)-1 do
      CommandSlave(vSlaves[i], vNumbers);
  end;
procedure CommandSlave(vSlaveName: String; vNumbers: Array of Integer); Overload;
  var vNumber: Integer;
  begin
    for vNumber in vNumbers do 
      CommandSlave(vSlaveName, vNumber);
  end;
procedure CommandSlave(vSlaveName: String; vNumber: Integer); Overload;
  var aBot: TBot;
  begin
    Print(vSlaveName);
    if (vSlaveName <> '') then
    begin
      BotList.ByName(vSlaveName, aBot);
      aBot.Control.Entry(vNumber);
    end;
  end;
end.