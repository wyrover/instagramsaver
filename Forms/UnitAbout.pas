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



unit UnitAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ShellAPI;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    sLabel1: TLabel;
    sLabel2: TLabel;
    sLabel3: TLabel;
    sLabel4: TLabel;
    sButton1: TButton;
    sButton2: TButton;
    sButton3: TButton;
    procedure sButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sLabel4Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }


  public
    { Public declarations }


  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}


uses
  UnitMain;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  {$IFDEF WIN32}



  sLabel1.Caption := 'InstagramSaver 1.6 32bit';
  {$ENDIF}
  {$IFDEF WIN64}



  sLabel1.Caption := 'InstagramSaver 1.6 64bit';
  {$ENDIF}



end;

procedure TAboutForm.sButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.sButton2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://sourceforge.net/projects/instagramsaver/', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.sButton3Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6MSWEDR4AGBQG', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.sLabel4Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://sbstnblnd.deviantart.com/art/Plateau-0-2-391110900', nil, nil, SW_SHOWNORMAL);
end;

end.

