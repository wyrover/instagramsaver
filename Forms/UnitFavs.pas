unit UnitFavs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, Vcl.Buttons,
  sBitBtn, sEdit, sListBox, sCheckListBox, sSkinProvider;

type
  TFavForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    FavList: TsCheckListBox;
    NewFavEdit: TsEdit;
    AddBtn: TsBitBtn;
    SaveBtn: TsButton;
    CancelBtn: TsButton;
    ClearBtn: TsButton;
    RemoveBtn: TsButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewFavEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RemoveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FavForm: TFavForm;

implementation

{$R *.dfm}

uses UnitMain;

procedure TFavForm.AddBtnClick(Sender: TObject);
begin
  if Length(NewFavEdit.Text) > 0 then
  begin
    NewFavEdit.Text := LowerCase(NewFavEdit.Text);

    FavList.Items.Add(NewFavEdit.Text);
    FavList.Checked[FavList.Items.Count - 1] := True;

    NewFavEdit.Text := '';
  end
  else
  begin
    Application.MessageBox('Please enter a user name.', 'Error', MB_ICONERROR);
  end;
end;

procedure TFavForm.CancelBtnClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFavForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TFavForm.FormShow(Sender: TObject);
var
  LFavFile: TStringList;
  I: Integer;
  LSplit: TStringList;
begin
  FavList.Items.Clear;
  if FileExists(MainForm.FFavFilePath) then
  begin
    LFavFile := TStringList.Create;
    LSplit := TStringList.Create;
    try
      LSplit.StrictDelimiter := True;
      LSplit.Delimiter := '|';
      LFavFile.LoadFromFile(MainForm.FFavFilePath);
      for I := 0 to LFavFile.Count - 1 do
      begin
        LSplit.Clear;
        LSplit.DelimitedText := LFavFile[i];
        if LSplit.Count = 2 then
        begin
          FavList.Items.Add(LSplit[0]);
          if LSplit[1] = '1' then
          begin
            FavList.Checked[FavList.Items.Count - 1] := True;
          end
          else
          begin
            FavList.Checked[FavList.Items.Count - 1] := false;
          end;
        end;
      end;
    finally
      LFavFile.Free;
      LSplit.Free;
    end;
  end;
end;

procedure TFavForm.NewFavEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    AddBtnClick(Self);
  end;
end;

procedure TFavForm.RemoveBtnClick(Sender: TObject);
begin
  FavList.DeleteSelected;
end;

procedure TFavForm.SaveBtnClick(Sender: TObject);
var
  I: Integer;
  LTmpList: TStringList;
begin
  if FavList.Items.Count > 0 then
  begin
    LTmpList := TStringList.Create;
    try
      for I := 0 to FavList.Items.Count - 1 do
      begin
        if FavList.Checked[i] then
        begin
          LTmpList.Add(FavList.Items[i] + '|1')
        end
        else
        begin
          LTmpList.Add(FavList.Items[i] + '|0')
        end;
      end;
      LTmpList.SaveToFile(MainForm.FFavFilePath, TEncoding.UTF8);
    finally
      LTmpList.Free;
    end;
  end
  else
  begin
    DeleteFile(MainForm.FFavFilePath)
  end;
  Self.Close;
end;

end.
