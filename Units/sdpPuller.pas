unit sdpPuller;
interface
type 
  TPullSpot = class abstract
    private
      FPointName: string;
    public
      constructor Create(pointName: string);
      function TryPullBackName(backPointName, skillname: string; range: Integer = 600): Boolean;
      function TryPullBackXYZ(x,y,z: Integer; skillname: string; range: Integer = 600): Boolean;
      function MobCount: Integer; virtual;
      function InArea(mob: TL2Spawn): Boolean; virtual; abstract;
      function TargetNthClosest(n: Integer = 0): Boolean;
      function MoveTo: Boolean; virtual;
    end;

  TSquareSpot = class(TPullSpot)
    private
      FX1, FY1, FZ1, FX2, FY2, FZ2: Integer;
    public
      constructor Create(pointName: string; x1, y1, z1, x2, y2, z2: Integer);
      function InArea(mob: TL2Spawn): Boolean; override;
    end;

  TCircleSpot = class(TPullSpot)
    private
      FCenterX, FCenterY, FCenterZ, FRadius, FRadiusSquared: Integer;
    public
      constructor Create(pointName: string; centerX, centerY, centerZ, radius: Integer);
      function InArea(mob: TL2Spawn): Boolean; override;
    end;

var
  arr_cc_branded_rls, arr_cc_apostate_rl : Array of TPullSpot;
  cc_branded_rl2, cc_branded_rlsl1, cc_branded_ssrs1: TPullSpot;

implementation
  uses SysUtils, sdpCounter, sdpGPS;
// TPullSpot
  constructor TPullSpot.Create(pointName: string); Overload;
    begin inherited Create();
      FPointName := pointName;
    end;
  function TPullSpot.TryPullBackName(backPointName, skillname: string; range: Integer = 600): Boolean;
    begin
      Result := false;
      if (MobCount > 0) then begin
        Engine.FaceControl(0, false);
        MoveTo;
        TargetNthClosest;
        if User.DistTo(User.Target) > range
        then Engine.MoveToTarget(-range);
        Engine.useSkill(skillname);
        GPS_MoveTo(backPointName);
        Engine.FaceControl(0, true);
        Result := true;
      end;
    end;
  function TPullSpot.TryPullBackXYZ(x,y,z: Integer; skillname: string; range: Integer = 600): Boolean;
    begin
      Result := false;
      if (MobCount > 0) then begin
        Engine.FaceControl(0, false);
        MoveTo;
        TargetNthClosest;
        if User.DistTo(User.Target) > range
        then Engine.MoveToTarget(-range);
        Engine.useSkill(skillname);
        GPS_MoveTo(x, y, z);
        Engine.FaceControl(0, true);
        Result := true;
      end else Print('Spot ' +FPointName+ ' empty');
    end;
  function TPullSpot.TargetNthClosest(n: Integer = 0): Boolean;
    var 
      i: Integer;
      mob: TL2Npc;
    begin
      Result := false;
      for i := 0 to NpcList.Count - 1 do begin
        mob := NpcList.Items(i);
        if(InArea(mob)) then begin
          Result := true;
          Engine.SetTarget(mob);
          break;
        end;
      end;
    end;
  function TPullSpot.MoveTo: Boolean; virtual;
    begin
      Result := GPS_MoveTo(FPointName);
    end;
  function TPullSpot.MobCount: Integer;
    var 
      i: Integer;
      mob: TL2Npc;
    begin
      Result := 0;
      for i := 0 to NpcList.Count - 1 do begin
        mob := NpcList.Items(i);
        if   InArea(mob)
        then Result := Result + 1;
      end;
    end;



// TSquare Spot  
  constructor TSquareSpot.Create(pointName: string; x1, y1, z1, x2, y2, z2: Integer);
    begin
      inherited Create(pointName);
      FX1 := x1;
      FY1 := y1;
      FZ1 := z1;
      FX2 := x2;
      FY2 := y2;
      FZ2 := z2;
    end;
  function TSquareSpot.InArea(mob: TL2Spawn): Boolean;
    begin
      Result := (mob.X > FX1) and (mob.X < FX2) and (mob.Y > FY1) and (mob.Y < FY2);
    end;
// TCircleSpot
  constructor TCircleSpot.Create(pointName: string; centerX, centerY, centerZ, radius: Integer);
    begin
      inherited Create(pointName);
      FCenterX := centerX;
      FCenterY := centerY;
      FCenterZ := centerZ;
      FRadius := radius;
      FRadiusSquared := radius * radius;
    end;
  function TCircleSpot.InArea(mob: TL2Spawn): Boolean;
    begin
      Result := (sqr(FCenterX - mob.X) + sqr(FCenterY - mob.Y)) < FRadiusSquared;
    end;
Initialization
  cc_branded_rl2 := TSquareSpot.Create('cc branded rl2', 48136, 172728, -4976, 48808, 174104, -4976);
  cc_branded_rlsl1 := TCircleSpot.Create('cc branded rlsl1', 50056, 171480, -4976, 350);
  cc_branded_ssrs1 := TCircleSpot.Create('cc branded ssrs1', 51192, 174888, -4976, 300);
  arr_cc_branded_rls := [cc_branded_rl2, cc_branded_rlsl1, cc_branded_ssrs1];
  arr_cc_apostate_rl := [
    TSquareSpot.Create('cc apostate rll1', -19288, -248872, -8160, -18632, -248280, -8160)
  ];
Finalization
  Print('Free');
  cc_branded_rl2.Free;
  cc_branded_rlsl1.Free;
  cc_branded_ssrs1.Free;
end.
 