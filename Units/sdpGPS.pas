// recalculate path if failed to run after teleport.

Unit sdpGPS;

Interface
uses Classes;
var 
  teleportAtGk: String = '1';
  vRandom: Integer = 0; // todo change to 50
//   acceptableDelta: Integer = 300;
function GPS_MoveTo(x, y, z: Integer; vTalkToNpc: Boolean = false): boolean;  overload;
function GPS_MoveTo(spot_name: string; vTalkToNpc: Boolean = false; tryNumber: Integer = 0): boolean;  overload;
function GPS_MoveToClosest(names: string; vTalkToNpc: Boolean = true; tryNumber: Integer = 0): string;
function GPS_MoveToBot(vName: String): boolean;  overload;

function GoHome(): Boolean;
Implementation
uses SysUtils, sdpBYPASS, sdpSL
  ;
function GPS_MoveTo(x, y, z: integer; vTalkToNpc: Boolean = true): boolean;  overload;
  var dist: single;  i: integer;
  begin  
    if((User.X = x) and (User.Y = y) and (User.Z = z)) then begin
      Print('already there');
    end else begin
      result:= false;
      dist:= GPS.GetPath(User.X, User.Y, User.Z, Round(x), Round(y), Round(z));
      Result := _GPS_RunThePath(vTalkToNpc);
    end;
  end;  

function GPS_MoveTo(spot_name: string; vTalkToNpc: Boolean = false; tryNumber: Integer = 0): boolean;  overload;
  var dist: single;  i, last: integer;
  begin  
    result:= false;
    Print('GPS_MoveTo(''' + spot_name + '''); // [sdpGPS]');
    dist:= GPS.GetPathByName(User.X, User.Y, User.Z, spot_name);     

    Result := _GPS_RunThePath(vTalkToNpc);
  end;
function GPS_MoveToClosest(names: string; vTalkToNpc: Boolean = true; tryNumber: Integer = 0): string;
  var bestPath: string;
  begin
    bestPath := FindClosestPath(names);
    if GPS_MoveTo(bestPath, vTalkToNpc, tryNumber)
    then Result := bestPath
    else Result := '';
  end;  
function FindClosestPath(names: string): string;
  var 
    i: Integer;
    bestName, curName: String; bestDist, curDist: Single;
    slOfNames: TStringList;
  begin
    slOfNames := SL(names);
    bestName := '';
    for i := 0 to slOfNames.Count - 1 do  
    begin
      curName := slOfNames[i];
      if(curName = '') then continue;
      curDist := GPS.GetPathByName(User.X, User.Y, User.Z, curName);
      Delay(50);
      if (bestName = '') or (bestDist > curDist) then begin
        bestName := curName;
        bestDist := curDist;
      end;
    end;
    Result := bestName;
  end;
function GPS_MoveToBot(vName: String): boolean;  overload;
  var aChar: TL2Char;
  begin
    aChar := GetControl(vName).GetUser;
    Result := GPS_MoveTo(
      Round(aChar.X), 
      Round(aChar.Y), 
      Round(aChar.Z),
      False
    );
  end;

function GoHome(): Boolean;
  var
    x,y,z: Integer;
    vItem: TL2Item;
  begin
    x := User.X; y := User.Y; z := User.Z;
    if not User.Dead then begin
      if (Inventory.User.ByID(736, vItem)) then
        Engine.UseItem(736)  // Soe: Town
      else if (Inventory.User.ByID(10650, vItem)) then 
      Engine.UseItem(1829) // Soe: CH
      else if (Inventory.User.ByID(10650, vItem)) then // adventurer's soe
        Engine.UseItem(10650) else
      begin
        Engine.UseSkill('Return');
        Engine.Unstuck;
        //Engine.EnterText('/unstuck');
      end;
      Delay(500);
      Delay(User.Cast.EndTime+50);
    end;
    Delay(1000);
    if (User.Dead) then begin
      Delay(1500 + Random(1500));
      Engine.GoHome
    end;
    Result := (Abs(User.X-x)>500) or (Abs(User.Y-y)>500);
  end;


function _GPS_RunThePath(vTalkToNpc: Boolean): Boolean; 
  // Input:
    // You have to 'GPS_FindPath' before function call.
  var i: Integer; aGpsPoint: TGpsPoint;
  begin
    Result := True;
    if (GPS.Count > 0) then begin
      if User.Sitting then Engine.Stand;
      for i := 0 to GPS.Count - 2 do  // -2 !! paskutini pointa su extra info begs
      begin
        aGpsPoint := GPS.Items(i);
        if not _GPS_MoveToOnePoint(aGpsPoint, vTalkToNpc) then 
        begin
          Result := False;
          Break;
        end;

      end;
      aGpsPoint := GPS.Items(GPS.Count - 1);
      Result := _GPS_MoveToOnePoint(aGpsPoint, vTalkToNpc);
    end else begin
      Print('[sdpGPS] Couln''t find path to point');
    end;
  end;
function _GPS_MoveToOnePoint(vGps: TGpsPoint; vTalkToNpc: Boolean): Boolean;
  var 
    pointInfoText: String; 
    aName: String; 
    aX,aY,aZ: Integer;
  begin
    aX := Round(vGps.x) + Random(vRandom);
    aY := Round(vGps.y) + Random(vRandom);
    aZ := Round(vGps.z);
    aName := vGps.Name;
    case Copy(aName, 1, 4) of
      'tlp:': begin
        if User.DistTo(aX, aY, aZ) > 2000 then // Likely this is teleport
        begin
          pointInfoText := Copy(aName, 5, 999); // 'tlp:asdasd asd' -> 'asdasd asd'
          TalkTo(this_gk_id, teleportAtGk+';'+pointInfoText, 'obles');
          Delay(3000);
        end;
      end;
      'nbl:': begin
        if User.DistTo(aX, aY, aZ) > 2000 then // Likely this is teleport
        begin
          pointInfoText := Copy(aName, 5, 999); // 'nbl:asdasd asd' -> 'asdasd asd'
          if TalkTo(this_gk_id, 'Nobles;2;'+pointInfoText) then Delay(3000);
        end;
      end;
      'dlg:': begin
        pointInfoText := Copy(aName, 5, 999); // 'npc:asdasd asd' -> 'asdasd asd'
        Dlg(pointInfoText);
      end;
      'npc:': begin
        Engine.MoveTo(aX, aY, aZ, -50);
        if (vTalkToNpc) then
        begin
          pointInfoText := Copy(aName, 5, 999); // 'npc:asdasd asd' -> 'asdasd asd'
          TalkTo(pointInfoText, '');
        end;
      end;
      else begin
        Engine.MoveTo(aX, aY, aZ);
      end;
    end; // end case
    Result := User.DistTo(aX,aY,aZ) < 400;
    if not Result then begin
      Print('Failed to go to point '''+aName+'''');
    end;
  end;

function this_gk_id: Integer; 
  begin
    Result := -99;
    if User.InRange(147963, -55282,-2759, 450, 500) then Result := 31275; // Goddard
    if User.InRange( 83344, 147932,-3431, 500, 500) then Result := 30080; // -Giran
    if User.InRange( 43820, -47690, -823, 250, 500) then Result := 31320; // rune main gk
    if User.InRange(146709,  25759,-2039, 250, 500) then Result := 30848; // -Aden
    if User.InRange( 82970,  53174,-1490, 500, 500) then Result := 30177; // -Oren
    if User.InRange(-12752, 122772,-3143, 500, 500) then Result := 30256; // -Gludio
    if User.InRange( 15643, 142931,-2704, 500, 500) then Result := 30059; // -Dion
    if User.InRange(111412, 219382,-3540, 500, 500) then Result := 30899; // -Heine
    if User.InRange(-84143, 244591,-3755, 500, 500) then Result := 30006; // Talking Island
    if User.InRange(-80782, 149800,-3070, 500, 500) then Result := 30320; // -Gludin
    if User.InRange(117107,  76911,-2722, 500, 500) then Result := 30233; // Hunter
    if User.InRange( 87138,-143415,-1319, 250, 250) then Result := 31964; // -Schutgart
    if User.InRange( 46924,  51485,-3003, 500, 500) then Result := 30146; // Elven Village
    if User.InRange(115093,-178177, -916, 300, 500) then Result := 30540; // Dwarf
    if User.InRange(  9695,  15556,-4601, 300, 500) then Result := 30134; // Dark
    if User.InRange(-45228,-112507, -265, 300, 500) then Result := 30576; // Orc
    if User.InRange(105888, 109808,-3216, 300, 500) then Result := 30836;
    if User.InRange(38370, -48097, -1152, 400, 300) then Result := 31699;
    if User.InRange( 38307, -48020,  896, 400, 300) then Result := 31698;
    if User.InRange( 47966, 186754,-3480, 500, 500) then Result := 30878; // Giran Harbour
    if User.InRange( 84814, 15886, -4291, 300, 200) then Result := 30162; // Ivory tover undergound
    if User.InRange( 85336, 16194, -3672, 300, 200) then Result := 30727; // Ivery tower loby
    if User.InRange( 85333, 16178, -2800, 300, 200) then Result := 30716; // Ivory tower 2nd (Human)
    if User.InRange( 85336, 16194, -1768, 300, 200) then Result := 30719; // Ivory tower 3rd (Elf)
    if User.InRange( 85364, 16164, -2288, 300, 200) then Result := 30722; // Ivory tower 4th (Dark Elf)
    if User.InRange( 77284, 78410, -5151, 300, 200) then Result := 31116; // Apostate cc [out]
    if User.InRange(139983, 79680, -5455, 300, 200) then Result := 31117; // Witch cc [out]
    if User.InRange(140778, 79694, -5453, 300, 200) then Result := 31123; // Witch cc [in]
    if User.InRange(17225, 114173, -3440, 300, 200) then Result := 30483; // Cruma Tower 0 [->1]
    if User.InRange(17680, 113968, -11672, 300, 200) then Result := 30484; // Cruma Tower 1 [->0]
    if User.InRange(17721, 107767, -11876, 300, 200) then Result := 30487; // Cruma Tower 1 [->2]
    if User.InRange(17719, 108293, -9084, 300, 200) then Result := 30485; // Cruma Tower 2 [->1]
    if User.InRange(117869, 132814, -4857, 300, 200) then Result := 31100; // cc: Martyrdom[out]
    if User.InRange(118640, 132793, -4855, 300, 200) then Result := 31108; // cc: Martyrdom[out]
  end;



initialization
GPS.LoadBase('dbfile.db3');
end.
