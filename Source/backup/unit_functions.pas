unit Unit_Functions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazLoggerBase, Registry;

function CheckAutoRun(): boolean;
procedure EnableAutoRun();
procedure DisableAutoRun();

implementation

function CheckAutoRun(): boolean;
var
  registry: TRegistry;
begin
  registry := TRegistry.Create(KEY_WRITE);
  try
    registry.RootKey := HKEY_CURRENT_USER;
    if registry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      if registry.ValueExists('ilkSQL') then
        Result := True;
      registry.CloseKey;
    end

  finally
    registry.Free;
  end;
end;

procedure EnableAutoRun();
var
  registry: TRegistry;
begin
  registry := TRegistry.Create(KEY_WRITE);
  try
    registry.RootKey := HKEY_CURRENT_USER;
    if registry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      registry.WriteString('ilkSQL',
        '"C:\Users\Adem\Documents\GitHub\ilkSQL\Build\i386-win32\ilkSQL.exe"');
      registry.CloseKey;
    end

  finally
    registry.Free;
  end;
end;

procedure DisableAutoRun();
var
  registry: TRegistry;
begin
  registry := TRegistry.Create(KEY_WRITE);
  try
    registry.RootKey := HKEY_CURRENT_USER;
    if registry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      registry.DeleteValue('ilkSQL');
      registry.CloseKey;
    end;

  finally
    registry.Free;
  end;
end;

end.
