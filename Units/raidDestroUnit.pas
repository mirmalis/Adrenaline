unit raidDestroUnit;
interface
uses sdpRaidUnit;
  var
    hitter, hitee: string;
    ind: Integer;
function BeSlaveDestroyer(x: Integer): Boolean;

implementation
  uses sdpMath, sdpSlaveMaster, sdpItem;
  const
    helm: Integer = 6;
    gloves: Integer = 9;
    chest: Integer = 10;
    pants: Integer = 11;
    boots: Integer = 12;
    
  var 
    arr: Array of Integer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    isNaked: Boolean = false;
    sword: TL2Item;
    swordId: Integer = 0;
    gradeName: string;
  
  function BeSlaveDestroyer(x: Integer): Boolean;
    begin
      Result := true;
      if x = 1 then Print('yes Masa (destroyer)')
      else if x = getLowCommand then GetLow(20)
      else if x = getLastLowCommand then GetLow(25)
      else if x = doLowerCommand then DoLower(20)
      else if x = doLastLowerCommand then DoLower(25)
      else if x = moveToRaidCommand then MoveToRaid
      else if x = frenzyCommand then Frenzy
      else if x = doNothingCommand then begin
        EquipDagger;
        Engine.FaceControl(0, false);
      end
      else Result := false;
    end;
  function Get2HSword(): TL2Item;
    begin
      if(User.Level >= 52) then Result := FindItem(0, 'B', 16384, 1);
      if((Result = nil) and (User.Level >= 40)) then Result := FindItem(0, 'C', 16384, 1);
      if((Result = nil) and (User.Level >= 20)) then Result := FindItem(0, 'D', 16384, 1);
      if((Result = nil)) then Result := FindItem(0, 'NG', 16384, 1);
    end;
  function SwordShots(state: Boolean): Boolean;
    begin
      if(sword = nil) then begin
        Engine.Say('I have no sword :(', 3, '');
      end else begin
        case gradeName of
          'D': Result := Engine.DAutoSoulShot(1463, state);
          'C': Result := Engine.DAutoSoulShot(1464, state);
          'B': Result := Engine.DAutoSoulShot(1465, state);
          else Engine.Say('no shots :( for' + sword.Name + '(' + sword.gradeName + ')', 3, '');
        end;
      end;
      
    end;
  procedure MoveToRaid;
    var vLive: TL2Live;
    begin
      ShMem[ind] := 1;
      Engine.SetTarget('lllhp');
      Delay(1200);
      vLive := User.Target.Target;
      Engine.MoveTo(vLive.X + 50, vLive.Y + 50, vLive.Z);
      ShMem[ind] := 0;
    end;
  procedure Frenzy;
    begin
      EquipDagger;
      Engine.UseSkill('Rage', false, false);
      Engine.UseSkill('Frenzy', false, false);
      Engine.UseSkill('Battle Roar', false, false);
      EquipSword;
      Engine.LoadConfig('de');
    end;
  procedure DoLower(hp: Integer);
    begin
      EquipDagger;
      Engine.SetTarget(hitee);
      while User.Target.HP > hp do begin
        Engine.Attack(100, true);
      end;
      Engine.MoveTo(User.X+25, User.Y+17, User.Z);
    end;
  procedure EquipDagger();
    
    begin
      SwordShots(false);
      Equip(4761, true);
      
    end;
  procedure EquipSword();
    begin
      SwordShots(true);
      if(not sword.Equipped) then begin
        Equip(SwordID);
      end;
    end;
  procedure getNaked(control: TL2Control);
    begin
      TakeOfItem(control, helm);
      TakeOfItem(control, boots);
      TakeOfItem(control, gloves);
      TakeOfItem(control, chest);
      TakeOfItem(control, pants);
    end;
  procedure TakeOfItem(control: TL2Control; ind: Integer);
    var
      inv: TInventory;
      i: Integer;
      item: TL2Item;
    begin
      inv := control.GetInventory();
      for i := 0 to inv.User.Count - 1 do begin
        item := inv.user.Items(i);
        if(Log2(item.BodyPart) = ind) then begin
          if(item.Equipped) then control.UseItemOID(item.OID, false, true );
          arr[ind] := item.OID;
          break;
        end;
      end;
    end;
  procedure getDressed(control: TL2Control);
    begin
      PutOnItem(control, helm);
      PutOnItem(control, gloves);
      PutOnItem(control, boots);
      PutOnItem(control, pants);
      PutOnItem(control, chest);
    end;
  procedure PutOnItem(control: TL2Control; ind: Integer);
    begin
      if(arr[ind] <> 0) then begin
        control.UseItemOID(arr[ind], false, true);
        arr[ind] := 0;
      end;
    end;
  function GetLow(hp: Integer): Integer;
    var
      control: TL2Control;
    begin
      ShMem[ind] := 1;
      control := Engine;
      if(control = nil) then begin end
      else begin
        isNaked := true;
        GetNaked(control);
        while Control.GetUser.HP > (hp+10) do begin
          Delay(100);
        end;
        PutOnItem(control, helm);
        while Control.GetUser.HP > (hp+5) do begin
          Delay(100);
        end;
        PutOnItem(control, gloves);
        while Control.GetUser.HP > (hp) do begin
          Delay(100);
        end;
        GetDressed(control);
        isNaked := false;
      end;
      ShMem[ind] := 0;
      Result := 0;
    end;

  function FindItem(
    itemType: Integer; // 0=weapon 1=Armor 2=Jewelery 4=adena 5=shots,summoncr, 
    gradeName: string; // 'NG' 'D', 'C', 'B', 'A', 'S'
    bodyPart: Integer; // 0=None 4=Earring 8=Neclase 32=Ring 64=Helmet 128=1hweapon 256=armor 1024=Chest 16384 = 2h 65536=circlet
    dbItemType2: Integer // 0=Helm 1=Sword 2=Blunt
    ): TL2Item;
    var 
      i: Integer;
      item: TL2Item;
      DBObj: TBaseObject;
      dbItem: TBaseItem;
    begin
      for i := 0 to Inventory.User.Count - 1 do 
      begin
        item := Inventory.User.Items(i);
        DBObj := L2DB.Items.ByID(item.ID, 1);
        if(
              (item.ItemType = itemType)
          and (item.GradeName = gradeName)
          and (item.BodyPart = bodyPart)
          and (TBaseItem(L2DB.Items.ByID(item.ID, 1)).Type2 = dbItemType2)
          
        ) then begin
          Result := item;
          break;
        end;
      end;
    end;
initialization
  sword := Get2HSword;
  swordId := sword.id;
  gradeName := sword.GradeName;
  if(sword <> nil) then Print(sword.Name);
  EquipDagger;
  Engine.FaceControl(0, false);
  Engine.LoadConfig('de');
  if (User.Name = 'lll1') then begin hitter := 'lll2'; hitee := 'lll2'; ind := 0; end 
  else if (User.Name = 'lll2') then begin hitter := 'lll1'; hitee := 'lll1'; ind := 1; end 
  else if (User.Name = 'lll3') then begin hitter := 'lll4'; hitee := 'lll4'; ind := 3; end
  else if (User.name = 'lll4') then begin hitter := 'lll3'; hitee := 'lll3'; ind := 4; end 
  else Print('Unsupported destro');
end.