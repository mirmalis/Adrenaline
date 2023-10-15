unit sdpFunc;
interface
type TAnonOfBool = reference to function: Boolean;
type TFuncOfBool = function(): Boolean;
type TAnonIntOfBool = reference to function(a: Integer): Boolean;
type TAnonIntIntOfBool = reference to function(a,b: Integer): Boolean;
type TAnonOfInt = reference to function(): Integer;
type TArrOfTAnonOfBool = Array of TAnonOfBool;
type TObjectInt = function: Integer of object;
type // enumerators
  TOperator = (LessOrEqual = -2, Less = -1, Equal = 0, Greater = 1, GreaterOrEqual = 2, NotEqual = 5);
function FAll(funcs: TArrOfTAnonOfBool): TAnonOfBool;
function FAny(funcs: TArrOfTAnonOfBool): TAnonOfBool;
function FNot(func: TAnonOfBool): TAnonOfBool;
function FComparer(vOperator: TOperator): TAnonIntIntOfBool;
implementation
function FAll(funcs: TArrOfTAnonOfBool): TAnonOfBool;
  begin
    Result := function(): Boolean
    var i: Integer;
    begin
      Result := true;
      for i:=0 to Length(funcs) - 1 do 
      begin
        if not funcs[i]() then 
        begin
          Result := false;
          exit;
        end;
      end;
    end;
  end;
function FAny(funcs: TArrOfTAnonOfBool): TAnonOfBool;
  begin
    Result := function(): Boolean
    var i: Integer;
    begin
      Result := false;
      for i:=0 to Length(funcs) - 1 do 
      begin
        if funcs[i]() then 
        begin
          Result := true;
          exit;
        end;
      end;
    end;
  end;
function FNot(func: TAnonOfBool): TAnonOfBool;
  begin
    Result := function(): Boolean
    begin
      Result := not func();
    end;
  end;

function FComparer(vOperator: TOperator): TAnonIntIntOfBool;
  begin
    case vOperator of 
      LessOrEqual: begin
        Result := function(a,b: Integer): Boolean
        begin
          Result := a <= b;
        end;
      end;
      Less: begin
        Result := function(a,b: Integer): Boolean
        begin
          Result := a < b;
        end;
      end;
      Equal: begin
        Result := function(a,b: Integer): Boolean
        begin
          Result := a = b;
        end;
      end;
      NotEqual: begin
        Result := function(a,b: Integer): Boolean
        begin
          Result := a <> b;
        end;
      end;
      Greater: begin
        Result := function(a,b: Integer): Boolean
        begin
          Result := a > b;
        end;
      end;
      GreaterOrEqual: begin
        Result := function(a,b: Integer): Boolean
        begin
          Result := a >= b;
        end;
      end;
      else Print('Unrecognized operator in FuncComparer');
    end;
  end;

Initialization


end.
