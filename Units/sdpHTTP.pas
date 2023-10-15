// 0.0.0
unit sdpHTTP;

interface

function SimpleHTTPGet(const URL: string): string;

implementation

uses
  IdHTTP;

function SimpleHTTPGet(const URL: string): string;
var
  HTTP: TIdHTTP;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    Result := HTTP.Get(URL);
  finally
    HTTP.Free;
  end;
end;

end.
