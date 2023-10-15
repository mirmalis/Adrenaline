unit sdpSL;
interface
uses Classes;
function SL(delimitedText: String; delimiter: Char = ';'; doTrim: Boolean = true): TStringList;
function SLJoin(l1, l2: TStringList): TStringList;
implementation
uses SysUtils;
function SL(delimitedText: String; delimiter: Char = ';'; doTrim: Boolean = true): TStringList;
  begin
    Result := TStringList.Create;
    Result.StrictDelimiter := true;
    Result.Delimiter := delimiter;
    if (doTrim) then
      Result.DelimitedText := Trim(delimitedText)
    else 
      Result.DelimitedText := delimitedText;
  end;
function SLJoin(l1, l2: TStringList): TStringList;
  var i: Integer;
  begin
    Result := l1;
    if (l2.Count = 0) then exit;
    for i := 0 to l2.Count - 1 do
      Result.Add(l2[i]);
  end;
end.