program ilkSQL;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Dialogs,
  zcomponent,
  Unit_Main,
  Unit_Functions, { you can add units after this }
  UExceptionLogger,
  UniqueInstance;
  {$R *.res}

  procedure OtherInstance(Sender: TObject; ParamCount: integer; const Parameters: array of ansistring);
  begin
    ShowMessage('ilkSQL zaten arkaplanda çalışıyor.');
  end;

var
  unique_instance: TUniqueInstance;
  onOtherInstance: procedure(Sender: TObject; ParamCount: integer;
  const Parameters: array of ansistring);
begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;

  unique_instance := TUniqueInstance.Create(Application);
  onOtherInstance := @OtherInstance;
  unique_instance.OnOtherInstance := onOtherInstance;

  exceptionLogger := TExceptionLogger.Create(Application);
  exceptionLogger.LogFileName := 'error.log';

  Application.CreateForm(TMain_Form, Main_Form);
  Application.ShowMainForm := False;
  Application.Run;
end.
