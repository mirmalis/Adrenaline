program Project23;
uses
  SysUtils;

type
  // Declare an event type. It looks allot like a normal method declaration except
  // it suffixed by "of object". That "of object" tells Delphi the variable of this
  // type needs to be assigned a method of an object, not just any global function
  // with the correct signature.
  TMyEventTakingAStringParameter = procedure(const aStrParam:string) of object;

  // A class that uses the actual event
  TMyDummyLoggingClass = class
  public
    OnLogMsg: TMyEventTakingAStringParameter; // This will hold the "closure", a pointer to
                                              // the method function itself + a pointer to the
                                              // object instance it's supposed to work on.
    procedure LogMsg(const msg:string);
  end;

  // A class that provides the required string method to be used as a parameter
  TMyClassImplementingTheStringMethod = class
  public
    procedure WriteLine(const Something:string); // Intentionally using different names for
                                                 // method and params; Names don't matter, only the
                                                 // signature matters.
  end;

  procedure TMyDummyLoggingClass.LogMsg(const msg: string);
  begin
    if Assigned(OnLogMsg) then // tests if the event is assigned
      OnLogMsg(msg); // calls the event.
  end;

  procedure TMyClassImplementingTheStringMethod.WriteLine(const Something: string);
  begin
    // Simple implementation, writing the string to console
    Writeln(Something);
  end;

var Logging: TMyDummyLoggingClass; // This has the OnLogMsg variable
    LoggingProvider: TMyClassImplementingTheStringMethod; // This provides the method we'll assign to OnLogMsg

begin
  try
    Logging := TMyDummyLoggingClass.Create;
    try

      // This does nothing, because there's no OnLogMsg assigned.
      Logging.LogMsg('Test 1');

      LoggingProvider := TMyClassImplementingTheStringMethod.Create;
      try
        Logging.OnLogMsg := LoggingProvider.WriteLine; // Assign the event
        try

          // This will indirectly call LoggingProvider.WriteLine, because that's what's
          // assigned to Logging.OnLogMsg
          Logging.LogMsg('Test 2');

        finally Logging.OnLogMsg := nil; // Since the assigned event includes a pointer to both
                                         // the method itself and to the instance of LoggingProvider,
                                         // need to make sure the event doesn't out-live the LoggingProvider                                             
        end;
      finally LoggingProvider.Free;
      end;
    finally Logging.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.