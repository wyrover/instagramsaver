unit UnitLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sMemo,
  Vcl.ComCtrls, sPageControl;

type
  TLogForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    LogList: TsMemo;
    sTabSheet2: TsTabSheet;
    ThreadsList: TsMemo;
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
