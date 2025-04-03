unit Unit_Functions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazLoggerBase, Forms, Registry;

function CheckAutoRun(): boolean;
procedure EnableAutoRun();
procedure DisableAutoRun();

implementation

function CheckAutoRun(): boolean;
var
  registry: TRegistry;
begin
  registry := TRegistry.Create(KEY_READ);
  try
    registry.RootKey := HKEY_CURRENT_USER;
    if registry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      if registry.ValueExists('ilkSQL') then
        Result := True
      else
        Result := False;
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
        '"' + Application.ExeName + '"');
      registry.CloseKey;
    end;

    registry.RootKey := HKEY_LOCAL_MACHINE;
    if registry.OpenKey('SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',
      False) then
    begin
      registry.WriteString('ilkSQL',
        '"' + Application.ExeName + '"');
      registry.CloseKey;
    end;

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

    registry.RootKey := HKEY_LOCAL_MACHINE;
    if registry.OpenKey('SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',
      False) then
    begin
      registry.DeleteValue('ilkSQL');
      registry.CloseKey;
    end;

  finally
    registry.Free;
  end;
end;

end.
