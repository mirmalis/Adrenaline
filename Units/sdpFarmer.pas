unit sdpFarmer;
interface
function ActionName(Action: TL2Action): string;
procedure Farmer_OnAction(Action: TL2Action; P1, P2: pointer);
procedure SetTimer(ms: Integer; P1, P2: pointer);
implementation

uses sdpStrings
, sdpCounter, sdpSL // remove
;
var 
  me: pointer;
  newPartyMember: Boolean;
procedure SetTimer(ms: Integer; P1, P2: pointer);
  begin

  end;
procedure Farmer_OnAction(Action: TL2Action; P1, P2: pointer);
begin
  if P1 = me 
  then HandleMyAction(Action, P1, P2)
  else HandleOthersAction(Action, P1, P2);
end;
function ActionName(Action: TL2Action): string;
  begin
    if (Action = laNull) then 
      begin 
        Result := 'laNull'; 
      end else if (Action = laSpawn) 
      then begin 
        Result := 'laSpawn'; 
      end else if (Action = laDelete) 
      then begin 
        Result := 'laDelete'; 
      end else if (Action = laPetSpawn) 
      then begin 
        Result := 'laPetSpawn'; 
      end else if (Action = laPetDelete) 
      then begin 
        Result := 'laPetDelete'; 
      end else if (Action = laPetJoin) 
      then begin 
        Result := 'laPetJoin'; 
      end else if (Action = laPetLeave) 
      then begin 
        Result := 'laPetLeave'; 
      end else if (Action = laCharJoin) 
      then begin 
        Result := 'laCharJoin'; 
      end else if (Action = laInvite) 
      then begin 
        Result := 'laInvite'; 
      end else if (Action = laDie) 
      then begin 
        Result := 'laDie'; 
        Engine.GoHome;
      end else if (Action = laRevive) 
      then begin 
        Result := 'laRevive'; 
      end else if (Action = laMyRevive) 
      then begin 
        Result := 'laMyRevive'; 
      end else if (Action = laStats) 
      then begin 
        Result := 'laStats'; 
      end else if (Action = laMyTarget) 
      then begin 
        Result := 'laMyTarget'; 
      end else if (Action = laMyUnTarget) 
      then begin 
        Result := 'laMyUnTarget'; 
      end else if (Action = laTarget) 
      then begin 
        Result := 'laTarget'; 
      end else if (Action = laUnTarget) 
      then begin 
        Result := 'laUnTarget'; 
      end else if (Action = laInGame) 
      then begin 
        Result := 'laInGame'; 
      end else if (Action = laBuffs) 
      then begin 
        Result := 'laBuffs'; 
      end else if (Action = laPartyBuffs) 
      then begin 
        Result := 'laPartyBuffs'; 
      end else if (Action = laSkills) 
      then begin 
        Result := 'laSkills'; 
      end else if (Action = laConfirmDlg) 
      then begin 
        Result := 'laConfirmDlg'; 
      end else if (Action = laDlg) 
      then begin 
        Result := 'laDlg'; 
      end else if (Action = laSysMsg) 
      then begin 
        Result := 'laSysMsg'; 
      end else if (Action = laMoveType) 
      then begin 
        Result := 'laMoveType'; 
      end else if (Action = laWaitType) 
      then begin 
        Result := 'laWaitType'; 
      end else if (Action = laMyWaitType) 
      then begin 
        Result := 'laMyWaitType'; 
      end else if (Action = laStart) 
      then begin 
        Result := 'laStart'; 
      end else if (Action = laStop) 
      then begin 
        Result := 'laStop'; 
      end else if (Action = laStartAttack) 
      then begin 
        Result := 'laStartAttack'; 
      end else if (Action = laStopAttack) 
      then begin 
        Result := 'laStopAttack'; 
      end else if (Action = laCast) 
      then begin 
        Result := 'laCast'; 
      end else if (Action = laCancelCast) 
      then begin 
        Result := 'laCancelCast'; 
      end else if (Action = laMyCancelCast) 
      then begin 
        Result := 'laMyCancelCast'; 
      end else if (Action = laCastFailed) 
      then begin 
        Result := 'laCastFailed'; 
      end else if (Action = laMyCastFailed) 
      then begin 
        Result := 'laMyCastFailed'; 
      end else if (Action = laTeleport) 
      then begin 
        Result := 'laTeleport'; 
      end else if (Action = laInvUpdate) 
      then begin 
        Result := 'laInvUpdate'; 
      end else if (Action = laAutoSoulShot) 
      then begin 
        Result := 'laAutoSoulShot'; 
      end else if (Action = laNpcTrade) 
      then begin 
        Result := 'laNpcTrade'; 
      end else if (Action = laChat) 
      then begin 
        Result := 'laChat'; 
      end else if (Action = laKey) 
      then begin 
        Result := 'laKey'; 
      end else if (Action = laCharSelect) 
      then begin 
        Result := 'laCharSelect'; 
      end else if (Action = laLeaveParty) 
      then begin 
        Result := 'laLeaveParty'; 
      end else if (Action = laPost) 
      then begin 
        Result := 'laPost'; 
      end else if (Action = laLearn) 
      then begin 
        Result := 'laLearn'; 
      end else if (Action = laAll) 
      then begin 
        Result := 'laAll'; 
      end else if (Action = laMyCast) 
      then begin 
        Result := 'laMyCast'; 
      end else if (Action = laDelay) 
      then begin 
        Result := 'laDelay'; 
      end else if (Action = laStatus) 
      then begin 
        Result := 'laStatus'; 
      end else if (Action = laAuction) 
      then begin 
        Result := 'laAuction'; 
      end else if (Action = laAuctionSL) 
      then begin 
        Result := 'laAuctionSL'; 
      end else if (Action = atCaptcha) 
      then begin 
        Result := 'atCaptcha'; 
      end else if (Action = atMail) 
      then begin 
        Result := 'atMail'; 
      end else if (Action = atTaxRate) 
      then begin 
        Result := 'atTaxRate'; 
      end else if (Action = laLoginState) 
      then begin 
        Result := 'laLoginState'; 
      end 
      else begin
        Result := 'else';
      end;
  end;
procedure HandleOthersAction(Action: TL2Action; P1, P2: pointer);
  begin
    Case Action of 
      TL2Action(1231231223)
      , laStop
      , laStart
      : begin // mobs do that all the time
       end;
      //laBuffs: begin end;
      // laTeleport: begin end;
      // laInvUpdate: begin end;
      // laSysMsg, 
      // laStats, 
      // laCast, 
      // laStartAttack, 
      // laStopAttack, 
      // , 
      
      // laSpawn, 
      // laDelete, 
      // laDie, 
      // laWaitType,
      // laMoveType : begin end;
      laCharJoin:   buffNewPartyMember;
      laPartyBuffs: onPartyBuffs(P1, P2);
      else Print(ActionName(Action) + ' [' + TL2Object(P1).name + ', ' + ToStr(P2)+ ']');
      // else Print('end else if (Action = '+ActionName(Action)+') then begin');
    end;
  end;
procedure onPartyBuffs(P1, P2: pointer);
  begin
    if (newPartyMember) then begin
      newPartyMember := false;
      Engine.SetTarget(TL2Live(P1));
      Engine.UseKey('F1');
      // if User.Name = 'lllse' then begin
      //   useSkills(SL('Shield;Concentration;Shield;Wind Walk;Empower'));
      // end else if User.Name = 'lllprp' then begin
      //   useSkills(SL('Regeneration;Mental Shield;Magic Barrier;Blessed Soul;Blessed Body;Acumen;Berserker Spirit'));
      // end;
    end;
  end;
procedure buffNewPartyMember();
  var vChar: TL2Char;
  begin
    newPartyMember := true;
    // vChar := Party.Chars.Items(Party.Chars.Count - 1);
    // Print(vChar.Name);
    // Engine.SetTarget(vChar);
    
  end;
procedure HandleMyAction(Action: TL2Action; P1, P2: pointer);
  begin
    case Action of 
      laBuffs,
      laTeleport,
      laMyRevive,
      laDie, 
      laRevive,
      laCast,
      laCancelCast,
      laCastFailed,
      laSpawn, 
      laWaitType,
      laMyCancelCast:
      begin
      end;

      laStats, 
      laStop, 
      laStart, 
      laStopAttack, 
      laDelete, 
      laStartAttack, 
      laTarget, 
      laUnTarget, 
      laMyTarget, laMyUnTarget
      ,laMyWaitType
      : begin end;
      else begin
        Print(ActionName(Action) + ': begin end;');
      end;
    end;
  end;
initialization
me := user;
end.