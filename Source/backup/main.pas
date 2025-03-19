unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, ButtonPanel, Menus, SynHighlighterSQL, SynEdit,
  ZConnection, ZDataset, LCLIntf, Unit_Functions, Registry;

type

  { TMain_Form }

  TMain_Form = class(TForm)
    ButtonPanel_ilkSQL: TButtonPanel;
    CheckBox_AutoRun: TCheckBox;
    ComboBox_Databases: TComboBox;
    Button_ListDatabases: TButton;
    Image_ilkadam: TImage;
    LabeledEdit_Timer: TLabeledEdit;
    Memo_Log: TMemo;
    MenuItem_Exit: TMenuItem;
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
    LabeledEdit_UserName: TLabeledEdit;
    Timer_ilkSQL: TTimer;
    TrayIcon_ilkSQL: TTrayIcon;
    ZConnection_ilkSQL: TZConnection;
    ZQuery_ilkSQL: TZQuery;
    procedure Button_ListDatabasesClick(Sender: TObject);
    procedure CheckBox_AutoRunChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image_ilkadamClick(Sender: TObject);
    procedure MenuItem_ExitClick(Sender: TObject);
    procedure Timer_ilkSQLTimer(Sender: TObject);
    procedure TrayIcon_ilkSQLDblClick(Sender: TObject);
  private

  public

  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.lfm}

{ TMain_Form }

procedure TMain_Form.MenuItem_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMain_Form.Timer_ilkSQLTimer(Sender: TObject);
begin
  try
    try

    finally

    end;
  except

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
    ZConnection_ilkSQL.User := LabeledEdit_UserName.Text;
    ZConnection_ilkSQL.Password := LabeledEdit_Password.Text;
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

procedure TMain_Form.CheckBox_AutoRunChange(Sender: TObject);
begin
  CheckAutoRun;
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  SynEdit_ilkSQL.Clear;
  Memo_Log.Text:='Hoşgeldiniz';
end;

procedure TMain_Form.Image_ilkadamClick(Sender: TObject);
begin
  OpenURL('https://ilkadam.com.tr');
end;

procedure TMain_Form.TrayIcon_ilkSQLDblClick(Sender: TObject);
begin
  Main_Form.Show;
end;

end.
