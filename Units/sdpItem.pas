unit sdpItem;
interface
function Equip(vID: Integer; newState: Boolean = True): Boolean; Overload;
function Equip(vID: Integer; newState: Boolean; vControl: TL2Control): Boolean; Overload;
function ItemCount(vID: Integer): Integer; Overload;
function Adena(): Integer;
implementation
  function Equip(vID: Integer; newState: Boolean = True): Boolean; Overload;
    begin
      Result := Equip(vID, newState, Engine);
    end;
  function Equip(vID: Integer; newState: Boolean; vControl: TL2Control): Boolean; Overload;
    var 
      aItem: TL2Item;
      i: Integer;
      aInventory: TInventory;
    begin
      if (vControl = Nil) then exit;
      if (vID <= 0) then exit;
      aInventory := vControl.GetInventory;
      Result := not newState;
      if newState then begin
        if aInventory.User.ByID(vID, aItem) then
        begin
          Result := true;
          if (aItem.Equipped <> newState) then 
          begin
            vControl.UseItem(aItem);
            Delay(500);
          end;
        end;
      end
      // newState = false
      else begin
        for i := 0 to aInventory.User.Count - 1 do begin
          aItem := aInventory.User.Items(i);
          if (aItem.ID = vID) then begin
            Result := true;
            if (aItem.Equipped) then begin
              vControl.UseItem(aItem);
              Delay(500);
            end;
          end;
        end;
      end;
    end;
  function ItemCount(vID: Integer): Integer; Overload;
    var aItem: TL2Item;
    begin
      if Inventory.User.ByID(vID, aItem) then Result := aItem.Count
      else if Inventory.Quest.ByID(vID, aItem) then Result := aItem.Count
      else Result := 0;
    end;
  function Adena(): Integer;
    begin
      Result := itemCount(57);
    end;
end.