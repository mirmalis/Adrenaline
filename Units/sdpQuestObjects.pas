unit sdpQuestObjects;
interface
uses SysUtils;
type 
TQuestPart = class
  private
    FPartId: Integer;
    FName: String;
  public
    constructor Create(partId: Integer; const name: String);
    property PartId: Integer read FPartId;
    property Name: String read FName;
  end;

TQuest = class
  private
    FId: Integer;
    FName: String;
    FParts: array of TQuestPart;
    FPartCount: Integer;
  public
    constructor Create(id: Integer; const name: String);
    procedure AddPart(part: TQuestPart);
    property Id: Integer read FId;
    property Name: String read FName;
    property PartCount: Integer read FPartCount;
    function GetPart(index: Integer): TQuestPart;
    function ToString: string;
  end;
implementation
  constructor TQuestPart.Create(partId: Integer; const name: String);
    begin inherited Create;
      FPartId := partId;
      FName := name;
    end;

  constructor TQuest.Create(id: Integer; const name: String);
    begin inherited Create;
      FId := id;
      FName := name;
      FPartCount := 0;
    end;

  procedure TQuest.AddPart(part: TQuestPart);
    begin
      SetLength(FParts, FPartCount + 1);
      FParts[FPartCount] := part;
      Inc(FPartCount);
    end;

  function TQuest.GetPart(index: Integer): TQuestPart;
    begin
      if (index >= 0) and (index < FPartCount) then
        Result := FParts[index]
      else
        Result := nil; // Handle out-of-range index gracefully if needed
    end;

  function TQuest.ToString: string;
  var
    IdStr: string;
  begin
    IdStr := Format('%.*d', [4, FId]);
    IdStr := StringReplace(IdStr, '0', '_', [rfReplaceAll]);
    Result := Format('Quest [%s] %s', [IdStr, FName]);
  end;
var
  shroom: TQuest;
initialization
shroom := TQuest.Create(1, 'trade with IT');
Print(TQuest.Create(12, 'trade with IT').ToString);
Print(TQuest.Create(1412, 'trade with IT').ToString);
Print(shroom.ToString);
end.
