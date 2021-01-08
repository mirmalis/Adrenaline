uses SysUtils;

var
  p1: cardinal;
  p2: pointer;
  action: TL2Action;
  src, dst: string;
  dmg: cardinal;
begin
  while engine.status = lsOnline do
  begin
    Action := Engine.WaitAction([laSysMsg], p1, p2);

    if Action = laSysMsg then
    begin
      if p1 = 2261 then //'Src' deal to 'Dst' 'xxx' damage
      begin
        src := string(pchar(p2));

        p2 := pointer(cardinal(p2) + ((length(src) + 1) * 2));
        p2 := pointer(cardinal(p2) + 4);

        dst := string(pchar(p2));

        p2 := pointer(cardinal(p2) + ((length(dst) + 1) * 2));
        p2 := pointer(cardinal(p2) + 4);

        dmg := pcardinal(p2)^;

        print src + '->' + dst + ' (' + intToStr(dmg) + ' dmg)';
      end;
    end;
  end;
end.