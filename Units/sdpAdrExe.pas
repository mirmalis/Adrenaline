unit sdpAdrExe;
interface
  var adrExePath: string;
implementation
  uses sdpUtils;
  procedure HttpGet()
  procedure Execute(params: string);
    begin
      cmd(adrExePath, params);
    end;
// function GetForegroundWindow: cardinal; stdcall; external 'User32.dll' name 'GetForegroundWindow';

initialization
  adrExePath := 'C:\Users\sars\Desktop\AdrExe2\AdrExe.exe';
  Print('adrExePath := ''' + adrExePath + '''');

end.