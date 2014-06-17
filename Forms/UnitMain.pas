unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, JvComponentBase, JvUrlListGrabber, JvUrlGrabbers, StrUtils,
  Vcl.Mask, sSkinProvider, sSkinManager, sMaskEdit,
  sCustomComboEdit, sToolEdit, Vcl.Buttons, sBitBtn, sEdit, Vcl.ComCtrls,
  sStatusBar, sGauge, sBevel, sPanel, JvComputerInfoEx, IniFiles, sLabel, ShellAPI, windows7taskbar, UnitImageTypeExtractor,
  Generics.Collections, JvThread;

type
  TURLType = (Img=0, Video=1);

type
  TURL = packed record
    URL: string;
    URLType: TURLType;
  end;

type
  TMainForm = class(TForm)
    ImagePageDownloader1: TJvHttpUrlGrabber;
    ImagePageDownloader2: TJvHttpUrlGrabber;
    ImageDownloader2: TJvHttpUrlGrabber;
    ImageDownloader1: TJvHttpUrlGrabber;
    GroupBox1: TGroupBox;
    ProgressEdit: TsEdit;
    OutputEdit: TsDirectoryEdit;
    OpenOutputBtn: TsBitBtn;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    CurrentBar: TsGauge;
    TotalBar: TsGauge;
    sPanel1: TsPanel;
    DownloadBtn: TsBitBtn;
    StopBtn: TsBitBtn;
    AboutBtn: TsBitBtn;
    SettingsBtn: TsBitBtn;
    sPanel2: TsPanel;
    UserNameEdit: TsEdit;
    Info: TJvComputerInfoEx;
    CurrentLinkEdit: TsLabel;
    StateEdit: TsLabel;
    DonateBtn: TsBitBtn;
    LogBtn: TsBitBtn;
    VideoLinkDownloader2: TJvHttpUrlGrabber;
    VideoLinkDownloader1: TJvHttpUrlGrabber;
    UpdateThread: TJvThread;
    UpdateDownloader: TJvHttpUrlGrabber;
    procedure DownloadBtnClick(Sender: TObject);
    procedure ImagePageDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure ImagePageDownloader2DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure ImageDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure ImageDownloader2DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure ImageDownloader2Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure ImageDownloader1Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StopBtnClick(Sender: TObject);
    procedure SettingsBtnClick(Sender: TObject);
    procedure OpenOutputBtnClick(Sender: TObject);
    procedure UserNameEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AboutBtnClick(Sender: TObject);
    procedure DonateBtnClick(Sender: TObject);
    procedure ImagePageDownloader2Error(Sender: TObject; ErrorMsg: string);
    procedure ImagePageDownloader1Error(Sender: TObject; ErrorMsg: string);
    procedure ImageDownloader1Error(Sender: TObject; ErrorMsg: string);
    procedure ImageDownloader2Error(Sender: TObject; ErrorMsg: string);
    procedure LogBtnClick(Sender: TObject);
    procedure VideoLinkDownloader1DoneFile(Sender: TObject; FileName: string;
      FileSize: Integer; Url: string);
    procedure VideoLinkDownloader2DoneFile(Sender: TObject; FileName: string;
      FileSize: Integer; Url: string);
    procedure VideoLinkDownloader1Error(Sender: TObject; ErrorMsg: string);
    procedure VideoLinkDownloader2Error(Sender: TObject; ErrorMsg: string);
    procedure VideoLinkDownloader1Progress(Sender: TObject; Position,
      TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure VideoLinkDownloader2Progress(Sender: TObject; Position,
      TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure ImagePageDownloader2Progress(Sender: TObject; Position,
      TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure ImagePageDownloader1Progress(Sender: TObject; Position,
      TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure UpdateThreadExecute(Sender: TObject; Params: Pointer);
    procedure UpdateDownloaderDoneStream(Sender: TObject; Stream: TStream;
      StreamSize: Integer; Url: string);
  private
    { Private declarations }
    FImageIndex: integer;
    FVideoPageIndex: Integer;

    FLinksToDownload: TList<TURL>;
    FPageURLs: TStringList;
    FFilesToCheck: TStringList;

    function LineToImageLink(const Line: string):string;
    function LinetoNextPageLink(const Line: string):string;
    function LineToPageLink(const Line: string): string;
    function LineToVideoURL(const Line: string): string;

    procedure LoadSettings;
    procedure SaveSettings;

    procedure DisableUI;
    procedure EnableUI;

    function URLToFileName(const URL: TURL): string;

    // returns true when no problem occurs
    function CheckFiles: Boolean;

    // generates guid
    function GenerateGUID: string;

    // checks if string is numeric
    function IsStringNumeric(Str: string): Boolean;
  public
    { Public declarations }
    FAppDataFolder: string;
    FTempFolder: string;
  end;

var
  MainForm: TMainForm;

const
  BuildInt = 235;
  Portable = False;

implementation

{$R *.dfm}

uses UnitSettings, UnitAbout, UnitLog;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  Self.Enabled := False;
  AboutForm.Show;
end;

function TMainForm.CheckFiles: Boolean;
var
  i: integer;
  LITE: TImageType;
begin
  Result := True;

  Self.Caption := 'Checking downloaded images...';
  Self.Enabled := False;
  try
    for I := 0 to FFilesToCheck.Count-1 do
    begin
      Application.ProcessMessages;
      Self.Caption := 'Checking downloaded images...(' + FloatToStr(i + 1) + '/' + FloatToStr(FFilesToCheck.Count) + ')';
      if FileExists(FFilesToCheck[i]) then
      begin
        // check image files
        if LowerCase(ExtractFileExt(FFilesToCheck[i])) = '.jpg' then
        begin
          LITE := TImageType.Create(FFilesToCheck[i]);
          try
            if Length(LITE.ImageType) < 1 then
            begin
              LogForm.LogList.Lines.Add('Invalid image file: ' + FFilesToCheck[i]);
            end;
          finally
            LITE.Free;
          end;
        end
        else
        begin
          // todo: check video files
        end;
      end
      else
      begin
        LogForm.LogList.Lines.Add('Unable to find file: ' + FFilesToCheck[i]);
      end;
    end;
  finally
    Self.Caption := 'InstagramSaver';
    Self.Enabled := True
  end;

  Result := 0 <> LogForm.LogList.Lines.Count;
end;

procedure TMainForm.DisableUI;
begin
  UserNameEdit.Enabled := False;
  DownloadBtn.Enabled := False;
  StopBtn.Enabled := True;
  SettingsBtn.Enabled := False;
  AboutBtn.Enabled := False;
  OutputEdit.Enabled := False;
end;

procedure TMainForm.DonateBtnClick(Sender: TObject);
begin
{<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="">
<input type="image" src="https://www.paypalobjects.com/tr_TR/TR/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - Online ödeme yapmanýn daha güvenli ve kolay yolu!">
<img alt="" border="0" src="https://www.paypalobjects.com/tr_TR/i/scr/pixel.gif" width="1" height="1">
</form>
}
ShellExecute(0, 'open', 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6MSWEDR4AGBQG', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DownloadBtnClick(Sender: TObject);
begin
  if Length(UserNameEdit.Text) > 0 then
  begin
    if not ForceDirectories(OutputEdit.Text + '\' + UserNameEdit.Text) then
    begin
      Application.MessageBox('Cannot create output folder. Please enter a valid one.', 'Error', MB_ICONERROR);
      Exit;
    end;
    // reset lists
    FLinksToDownload.Clear;
    FFilesToCheck.Clear;
    FPageURLs.Clear;

    // delete temp files
    if FileExists(ImagePageDownloader1.FileName) then
    begin
      DeleteFile(ImagePageDownloader1.FileName)
    end;
    if FileExists(ImagePageDownloader2.FileName) then
    begin
      DeleteFile(ImagePageDownloader2.FileName)
    end;
    if FileExists(VideoLinkDownloader2.FileName) then
    begin
      DeleteFile(VideoLinkDownloader2.FileName)
    end;
    if FileExists(VideoLinkDownloader1.FileName) then
    begin
      DeleteFile(VideoLinkDownloader1.FileName)
    end;

    ImageDownloader1.OnProgress := ImageDownloader1Progress;
    ImageDownloader2.OnProgress := ImageDownloader2Progress;
    CurrentBar.Progress := 0;
    TotalBar.Progress := 0;

    StateEdit.Caption := 'State: Extracting image links...';
    ProgressEdit.Text := '0/0';
    Self.Caption := '0% [InstagramSaver]';
    DisableUI;
    CurrentLinkEdit.Caption := 'Link: ' + 'http://web.stagram.com/n/' + UserNameEdit.Text + '/?vm=list';
    SetProgressState(Handle, tbpsNormal);

    ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + UserNameEdit.Text + '/?vm=list';
    ImagePageDownloader1.Start;
  end
  else
  begin
    Application.MessageBox('Please enter a user name first.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.EnableUI;
begin
  UserNameEdit.Enabled := True;
  DownloadBtn.Enabled := True;
  StopBtn.Enabled := False;
  SettingsBtn.Enabled := True;
  AboutBtn.Enabled := True;
  OutputEdit.Enabled := True;
  CurrentBar.Progress := 0;
  TotalBar.Progress := 0;
  CurrentLinkEdit.Caption := 'Link: ';
  StateEdit.Caption := 'State: ';
  Self.Caption := 'InstagramSaver';
  SetProgressValue(Handle, 0, MaxInt);
  SetProgressState(Handle, tbpsNone);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
  // delete temp files
  if FileExists(ImagePageDownloader1.FileName) then
  begin
    DeleteFile(ImagePageDownloader1.FileName)
  end;
  if FileExists(ImagePageDownloader2.FileName) then
  begin
    DeleteFile(ImagePageDownloader2.FileName)
  end;
  if FileExists(VideoLinkDownloader2.FileName) then
  begin
    DeleteFile(VideoLinkDownloader2.FileName)
  end;
  if FileExists(VideoLinkDownloader1.FileName) then
  begin
    DeleteFile(VideoLinkDownloader1.FileName)
  end;
  if Portable then
  begin
    if DirectoryExists(FTempFolder) then
    begin
      RemoveDir(FTempFolder);
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLinksToDownload := TList<TURL>.Create;
  FPageURLs := TStringList.Create;
  FFilesToCheck := TStringList.Create;

  if Portable then
  begin
    FAppDataFolder := ExtractFileDir(Application.ExeName) + '\'
  end
  else
  begin
    FAppDataFolder := Info.Folders.AppData + '\InstagramSaver\';
  end;
  FTempFolder := Info.Folders.Temp + '\InstagramSaver\';
  if not DirectoryExists(FAppDataFolder) then
  begin
    CreateDir(FAppDataFolder);
  end;
  if not DirectoryExists(FTempFolder) then
  begin
    CreateDir(FTempFolder);
  end;
  ImagePageDownloader1.FileName := FTempFolder + '\' + GenerateGUID + '.txt';
  ImagePageDownloader2.FileName := FTempFolder + '\' + GenerateGUID + '.txt';
  VideoLinkDownloader2.FileName := FTempFolder + '\' + GenerateGUID + '.txt';
  VideoLinkDownloader1.FileName := FTempFolder + '\' + GenerateGUID + '.txt';

  // windows 7 taskbar
  if CheckWin32Version(6, 1) then
  begin
    if not InitializeTaskbarAPI then
    begin
      Application.MessageBox('You seem to have Windows 7 but program can''t start taskbar progressbar!', 'Error', MB_ICONERROR);
    end;
  end;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FLinksToDownload.Free;
  FPageURLs.Free;
  FFilesToCheck.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadSettings;
end;

function TMainForm.GenerateGUID: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := GUIDToString(LGUID);
end;

procedure TMainForm.ImageDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
var
  LOutFile: string;
begin
  inc(FImageIndex);
  if FImageIndex < FLinksToDownload.Count then
  begin
    LOutFile := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
    // dont download twice
    if SettingsForm.DontDoubleDownloadBtn.Checked then
    begin
      if not FileExists(LOutFile) then
      begin
        ImageDownloader2.Url := FLinksToDownload[FImageIndex].URL;
        CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[FImageIndex].URL;
        ImageDownloader2.FileName := LOutFile;
        ImageDownloader2.Start;
        FFilesToCheck.Add(LOutFile);
      end
      else
      begin
        while FileExists(LOutFile) do
        begin
          inc(FImageIndex);
          if FImageIndex < FLinksToDownload.Count then
          begin
            LOutFile := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
            if not FileExists(LOutFile) then
            begin
              ImageDownloader2.Url := FLinksToDownload[FImageIndex].URL;
              CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[FImageIndex].URL;
              ImageDownloader2.FileName := LOutFile;
              ImageDownloader2.Start;
              FFilesToCheck.Add(LOutFile);
              Break;
            end;
          end
          else
          begin
            if ImagePageDownloader1.Status <> gsStopped then
            begin
              ImagePageDownloader1.Stop
            end;
            ImagePageDownloader1.OnProgress := nil;
            EnableUI;
            Self.BringToFront;
            if SettingsForm.OpenOutBtn.Checked then
            begin
              ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text + '\' + UserNameEdit.Text), nil, nil, SW_SHOWNORMAL);
            end;

            Sleep(100);
            CurrentBar.Progress := 0;
            TotalBar.Progress := 0;
            ProgressEdit.Text := FloatToStr(FLinksToDownload.Count) + '/' + FloatToStr(FLinksToDownload.Count);
            if CheckFiles then
            begin
              LogForm.Show;
            end;
            Break;
          end;
        end;
      end;
    end
    else
    begin
      ImageDownloader2.Url := FLinksToDownload[FImageIndex].URL;
      CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[FImageIndex].URL;
      ImageDownloader2.FileName := LOutFile;
      ImageDownloader2.Start;
    end;
  end
  else
  begin
    if ImagePageDownloader1.Status <> gsStopped then
    begin
      ImagePageDownloader1.Stop
    end;
    ImageDownloader1.OnProgress := nil;
    EnableUI;
    Self.BringToFront;
    if SettingsForm.OpenOutBtn.Checked then
    begin
      ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text + '\' + UserNameEdit.Text), nil, nil, SW_SHOWNORMAL);
    end;

    Sleep(100);
    CurrentBar.Progress := 0;
    TotalBar.Progress := 0;
    if CheckFiles then
    begin
      LogForm.Show;
    end;
  end;
end;

procedure TMainForm.ImageDownloader1Error(Sender: TObject; ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('ID1: ' + ErrorMsg);
end;

procedure TMainForm.ImageDownloader1Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  if TotalSize > 0 then
  begin
    CurrentBar.Progress := (100 * Position) div TotalSize;
    TotalBar.Progress := (100 * FImageIndex) div FLinksToDownload.Count;
    ProgressEdit.Text := FloatToStr(FImageIndex+1) + '/' + FloatToStr(FLinksToDownload.Count);
    SetProgressValue(Handle, FImageIndex+1, FLinksToDownload.Count);

    Self.Caption := FloatToStr(TotalBar.Progress) + '% [InstagramSaver]';
  end;
end;

procedure TMainForm.ImageDownloader2DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
var
  LOutFile: string;
begin
  inc(FImageIndex);                                                                                                    //URLToFileName(FLinksToDownload[FImageIndex].URL)
  if FImageIndex < FLinksToDownload.Count then
  begin
    LOutFile := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
    // dont download twice
    if SettingsForm.DontDoubleDownloadBtn.Checked then
    begin
      if not FileExists(LOutFile) then
      begin
        ImageDownloader1.Url := FLinksToDownload[FImageIndex].URL;
        CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[FImageIndex].URL;
        ImageDownloader1.FileName := LOutFile;
        ImageDownloader1.Start;
        FFilesToCheck.Add(LOutFile);
      end
      else
      begin
        while FileExists(LOutFile) do
        begin
          inc(FImageIndex);
          if FImageIndex < FLinksToDownload.Count then
          begin
            LOutFile := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
            if not FileExists(LOutFile) then
            begin
              ImageDownloader1.Url := FLinksToDownload[FImageIndex].URL;
              CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[FImageIndex].URL;
              ImageDownloader1.FileName := LOutFile;
              ImageDownloader1.Start;
              FFilesToCheck.Add(LOutFile);
              Break;
            end;
          end
          else
          begin
            if ImagePageDownloader2.Status <> gsStopped then
            begin
              ImagePageDownloader2.Stop
            end;
            ImageDownloader2.OnProgress := nil;
            EnableUI;
            Self.BringToFront;
            if SettingsForm.OpenOutBtn.Checked then
            begin
              ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text + '\' + UserNameEdit.Text), nil, nil, SW_SHOWNORMAL);
            end;

            Sleep(100);
            CurrentBar.Progress := 0;
            TotalBar.Progress := 0;
            ProgressEdit.Text := FloatToStr(FLinksToDownload.Count) + '/' + FloatToStr(FLinksToDownload.Count);
            if CheckFiles then
            begin
              LogForm.Show;
            end;
            Break;
          end;
        end;
      end;
    end
    else
    begin
      ImageDownloader1.Url := FLinksToDownload[FImageIndex].URL;
      CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[FImageIndex].URL;
      ImageDownloader1.FileName := LOutFile;
      ImageDownloader1.Start;
    end;
  end
  else
  begin
    if ImagePageDownloader2.Status <> gsStopped then
    begin
      ImagePageDownloader2.Stop
    end;
    ImageDownloader2.OnProgress := nil;
    EnableUI;
    Self.BringToFront;
    if SettingsForm.OpenOutBtn.Checked then
    begin
      ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text + '\' + UserNameEdit.Text), nil, nil, SW_SHOWNORMAL);
    end;

    Sleep(100);
    CurrentBar.Progress := 0;
    TotalBar.Progress := 0;
    if CheckFiles then
    begin
      LogForm.Show;
    end;
  end;
end;

procedure TMainForm.ImageDownloader2Error(Sender: TObject; ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('ID2: ' + ErrorMsg);
end;

procedure TMainForm.ImageDownloader2Progress(Sender: TObject; Position,
  TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  if TotalSize > 0 then
  begin
    CurrentBar.Progress := (100 * Position) div TotalSize;
    TotalBar.Progress := (100 * FImageIndex) div FLinksToDownload.Count;
    ProgressEdit.Text := FloatToStr(FImageIndex+1) + '/' + FloatToStr(FLinksToDownload.Count);
    SetProgressValue(Handle, FImageIndex+1, FLinksToDownload.Count);

    Self.Caption := FloatToStr(TotalBar.Progress) + '% [InstagramSaver]';
  end;
end;

procedure TMainForm.ImagePageDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
const
  ImageLink = '.jpg';
  ImageLink2 = '<a href="/p/';
  NextPageLink = 'npk';
  Grid = 'vm=grid&';
  List = 'vm=list&';
  NextText = 'rel="next">';
  LargeImg = 'pw:image="';
  PageURLStart = 'pw:url="';
var
  LStreamReader: TStreamReader;
  LLine: string;
  LNextPageLink: string;
  i:integer;
  LURL: TURL;
begin
  // if StreamSize > 0 then
  // begin
  LStreamReader := TStreamReader.Create(FileName, True);
  LNextPageLink := '';
  try
    while not LStreamReader.EndOfStream do
    begin
      LLine := Trim(LStreamReader.ReadLine);
      // image link
      if ContainsText(LLine, LargeImg) then
      begin
        if ('htt' = Copy(LineToImageLink(LLine), 1, 3)) then
        begin
          LURL.URL := LineToImageLink(LLine);
          LURL.URLType := Img;
          FLinksToDownload.Add(LURL);
        end;
      end;
      // page link
      if ContainsText(LLine, PageURLStart) then
      begin
        FPageURLs.Add(LineToPageLink(LLine))
      end;
      // next page
      if ContainsText(LLine, NextPageLink) and ContainsText(LLine, NextText) then
      begin
        LNextPageLink := LinetoNextPageLink(LLine);
        if not ('htt' = Copy(LNextPageLink, 1, 3)) then
        begin
          LNextPageLink := '';
        end
        else
        begin
          ProgressEdit.Text := '0/' + FloatToStr(FLinksToDownload.Count);
        end;
      end;
    end;
  finally
    LStreamReader.Close;
    LStreamReader.Free;
  end;

  if (Length(LNextPageLink) > 0) then
  begin
    ImagePageDownloader2.Url := LNextPageLink;
    CurrentLinkEdit.Caption := 'Link: ' + LNextPageLink;
    ImagePageDownloader2.Start;
  end
  else
  begin
    ProgressEdit.Text := '0/' + FloatToStr(FLinksToDownload.Count);

    for I := 0 to FLinksToDownload.Count-1 do
    begin
      LURL := FLinksToDownload[i];
      LURL.URL := StringReplace(LURL.URL, 'a.jpg', 'n.jpg', [rfReplaceAll]);
      FLinksToDownload[i] := LURL;
    end;

    if SettingsForm.DownloadVideoBtn.Checked then
    begin
      // search for video links
      StateEdit.Caption := 'State: Extracting video links...';
      FVideoPageIndex := 0;
      CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
      VideoLinkDownloader1.Url := FPageURLs[FVideoPageIndex];
      VideoLinkDownloader1.Start;
    end
    else
    begin
      // start downloading
      if FLinksToDownload.Count > 0 then
      begin
        StateEdit.Caption := 'State: Downloading...';
        FImageIndex := 0;
        ImageDownloader1.Url := FLinksToDownload[0].URL;
        CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[0].URL;
        ImageDownloader1.FileName := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
        ImageDownloader1.Start;
        FFilesToCheck.Add(ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]));
      end
      else
      begin
        Application.MessageBox('No image links were extracted.', 'Error', MB_ICONERROR);
      end;
    end;
  end;

end;

procedure TMainForm.ImagePageDownloader1Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('IPD1: ' + ErrorMsg);
end;

procedure TMainForm.ImagePageDownloader1Progress(Sender: TObject; Position,
  TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  if TotalSize > 0 then
  begin
    CurrentBar.Progress := (100 * Position) div TotalSize;
  end;
end;

procedure TMainForm.ImagePageDownloader2DoneFile(Sender: TObject; FileName: string;
  FileSize: Integer; Url: string);
const
  ImageLink = '.jpg';
  ImageLink2 = '<a href="/p/';
  NextPageLink = 'npk';
  Grid = 'vm=grid&';
  List = 'vm=list&';
  NextText = 'rel="next">';
  SmallerImgStart = 'scontent';
  LargeImg = 'pw:image="';
  VideoLineStartStr = '<div id="jquery_jplayer_1" class="jp-jplayer"';
  PageURLStart = 'pw:url="';
var
  LStreamReader: TStreamReader;
  LLine: string;
  LNextPageLink: string;
  i:integer;
  LURL: TURL;
begin
  // if StreamSize > 0 then
  // begin
  LStreamReader := TStreamReader.Create(FileName, True);
  LNextPageLink := '';
  try
    while not LStreamReader.EndOfStream do
    begin
      LLine := Trim(LStreamReader.ReadLine);
      // image link
      if ContainsText(LLine, LargeImg) then
      begin
        if ('htt' = Copy(LineToImageLink(LLine), 1, 3)) then
        begin
          LURL.URL := LineToImageLink(LLine);
          LURL.URLType := Img;
          FLinksToDownload.Add(LURL);
        end;
      end;
      // page link
      if ContainsText(LLine, PageURLStart) then
      begin
        FPageURLs.Add(LineToPageLink(LLine))
      end;
      // next page
      if ContainsText(LLine, NextPageLink) and ContainsText(LLine, NextText) then
      begin
        LNextPageLink := LinetoNextPageLink(LLine);
        if not ('htt' = Copy(LNextPageLink, 1, 3)) then
        begin
          LNextPageLink := '';
        end
        else
        begin
          ProgressEdit.Text := '0/' + FloatToStr(FLinksToDownload.Count);
        end;
      end;
    end;
  finally
    LStreamReader.Close;
    LStreamReader.Free;
  end;

  if (Length(LNextPageLink) > 0) then
  begin
    ImagePageDownloader1.Url := LNextPageLink;
    CurrentLinkEdit.Caption := 'Link: ' + LNextPageLink;
    ImagePageDownloader1.Start;
  end
  else
  begin
    ProgressEdit.Text := '0/' + FloatToStr(FLinksToDownload.Count);

    for I := 0 to FLinksToDownload.Count-1 do
    begin
      LURL := FLinksToDownload[i];
      LURL.URL := StringReplace(LURL.URL, 'a.jpg', 'n.jpg', [rfReplaceAll]);
      FLinksToDownload[i] := LURL;
    end;

    if SettingsForm.DownloadVideoBtn.Checked then
    begin
      // search for video links
      StateEdit.Caption := 'State: Extracting video links...';
      FVideoPageIndex := 0;
      CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
      VideoLinkDownloader1.Url := FPageURLs[FVideoPageIndex];
      VideoLinkDownloader1.Start;
    end
    else
    begin
      // start downloading
      if FLinksToDownload.Count > 0 then
      begin
        StateEdit.Caption := 'State: Downloading...';
        FImageIndex := 0;
        ImageDownloader1.Url := FLinksToDownload[0].URL;
        CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[0].URL;
        ImageDownloader1.FileName := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
        ImageDownloader1.Start;
        FFilesToCheck.Add(ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]));
      end
      else
      begin
        Application.MessageBox('No image links were extracted.', 'Error', MB_ICONERROR);
      end;
    end;
  end;

end;

procedure TMainForm.ImagePageDownloader2Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('IPD2: ' + ErrorMsg);
end;

procedure TMainForm.ImagePageDownloader2Progress(Sender: TObject; Position,
  TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  if TotalSize > 0 then
  begin
    CurrentBar.Progress := (100 * Position) div TotalSize;
  end;
end;

function TMainForm.IsStringNumeric(Str: string): Boolean;
var
  P: PChar;
begin

  if Length(Str) < 1 then
  begin
    Result := False;
    Exit;
  end;

  P := PChar(Str);
  Result := False;

  while P^ <> #0 do
  begin
    Application.ProcessMessages;

    if (Not CharInSet(P^, ['0' .. '9'])) then
    begin
      Exit;
    end;

    Inc(P);
  end;

  Result := True;
end;

function TMainForm.LineToImageLink(const Line: string): string;
const
  ImgSrc = '<div class="social_buttons pw-widget pw-size-medium pw-counter-show" pw:image="';
  WidthStr = '.jpg';
var
  Pos2: integer;
  LTmpStr: string;
begin
  Result := Line;
  LTmpStr := Line;
  LTmpStr := StringReplace(LTmpStr, ImgSrc, '', [rfReplaceAll, rfIgnoreCase]);
  Pos2 := Pos(WidthStr, LTmpStr);
  if Pos2 > 0 then
  begin
    Result := Copy(LTmpStr, 1, Pos2+3);
  end;
end;

function TMainForm.LinetoNextPageLink(const Line: string): string;
const
  StartStr = '<li><a href="';
  LastStr = '" rel="next">';
  StartStr2 = '<a href="';
  LastStr2 = '" class="';
var
  Pos1: integer;
  Pos2: integer;
  LLink: string;
  LUnderLinePos: Integer;
begin
  Result := Line;

  if StartStr = Copy(Line, 1, Length(StartStr)) then
  begin
    Pos1 :=  Pos(StartStr, Line);
    Pos2 := Pos(LastStr, Line);
    if Pos2 > Pos1 then
    begin
      LLink := Copy(Line, Pos1+Length(StartStr), Pos2-Pos1-Length(LastStr)-1);
    end;
  end
  else
  begin
    Pos1 := Pos(StartStr2, Line);
    Pos2 := Pos(LastStr2, Line);
    if Pos2 > Pos1 then
    begin
      LLink := Copy(Line, Pos1+Length(StartStr2), Pos2-Pos1-Length(LastStr2)-1);
    end;
  end;
  LLink := StringReplace(LLink, 'vm=grid&', '', [rfReplaceAll]);
  LLink := StringReplace(LLink, 'vm=list&', '', [rfReplaceAll]);
  LLink := StringReplace(LLink, 'https', 'http', [rfReplaceAll]);
  LLink := ReverseString(LLink);
  LUnderLinePos := Pos('_', LLink);
  if LUnderLinePos > 0 then
  begin
    LLink := Copy(LLink, LUnderLinePos+1, MaxInt);
  end;
  LLink := ReverseString(LLink);
  if Length(LLink) > 0 then
  begin
    Result := 'http://web.stagram.com' + LLink;
  end;
end;

function TMainForm.LineToPageLink(const Line: string): string;
var
  Pos1, Pos2: integer;
  LTmpStr: string;
begin
  Result := Line;
  LTmpStr := Line;
  Pos1 := PosEx('pw:url="', Line);
  Pos2 := PosEx('" pw:twitter-via="', Line);
  if Pos2 > Pos1 then
  begin
    Result := Copy(Line, Pos1+8, Pos2-Pos1-8);
  end;
end;

function TMainForm.LineToVideoURL(const Line: string): string;
const
  Start = 'data-m4v="';
  EndStr = '"></div>';
var
  Pos1, Pos2: integer;
  LTmpStr: string;
begin
  Result := Line;
  LTmpStr := Line;
  Pos1 := PosEx(Start, LTmpStr);
  Pos2 := PosEx(EndStr, LTmpStr);
  if Pos2 > Pos1 then
  begin
    Result := Copy(LTmpStr, Pos1+Length(Start), Pos2-Pos1-Length(Start));
  end;
end;

procedure TMainForm.LoadSettings;
var
  LSetFile: TIniFile;
begin
  LSetFile := TIniFile.Create(FAppDataFolder + 'settings.ini');
  try
    with LSetFile do
    begin
      if Portable then
      begin
        OutputEdit.Text := ReadString('general', 'output', ExtractFileDir(Application.ExeName));
      end
      else
      begin
        OutputEdit.Text := ReadString('general', 'output', Info.Folders.Personal + '\InstagramSaver');
      end;

      // check update
      if ReadBool('general', 'update', True) then
      begin
        UpdateThread.Execute(nil);
      end;
      // skins
      case ReadInteger('general', 'skin', 0) of
        0:
          sSkinManager1.SkinName := 'DarkMetro (internal)';
        1:
          sSkinManager1.SkinName := 'AlterMetro (internal)';
      end;
    end;
  finally
    LSetFile.Free;
  end;
end;

procedure TMainForm.LogBtnClick(Sender: TObject);
begin
  LogForm.Show;
end;

procedure TMainForm.OpenOutputBtnClick(Sender: TObject);
begin
  if DirectoryExists(OutputEdit.Text) then
  begin
    ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TMainForm.SaveSettings;
var
  LSetFile: TIniFile;
begin
  LSetFile := TIniFile.Create(FAppDataFolder + 'settings.ini');
  try
    with LSetFile do
    begin
      WriteString('general', 'output', OutputEdit.Text);
    end;
  finally
    LSetFile.Free;
  end;
end;

procedure TMainForm.SettingsBtnClick(Sender: TObject);
begin
  Self.Enabled := False;
  SettingsForm.Show;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
begin
  if ID_YES = Application.MessageBox('Stop downloading?', 'Stop', MB_ICONQUESTION or MB_YESNO) then
  begin
    if ImagePageDownloader1.Status <> gsStopped then
    begin
      ImagePageDownloader1.Stop;
    end;
    if ImagePageDownloader2.Status <> gsStopped then
    begin
      ImagePageDownloader2.Stop;
    end;
    if ImageDownloader2.Status <> gsStopped then
    begin
      ImageDownloader2.Stop;
    end;
    if ImageDownloader1.Status <> gsStopped then
    begin
      ImageDownloader1.Stop;
    end;
    if VideoLinkDownloader2.Status <> gsStopped then
    begin
      VideoLinkDownloader2.Stop;
    end;
    if VideoLinkDownloader1.Status <> gsStopped then
    begin
      VideoLinkDownloader1.Stop;
    end;
    EnableUI;
  end;
end;

procedure TMainForm.UpdateDownloaderDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
var
  VersionFile: TStringList;
  LatestVersion: Integer;
begin
  VersionFile := TStringList.Create;
  try
    if StreamSize > 0 then
    begin
      VersionFile.LoadFromStream(Stream);
      if VersionFile.Count = 1 then
      begin
        if IsStringNumeric(VersionFile.Strings[0]) then
        begin
          LatestVersion := StrToInt(VersionFile.Strings[0]);
          if LatestVersion > BuildInt then
          begin
            if ID_YES = Application.MessageBox('There is a new version. Would you like to go homepage and download it?', 'New Version', MB_ICONQUESTION or MB_YESNO) then
            begin
              ShellExecute(Application.Handle, 'open', 'https://sourceforge.net/projects/instagramsaver/', nil, nil, SW_SHOWNORMAL);
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(VersionFile);
  end;
end;

procedure TMainForm.UpdateThreadExecute(Sender: TObject; Params: Pointer);
begin
  UpdateDownloader.Url := 'http://sourceforge.net/projects/instagramsaver/files/version.txt/download';
  UpdateDownloader.Start;

  UpdateThread.CancelExecute;
end;

function TMainForm.URLToFileName(const URL: TURL): string;
var
  LURL: string;
begin
  Result := URL.URL;
  LURL := URL.URL;
  LURL := StringReplace(LURL, '/', '\', [rfReplaceAll]);
  case URL.URLType of
    Img: Result := ChangeFileExt(ExtractFileName(LURL), '.jpg');
    Video: Result := ChangeFileExt(ExtractFileName(LURL), '.mp4');
  end;
end;

procedure TMainForm.UserNameEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    DownloadBtnClick(Self);
  end;
end;

procedure TMainForm.VideoLinkDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
const
  VideoLineStartStr = '<div id="jquery_jplayer_1" class="jp-jplayer"';
var
  LStreamReader: TStreamReader;
  LLine: string;
  LURL: TURL;
begin
  Inc(FVideoPageIndex);
  if FVideoPageIndex < FPageURLs.Count-1 then
  begin
    LStreamReader := TStreamReader.Create(FileName, True);
    try
      while not LStreamReader.EndOfStream do
      begin
        LLine := Trim(LStreamReader.ReadLine);
        if VideoLineStartStr = Copy(LLine, 1, Length(VideoLineStartStr)) then
        begin
          LURL.URL := LineToVideoURL(LLine);
          LURL.URLType := Video;
          FLinksToDownload.Add(LURL);
          ProgressEdit.Text := '0/' + FloatToStr(FLinksToDownload.Count);
          LogForm.LogList.Lines.Add('Video1: ' + LURL.URL);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
    end;

    // run next video page link
    CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
    VideoLinkDownloader2.Url := FPageURLs[FVideoPageIndex];
    LogForm.LogList.Lines.Add('Video1: ' + FPageURLs[FVideoPageIndex]);
    VideoLinkDownloader2.Start;
  end
  else
  begin
    // start downloading
    if FLinksToDownload.Count > 0 then
    begin
      StateEdit.Caption := 'State: Downloading...';
      FImageIndex := 0;
      ImageDownloader1.Url := FLinksToDownload[0].URL;
      CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[0].URL;
      ImageDownloader1.FileName := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
      ImageDownloader1.Start;
      FFilesToCheck.Add(ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]));
    end
    else
    begin
      Application.MessageBox('No image links were extracted.', 'Error', MB_ICONERROR);
    end;
  end;
end;

procedure TMainForm.VideoLinkDownloader1Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('VPD1: ' + ErrorMsg);
end;

procedure TMainForm.VideoLinkDownloader1Progress(Sender: TObject; Position,
  TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  if TotalSize > 0 then
  begin
    CurrentBar.Progress := (100 * Position) div TotalSize;
    TotalBar.Progress := (100 * FVideoPageIndex) div FPageURLs.Count;
  end;
end;

procedure TMainForm.VideoLinkDownloader2DoneFile(Sender: TObject;
  FileName: string; FileSize: Integer; Url: string);
const
  VideoLineStartStr = '<div id="jquery_jplayer_1" class="jp-jplayer"';
var
  LStreamReader: TStreamReader;
  LLine: string;
  LURL: TURL;
begin
  Inc(FVideoPageIndex);
  if FVideoPageIndex < FPageURLs.Count-1 then
  begin
    LStreamReader := TStreamReader.Create(FileName, True);
    try
      while not LStreamReader.EndOfStream do
      begin
        LLine := Trim(LStreamReader.ReadLine);
        if VideoLineStartStr = Copy(LLine, 1, Length(VideoLineStartStr)) then
        begin
          LURL.URL := LineToVideoURL(LLine);
          LURL.URLType := Video;
          FLinksToDownload.Add(LURL);
          ProgressEdit.Text := '0/' + FloatToStr(FLinksToDownload.Count);
          LogForm.LogList.Lines.Add('Video2: ' + LURL.URL);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
    end;

    // run next video page link
    CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
    VideoLinkDownloader1.Url := FPageURLs[FVideoPageIndex];
    LogForm.LogList.Lines.Add('Video2: ' + FPageURLs[FVideoPageIndex]);
    VideoLinkDownloader1.Start;
  end
  else
  begin
    // start downloading
    if FLinksToDownload.Count > 0 then
    begin
      StateEdit.Caption := 'State: Downloading...';
      FImageIndex := 0;
      ImageDownloader1.Url := FLinksToDownload[0].URL;
      CurrentLinkEdit.Caption := 'Link: ' + FLinksToDownload[0].URL;
      ImageDownloader1.FileName := ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]);
      ImageDownloader1.Start;
      FFilesToCheck.Add(ExcludeTrailingPathDelimiter(OutputEdit.Text) + '\' + UserNameEdit.Text + '\' + URLToFileName(FLinksToDownload[FImageIndex]));
    end
    else
    begin
      Application.MessageBox('No image links were extracted.', 'Error', MB_ICONERROR);
    end;
  end;
end;

procedure TMainForm.VideoLinkDownloader2Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('VPD2: ' + ErrorMsg);
end;

procedure TMainForm.VideoLinkDownloader2Progress(Sender: TObject; Position,
  TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  if TotalSize > 0 then
  begin
    CurrentBar.Progress := (100 * Position) div TotalSize;
    TotalBar.Progress := (100 * FVideoPageIndex) div FPageURLs.Count;
  end;
end;

end.
