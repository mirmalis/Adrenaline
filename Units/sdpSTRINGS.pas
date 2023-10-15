Unit sdpStrings;
interface
uses Classes;

function ToStr(i: Double): String; Overload;
function ToStr(i: Boolean): String; Overload;
function ToStr(i: Single): String; Overload;
function ToStr(i: Integer): String; Overload;
function ToStr(p: Pointer): String; Overload;
// function ToStr(i: Cardinal): String; Overload; 
function ToStr(str: String): String; Overload;

function ToInt(dbl: Double): Integer; Overload;
function ToInt(str: String): Integer; Overload;
function ToInt(bl: Boolean): Integer; Overload;
function Floor(dbl: Double): Integer; Overload;

function ToArrOfString(Strings: TStringList): Array of String;
function ToLower(str: String): String;

function new_line(): String;
// vectors
function is_in(a: Integer; arr: Array of Integer): Boolean; Overload;
function is_in(a: String; arr: Array of String): Boolean; Overload;
function is_in(a: String; vSLString: String): Boolean; Overload;
function is_in(a: String; arr: TStringList): Boolean; Overload;
function overlap(arrA, arrB: Array of Integer): Boolean; Overload; 
function overlap(arrA, arrB: Array of String): Boolean; Overload; 
// strings
function TrimLeft(text: String): String;
// other
implementation
Uses SysUtils, sdpSL;
var i: Integer; str: String; // tbd: make variables local;
// Conversion
function ToStr(i: Double): String; Overload; 
  begin
    Result := FToStr(i);
  end;
function ToStr(i: Boolean): String; Overload; 
  begin
    if (i) then 
      Result := 'true'
    else 
      Result := 'false';
  end;
function ToStr(i: Single): String; Overload; 
  begin
    Result := ToStr(trunc(i));
  end;
function ToStr(str: String): String; Overload; 
  begin
    Result := str;
  end;
function ToStr(i: Integer): String; Overload; 
  begin
    Result := IntToStr(i);
  end;
function ToStr(p: Pointer): String; Overload;
  begin
    Result := MemToHex(p, 1);
  end;
// function ToStr(i: Cardinal): String; Overload; 
//   begin
//     Result := UIntToStr(i);
//   end;
function ToInt(dbl: Double): Integer; Overload;
  begin
    Result := trunc(dbl);

  end;
function ToInt(str: String): Integer; Overload;
  begin
    try
      Result := StrToInt(str);    // 'G' is an invalid hexadecimal digit
    except
    on Exception : EConvertError do
    begin
    end;
    end;

  end;
function Floor(dbl: Double): Integer; Overload;
  begin
    Result := ToInt(dbl - Frac(dbl));
    // terible!
    // if (dbl < 0) then 
    //   Result := Trunc(dbl) - 1
    // else 
    //   Result := Trunc(dbl);
  end;
function ToArrOfString(Strings: TStringList): Array of String;
  var
    i: Integer;
    arr: Array of String;
  begin
    SetLength(arr, Strings.Count);
    For i := 0 To Strings.Count-1 Do
      arr[i] := Strings[i];
    Result := arr;
  end;
function ToLower(str: String): String;
  begin
    Result := LowerCase(str);
  end;
// Convert from Array of String to TStringList

function ToInt(bl: Boolean): Integer; Overload;
  begin
    if (bl) then Result := 1
    else Result := 0;
  end;

function new_line(): String; 
  begin
    Result := AnsiString(#13#10);
  end;
// vectors
function is_in(a: Integer; arr: Array of Integer): Boolean; Overload;
  var part: Integer;
  begin
    Result := False;
    for part in arr do
    begin 
      if part = a then 
      begin 
  	    Result := True;
  	    Break;
  	  end;
    end;
  end;
function is_in(a: String; arr: Array of String): Boolean; Overload;
  var 
    part: String; 
    i: Integer;
  begin
    Result := False;
    for i := 0 to Length(arr) - 1 do
    begin
      if a = arr[i] then 
        begin 
          Result := True;
          Break;
        end;
    end;
  end;

function is_in(a: String; vSLString: String): Boolean; Overload;
  begin
    Result := is_in(a, SL(vSLString));
  end;
function is_in(a: String; arr: TStringList): Boolean; Overload;
  var 
    part: String; 
    i: Integer;
  begin
    Result := False;
    for i := 0 to arr.Count - 1 do
    begin
      if a = arr[i] then 
        begin 
          Result := True;
          Break;
        end;
    end;
  end;
function overlap(arrA, arrB: Array of Integer): Boolean; Overload; 
  var part: Integer;
  begin
    Result := False;
    for part in arrA do 
    begin
      if is_in(part, arrB) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
function overlap(arrA, arrB: Array of String): Boolean; Overload; 
  var part: String;
  begin
    Result := False;
    for part in arrA do 
    begin
      if is_in(part, arrB) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
// strings
function TrimLeft(text: String): String;
  begin
    Result := SysUtils.TrimLeft(text);
  end;
// other


end.