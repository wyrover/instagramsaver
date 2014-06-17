unit UnitAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sLabel,
  acPNG, Vcl.ExtCtrls, ShellAPI, sButton;

type
  TAboutForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    Image1: TImage;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    procedure sButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sLabel4Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

uses UnitMain;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
  MainForm.BringToFront;
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
