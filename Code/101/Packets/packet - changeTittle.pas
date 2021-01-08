uses packetUnit in '.\..\..\Units\PacketUnit.pas';
procedure NickNameChanged(oid: integer; title: string);
var
  Pck: TNetworkPacket;
begin
  Pck:= TNetworkPacket.Create;
  begin
    Pck.WriteC($CC);
    Pck.WriteD(oid);
    Pck.WriteS(title);
    Engine.SendToClient(Pck.ToHex);
    Pck.Free;
  end;
end;

var
  i: integer;
  Ch: TL2Char;
begin
  for i := 0 to CharList.Count -1 do
  begin
    Ch := CharList.Items(i);
    if (User.DistTo(Ch)<5555) then
      begin
//        Engine.SetTarget();
        NickNameChanged(Ch.oid, 'test3');
        delay(1);
      end;
  end;
end.