unit sdpSTR;
Interface
uses Classes;
function Split(Delim: Char; Text: String): Array of String;
function Replace(const SourceString, OldPattern, NewPattern: String; vAll: Boolean = true; vIgnoreCase: Boolean = false): string;
Implementation
uses SysUtils, sdpSTRINGS;
function Split(Delim: Char; Text: String): Array of String;
  var
    OutPutList: TStringList;
    arr: Array of String;
    i: Integer;
  begin
    OutPutList := TStringList.Create;
    try
      _split(Delim, Text, OutPutList);
      SetLength(arr, OutPutList.Count);
      for i := 0 to OutputList.Count - 1 do
        arr[i] := OutPutList[i];
      Result := arr;
    finally
      OutPutList.Free;
    end;
  end;
procedure _split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
  begin
    ListOfStrings.Clear;
    ListOfStrings.Delimiter       := Delimiter;
    ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
    ListOfStrings.DelimitedText   := Str;
  end;
function Replace(const SourceString, OldPattern, NewPattern: String; vAll: Boolean = true; vIgnoreCase: Boolean = true): string;
  var
    arr: TReplaceFlags;
  begin
    if vAll and vIgnoreCase then 
      arr := [rfReplaceAll, rfIgnoreCase]
    else if vAll then 
      arr := [rfReplaceAll]
    else if vIgnoreCase then 
      arr := [rfIgnoreCase]
    else 
      arr := [];
    Result := stringreplace(SourceString, OldPattern, NewPattern, arr);
  end;

end.