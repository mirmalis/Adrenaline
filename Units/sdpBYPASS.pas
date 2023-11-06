// TODO: text not inside of button itself. Typically in alt+b where text is in one element and button some form of textless element.
  // TODO: bypass a bypass where bypass message is dynamic. Ex: Creating scheme bypass changes based on new schemes image selected.

// TalkTo('Clarissa','teleport;antharas lair');
// TalkTo('Clarissa=teleport;antharas lair'); // Could be useful for Quest scripts.
Unit sdpBYPASS;
Interface
uses Classes;
var 
  vDelay: Integer;
  gPrint: Boolean;
function Dot(textAfterDot: String): Boolean;
function EnterText(text: String): Boolean;
function B(textToClick: String; textToNotClick: String = '$a^'): Boolean;
function CB(section: Integer; textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
function CB(textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
function Dlg(textToClick: String; textToNotClick: String = '$a^'): Boolean;
function TalkTo(npcId: Integer; textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
function TalkTo(npcName: String; textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
function TalkTo(npcName: String): Boolean; Overload;
function ByPassNth(html: String; n: Integer): Boolean;

function _getControls(html: String): TStringList;
function _getBypassText(controlText: String; out isLink: Boolean): String;
Implementation
uses sdpREGEX, sdpSTRINGS;
type 
  TFuncOfString = function(): String;
// Public
function Dot(textAfterDot: String): Boolean;
  begin
    Result := EnterText('.' + textAfterDot);
  end;
function EnterText(text: String): Boolean;
  begin
    Engine.EnterText(text);
  end;
function B(textToClick: String; textToNotClick: String = '$a^'): Boolean;
  var f: TFuncOfString;
  begin
    f := _getCBText;
    Result := ByPass(
      f,
      textToClick, textToNotClick
    );
  end;
function CB(section: Integer; textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
  var sectionBypass: String;
  begin
    Print(section);
    Print(textToClick);
    case section of 
      1: sectionBypass := '_bbshome';
      2: sectionBypass := '_bbsgetfav';
      3: sectionBypass := '_bbsloc';
      4: sectionBypass := '_bbsclan';
      5: sectionBypass := '_bbsmemo';
      6: sectionBypass := '_maillist_0_1_0_';
      7: sectionBypass := '_friendlist_0_';
      else begin
        Print('unknown section ' + ToStr(section));
        sectionBypass := '';
      end;
    end;
    Print(sectionBypass);
    if (sectionBypass <> '') 
    then begin
      Engine.BypassToServer(sectionBypass); 
      Delay(vDelay);
    end;
    Result := B(textToClick, textToNotClick);
  end;
function CB(textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
  begin
    if textToClick = '' then begin
      Result := true;
      exit;
    end;
    Engine.BypassToServer('_bbshome'); 
    Delay(vDelay);
    Result := B(textToClick, textToNotClick);
  end;
function Dlg(textToClick: String; textToNotClick: String = '$a^'): Boolean;
  var f: TFuncOfString;
  begin
    if textToClick = '' then begin
      Result := true;
      exit;
    end;
    f := _getDlgText;
    Result := ByPass(
      f,
      textToClick, textToNotClick
    );
  end;
function TalkTo(npcId: Integer; textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
  begin
    Result := false;
    if (not _dlgStart(npcId)) then exit;
    Result := Dlg(textToClick, textToNotClick);
    Delay(vDelay); // if talking to more than 1 npc in a row
  end;
function TalkTo(npcName: String; textToClick: String; textToNotClick: String = '$a^'): Boolean; Overload;
  begin
    Result := false;
    if (not _dlgStart(npcName)) then exit;
    Result := Dlg(textToClick, textToNotClick);
    Delay(vDelay); // if talking to more than 1 npc in a row
  end;
function TalkTo(npcName: String): Boolean; Overload;
  begin
    Result := _dlgStart(npcName);
    Delay(vDelay);
  end;
// Core
procedure _ByPassToServer(bypassText: String; isLink: Boolean = false);
  begin
    if gPrint then Print(bypassText);
    //Print('Engine.ByPassToServer(''' + bypassText + ''', '+ ToStr(not isLink) + ');');
    Engine.BypassToServer(bypassText, not isLink);
  end;
function ByPass1(html: String; textToClick: String; textToNotClick: String = '$a^'): Boolean;
  var i: Integer; controlText, bypassText: String; controlsTexts: TStringList;
    isLink: Boolean;
  begin
    Result := false;
    controlText := '';
    controlsTexts := _getControls(html);
    if (controlsTexts <> Nil) and (controlsTexts.Count > 0) then 
      for i := 0 to controlsTexts.Count - 1 do begin
        controlText := controlsTexts[i];
        if  _controlIsSuitable(controlText, textToClick, textToNotClick) then 
        begin
          bypassText := _getBypassText(controlText, isLink);
          break; // take 1st suitable bypass
        end;
      end;
    
    if (Length(bypassText) > 0) then // if something to bypass - bypass
    begin
      _ByPassToServer(bypassText, isLink);
      Result := true;
    end;

    controlsTexts.Free;
  end;
function ByPassNth(html: String; n: Integer): Boolean;
  var i: Integer; controlText, bypassText: String; controlsTexts: TStringList;
    isLink: Boolean;
  begin
    Result := false;
    controlsTexts := _getControls(html);
    if (controlsTexts.Count >= n) then 
    begin
      bypassText := _getBypassText(controlsTexts[n-1], isLink);
      _ByPassToServer(bypassText, isLink);
      Result := true;
    end else Print('Can''t ByPassNth to n larger than Count.');
  end;

function ByPass(textSourceFunction: TFuncOfString; textToClick: String; textToNotClick: String = '$a^'): Boolean;
  var 
    textsToSend: TStringList; i: Integer;
    thisText: String;
    html: String;
  begin
    Result := true;
    textsToSend := TStringList.Create;
    textsToSend.StrictDelimiter := true; // so the string is split by ';' only.
    textsToSend.Delimiter := ';';
    textsToSend.DelimitedText := textToClick;
    for i:=0 to textsToSend.Count - 1 do begin
      html := textSourceFunction();
      thisText := textsToSend[i];
      if str_detect(thisText, '^\d*$') then // if digit
        if BypassNth(html, ToInt(thisText)) then 
        begin
          Delay(vDelay);
          Continue;
        end;

      html := textSourceFunction();
      if ByPass1(html, textsToSend[i], textToNotClick) then 
      begin
        Delay(vDelay);
        Continue;
      end;
      Result := false;
      
      break;
    end;
    textsToSend.Free;
  end;

// Core helpers
function _getControls(html: String): TStringList;
  begin
    Result := str_extract_all(
      html, 
      '(<a *(.+?)</a>)|(<button *(.+?)>)', '$0'
      //'"bypass -h .*"'
    );
  end;
function _controlIsSuitable(controlText, textToClick, textToNotClick: String): Boolean;
  begin
    Result := str_detect(controlText, textToClick) and not str_detect(controlText, textToNotClick);
  end;
function _getBypassText(controlText: String; out isLink: Boolean): String;
  begin
    //controlText := '<a action="bypass )0"> Necromancer</a>';
    //controlText := '<button action="bypass -h )0" value="Англ./English" width=120 height=20 back="Ketrawars.a1b" fore="Ketrawars.a1">';
    //controlText := '<button value="Mage set" action="bypass -h )0" width=120 height=20 back="Ketrawars.a1b" fore="Ketrawars.a1">';
    //controlText := '<button value="" action="bypass  )1" width=34 height=23 back="Crest.crest_31_79515408" fore="Crest.crest_31_138348129">';
    //controlText := '<button value="" action="bypass  )1" width=34 height=23 back="Crest.crest_31_155287654" fore="Crest.crest_31_193920412">';
    
    Result := TrimLeft(
      str_extract(controlText, '"(bypass -h|bypass) (.*)"', '$2')
    );
    
    if (Result <> '') then begin
      isLink := false
    end else begin
      Result := TrimLeft(str_extract(controlText, '"(link) (.*)"', '$2'));
      isLink := true;
    end;
  end;


// TalkTo helpers
function _getDlgText(): String;
  begin
    Result := Engine.DlgText;
  end;
function _getCBText(): String;
  begin
    Result := Engine.CBText;
  end;
function _npcExists(vName: String): Boolean; Overload;
  var aNPC: TL2NPC;
  begin // tbd: probably move to other unit
    NPCList.ByName(vName, aNPC);
    Result := aNPC <> Nil;
  end;
function _npcExists(vID: Integer): Boolean; Overload;
  var aNPC: TL2NPC;
  begin // tbd: probably move to other unit
    NPCList.ByID(vID, aNPC);
    Result := aNPC <> Nil;
  end;
function _dlgStart(vName: String; vDelay: Integer = 1000): boolean; Overload;
  var j: Integer;
  begin
    Result := False;
    if _npcExists(vName) then 
    begin
      if User.Sitting then 
      begin
        Print('User sitting');
        Engine.Stand;
        Delay(3500);
        
      end;
      Engine.SetTarget(vName);
      for j := 0 to 5*(vDelay/10) do begin
        if str_detect(User.Target.Name, vName, false) then 
        begin
          Engine.MoveTo(User.Target, -45);
          Engine.DlgOpen;
          Delay(vDelay);
          Result := True;
          break;
        end else delay(100);
      end;
    end 
    else
      Print('NPC of name ' + vName + ' was not found.');
  end;
function _dlgStart(vID: Integer; vDelay: Integer = 1000): boolean; Overload;
  var j: Integer;
  begin
    Result := False;
    if _npcExists(vID) then 
    begin
      if User.Sitting then 
      begin
        Engine.Stand;
        Delay(3500);
      end;
      Engine.SetTarget(vID);
      for j := 0 to 5*(vDelay/10) do begin
        if User.Target.ID = vID then 
        begin
          Engine.MoveTo(User.Target, -45);
          Engine.DlgOpen;
          Delay(vDelay);
          Result := True;
          break;
        end else delay(100);
      end;
    end 
    else 
      Print('NPC of ID ' + ToStr(vID) + ' was not found.');
  end;

{// Might want to impelement these
  function GPS_TalkTo(vID: Integer; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
  begin
    Result := False;
    if _dlgStart(vID, vDelay) then 
    begin
      if (User.DistTo(User.Target) > 350) then GPS_MoveTo(User.Target.X, User.Target.Y, User.Target.Z);
      bypass('DlgText', arr, exclude, vDelay);
      Result := True;
    end;
  end;
  function GPS_TalkTo(vName: String; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
  begin
    Result := False;
    if _dlgStart(vName, vDelay) then 
    begin
      if (User.DistTo(User.Target) > 350) then GPS_MoveTo(User.Target.X, User.Target.Y, User.Target.Z);
      bypass('DlgText', arr, exclude, vDelay);
      Result := True;
    end;
  end;
  function ByPassOnlyOption(html: String): Boolean;
  var 
    SL: TStringList;
    bypassText: String;
  begin
    Result := false;
    SL := _getControls(html);
    if (SL.Count = 1) then
    begin
      bypassText := _getBypassText(SL[0]);
      if (Length(bypassText) > 0) then // if something to bypass - bypass
        Result := Engine.BypassToServer(bypassText);
    end;
  end;

 }
Initialization
vDelay := 600;
gPrint := false;
end.


