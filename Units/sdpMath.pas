Unit sdpMath;
Interface
function Max(a: Integer; b: Integer): Integer;
function Min(a: Integer; b: Integer): Integer;
function Log2(number: Integer): Integer;
Implementation
function Min(a: Integer; b: Integer): Integer;
  begin
    if(a < b) 
    then Result := a
    else Result := b;

  end;
function Max(a: Integer; b: Integer): Integer;
  begin
    if(a >= b) 
    then Result := a
    else Result := b;

  end;
function Log2(number: Integer): Integer;
  begin
    Result := -1;
    case number of
        1: Result := 0;
        2: Result := 1;
        4: Result := 2;
        8: Result := 3;
        16: Result := 4;
        32: Result := 5;
        64: Result := 6;
        128: Result := 7;
        256: Result := 8;
        512: Result := 9;
        1024: Result := 10;
        2048: Result := 11;
        4096: Result := 12;
        8192: Result := 13;
        16384: Result := 14;
        32768: Result := 15;
        65536: Result := 16;
        131072: Result := 17;
        262144: Result := 18;
        524288: Result := 19;
        1048576: Result := 20;
        2097152: Result := 21;
        4194304: Result := 22;
        8388608: Result := 23;
        16777216: Result := 24;
        33554432: Result := 25;
        67108864: Result := 26;
        134217728: Result := 27;
        268435456: Result := 28;
        536870912: Result := 29;
        1073741824: Result := 30;
    end;    
  end;
end.