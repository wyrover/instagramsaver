unit UnitSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sButton,
  sCheckBox, IniFiles, sComboBox;

type
  TSettingsForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    CheckUpdateBtn: TsCheckBox;
    OpenOutBtn: TsCheckBox;
    sButton1: TsButton;
    DontDoubleDownloadBtn: TsCheckBox;
    DownloadVideoBtn: TsCheckBox;
    SkinList: TsComboBox;
    ThreadList: TsComboBox;
    procedure sButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SkinListChange(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses UnitMain;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  LoadSettings;
end;

procedure TSettingsForm.LoadSettings;
var
  LSetFile: TIniFile;
begin
  LSetFile := TIniFile.Create(MainForm.FAppDataFolder + 'settings.ini');
  try
    with LSetFile do
    begin
      CheckUpdateBtn.Checked := ReadBool('general', 'update', True);
      OpenOutBtn.Checked := ReadBool('general', 'openout', True);
      DontDoubleDownloadBtn.Checked := ReadBool('general', 'nodouble', True);
      DownloadVideoBtn.Checked := ReadBool('general', 'video', False);
      SkinList.ItemIndex := ReadInteger('general', 'skin', 0);
      ThreadList.ItemIndex := ReadInteger('general', 'thread', CPUCount-1);
    end;
  finally
    LSetFile.Free;
  end;

end;

procedure TSettingsForm.SaveSettings;
var
  LSetFile: TIniFile;
begin
  LSetFile := TIniFile.Create(MainForm.FAppDataFolder + 'settings.ini');
  try
    with LSetFile do
    begin
      WriteBool('general', 'update', CheckUpdateBtn.Checked);
      WriteBool('general', 'openout', OpenOutBtn.Checked);
      WriteBool('general', 'nodouble', DontDoubleDownloadBtn.Checked);
      WriteBool('general', 'video', DownloadVideoBtn.Checked);
      WriteInteger('general', 'skin', SkinList.ItemIndex);
      WriteInteger('general', 'thread', ThreadList.ItemIndex);
    end;
  finally
    LSetFile.Free;
    SkinListChange(Self);
  end;
end;

procedure TSettingsForm.sButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TSettingsForm.SkinListChange(Sender: TObject);
begin
  case SkinList.ItemIndex of
    0:
      MainForm.sSkinManager1.SkinName := 'DarkMetro (internal)';
    1:
      MainForm.sSkinManager1.SkinName := 'AlterMetro (internal)';
  end;
end;

end.
