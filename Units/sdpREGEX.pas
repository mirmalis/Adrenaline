Unit sdpREGEX;
Interface
Uses Classes;
function str_detect(str, pattern: String; caseSensitive: Boolean = false): Boolean; Overload;
function str_detect_any(str: String; patterns: Array of String; caseSensitive: Boolean = false): Boolean;
function str_extract(SL: TStringList; pattern: String; output: String = '$0'): String; Overload;
function str_extract(str, pattern: String; output: String = '$0'): String; Overload;
function str_extract_all(str, pattern: String; output: String = '$0'): TStringList;
procedure str_print(SL: TStringList);
Implementation
Uses RegExpr, sdpSTRINGS, SysUtils
  ;
function str_detect(str, pattern: String; caseSensitive: Boolean = false): Boolean; Overload;
  var
    RegExp: TRegExpr;
  begin
    RegExp := TRegExpr.Create;
    // Should use i flag, but it crashes for some reason or another.
    //RegExp.ModifierI := true; // Crashes for some reason
    if (not caseSensitive) then 
    begin
      RegExp.Expression:= LowerCase(pattern);
      Result := Regexp.Exec(LowerCase(str));
    end
    else
    begin
      RegExp.Expression:= pattern;
      Result := RegExp.Exec(str);
    end;
  end;
function str_detect_any(str: String; patterns: Array of String; caseSensitive: Boolean = false): Boolean;
  var
    part: String;
  begin
    Result := false;
    for part in patterns do
      if str_detect(str, part, caseSensitive) then 
        begin
          Result := true;
          Break;
        end;
  end;
  
function str_extract(SL: TStringList; pattern: String; output: String = '$0'): String; Overload;
  var 
    i: Integer;
  begin
    Result:= '';
    for i := 0 to SL.Count-1 do 
      if str_detect(SL[i], pattern) then 
        Result := str_extract(SL[i], pattern, output);
    SL.Free;
  end;
function str_extract(str, pattern: String; output: String = '$0'): String; Overload;
  var listOfAll: TStringList;
  begin
    // cbd:needs to be done more efficiently, w/o code duplication. someday.
    // Print('ohh the shame of using this function (str_extract done in least efficient way)');
    listOfAll := str_extract_all(str, pattern, output);
    if listOfAll <> Nil then 
      Result := listOfAll[0]
    else 
      Result := '';
  end;
function str_extract_all(str, pattern: String; output: String = '$0'): TStringList;
  var
    RegExp: TRegExpr;
    i,j: Integer;
    tempStr: String;
  begin
    RegExp:= TRegExpr.Create;
    Result := TStringList.Create;
    RegExp.Expression := pattern;
    if RegExp.Exec(str) then
      repeat 
      begin
        tempStr := '';
        for i := 1 to Length(output)-1 do
        begin
          j := 0;
          if (output[i] = '$') then
          begin
            repeat // cbd:use built in regex method to extract pattern. dunno how though.
              i := i + 1;
              j := j * 10 + ToInt(output[i]);
            until not str_detect(output[i+1], '\d') or (i >= Length(output));
            tempStr := tempStr + RegExp.Match[j];
          end 
          else 
          begin
            tempStr := tempStr + output[i];
          end;
        end;
        Result.Add(tempStr);
      end until (not RegExp.ExecNext)
    else Result := Nil;

  end;
procedure str_print(SL: TStringList);
  var 
    i: Integer;
  begin
    for i := 0 to SL.Count-1 do 
      Print(SL[i]);
    SL.Free;
  end;
end.

// str_extract('tlp:Silent Valey', 'tlp:(.*)', '$1');
  // expected: 'Silent Valey
  // factual: ''
  