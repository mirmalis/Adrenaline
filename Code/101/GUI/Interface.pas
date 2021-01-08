//Source: https://forum.l2kot.ru/index.php?/topic/335-%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82-%D0%BD%D0%B0-%D0%B0%D0%B2%D1%82%D0%BE%D0%B2%D1%85%D0%BE%D0%B4-%D0%BF%D0%BE%D1%81%D0%BB%D0%B5-%D1%80%D0%B5%D1%81%D1%82%D0%B0%D1%80%D1%82%D0%B0/
uses SysUtils, StdCtrls, Controls, Forms, Dialogs;

type
  TEvents = class (tobject)
    procedure OnClick(Sender: tobject);
  end;

var Frm   : TForm;
    LB    : TListBox;
    Events: TEvents;
    bStart: TButton;
    bStop : TButton;
    bClear: TButton;
    bDel  : TButton;
    bSave : TButton;
    Action: TL2Action;    
    obj   : TL2Live;
    Tar   : TL2Live;
    Txt   : string;
    p     : pointer;
  
procedure TEvents.OnClick(Sender: tobject);
var S: string;
begin
  if Sender = bClear then LB.Clear;  
  if Sender = bSave then begin
    S := '';
    if not PromptForFileName(S, 'ScriptRec (*.txt)|*.txt', '.txt', '', '', true) then exit;
    LB.Items.insert(0,'BEGIN');
    LB.Items.Add('END.');
    LB.Items.SaveToFile(S);
    LB.Items.delete(0);
    LB.Items.delete(LB.Items.Count -1);
  end;
  if (Sender = bDel) and (LB.ItemIndex <> 0) then LB.Items.delete(LB.ItemIndex);
  if Sender = bStart then begin
    bStart.Enabled := false;
    bStop.Enabled := true;
  end;
  if Sender = bStop then begin
    bStart.Enabled := true;
    bStop.Enabled := false;
  end;  
end;

procedure MainLog;
begin
  if (assigned(Frm)) and (not bStart.Enabled) then LB.Items.Add(Txt);
end;

procedure ToLog(const S: string);
begin
  Txt := S;
  Script.MainProc(@MainLog);
end;

procedure MainProc;
begin
  Events := TEvents.Create;

  Frm  := TForm.Create(nil);
  Frm.Caption := 'ScriptRec';
  Frm.BorderStyle := bsDialog;
  Frm.Position := poScreenCenter;
  //Frm.FormStyle := fsStayOnTop;
  Frm.Height := 340;
  Frm.Width := 350;
  Frm.AlphaBlendValue := 200;
  Frm.AlphaBlend := true;
  //Frm.OnClose := Events.OnClose;

  LB := TListBox.Create(Frm);
  LB.Parent := Frm;
  LB.Width := 250;
  LB.Align := alLeft;

  bStart := TButton.Create(Frm);
  bStart.left := LB.Width + 10;
  bStart.Caption := '?????';
  bStart.OnClick := Events.OnClick;
  bStart.Parent  := Frm;

  bStop  := TButton.Create(Frm);
  bStop.left := bStart.left;
  bStop.Top  := bStart.Top + bStart.Height + 4;
  bStop.Enabled := false;
  bStop.Caption := '????';
  bStop.OnClick := Events.OnClick;
  bStop.Parent  := Frm;

  bClear := TButton.Create(Frm);
  bClear.left := bStart.left;
  bClear.Top  := bStop.Top + bStop.Height + 4;
  bClear.Caption := '????????';
  bClear.OnClick := Events.OnClick;
  bClear.Parent  := Frm;

  bDel := TButton.Create(Frm);
  bDel.left := bStart.left;
  bDel.Top  := bClear.Top + bClear.Height + 4;
  bDel.Caption := '??????? ???';
  bDel.OnClick := Events.OnClick;
  bDel.Parent  := Frm;  

  bSave := TButton.Create(Frm);
  bSave.left := bStart.left;
  bSave.Top  := bDel.Top + bDel.Height + 4;
  bSave.Caption := '?????????...';
  bSave.OnClick := Events.OnClick;
  bSave.Parent  := Frm;  

  Frm.Show;
end;

procedure OnFree;
var Tmp: tobject;
begin
  Tmp := Frm;
  Frm := nil;
  bStart.Free;
  bStop.Free;
  bClear.Free;
  bDel.Free;
  bSave.Free;
  LB.Free;
  Tmp.Free;
  Events.Free;  
  print('ScriptRec - Stopped');
end;


begin
  Script.MainProc(@MainProc);
  repeat
    Action := Engine.WaitAction([laDlg, laUnTarget, laStop], obj, p);

    if (Action = laStop) and (Obj = User) then ToLog('  Engine.MoveTo(' + inttostr(User.X) + ',' + inttostr(User.Y) + ',' + inttostr(User.Z) + ');');
    if (Action = laDlg) and (User.Target.Valid) and (User.Target <> Tar) then begin
      Tar := User.Target;
      ToLog('  Engine.SetTarget('''+ Tar.Name +''');');
      ToLog('  Engine.DlgOpen;');
      ToLog('  //????? ?????? ? NPC');
    end;
    if (Action = laUntarget) and (obj = User) and (assigned(Tar)) then begin
      Tar := nil;
      ToLog('  Engine.CancelTarget;');
    end;
  until not assigned(Frm);
end.