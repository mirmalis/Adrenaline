unit threadShadowWeapon;
Interface
procedure ShadowWeapon();
procedure ShadowWeaponInfo();
Implementation
uses
  sdpREGEX
  , sdpITEM
;
procedure ShadowWeapon();
  begin
    while EnsureShadowItemOn('Shadow Item') do 
      Delay(1000);
    Print('ShadowWeapon could not be ensured and now is stopped.');
  end;
procedure ShadowWeaponInfo();
  begin
    Print('Puts on whatever shadow weapon is awailable when shadow item is not equiped.');
  end;
function EnsureShadowItemOn(vName: String): Boolean;
  begin
    if (getNamedItem(vName, true) = nil) then
    begin
      Print('Reequipping shadow item');
      doEquip(getNamedItem(vName), true);
      Result := getNamedItem(vName, true) <> nil;
    end else Result := true;
  end;
end.