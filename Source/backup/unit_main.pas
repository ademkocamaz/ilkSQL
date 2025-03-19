unit Unit_Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, DB, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, ButtonPanel, Menus, SynHighlighterSQL, SynEdit,
  ZConnection, ZDataset, ZSqlMonitor, LCLIntf, UniqueInstance, Unit_Functions;

type

  { TMain_Form }

  TMain_Form = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn_Execute: TBitBtn;
    BitBtn_Start: TBitBtn;
    ButtonPanel_ilkSQL: TButtonPanel;
    CheckBox_AutoRun: TCheckBox;
    ComboBox_Databases: TComboBox;
    Button_ListDatabases: TButton;
    DataSource_ilkSQL: TDataSource;
    GroupBox_Every: TGroupBox;
    Image_ilkadam: TImage;
    LabeledEdit_Hour: TLabeledEdit;
    LabeledEdit_Minute: TLabeledEdit;
    LabeledEdit_Second: TLabeledEdit;
    Memo_Log: TMemo;
    MenuItem_Exit: TMenuItem;
    Panel_Bottom: TPanel;
    Separator: TMenuItem;
    MenuItem_ilkSQL: TMenuItem;
    PageControl_ilkSQL: TPageControl;
    LabeledEdit_Password: TLabeledEdit;
    LabeledEdit_Server: TLabeledEdit;
    PopupMenu_ilkSQL: TPopupMenu;
    SynEdit_ilkSQL: TSynEdit;
    SynSQLSyn_ilkSQL: TSynSQLSyn;
    TabSheet_About: TTabSheet;
    TabSheet_Ayarlar: TTabSheet;
    TabSheet_SQL: TTabSheet;
    TabSheet_Connection: TTabSheet;
    LabeledEdit_User: TLabeledEdit;
    Timer_ilkSQL: TTimer;
    TrayIcon_ilkSQL: TTrayIcon;
    UniqueInstance_ilkSQL: TUniqueInstance;
    ZConnection_ilkSQL: TZConnection;
    ZQuery_ilkSQL: TZQuery;
    ZSQLMonitor_ilkSQL: TZSQLMonitor;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn_ExecuteClick(Sender: TObject);
    procedure BitBtn_StartClick(Sender: TObject);
    procedure Button_ListDatabasesClick(Sender: TObject);
    procedure CheckBox_AutoRunChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image_ilkadamClick(Sender: TObject);
    procedure MenuItem_ExitClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Timer_ilkSQLStartTimer(Sender: TObject);
    procedure Timer_ilkSQLStopTimer(Sender: TObject);
    procedure Timer_ilkSQLTimer(Sender: TObject);
    procedure TrayIcon_ilkSQLDblClick(Sender: TObject);
    procedure UniqueInstance_ilkSQLOtherInstance(Sender: TObject;
      ParamCount: integer; const Parameters: array of string);
  private
    procedure Log(message: string);
  public

  end;

const
  iniFile = 'settings.ini';

var
  Main_Form: TMain_Form;

implementation

{$R *.lfm}

{ TMain_Form }

procedure TMain_Form.MenuItem_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMain_Form.OKButtonClick(Sender: TObject);
var
  settings: TIniFile;
  hour, minute, second: integer;
begin
  Log('Ayarlar kaydediliyor.');
  if (LabeledEdit_Hour.Text = '') or (LabeledEdit_Hour.Text = '0') then
    hour := 0
  else
    hour := StrToInt(LabeledEdit_Hour.Text) * 60 * 60 * 1000;

  if (LabeledEdit_Minute.Text = '') or (LabeledEdit_Minute.Text = '0') then
    minute := 0
  else
    minute := StrToInt(LabeledEdit_Minute.Text) * 60 * 1000;

  if (LabeledEdit_Second.Text = '') or (LabeledEdit_Second.Text = '0') then
    second := 0
  else
    second := StrToInt(LabeledEdit_Second.Text) * 1000;

  Timer_ilkSQL.Interval := hour + minute + second;
  Log('Timer.Interval:' + IntToStr(Timer_ilkSQL.Interval));
  settings := TIniFile.Create(iniFile);
  settings.WriteString('Connection', 'Host', LabeledEdit_Server.Text);
  settings.WriteString('Connection', 'User', LabeledEdit_User.Text);
  settings.WriteString('Connection', 'Password', LabeledEdit_Password.Text);

  settings.WriteString('Database', 'Name', ComboBox_Databases.Text);

  settings.WriteInteger('Timer', 'Interval', Timer_ilkSQL.Interval);
  settings.WriteBool('Timer', 'Enabled', True);

  settings.WriteString('Every', 'Hour', LabeledEdit_Hour.Text);
  settings.WriteString('Every', 'Minute', LabeledEdit_Minute.Text);
  settings.WriteString('Every', 'Second', LabeledEdit_Second.Text);

  settings.WriteString('Query', 'SQL', SynEdit_ilkSQL.Text);

  settings.Free;
  //SynEdit_ilkSQL.Lines.SaveToFile('sql.txt');
  Timer_ilkSQL.Enabled := True;
  Log('Ayarlar kaydedildi.');
  Self.Hide;
end;

procedure TMain_Form.Timer_ilkSQLStartTimer(Sender: TObject);
begin
  Log('Timer başlatıldı.');
  Log('Timer.Interval:' + IntToStr(Timer_ilkSQL.Interval));
end;

procedure TMain_Form.Timer_ilkSQLStopTimer(Sender: TObject);
begin
  Log('Timer durduruldu.');
end;

procedure TMain_Form.Timer_ilkSQLTimer(Sender: TObject);
begin
  try
    try
      Log('Veritabanına bağlanılıyor.');
      ZConnection_ilkSQL.HostName := LabeledEdit_Server.Text;
      ZConnection_ilkSQL.User := LabeledEdit_User.Text;
      ZConnection_ilkSQL.Password := LabeledEdit_Password.Text;
      ZConnection_ilkSQL.Database := ComboBox_Databases.Text;
      ZConnection_ilkSQL.Connect;
      Log('Veritabanına bağlanıldı.');
      Log('Sorgu çalıştırılıyor.');
      ZQuery_ilkSQL.SQL.Text := SynEdit_ilkSQL.Text;
      if not ZQuery_ilkSQL.Prepared then
        ZQuery_ilkSQL.Prepare;
      ZQuery_ilkSQL.ExecSQL;
      Log('Sorgu çalıştırıldı.');
    finally
      ZQuery_ilkSQL.Unprepare;
      ZConnection_ilkSQL.Disconnect;
      Log('İşlem başarıyla tamamlandı.')
    end;
  except
    Log('Hata oluştu.')
  end;
end;

procedure TMain_Form.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := TCloseAction.caHide;
end;

procedure TMain_Form.Button_ListDatabasesClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    ZConnection_ilkSQL.HostName := LabeledEdit_Server.Text;
    ZConnection_ilkSQL.User := LabeledEdit_User.Text;
    ZConnection_ilkSQL.Password := LabeledEdit_Password.Text;
    ZConnection_ilkSQL.Database := 'master';
    ZConnection_ilkSQL.Connect;
    ZQuery_ilkSQL.SQL.Text := 'SELECT NAME FROM SYS.DATABASES';
    if not ZQuery_ilkSQL.Prepared then
      ZQuery_ilkSQL.Prepare;
    ZQuery_ilkSQL.Open;
    while not ZQuery_ilkSQL.EOF do
    begin
      ComboBox_Databases.Items.Add(ZQuery_ilkSQL.FieldByName('NAME').AsString);
      ZQuery_ilkSQL.Next;
    end;
  finally
    Screen.Cursor := crDefault;
    ZQuery_ilkSQL.Unprepare;
    ZQuery_ilkSQL.Close;
    ZConnection_ilkSQL.Disconnect;
  end;
end;

procedure TMain_Form.BitBtn_StartClick(Sender: TObject);
begin
  Timer_ilkSQL.Enabled := True;
end;

procedure TMain_Form.BitBtn1Click(Sender: TObject);
begin
  Timer_ilkSQL.Enabled := False;
end;

procedure TMain_Form.BitBtn_ExecuteClick(Sender: TObject);
begin
  try
    try
      Screen.Cursor := crHourGlass;
      ZConnection_ilkSQL.HostName := LabeledEdit_Server.Text;
      ZConnection_ilkSQL.User := LabeledEdit_User.Text;
      ZConnection_ilkSQL.Password := LabeledEdit_Password.Text;
      ZConnection_ilkSQL.Database := ComboBox_Databases.Text;
      ZConnection_ilkSQL.Connect;
      Log('Veritabanına bağlanıldı.');
      ZQuery_ilkSQL.SQL.Text := SynEdit_ilkSQL.Text;
      if not ZQuery_ilkSQL.Prepared then
        ZQuery_ilkSQL.Prepare;
      ZQuery_ilkSQL.ExecSQL;
      Log('Sorgu çalıştırıldı.');
    finally
      Screen.Cursor := crDefault;
      ZQuery_ilkSQL.Unprepare;
      ZQuery_ilkSQL.Close;
      ZConnection_ilkSQL.Disconnect;
    end;
  except

  end;

end;

procedure TMain_Form.CheckBox_AutoRunChange(Sender: TObject);
begin
  if CheckBox_AutoRun.Checked then
  begin
    Unit_Functions.EnableAutoRun();
    Log('Windows başlangıcında çalıştırma açıldı.');
  end
  else
  begin
    Unit_Functions.DisableAutoRun();
    Log('Windows başlangıcında çalıştırma kapatıldı.');
  end;
end;

procedure TMain_Form.FormCreate(Sender: TObject);
var
  settings: TIniFile;
  host, user, password, database: string;
begin
  Memo_Log.Clear;
  SynEdit_ilkSQL.Clear;

  Log('Hoşgeldiniz.');

  CheckBox_AutoRun.Checked := Unit_Functions.CheckAutoRun();
  if FileExists(iniFile) then
  begin
    settings := TIniFile.Create(iniFile);

    host := settings.ReadString('Connection', 'Host', '');
    user := settings.ReadString('Connection', 'User', '');
    password := settings.ReadString('Connection', 'Password', '');
    database := settings.ReadString('Database', 'Name', '');

    LabeledEdit_Server.Text := host;
    LabeledEdit_User.Text := user;
    LabeledEdit_Password.Text := password;
    ComboBox_Databases.Text := database;

    ZConnection_ilkSQL.HostName := host;
    ZConnection_ilkSQL.User := user;
    ZConnection_ilkSQL.Password := password;
    ZConnection_ilkSQL.Database := database;

    SynEdit_ilkSQL.Text := settings.ReadString('Query', 'SQL', '');


    Timer_ilkSQL.Interval := settings.ReadInteger('Timer', 'Interval', 60000);
    Timer_ilkSQL.Enabled := settings.ReadBool('Timer', 'Enabled', False);

    LabeledEdit_Hour.Text := settings.ReadString('Every', 'Hour', '0');
    LabeledEdit_Minute.Text := settings.ReadString('Every', 'Minute', '0');
    LabeledEdit_Second.Text := settings.ReadString('Every', 'Second', '0');
  end
  else
    Self.Show;

end;

procedure TMain_Form.Image_ilkadamClick(Sender: TObject);
begin
  OpenURL('https://ilkadam.com.tr');
end;

procedure TMain_Form.TrayIcon_ilkSQLDblClick(Sender: TObject);
begin
  Main_Form.Show;
end;

procedure TMain_Form.UniqueInstance_ilkSQLOtherInstance(Sender: TObject;
  ParamCount: integer; const Parameters: array of string);
begin
  ShowMessage('ilkSQL zaten arkaplanda çalışıyor.');
end;

procedure TMain_Form.Log(message: string);
begin
  Memo_Log.Lines.Add(DateTimeToStr(Now) + ' : ' + message);
end;

end.
