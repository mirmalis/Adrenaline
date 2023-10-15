unit threadMapMaker;
interface
Type
TMapMaker = Class
  private
    external_points: string;
    internal_points: string;
    function full_string(external_points: String; internal_points: String = ''): String;
    procedure add_square(a: Integer);
    procedure new_internal_polygon();
  published
    zoneName: String;
    procedure Thread();
    procedure PrintHelp();
    Constructor Create(zoneNamez: String);
  end;
procedure PrintExamples();
implementation
  uses sdpStrings;
//TMapMaker. 
  Constructor TMapmaker.Create(zoneNamez: String);
    begin
      self.external_points := '';
      self.internal_points := '';
      self.zoneName := zoneNamez;
      inherited Create();
    end;
  procedure TMapMaker.Thread();
    var
      p1: cardinal; p2: pointer;
    begin
      PrintHelp();
      while engine.status = lsOnline do
      begin
        Engine.WaitAction([laKey], p1, p2);
        case p1 of
          96: //Numpad0
          begin
            external_points := '';
            internal_points := '';
            PrintHelp();
            print('');
          end;
          97: //Numpad1 -- add point to external_points.
          begin
            external_points :=
            external_points +
            #9#9#9#9 + '<point x="' + ToStr(User.x) + '" y="' + ToStr(User.y) + '"/>' + #10;
            
            Print(full_string(external_points, internal_points));
          end;
          98: //Numpad2 -- add point to internal_points.
          begin
            internal_points :=
            internal_points + 
            #9#9#9#9 + '<point x="' + ToStr(User.x) + '" y="' + ToStr(User.y) + '"/>' + #10;
            Print(full_string(external_points, internal_points));
          end;
          99: //Numpad3 -- start new polygon inside internal_points.
          begin
            new_internal_polygon;
          end;
          100: // Numpad4 -- add square of size 112
          begin
            add_square(112);
          end;
          101: // Numpad5 -- add square of size 51
          begin
            add_square(51);
          end;
          102: // Numpad6 -- load map
          begin
            Engine.LoadZone(self.zoneName);
          end;
        end; // case
      end; // while
      Print('TMapMaker.Thread finished');
    end;
  procedure TMapMaker.PrintHelp();
    begin
      Print('[TMapMaker] Numpad1 -- external polygon');
      Print('[TMapMaker] Numpad2 -- last internal polygon');
      Print('[TMapMaker] Numpad3 -- starts new internal polygon');
      Print('[TMapMaker] Numpad4 -- adds a square of 112 size');
      Print('[TMapMaker] Numpad5 -- adds a square of 51 size');
      Print('[TMapMaker] Numpad6 -- Engine.LoadZone(''' + self.zoneName + ''')');
    end;

  function TMapMaker.full_string(external_points: String; internal_points: String = ''): String;
    begin
      if (external_points <> '') then
      begin
      Result := '<?xml version="1.0" encoding="utf-8"?>' + #10 +
                      '<zone>' + #10 +
                  #9 + '<ExternalPoly>' + #10 +
                #9#9 + '<points>' + #10 +
                external_points +
                #9#9 + '</points>' + #10 +
                  #9 + '</ExternalPoly>' + #10
                  ;
      if (internal_points = '') then
      begin
        Result := Result + #9 + '<InternalPolies/>' + #10;
      end else begin
        Result := Result +
                  #9 + '<InternalPolies>' + #10+
                  #9#9+'<poly>'+#10+
                  #9#9#9+'<points>'+#10+
                          internal_points +
                  #9#9#9+'</points>'+#10+
                  #9#9+'</poly>'+#10+
                  #9 + '</InternalPolies>' + #10;
      end;
      Result := Result + '</zone>' + #10;
      end else
      begin
        Result :=
          #9#9+'<poly>'+#10+
        #9#9#9+'<points>'+#10+
                internal_points +
        #9#9#9+'</points>'+#10+
          #9#9+'</poly>'+#10;
      end;
    end;
  procedure TMapMaker.add_square(a: Integer);
    begin
      internal_points :=
        internal_points +
        #9#9#9#9 + '<point x="' + ToStr(User.x) + '" y="' + ToStr(User.y) + '"/>' + #10 +
        #9#9#9#9 + '<point x="' + ToStr(User.x) + '" y="' + ToStr(User.y-a) + '"/>' + #10 +
        #9#9#9#9 + '<point x="' + ToStr(User.x+a) + '" y="' + ToStr(User.y-a) + '"/>' + #10 +
        #9#9#9#9 + '<point x="' + ToStr(User.x+a) + '" y="' + ToStr(User.y) + '"/>' + #10;
      self.new_internal_polygon;
      Print(full_string(external_points, internal_points));
    end;
  procedure TMapMaker.new_internal_polygon();
    begin
      internal_points :=
      internal_points +
      #9#9#9 + '</points>' + #10 +
      #9#9 + '</poly>' + #10 +
      #9#9 + '<poly>' + #10 +
      #9#9#9 + '<points>' + #10;
    end;
procedure PrintExamples();
  begin
    Print('Script.NewThread(@threadMapMaker.TMapMaker.Thread, threadMapMaker.TMapMaker.Create(''your zone name''));')
  end;
end.