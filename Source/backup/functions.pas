unit Functions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazLoggerBase, Registry;

procedure Log(message: string);
procedure AutoRun();

implementation

procedure Log(message: string);
begin
  DebugLn(DateTimeToStr(Now) + ' : ' + message);
end;

procedure CheckAutoRun();
var
  registry: TRegistry;
begin
  registry := TRegistry.Create(KEY_WRITE);
  try
    registry.RootKey := HKEY_LOCAL_MACHINE;
    registry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
    if not registry.ValueExists('ilkSQL') then
      registry.WriteString('ilkSQL',
        '"C:\Users\Adem\Documents\GitHub\ilkSQL\Build\i386-win32\ilkSQL.exe"');
    registry.CloseKey;
  finally
    registry.Free;
  end;
end;

end.
