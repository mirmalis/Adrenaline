unit threadStopCasters;
interface
uses Classes, sdpSL;
Type
TStopCaster = Class
  private
    schemaNormal: String;
    schemaPassive: String;
    SpellNameList: TStringList;
    printMuch: boolean;
  published
    ShouldStop: Boolean;
    procedure Thread();
    Constructor Create(vSchemaNormal: String; vSchemaPassive: String; vSpellNameList: TStringList; vPrintMuch: Boolean = false);
  end;
implementation
  uses sdpStrings;
//TStopCaster. 
  Constructor TStopCaster.Create(
    vSchemaNormal: String; 
    vSchemaPassive: String; 
    vSpellNameList: TStringList; 
    vPrintMuch: Boolean = false
  );
    begin
      inherited Create();
      self.schemaNormal := vSchemaNormal;
      self.schemaPassive := vSchemaPassive;
      self.SpellNameList := vSpellNameList;
      self.printMuch := vPrintMuch;
      ShouldStop := false;
    end;
  procedure TStopCaster.Thread();
    var P1, P2: pointer;
    begin
      while (engine.status = lsOnline) and not ShouldStop do
      begin
        Engine.WaitAction([laCast], P1, P2);
        if TL2Live(P1).Attackable then begin
          if (printMuch) then Print(TL2Live(P1).Name + ' casts "' + TL2Live(P1).Cast.Name + '" (' + ToStr(TL2Live(P1).Cast.ID) + ')');
          if is_in(TL2Live(P1).Cast.Name, SpellNameList) then begin
            if (User.Target <> TL2Live(P1)) then begin
              Print('Stopping casting of "' + TL2Live(P1).Cast.Name + '" by ' + TL2Live(P1).Name );
              Engine.LoadConfig(schemaPassive);
              Engine.SetTarget(TL2Live(P1));
              while (TL2Live(P1).Cast.EndTime > 0) and (not User.Target.Dead) do begin
              end;
              Engine.LoadConfig(schemaNormal);
            end;
          end;
        end;
      end;
      Print('TStopCaster.Thread ended.');
    end;
initialization
//Print('Script.NewThread(@threadStopCasters.TStopCaster.Thread, threadStopCasters.TStopCaster.Create(''nekras'', ''nekras pasive'', SL(''Silence;Sleep;Cancellation''), false)); // Hits attackables that cast cancel, sleep or silence.')

end.