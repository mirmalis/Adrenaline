unit RecorderUnit;
interface
uses SysUtils, StdCtrls, Controls, Forms, Dialogs, Classes, sdpBYPASS, sdpREGEX;

type
TRecorderForm = class (TForm)
  public
    LB    : TListBox;
    bStart: TButton;
    bStop : TButton;
    bClear: TButton;
    bDel  : TButton;
    bSave : TButton;
    LBChoices : TListBox;
    procedure ToLog(const S: string);
    constructor Create();
    destructor Destroy(); Override;
  private
    procedure InitializeData();
    procedure ButtonClickEvent(Sender: tobject);
  end;
var
  RecFrm: TRecorderForm;
procedure RecorderCreate();
procedure RecorderDestroy();
implementation
procedure RecorderCreate();
  begin
    RecFrm := TRecorderForm.Create();
    RecFrm.InitializeData;
  end;
procedure RecorderDestroy();
  var
    Tmp: TRecorderForm;
  begin
    Tmp := RecFrm;
    RecFrm := nil;
    Tmp.Free;

  end;
procedure TRecorderForm.InitializeData;
  begin
    Caption         := 'Script Recorder';
    BorderStyle     := bsDialog;
    Position        := poScreenCenter;
    Height          := 340;
    Width           := 350;
    AlphaBlendValue := 200;
    AlphaBlend      := true;

    LB              := TListBox.Create(Self);
    LB.Parent       := Self;
    LB.Width        := 250;
    LB.Left         := 0;
    LB.Align        := alLeft;

    // LBChoices       := TListBox.Create(Self);
    // LBChoices.Parent:= Self;
    // LBChoices.left  := 450;
    // LBChoices.Width := 50;
    // LBChoices.Align := alLeft;

    bStart          := TButton.Create(Self);
    bStart.left     := LB.Width + 10;
    bStart.Caption  := 'Start';
    bStart.OnClick  := ButtonClickEvent;
    bStart.Parent   := Self;

    bStop           := TButton.Create(Self);
    bStop.left      := bStart.left;
    bStop.Top       := bStart.Top + bStart.Height + 4;
    bStop.Enabled   := false;
    bStop.Caption   := 'Stop';
    bStop.OnClick   := ButtonClickEvent;
    bStop.Parent    := Self;

    bClear          := TButton.Create(Self);
    bClear.left     := bStart.left;
    bClear.Top      := bStop.Top + bStop.Height + 4;
    bClear.Caption  := 'Clear';
    bClear.OnClick  := ButtonClickEvent;
    bClear.Parent   := Self;

    bDel            := TButton.Create(Self);
    bDel.left       := bStart.left;
    bDel.Top        := bClear.Top + bClear.Height + 4;
    bDel.Caption    := 'Del. selected';
    bDel.OnClick    := ButtonClickEvent;
    bDel.Parent     := Self;

    bSave           := TButton.Create(Self);
    bSave.left      := bStart.left;
    bSave.Top       := bDel.Top + bDel.Height + 4;
    bSave.Caption   := 'Save';
    bSave.OnClick   := ButtonClickEvent;
    bSave.Parent    := Self;

    Show;
  end;
procedure TRecorderForm.ButtonClickEvent(Sender: TObject);
  var S: string;
  begin
    case Sender of
      RecFrm.bClear: RecFrm.LB.Clear;
      RecFrm.bSave: begin
        S := '';
        if not PromptForFileName(S, 'ScriptRec (*.txt)|*.txt', '.txt', '', '', true) then
          exit;
        RecFrm.LB.Items.insert(0,'begin');
        RecFrm.LB.Items.Add('end.');
        RecFrm.LB.Items.SaveToFile(S);
        RecFrm.LB.Items.delete(0);
        RecFrm.LB.Items.delete(RecFrm.LB.Items.Count -1);
      end;
      RecFrm.bDel: if (RecFrm.LB.ItemIndex <> 0) then
        begin
          RecFrm.LB.Items.delete(RecFrm.LB.ItemIndex)
        end;
      RecFrm.bStart: begin
        RecFrm.bStart.Enabled := false;
        RecFrm.bStop.Enabled := true;
      end;
      RecFrm.bStop: begin
        RecFrm.bStart.Enabled := true;
        RecFrm.bStop.Enabled := false;
      end;
      else Print('Unsupported Sender@TEvents.ButtonClickEvent');
    end;
  end;
procedure TRecorderForm.ToLog(const S: string);
  begin
    if (assigned(RecFrm)) and (not bStart.Enabled) then LB.Items.Add(S);
  end;
constructor TRecorderForm.Create();
  begin
    inherited Create(Nil);
  end;
destructor TRecorderForm.Destroy(); Override;
  begin
    bStart.Free; bStart := nil;
    bStop.Free; bStop := nil;
    bClear.Free; bClear := nil;
    bDel.Free; bDel := nil;
    bSave.Free; bSave := nil;
    LB.Free; LB := nil;
    LBChoices.Free; LBChoices := nil;
    inherited Destroy;
  end;
end.
