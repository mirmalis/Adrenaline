Unit sdpSlave;
Interface
function HandleEntry(var x:Integer): Boolean;

Implementation
Uses sdpSTRINGS, sdpGPS;
var isBusy: Boolean = false;
// //Use unit sdpMASTER to control a slave character
// //by sending integer value to say what the bot should do.
// //all the values below 0 are expected to result in asynchronous task
// //all the values abowe 0 are expected to result in synchronous task

// Slave script should look something like this:
//using sdpSLAVE;
//function OnEntry(var x:Integer): Boolean;
//  begin
//    HandleEntry(x);
//  end;
//function DoCustom(x: Integer): Boolean;
//  begin
//    Result := true;
//    if x = 0 then Print('yes Masa')
//    else Result := false;
//  end;
//begin
//  Delay(-1);
//end.
procedure DoSync(x: Integer);
  begin
    while isBusy do delay(10);
    isBusy := true;
    DoAsync(x);
    isBusy := false;
  end;
procedure DoAsync(x: Integer);
  begin
    // if could acomplish task in DoCustom, try to acomplish default task.
    if not DoCustom(x) 
    then DoDefault(x);
  end;
function DoDefault(x: Integer): Boolean;
  begin
    Result := true;

    if false then begin end
    else if x = -1102 then Engine.FaceControl(0, false)
    else if x = -1101 then Engine.FaceControl(0, true)
    else if x =  1100 then GoHome()
    else 
    begin 
      Print('Slave does not support task value of ' + ToStr(x));
      Result := false;
    end;
  end;
function HandleEntry(var X:Integer): Boolean;
  begin
    if x >= 0
    then Script.NewThread(@DoSync, Pointer(X))
    else Script.NewThread(@DoAsync, Pointer(X));
  end;
end.