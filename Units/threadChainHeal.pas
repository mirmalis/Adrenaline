unit threadChainHeal;
  // uses threadChainHeal in 'Libraries\Threads\threadChainHeal.pas';
  // Script.NewThread(@ChainHealThread, Pointer(85));
interface
  // Check if average party hp is lower than <vPerc>, if so casts ChainHeal on himself.
procedure threadChainHeal(vPerc: Integer = 85);
implementation
function PartyAvarageHP(vDist: integer = 450): Integer;
  var
    sum, i, n: Integer;
  begin
    sum := User.hp; n := 1;
    for i := i to Party.Chars.Count - 1 do
    begin
      if (User.DistTo(Party.Chars.Items(i)) < vDist) then begin
        sum := sum + Party.Chars.Items(i).HP;
        n := n + 1;
      end;
    end;
    Result := trunc(sum/n);
  end;
procedure threadChainHeal(vPerc: Integer = 85);
  var PreviousTarget: Tl2Live;
  begin
    while Delay(555) do begin
      if (Engine.Status = lsOnline) then 
      begin
        if (PartyAvarageHP(450) < vPerc) then begin
          PreviousTarget:= User.Target;
          Engine.FaceControl(0, false);
          if Engine.SetTarget(User) then Delay(111);
          if Engine.UseSkill(1553) then Delay(111);
          Delay(User.Cast.EndTime);
          Engine.SetTarget(PreviousTarget);
          Engine.FaceControl(0, true);
        end;
      end;
    end;
  end;
end.