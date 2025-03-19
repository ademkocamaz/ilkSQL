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
  zcomponent,
  Unit_Main,
  Unit_Functions, { you can add units after this }
  UExceptionLogger;
  {$R *.res}
begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;

  exceptionLogger := TExceptionLogger.Create(Application);
  exceptionLogger.LogFileName := 'error.log';

  Application.CreateForm(TMain_Form, Main_Form);
  Application.ShowMainForm := False;
  Application.Run;
end.
