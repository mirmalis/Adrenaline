unit sdpPacketUnit;

interface

type TNetworkPacket = class
  public
    Current: Integer;
    constructor Create(pData: PChar; vDataSize: Word); overload;
    constructor Create(); overload;
    procedure WriteQ(value: Int64);
    procedure Write64(value: Int64);      // WriteQ
    procedure WriteD(value: Cardinal);
    procedure Write32(value: Cardinal);   // WriteD
    procedure WriteH(value: Word);
    procedure Write16(value: Word);       // WriteH
    procedure WriteC(value: Byte);
    procedure Write8(value: Byte);        // WriteC
    procedure WriteS(value: String);
    procedure WriteString(value: String); // WriteS
    function ReadQ(): Int64;
    function Read64(): Int64;             // ReadQ, Q = ??
    function ReadD(): Cardinal;
    function Read32(): Cardinal;          // ReadD, D = ??
    function ReadH(): Word;
    function Read16(): Word;              // ReadH, H = ??
    function ReadC(): Byte;
    function Read8(): Byte;               // ReadC, C = ??
    function ReadS(): String;
    function ReadString(): String;        // ReadS, S = String
    function ToHex(): String;
    function SendToServer(vControl: TL2Control): Boolean;
    function SendToClient(vControl: TL2Control): Boolean;
    
    function Done(): Boolean;
    procedure Skip(amount: Integer);
    procedure PrintMem(vStepSize: Integer = 1);
    procedure PrintFormatted(vFormat: String);
  private
    dataSize: Word;
    data: Array[0..10240] of Byte;
  end;


implementation
uses SysUtils, sdpStrings, sdpSTR, sdpMATH;
constructor TNetworkPacket.Create(pData: PChar; vDataSize: Word);
  begin
    inherited Create;
    self.dataSize := vDataSize;
    Move(pData^, PChar(@data[0])^, vDataSize);
  end;

constructor TNetworkPacket.Create();
  begin
    inherited Create;
  end;

function TNetworkPacket.ReadQ;
  begin
    Result:= PInt64(@data[Current])^;
    Current:= Current + SizeOf(Int64);
  end;
function TNetworkPacket.Read64;
  begin
    Result := ReadQ;
  end;
function TNetworkPacket.ReadD;
  begin
    Result:= PCardinal(@data[Current])^;
    Current:= Current + SizeOf(Cardinal);
  end;
function TNetworkPacket.Read32;
  begin
    Result:= ReadD;
  end;
function TNetworkPacket.ReadH;
  begin
    Result:= PWord(@data[Current])^;
    Current:= Current + SizeOf(Word);
  end;
function TNetworkPacket.Read16;
  begin
    Result:= ReadH;
  end;

function TNetworkPacket.ReadC;
  begin
    Result:= PByte(@data[Current])^;
    Current:= Current + SizeOf(Byte);
  end;
function TNetworkPacket.Read8;
  begin
    Result:= ReadC;
  end;

function TNetworkPacket.ReadS;
  begin
    Result:= String(PChar(@data[Current]));
    Current:= Current + (Length(Result) + 1) * SizeOf(Char);
  end;
function TNetworkPacket.ReadString;
  begin
    Result := ReadS;
  end;
procedure TNetworkPacket.WriteQ;
  begin
    (PInt64(@data[Current])^):= value;
    Current:= Current + SizeOf(Int64);
  end;
procedure TNetworkPacket.Write64;
  begin
    WriteQ(value);
  end;

procedure TNetworkPacket.WriteD;
  begin
    (PCardinal(@data[Current])^):= value;
    Current:= Current + SizeOf(Cardinal);
  end;
procedure TNetworkPacket.Write32;
  begin
    WriteD(value);
  end;

procedure TNetworkPacket.WriteH;
  begin
    (PWord(@data[Current])^):= value;
    Current:= Current + SizeOf(Word);
  end;
procedure TNetworkPacket.Write16;
  begin
    WriteH(value);
  end;

procedure TNetworkPacket.WriteC;
  begin
    (PByte(@data[Current])^):= value;
    Current:= Current + SizeOf(Byte);
  end;
procedure TNetworkPacket.Write8;
  begin
    WriteC(value);
  end;

procedure TNetworkPacket.WriteS;
  begin
    Move(value^, PChar(@data[Current])^, (Length(value) + 1) * SizeOf(Char));
    Current:= Current + (Length(value) + 1) * SizeOf(Char);
  end;
procedure TNetworkPacket.WriteString;
  begin
    WriteS(value);
  end;

function TNetworkPacket.ToHex;
  var i: Cardinal;
  begin
    Result:= '';
    for i:= 0 to Current-1 do 
      Result:= Result + IntToHex(data[i], 2);
  end;

function TNetworkPacket.SendToServer;
  begin
    vControl.SendToServer(Self.ToHex);
  end;

function TNetworkPacket.SendToClient;
  begin
    vControl.SendToClient(Self.ToHex);
  end;


function TNetworkPacket.Done(): Boolean;
  begin
    Result := dataSize <= Current;
  end;
procedure TNetworkPacket.Skip(amount: Integer);
  begin
    self.Current := self.Current + amount;
  end;
procedure TNetworkPacket.PrintFormatted(vFormat: String);
  var
    
    s1: Array of String;
    variables: string;
    part: string;
    str: string;
    startCurrent: Integer;
  begin
    startCurrent := Current;
    Current := 0;
    s1 := Split(':', vFormat);
    Print(s1[0]);
    variables := s1[1];
    s1 := Split(')', variables);
    for part in s1 do begin
      if part <> '' then
      begin
        str := '  '+part+'): ';
        case Copy(part, 1, 1) of
          'q': str := str + ToStr(ReadQ);
          'd': str := str + ToStr(ReadD);
          'h': str := str + ToStr(ReadH);
          'c': str := str + ToStr(ReadC);
        end;
        Print(str);
      end;
    end;
    // restore current index.
    Current := startCurrent;
  end;
procedure TNetworkPacket.PrintMem(vStepSize: Integer = 1);
  var 
    aShift: Integer;
  begin
    aShift := 0;
    Print(ToHex);
    while aShift < max(DataSize, Current) do begin
      PrintMemAt(aShift, @Data, DataSize);
      Inc(aShift, vStepSize);
    end;
  end;
procedure PrintMemAt(aShift: Integer; vData: pointer; vDataSize: word);
  var printStr: String;
  var aChar, aCardinal, aIneger, aWord, aByte: string;
  begin
    aChar := ToStr(Char(Cardinal(Cardinal(vData)+aShift)^));
    aCardinal := ToStr(Cardinal(Cardinal(Cardinal(vData)+aShift)^));
    aIneger := ToStr(Integer(Cardinal(Cardinal(vData)+aShift)^));
    aWord := ToStr(Word(Cardinal(Cardinal(vData)+aShift)^));
    aByte := ToStr(Byte(Cardinal(Cardinal(vData)+aShift)^));

    printStr := '[32: ' + aCardinal + '/' + aIneger + ', 16: '+ aWord + ', 8: '+ aByte + ']';
    if (aChar <> '') then begin
      printStr := '''' + aChar + ''' or ' + printStr;
    end;

    Print(ToStr(aShift) + '/' + ToStr(vDataSize) + ': ' + printStr);
  end;
end.