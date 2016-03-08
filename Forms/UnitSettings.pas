{ *
  * Copyright (C) 2014-2016 ozok <ozok26@gmail.com>
  *
  * This file is part of InstagramSaver.
  *
  * InstagramSaver is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License.
  *
  * InstagramSaver is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with InstagramSaver.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }


unit UnitSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IniFiles,
  Vcl.Samples.Spin;

type
  TSettingsForm = class(TForm)
    CheckUpdateBtn: TCheckBox;
    OpenOutBtn: TCheckBox;
    sButton1: TButton;
    DontDoubleDownloadBtn: TCheckBox;
    DownloadVideoBtn: TCheckBox;
    ThreadList: TComboBox;
    DontCheckBtn: TCheckBox;
    Label1: TLabel;
    procedure sButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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


uses
  UnitMain;

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
      if CPUCount > 16 then
      begin
        ThreadList.ItemIndex := ReadInteger('general', 'thread', 15);
      end
      else
      begin
        ThreadList.ItemIndex := ReadInteger('general', 'thread', CPUCount - 1);
      end;
      DontCheckBtn.Checked := ReadBool('general', 'check', False);
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
      WriteInteger('general', 'thread', ThreadList.ItemIndex);
      WriteBool('general', 'check', DontCheckBtn.Checked);
    end;
  finally
    LSetFile.Free;
  end;
end;

procedure TSettingsForm.sButton1Click(Sender: TObject);
begin
  Close;
end;

end.

