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
    UpBtn: TsButton;
    DownBtn: TsButton;
    DownloadBtn: TsButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewFavEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RemoveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FavListClickCheck(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure DownloadBtnClick(Sender: TObject);
  private
    { Private declarations }
    FEdited: Boolean;
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

    FEdited := True;
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

procedure TFavForm.ClearBtnClick(Sender: TObject);
begin
  if ID_YES = Application.MessageBox('Clear the favourites? This cannot be reversed!', 'Clear', MB_ICONQUESTION or MB_YESNO) then
  begin
    FEdited := True;
    // delete fav file
    if FileExists(MainForm.FFavFilePath) then
    begin
      DeleteFile(MainForm.FFavFilePath);
    end;
    FavList.Items.Clear;
  end;
end;

procedure TFavForm.DownBtnClick(Sender: TObject);
var
  I: Integer;
begin
  I := Favlist.Items.Count - 2;
  while I >= 0 do
  begin
    if Favlist.Selected[I] then
    begin
      Favlist.Items.Exchange(I, I + 1);
      Favlist.Selected[I + 1] := True;
    end;
    Dec(I);
  end;
end;

procedure TFavForm.DownloadBtnClick(Sender: TObject);
begin
  if FavList.ItemIndex > -1 then
  begin
    Self.Close;
    MainForm.UserNameEdit.Text := FavList.Items[FavList.ItemIndex];
    MainForm.DownloadBtnClick(Self);
  end;
end;

procedure TFavForm.FavListClickCheck(Sender: TObject);
begin
  FEdited := True;
end;

procedure TFavForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FEdited := True;
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TFavForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  LAnswer: integer;
begin
  if FEdited then
  begin
    // ask user wheter they want to close the form
    LAnswer := Application.MessageBox('Some values are changed. Do you want to save them before you close this window?', 'Save', MB_ICONQUESTION or MB_YESNOCANCEL);
    if ID_YES = LAnswer then
    begin
      // save then close
      SaveBtnClick(Self);
      CanClose := True;
    end
    else if ID_CANCEL = LAnswer then
    begin
      // dont close wtf
      CanClose := False;
    end
    else
    begin
      // close
      CanClose := True;
    end;
  end
  else
  begin
    // nothing's changed just close the form
    CanClose := True;
  end;
end;

procedure TFavForm.FormShow(Sender: TObject);
var
  LFavFile: TStringList;
  I: Integer;
  LSplit: TStringList;
begin
  FEdited := False;
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
  FEdited := true;
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
  FEdited := False;
  Self.Close;
end;

procedure TFavForm.UpBtnClick(Sender: TObject);
var
  I: Integer;
begin
  I := 1;
  while I < Favlist.Items.Count do
  begin
    if Favlist.Selected[I] then
    begin
      Favlist.Items.Exchange(I, I - 1);
      Favlist.Selected[I - 1] := True;
    end;
    Inc(I);
  end;
end;

end.
