{ *
  * Copyright (C) 2014 ozok <ozok26@gmail.com>
  *
  * This file is part of InstagramSaver.
  *
  * InstagramSaver is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
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

unit UnitLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sMemo,
  Vcl.ComCtrls, sPageControl, sButton, Vcl.ExtCtrls, sPanel, sDialogs;

type
  TLogForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    LogList: TsMemo;
    sTabSheet2: TsTabSheet;
    ThreadsList: TsMemo;
    sPanel1: TsPanel;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sSaveDialog1: TsSaveDialog;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.dfm}

procedure TLogForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Self.Close;
  end;
end;

procedure TLogForm.sButton1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TLogForm.sButton2Click(Sender: TObject);
begin
  case sPageControl1.ActivePageIndex of
    0:
      LogList.Lines.Clear;
    1:
      ThreadsList.Lines.Clear;
  end;
end;

procedure TLogForm.sButton3Click(Sender: TObject);
begin
  if sSaveDialog1.Execute then
  begin
    case sPageControl1.ActivePageIndex of
      0:
        LogList.Lines.SaveToFile(sSaveDialog1.FileName);
      1:
        ThreadsList.Lines.SaveToFile(sSaveDialog1.FileName);
    end;
  end;
end;

end.
