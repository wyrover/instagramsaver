unit UnitLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sMemo;

type
  TLogForm = class(TForm)
    LogList: TsMemo;
    sSkinProvider1: TsSkinProvider;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.dfm}

end.
