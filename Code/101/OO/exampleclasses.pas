uses sdpBYPASS, sdpSL, Classes;
var part: String;
i: Integer;
L: TStringList;
type Amount = record
  id       : Integer;
  amount   : Integer;
  end;
type Item = record
  id       : Integer;
  name     : String;
  end;
type Exchange = class
  public
  res   : Amount;
  r1,r2: Integer;
  c1,c2: Integer;
  cost     : Amount;
  constructor Create(resultId: Integer; resultAmount: Integer; costId: Integer; costAmount: Integer); overload;
  
  end;
constructor Exchange.Create(resultId: Integer; resultAmount: Integer; costId: Integer; costAmount: Integer); overload;
  begin
  inherited Create();
  with res do
  begin
    id := resultId;
    amount := resultAmount;
  end;
  with cost do
  begin
    id := costId;
    amount := costAmount;
  end;
  end;
var
  bspsc : Exchange;
begin
  bspsc := Exchange.Create(123, 1000, 50000, 57);
  Print(bspsc.res.id);
  // CB('Buffer;L2UI_CT1.ItemWindow_DF_Frame_Down');
//end.
end.
  L := _getControls(Engine.CBText);
  
  for i := 0 to L.Count - 1 do
    print(L[i]);
  Print(L.Count);  
end.