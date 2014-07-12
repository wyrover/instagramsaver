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

unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, JvComponentBase, JvUrlListGrabber, JvUrlGrabbers, StrUtils,
  Vcl.Mask, sSkinProvider, sSkinManager, sMaskEdit,
  sCustomComboEdit, sToolEdit, Vcl.Buttons, sBitBtn, sEdit, Vcl.ComCtrls,
  sStatusBar, sGauge, sBevel, sPanel, JvComputerInfoEx, IniFiles, sLabel, ShellAPI, windows7taskbar,
  Generics.Collections, JvThread, Vcl.Menus, UnitPhotoDownloaderThread, System.Types,
  JvTrayIcon, MediaInfoDll, acProgressBar, UnitFileChecker;

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
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sPanel1: TsPanel;
    DownloadBtn: TsBitBtn;
    StopBtn: TsBitBtn;
    AboutBtn: TsBitBtn;
    SettingsBtn: TsBitBtn;
    sPanel2: TsPanel;
    UserNameEdit: TsEdit;
    Info: TJvComputerInfoEx;
    DonateBtn: TsBitBtn;
    LogBtn: TsBitBtn;
    VideoLinkDownloader2: TJvHttpUrlGrabber;
    VideoLinkDownloader1: TJvHttpUrlGrabber;
    UpdateThread: TJvThread;
    UpdateDownloader: TJvHttpUrlGrabber;
    AboutMenu: TPopupMenu;
    A1: TMenuItem;
    c1: TMenuItem;
    H1: TMenuItem;
    PosTimer: TTimer;
    TimeTimer: TTimer;
    R1: TMenuItem;
    S1: TMenuItem;
    TrayIcon: TJvTrayIcon;
    sPanel3: TsPanel;
    GroupBox1: TGroupBox;
    TotalBar: TsProgressBar;
    CurrentLinkEdit: TsLabel;
    StateEdit: TsLabel;
    OpenOutputBtn: TsBitBtn;
    OutputEdit: TsDirectoryEdit;
    FavBtn: TsBitBtn;
    FavMenu: TPopupMenu;
    D1: TMenuItem;
    E1: TMenuItem;
    D2: TMenuItem;
    ProgressEdit: TsLabel;
    TimeLabel: TsLabel;
    NormalPanel: TsPanel;
    FileCheckPanel: TsPanel;
    FileCheckProgressBar: TsProgressBar;
    StopFileCheckBtn: TsBitBtn;
    sLabel1: TsLabel;
    CurrFileLabel: TsLabel;
    FileCheckProgressLabel: TsLabel;
    procedure DownloadBtnClick(Sender: TObject);
    procedure ImagePageDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure ImagePageDownloader2DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
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
    procedure LogBtnClick(Sender: TObject);
    procedure VideoLinkDownloader1DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure VideoLinkDownloader2DoneFile(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure VideoLinkDownloader1Error(Sender: TObject; ErrorMsg: string);
    procedure VideoLinkDownloader2Error(Sender: TObject; ErrorMsg: string);
    procedure VideoLinkDownloader1Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure VideoLinkDownloader2Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
    procedure UpdateThreadExecute(Sender: TObject; Params: Pointer);
    procedure UpdateDownloaderDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
    procedure A1Click(Sender: TObject);
    procedure c1Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure PosTimerTimer(Sender: TObject);
    procedure TimeTimerTimer(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure TrayIconBalloonClick(Sender: TObject);
    procedure TrayIconBalloonHide(Sender: TObject);
    procedure sSkinManager1Activate(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure FavBtnClick(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure StopFileCheckBtnClick(Sender: TObject);
  private
    { Private declarations }
    FImageIndex: integer;
    FVideoPageIndex: Integer;
    FTime: Integer;

    FLinksToDownload: TList<TURL>;
    FPageURLs: TStringList;
    FFilesToCheck: TStringList;
    FFileChecker: TFileCheckerThread;
    FFavLinks: TList<TURL>;
    FFavs: TStringList;
    FFavIndex: Integer;
    FDownloadingFavs: Boolean;
    FIgnoredImgCount: Cardinal;
    FDownloadedImgCount: Cardinal;
    FStopFileCheck: Boolean;

    FDownloadThreads: array[0..15] of TPhotoDownloadThread;
    FURLs: array[0..15] of  TStringList;
    FOutputFiles: array[0..15] of TStringList;
    FThreadCount: Integer;

    function LineToImageLink(const Line: string):string;
    function LinetoNextPageLink(const Line: string):string;
    function LineToPageLink(const Line: string): string;
    function LineToVideoURL(const Line: string): string;

    procedure LoadSettings;
    procedure SaveSettings;

    procedure DisableUI;
    procedure EnableUI;

    // converts url to file name
    function URLToFileName(const URL: TURL): string;

    // returns true when no problem occurs
    function CheckFiles: Boolean;

    // generates guid
    function GenerateGUID: string;

    // checks if string is numeric
    function IsStringNumeric(Str: string): Boolean;

    // starts image/video downloader threads
    procedure LaunchDownloadThreads(const ThreadCount: Integer);

    // clears temp folder
    procedure ClearTempFolder;

    // adds msg to log
    // todo: save logs to text file
    procedure AddToProgramLog(const Line: string);

    // int to hh:mm:ss
    function IntegerToTime(const Time: Integer): string;

    function ShorthenURL(const URL: string):string;
  public
    { Public declarations }
    FAppDataFolder: string;
    FTempFolder: string;
    FFavFilePath: string;
  end;

var
  MainForm: TMainForm;

const
  BuildInt = 447;
  Portable = False;

implementation

{$R *.dfm}

uses UnitSettings, UnitAbout, UnitLog, UnitFavs;

procedure TMainForm.A1Click(Sender: TObject);
begin
  Self.Enabled := False;
  AboutForm.Show;
end;

procedure TMainForm.AboutBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := AboutBtn.ClientToScreen(Point(0, 0));

  AboutMenu.Popup(P.X, P.Y + AboutBtn.Height)
end;

procedure TMainForm.AddToProgramLog(const Line: string);
begin
  // dont add date if msg is empty
  if Length(Line) > 0 then
  begin
    LogForm.LogList.Lines.Add('[' + DateTimeToStr(Now) + '] ' + Line)
  end
  else
  begin
    LogForm.LogList.Lines.Add('');
  end;
end;

procedure TMainForm.c1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', pwidechar(ExtractFileDir(Application.ExeName) + '\changelog.txt'), nil, nil, SW_SHOWNORMAL);
end;

function TMainForm.CheckFiles: Boolean;
var
  i: integer;
begin
  // checks if downloaded files are valid
  Self.Caption := 'InstagramSaver';
  StateEdit.Caption := 'State:';
  CurrFileLabel.Caption := 'Current file:';
  FileCheckProgressBar.Position := 0;
  FileCheckProgressLabel.Caption := 'Progress: 0/0';
  FileCheckPanel.Visible := True;
  FileCheckPanel.BringToFront;
  Self.Enabled := False;
  Result := False;
  FStopFileCheck := false;
  try
    if FFilesToCheck.Count > 0 then
    begin
      // check file
      FFileChecker := TFileCheckerThread.Create(FFilesToCheck);
      try
        // empty extension means something went wrong
        while not FFileChecker.Done do
        begin
          Application.ProcessMessages;
          if FStopFileCheck then
          begin
            Break;
          end;
          sleep(20);
        end;
        if not FStopFileCheck then
        begin
          if FFileChecker.Results.Count > 0 then
          begin
            for I := 0 to FFileChecker.Results.Count-1 do
            begin
              AddToProgramLog(FFileChecker.Results[i]);
            end;
          end;
          Result := FFileChecker.Result;
        end;
      finally
        FFileChecker.Free;
      end;
    end;
  finally
    StateEdit.Caption := 'State:';
    ProgressEdit.Caption := 'Progress: 0/0';
    TotalBar.Position := 0;
    Self.Caption := 'InstagramSaver';
    Self.Enabled := True;
    FileCheckPanel.Visible := False;
  end;
end;

procedure TMainForm.ClearTempFolder;
var
  Search: TSearchRec;
begin
  // search and delete all the files in the temp folder
  if DirectoryExists(FTempFolder) then
  begin
    if (FindFirst(FTempFolder + '\*.*', faAnyFile, Search) = 0) then
    Begin
      repeat
        Application.ProcessMessages;
        if (Search.Name = '.') or (Search.Name = '..') then
          Continue;
        if FileExists(FTempFolder + '\' + Search.Name) then
        begin
          DeleteFile(FTempFolder + '\' + Search.Name)
        end;
      until (FindNext(Search) <> 0);
      FindClose(Search);
    end;
  end;
end;

procedure TMainForm.D1Click(Sender: TObject);
var
  LFavFile: TStringList;
  LFavCount: Integer;
  LSplit: TStringList;
  I: Integer;
begin
  // download favs
  LFavCount := 0;
  if FileExists(FFavFilePath) then
  begin
    // read fav file
    // stateint=0/1|accountname
    LFavFile := TStringList.Create;
    LSplit := TStringList.Create;
    FFavLinks.Clear;
    FFavs.Clear;
    FFavIndex := 0;
    try
      LFavFile.LoadFromFile(FFavFilePath);
      LFavCount := LFavFile.Count;

      if LFavCount > 0 then
      begin
        // add selected favs to download list
        LSplit.StrictDelimiter := True;
        LSplit.Delimiter := '|';
        for I := 0 to LFavFile.Count-1 do
        begin
          LSplit.Clear;
          LSplit.DelimitedText := LFavFile[i];
          // check if fav is checked to be downloaded
          if LSplit.Count = 2 then
          begin
            if LSplit[1] = '1' then
            begin
              FFavs.Add(LSplit[0]);
            end;
          end;
        end;
        // dont download if no favs are selected
        if FFavs.Count < 1 then
        begin
          Application.MessageBox('Please select one or more favourites.', 'Error', MB_ICONERROR);
          Exit;
        end;
        // flag to show that we are downloading favs
        FDownloadingFavs := True;
        // create directory for favs
        for I := 0 to FFavs.Count-1 do
        begin
          ForceDirectories(OutputEdit.Text + '\' + FFavs[i])
        end;

        // reset lists
        FLinksToDownload.Clear;
        FFilesToCheck.Clear;
        FPageURLs.Clear;
        FTime := 0;
        FDownloadedImgCount := 0;
        FIgnoredImgCount := 0;
        TotalBar.Position := 0;

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

        StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
        ProgressEdit.Caption := 'Progress: 0/0';
        Self.Caption := '0% [InstagramSaver]';
        DisableUI;
        CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
        SetProgressState(Handle, tbpsNormal);

        if LogForm.LogList.Lines.Count > 0 then
        begin
          AddToProgramLog('');
        end;
        AddToProgramLog('Starting to download favourites.');
        AddToProgramLog('Settings:');
        AddToProgramLog('Don''t download already downloaded files: ' + BoolToStr(SettingsForm.DontDoubleDownloadBtn.Checked, True));
        AddToProgramLog('Download videos: ' + BoolToStr(SettingsForm.DownloadVideoBtn.Checked, True));
        AddToProgramLog('Check downloaded files: ' + BoolToStr(not SettingsForm.DontCheckBtn.Checked, True));
        AddToProgramLog('');
        AddToProgramLog('Starting to download user: ' + FFavs[FFavIndex]);
        AddToProgramLog('Extracting image links...');
        UserNameEdit.Text := FFavs[FFavIndex];
        ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
        ImagePageDownloader1.Start;
        TimeTimer.Enabled := True;
      end
      else
      begin
        Application.MessageBox('You don''t have any favourites.', 'Error', MB_ICONERROR);
      end;
    finally
      LFavFile.Free;
      LSplit.Free;
    end;
  end
  else
  begin
    Application.MessageBox('You don''t have any favourites.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.D2Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6MSWEDR4AGBQG', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DisableUI;
begin
  UserNameEdit.Enabled := False;
  DownloadBtn.Enabled := False;
  StopBtn.Enabled := True;
  SettingsBtn.Enabled := False;
  AboutBtn.Enabled := False;
  OutputEdit.Enabled := False;
  FavBtn.Enabled := False;
end;

procedure TMainForm.DonateBtnClick(Sender: TObject);
begin
  // open google play link
  ShellExecute(0, 'open', 'https://play.google.com/store/apps/details?id=com.mopa.instasaver', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DownloadBtnClick(Sender: TObject);
begin
  if Length(UserNameEdit.Text) > 0 then
  begin
    // only lowercase
    UserNameEdit.Text := LowerCase(UserNameEdit.Text);

    if not ForceDirectories(OutputEdit.Text + '\' + UserNameEdit.Text) then
    begin
      Application.MessageBox('Cannot create output folder. Please enter a valid one.', 'Error', MB_ICONERROR);
      Exit;
    end;
    // reset
    FLinksToDownload.Clear;
    FFilesToCheck.Clear;
    FPageURLs.Clear;
    FTime := 0;
    TotalBar.Position := 0;
    FDownloadedImgCount := 0;
    FIgnoredImgCount := 0;

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

    StateEdit.Caption := 'State: Extracting image links...';
    ProgressEdit.Caption := 'Progress: 0/0';
    Self.Caption := '0% [InstagramSaver]';
    DisableUI;
    CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + UserNameEdit.Text + '/?vm=list';
    SetProgressState(Handle, tbpsNormal);
    FDownloadingFavs := False;
    if LogForm.LogList.Lines.Count > 0 then
    begin
      AddToProgramLog('');
    end;
    AddToProgramLog('Settings:');
    AddToProgramLog('Don''t download already downloaded files: ' + BoolToStr(SettingsForm.DontDoubleDownloadBtn.Checked, True));
    AddToProgramLog('Download videos: ' + BoolToStr(SettingsForm.DownloadVideoBtn.Checked, True));
    AddToProgramLog('Check downloaded files: ' + BoolToStr(not SettingsForm.DontCheckBtn.Checked, True));
    AddToProgramLog('');
    AddToProgramLog('Starting to download user: ' + UserNameEdit.Text);
    AddToProgramLog('Extracting image links...');
    ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + UserNameEdit.Text + '/?vm=list';
    ImagePageDownloader1.Start;
    TimeTimer.Enabled := True;
  end
  else
  begin
    Application.MessageBox('Please enter a user name first.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.E1Click(Sender: TObject);
begin
  Self.Enabled := False;
  FavForm.Show;
end;

procedure TMainForm.EnableUI;
begin
  TimeTimer.Enabled := False;
  UserNameEdit.Enabled := True;
  DownloadBtn.Enabled := True;
  StopBtn.Enabled := False;
  SettingsBtn.Enabled := True;
  AboutBtn.Enabled := True;
  OutputEdit.Enabled := True;
  FavBtn.Enabled := True;
  TotalBar.Position := 0;
  CurrentLinkEdit.Caption := 'Link: ';
  StateEdit.Caption := 'State: ';
  Self.Caption := 'InstagramSaver';
  SetProgressValue(Handle, 0, MaxInt);
  SetProgressState(Handle, tbpsNone);
  TimeLabel.Caption := 'Time: 00:00:00';
  if FDownloadingFavs then
  begin
    UserNameEdit.Text := '';
  end;
end;

procedure TMainForm.FavBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := FavBtn.ClientToScreen(Point(0, 0));

  FavMenu.Popup(P.X, P.Y + FavBtn.Height)
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
  ClearTempFolder;
  // delete temp folder with portable version
  if Portable then
  begin
    if DirectoryExists(FTempFolder) then
    begin
      RemoveDir(FTempFolder);
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FLinksToDownload := TList<TURL>.Create;
  FFavLinks := TList<TURL>.Create;
  FPageURLs := TStringList.Create;
  FFilesToCheck := TStringList.Create;
  FFavs := TStringList.Create;
  for I := Low(FURLs) to High(FURLs) do
  begin
    FURLs[i] := TStringList.Create;
    FOutputFiles[i] := TStringList.Create;
  end;
  // different path for portable
  if Portable then
  begin
    FAppDataFolder := ExtractFileDir(Application.ExeName) + '\'
  end
  else
  begin
    FAppDataFolder := Info.Folders.AppData + '\InstagramSaver\';
  end;
  FTempFolder := Info.Folders.Temp + '\InstagramSaver\';
  FFavFilePath := FAppDataFolder + '\favs.dat';
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
  // init mediainfo
  if not MediaInfoDLL_Load(ExtractFileDir(Application.ExeName) + '\MediaInfo.dll') then
  begin
    Application.MessageBox('Unable to init mediainfo.', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  // windows 7 taskbar
  if CheckWin32Version(6, 1) then
  begin
    if not InitializeTaskbarAPI then
    begin
      Application.MessageBox('You seem to have Windows 7 but program can''t start taskbar progressbar!', 'Error', MB_ICONERROR);
    end;
  end;
  // in any case
  ClearTempFolder;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FLinksToDownload.Free;
  FPageURLs.Free;
  FFilesToCheck.Free;
  FFavLinks.Free;
  FFavs.Free;
  for I := Low(FURLs) to High(FURLs) do
  begin
    FURLs[i].Free;
    FOutputFiles[i].Free;
  end;
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

procedure TMainForm.H1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://sourceforge.net/projects/instagramsaver/', nil, nil, SW_SHOWNORMAL);
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
          ProgressEdit.Caption := 'Progress: 0/' + FloatToStr(FLinksToDownload.Count);
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
    ProgressEdit.Caption := 'Progress: 0/' + FloatToStr(FLinksToDownload.Count);

    for I := 0 to FLinksToDownload.Count-1 do
    begin
      LURL := FLinksToDownload[i];
      LURL.URL := StringReplace(LURL.URL, 'a.jpg', 'n.jpg', [rfReplaceAll]);
      FLinksToDownload[i] := LURL;
    end;

    if SettingsForm.DownloadVideoBtn.Checked then
    begin
      if FPageURLs.Count > 0 then
      begin
        // search for video links
        if not FDownloadingFavs then
        begin
          StateEdit.Caption := 'State: Extracting video links...';
        end
        else
        begin
          StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting video links...';
        end;
        FVideoPageIndex := 0;
        AddToProgramLog('Searching for video links...');
        CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
        VideoLinkDownloader1.Url := FPageURLs[FVideoPageIndex];
        VideoLinkDownloader1.Start;
      end
      else
      begin
        if not FDownloadingFavs then
        begin
          Application.MessageBox('No links were extracted.', 'Error', MB_ICONERROR);
        end;
        AddToProgramLog('Failed to extract links for ' + UserNameEdit.Text + '.');
        if FDownloadingFavs then
          begin
          PosTimer.Enabled := False;
          // downloading favourites
          Inc(FFavIndex);
          if FFavIndex < FFavs.Count then
          begin
            // start downloading next fav
            // reset lists
            FLinksToDownload.Clear;
            FPageURLs.Clear;
            TotalBar.Position := 0;
            SetProgressValue(Handle, 0, MaxInt);

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

            StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
            ProgressEdit.Caption := 'Progress: 0/0';
            Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
            DisableUI;
            CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            SetProgressState(Handle, tbpsNormal);
            if ImagePageDownloader1.Status <> gsStopped then
            begin
              ImagePageDownloader1.Stop;
            end;
            if ImagePageDownloader2.Status <> gsStopped then
            begin
              ImagePageDownloader2.Stop;
            end;
            UserNameEdit.Text := FFavs[FFavIndex];
            ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            ImagePageDownloader1.Start;
            PosTimer.Enabled := True;
          end
          else
          begin
            // done
            EnableUI;
          end;
        end
        else
        begin
          // normal account download
          EnableUI;
        end;
      end;
    end
    else
    begin
      // start downloading
      if FLinksToDownload.Count > 0 then
      begin
        if not FDownloadingFavs then
        begin
          StateEdit.Caption := 'State: Downloading...';
        end
        else
        begin
          StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Downloading...';
        end;
        FImageIndex := 0;
        // parallel download count
        FThreadCount := SettingsForm.ThreadList.ItemIndex+1;
        if FThreadCount > FLinksToDownload.Count then
        begin
          FThreadCount := FLinksToDownload.Count;
        end;
        LaunchDownloadThreads(FThreadCount);
      end
      else
      begin
        if not FDownloadingFavs then
        begin
          Application.MessageBox('No links were extracted.', 'Error', MB_ICONERROR);
        end;
        AddToProgramLog('Failed to extract links for ' + UserNameEdit.Text + '.');
        if FDownloadingFavs then
          begin
          PosTimer.Enabled := False;
          // downloading favourites
          Inc(FFavIndex);
          if FFavIndex < FFavs.Count then
          begin
            // start downloading next fav
            // reset lists
            FLinksToDownload.Clear;
            FPageURLs.Clear;
            TotalBar.Position := 0;
            SetProgressValue(Handle, 0, MaxInt);

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

            StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
            ProgressEdit.Caption := 'Progress: 0/0';
            Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
            DisableUI;
            CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            SetProgressState(Handle, tbpsNormal);
            if ImagePageDownloader1.Status <> gsStopped then
            begin
              ImagePageDownloader1.Stop;
            end;
            if ImagePageDownloader2.Status <> gsStopped then
            begin
              ImagePageDownloader2.Stop;
            end;
            UserNameEdit.Text := FFavs[FFavIndex];
            ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            ImagePageDownloader1.Start;
            PosTimer.Enabled := True;
          end
          else
          begin
            // done
            EnableUI;
          end;
        end
        else
        begin
          // normal account download
          EnableUI;
        end;
      end;
    end;
  end;

end;

procedure TMainForm.ImagePageDownloader1Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('IPD1: ' + ErrorMsg);
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
          ProgressEdit.Caption := 'Progress: 0/' + FloatToStr(FLinksToDownload.Count);
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
    ProgressEdit.Caption := 'Progress: 0/' + FloatToStr(FLinksToDownload.Count);

    for I := 0 to FLinksToDownload.Count-1 do
    begin
      LURL := FLinksToDownload[i];
      LURL.URL := StringReplace(LURL.URL, 'a.jpg', 'n.jpg', [rfReplaceAll]);
      FLinksToDownload[i] := LURL;
    end;

    if SettingsForm.DownloadVideoBtn.Checked then
    begin
      if FPageURLs.Count > 0 then
      begin
        // search for video links
        if not FDownloadingFavs then
        begin
          StateEdit.Caption := 'State: Extracting video links...';
        end
        else
        begin
          StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting video links...';
        end;
        FVideoPageIndex := 0;
        AddToProgramLog('Searching for video links...');
        CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
        VideoLinkDownloader1.Url := FPageURLs[FVideoPageIndex];
        VideoLinkDownloader1.Start;
      end
      else
      begin
        if not FDownloadingFavs then
        begin
          Application.MessageBox('No links were extracted.', 'Error', MB_ICONERROR);
        end;
        AddToProgramLog('Failed to extract links for ' + UserNameEdit.Text + '.');
        if FDownloadingFavs then
          begin
          PosTimer.Enabled := False;
          // downloading favourites
          Inc(FFavIndex);
          if FFavIndex < FFavs.Count then
          begin
            // start downloading next fav
            // reset lists
            FLinksToDownload.Clear;
            FPageURLs.Clear;
            TotalBar.Position := 0;
            SetProgressValue(Handle, 0, MaxInt);

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

            StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
            ProgressEdit.Caption := 'Progress: 0/0';
            Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
            DisableUI;
            CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            SetProgressState(Handle, tbpsNormal);
            if ImagePageDownloader1.Status <> gsStopped then
            begin
              ImagePageDownloader1.Stop;
            end;
            if ImagePageDownloader2.Status <> gsStopped then
            begin
              ImagePageDownloader2.Stop;
            end;
            UserNameEdit.Text := FFavs[FFavIndex];
            ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            ImagePageDownloader1.Start;
            PosTimer.Enabled := True;
          end
          else
          begin
            // done
            EnableUI;
          end;
        end
        else
        begin
          // normal account download
          EnableUI;
        end;
      end;
    end
    else
    begin
      // start downloading
      if FLinksToDownload.Count > 0 then
      begin
        if not FDownloadingFavs then
        begin
          StateEdit.Caption := 'State: Downloading...';
        end
        else
        begin
          StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Downloading...';
        end;
        FImageIndex := 0;
        // parallel download count
        FThreadCount := SettingsForm.ThreadList.ItemIndex+1;
        if FThreadCount > FLinksToDownload.Count then
        begin
          FThreadCount := FLinksToDownload.Count;
        end;
        LaunchDownloadThreads(FThreadCount);
      end
      else
      begin
        if not FDownloadingFavs then
        begin
          Application.MessageBox('No links were extracted.', 'Error', MB_ICONERROR);
        end;
        AddToProgramLog('Failed to extract links for ' + UserNameEdit.Text + '.');
        if FDownloadingFavs then
          begin
          PosTimer.Enabled := False;
          // downloading favourites
          Inc(FFavIndex);
          if FFavIndex < FFavs.Count then
          begin
            // start downloading next fav
            // reset lists
            FLinksToDownload.Clear;
            FPageURLs.Clear;
            TotalBar.Position := 0;
            SetProgressValue(Handle, 0, MaxInt);

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

            StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
            ProgressEdit.Caption := 'Progress: 0/0';
            Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
            DisableUI;
            CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            SetProgressState(Handle, tbpsNormal);
            if ImagePageDownloader1.Status <> gsStopped then
            begin
              ImagePageDownloader1.Stop;
            end;
            if ImagePageDownloader2.Status <> gsStopped then
            begin
              ImagePageDownloader2.Stop;
            end;
            UserNameEdit.Text := FFavs[FFavIndex];
            ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
            ImagePageDownloader1.Start;
            PosTimer.Enabled := True;
          end
          else
          begin
            // done
            EnableUI;
          end;
        end
        else
        begin
          // normal account download
          EnableUI;
        end;
      end;
    end;
  end;

end;

procedure TMainForm.ImagePageDownloader2Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('IPD2: ' + ErrorMsg);
end;

function TMainForm.IntegerToTime(const Time: Integer): string;
var
  LHourStr, LMinStr, LSecStr: string;
  LHour, LMin, LSec: Integer;
begin
  Result := '00:00:00';
  if Time > 0 then
  begin
    LHour := Time div 3600;
    LMin := (Time div 60) - (LHour * 60);
    LSec := (Time mod 60);
    if LSec < 10 then
    begin
      LSecStr := '0' + FloatToStr(LSec)
    end
    else
    begin
      LSecStr := FloatToStr(LSec)
    end;
    if LMin < 10 then
    begin
      LMinStr := '0' + FloatToStr(LMin)
    end
    else
    begin
      LMinStr := FloatToStr(LMin)
    end;
    if LHour < 10 then
    begin
      LHourStr := '0' + FloatToStr(LHour)
    end
    else
    begin
      LHourStr := FloatToStr(LHour)
    end;
    Result := LHourStr + ':' + LMinStr + ':' + LSecStr;
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

procedure TMainForm.LaunchDownloadThreads(const ThreadCount: Integer);
var
  I: Integer;
begin
  if FDownloadingFavs then
  begin
    AddToProgramLog('Starting to download ' + FFavs[FFavIndex] + '.');
  end
  else
  begin
    AddToProgramLog('Starting to download.');
  end;
  AddToProgramLog(Format('Using %d threads.', [ThreadCount]));
  AddToProgramLog(Format('Found %d links.', [FLinksToDownload.Count]));

  // clear lists
  for I := Low(FURLs) to High(FURLs) do
  begin
    FURLs[i].Clear;
    FOutputFiles[i].Clear;
  end;
  // add links and files to lists
  for I := 0 to FLinksToDownload.Count-1 do
  begin
    FURLs[i mod ThreadCount].Add(FLinksToDownload[i].URL);
    FOutputFiles[i mod ThreadCount].Add(ExcludeTrailingPathDelimiter(OutputEdit.Text) + URLToFileName(FLinksToDownload[i]));
    FFilesToCheck.Add(ExcludeTrailingPathDelimiter(OutputEdit.Text) + URLToFileName(FLinksToDownload[i]));
  end;
  // create threads
  for I := 0 to ThreadCount-1 do
  begin
    FDownloadThreads[i] := TPhotoDownloadThread.Create(FURLs[i], FOutputFiles[i]);
    FDownloadThreads[i].ID := i;
    FDownloadThreads[i].DontDoubleDownload := SettingsForm.DontDoubleDownloadBtn.Checked;
  end;

  PosTimer.Enabled := True;
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
        begin
          MainForm.sSkinManager1.Active := True;
          MainForm.sSkinManager1.SkinName := 'DarkMetro (internal)';
        end;
      1:
        begin
          MainForm.sSkinManager1.Active := True;
          MainForm.sSkinManager1.SkinName := 'AlterMetro (internal)';
        end;
      2:
        begin
          MainForm.sSkinManager1.Active := False;
        end;
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

procedure TMainForm.PosTimerTimer(Sender: TObject);
var
  LStillRunning: Boolean;
  I: Integer;
  LTotalProgress: Integer;
  LCurURL: string;
  LDone: Boolean;
  LDownloadedImgCount: Cardinal;
  LIgnoredImgCount: Cardinal;
begin
  LStillRunning := False;
  LTotalProgress := 0;
  LDownloadedImgCount := 0;
  LIgnoredImgCount := 0;
  // progress
  // gather info from all active threads
  for I := Low(FDownloadThreads) to High(FDownloadThreads) do
  begin
    if Assigned(FDownloadThreads[i]) then
    begin
      LStillRunning := LStillRunning or (FDownloadThreads[i].Status = downloading);
      Inc(LTotalProgress, FDownloadThreads[i].Progress);
      Inc(LDownloadedImgCount, FDownloadThreads[i].DownloadedImgCount);
      Inc(LIgnoredImgCount, FDownloadThreads[i].IgnoredImgCount);
    end;
  end;

  if LStillRunning then
  begin
    // continue
    TotalBar.Position := (100 * LTotalProgress) div FLinksToDownload.Count;
    ProgressEdit.Caption := 'Progress: ' + FloatToStr(LTotalProgress) + '/' + FloatToStr(FLinksToDownload.Count);
    if not FDownloadingFavs then
    begin
      Self.Caption := FloatToStr(TotalBar.Position) + '% [InstagramSaver]';
    end
    else
    begin
      Self.Caption := FloatToStr(TotalBar.Position) + '% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
    end;
    SetProgressValue(Handle, LTotalProgress, FLinksToDownload.Count);
    // show random link
    Randomize;
    LCurURL := FDownloadThreads[Random(FThreadCount)].CurrentURL;
    if Length(LCurURL) > 0 then
    begin
      if CurrentLinkEdit.Caption <> ('Link: ' + LCurURL) then
      begin
        CurrentLinkEdit.Caption := 'Link: ' + LCurURL;
      end;
    end;
  end
  else
  begin
    if FDownloadingFavs then
    begin
      PosTimer.Enabled := False;
      // downloading favourites
      Inc(FFavIndex);
      if FFavIndex < FFavs.Count then
      begin
        // start downloading next fav
        LDone := False;

        // reset lists
        FLinksToDownload.Clear;
        FPageURLs.Clear;
        TotalBar.Position := 0;
        SetProgressValue(Handle, 0, MaxInt);

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
        // update download/ignore values
        FDownloadedImgCount := 0;
        FIgnoredImgCount := 0;
        Inc(FDownloadedImgCount, LDownloadedImgCount);
        Inc(FIgnoredImgCount, LIgnoredImgCount);
        AddToProgramLog(Format('Downloaded file count: %d', [FDownloadedImgCount]));
        AddToProgramLog(Format('Skipped file count: %d', [FIgnoredImgCount]));
        AddToProgramLog('');
        AddToProgramLog('Starting to download user: ' + FFavs[FFavIndex]);
        AddToProgramLog('Extracting image links...');
        StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
        ProgressEdit.Caption := 'Progress: 0/0';
        Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
        DisableUI;
        CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
        SetProgressState(Handle, tbpsNormal);
        if ImagePageDownloader1.Status <> gsStopped then
        begin
          ImagePageDownloader1.Stop;
        end;
        if ImagePageDownloader2.Status <> gsStopped then
        begin
          ImagePageDownloader2.Stop;
        end;
        UserNameEdit.Text := FFavs[FFavIndex];
        ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
        ImagePageDownloader1.Start;
      end
      else
      begin
        // done
        LDone := True;
      end;
    end
    else
    begin
      // normal account download
      LDone := True;
    end;
    if LDone then
    begin
      // done
      PosTimer.Enabled := False;
      // update download/ignore values
      FDownloadedImgCount := 0;
      FIgnoredImgCount := 0;
      Inc(FDownloadedImgCount, LDownloadedImgCount);
      Inc(FIgnoredImgCount, LIgnoredImgCount);
      AddToProgramLog(Format('Finished downloading in %s.', [IntegerToTime(FTime)]));
      AddToProgramLog(Format('Downloaded file count: %d', [FDownloadedImgCount]));
      AddToProgramLog(Format('Skipped file count: %d', [FIgnoredImgCount]));
      AddToProgramLog('');
      EnableUI;
      Self.BringToFront;
      if SettingsForm.OpenOutBtn.Checked then
      begin
        if FDownloadingFavs then
        begin
          ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text), nil, nil, SW_SHOWNORMAL);
        end
        else
        begin
          ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text + '\' + UserNameEdit.Text), nil, nil, SW_SHOWNORMAL);
        end;
      end;

      Sleep(100);
      TotalBar.Position := 0;
      ProgressEdit.Caption := 'Progress: ' + FloatToStr(FLinksToDownload.Count) + '/' + FloatToStr(FLinksToDownload.Count);
      if not SettingsForm.DontCheckBtn.Checked then
      begin
        if CheckFiles then
        begin
          LogForm.Show;
          TrayIcon.Active := True;
          TrayIcon.BalloonHint('InstagramSaver', 'InstagramSaver finished downloading. Some problems occured. Please see logs.', btError, 5000, True);
        end
        else
        begin
          AddToProgramLog('File check did not report any problematic files.');
          TrayIcon.Active := True;
          TrayIcon.BalloonHint('InstagramSaver', 'InstagramSaver finished downloading succesfully.', btInfo, 5000, True);
        end;
        end
      else
      begin
        AddToProgramLog('File check is disabled.');
        TrayIcon.Active := True;
        TrayIcon.BalloonHint('InstagramSaver', 'InstagramSaver finished downloading.', btInfo, 5000, True);
      end;
    end;

  end;
end;

procedure TMainForm.R1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://sourceforge.net/p/instagramsaver/tickets/', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.S1Click(Sender: TObject);
const
  NewLine = '%0D%0A';
var
  mail: PChar;
  mailbody: string;
begin
  mailbody := AboutForm.sLabel1.Caption;
  if Portable then
  begin
    mailbody := mailbody + NewLine + 'Portable version';
  end
  else
  begin
    mailbody := mailbody + NewLine + 'Installed version';
  end;
  mailbody := mailbody + NewLine + 'Bugs: ' + NewLine + NewLine + NewLine + 'Suggestions: ' + NewLine + NewLine + NewLine;
  mail := PwideChar('mailto:ozok26@gmail.com?subject=InstagramSaver&body=' + mailbody);

  ShellExecute(0, 'open', mail, nil, nil, SW_SHOWNORMAL);
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

function TMainForm.ShorthenURL(const URL: string): string;
var
  LLabelWidth: integer;
begin
  Result := URL;
  LLabelWidth := Self.Canvas.TextWidth(URL);
  if True then

end;

procedure TMainForm.sSkinManager1Activate(Sender: TObject);
begin
  MainForm.Repaint;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
var
  I: Integer;
begin
  if ID_YES = Application.MessageBox('Stop downloading?', 'Stop', MB_ICONQUESTION or MB_YESNO) then
  begin
    PosTimer.Enabled := False;

    if ImagePageDownloader1.Status <> gsStopped then
    begin
      ImagePageDownloader1.Stop;
    end;
    if ImagePageDownloader2.Status <> gsStopped then
    begin
      ImagePageDownloader2.Stop;
    end;
    if VideoLinkDownloader2.Status <> gsStopped then
    begin
      VideoLinkDownloader2.Stop;
    end;
    if VideoLinkDownloader1.Status <> gsStopped then
    begin
      VideoLinkDownloader1.Stop;
    end;
    for I := Low(FDownloadThreads) to High(FDownloadThreads) do
    begin
      if Assigned(FDownloadThreads[i]) then
      begin
        FDownloadThreads[i].Stop;
      end;
    end;

    AddToProgramLog(Format('Download is stopped at %s.', [IntegerToTime(FTime)]));
    AddToProgramLog('');
    EnableUI;
    ProgressEdit.Caption := 'Progress: 0/0';
  end;
end;

procedure TMainForm.StopFileCheckBtnClick(Sender: TObject);
begin
  FStopFileCheck := True;
end;

procedure TMainForm.TimeTimerTimer(Sender: TObject);
begin
  Inc(FTime);
  TimeLabel.Caption := 'Time: ' + IntegerToTime(FTime);
end;

procedure TMainForm.TrayIconBalloonClick(Sender: TObject);
begin
  TrayIcon.Active := False;
end;

procedure TMainForm.TrayIconBalloonHide(Sender: TObject);
begin
  TrayIcon.Active := False;
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
        end
        else
        begin
          AddToProgramLog('[UPDATE ERROR] Invalid update line.');
        end
      end
      else
      begin
        AddToProgramLog('[UPDATE ERROR] Invalid update file.');
      end;
    end
    else
    begin
      AddToProgramLog('[UPDATE ERROR] Update file is empty.');
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
  if FDownloadingFavs then
  begin
    Result := '\' + FFavs[FFavIndex] + '\' + Result
  end
  else
  begin
    Result :=  '\' + UserNameEdit.Text + '\' + Result
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
          ProgressEdit.Caption := 'Progress: 0/' + FloatToStr(FLinksToDownload.Count);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
    end;

    // run next video page link
    CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
    VideoLinkDownloader2.Url := FPageURLs[FVideoPageIndex];
    VideoLinkDownloader2.Start;
  end
  else
  begin
    // start downloading
    if FLinksToDownload.Count > 0 then
    begin
      if not FDownloadingFavs then
      begin
        StateEdit.Caption := 'State: Downloading...';
      end
      else
      begin
        StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Downloading...'
      end;
      FImageIndex := 0;
      // parallel download count
      FThreadCount := SettingsForm.ThreadList.ItemIndex+1;
      if FThreadCount > FLinksToDownload.Count then
      begin
        FThreadCount := FLinksToDownload.Count;
      end;
      LaunchDownloadThreads(FThreadCount);
    end
    else
    begin
      if not FDownloadingFavs then
      begin
        Application.MessageBox('No links were extracted.', 'Error', MB_ICONERROR);
      end;
      AddToProgramLog('Failed to extract links for ' + UserNameEdit.Text + '.');
      if FDownloadingFavs then
      begin
        PosTimer.Enabled := False;
        // downloading favourites
        Inc(FFavIndex);
        if FFavIndex < FFavs.Count then
        begin
          // start downloading next fav
          // reset lists
          FLinksToDownload.Clear;
          FPageURLs.Clear;
          TotalBar.Position := 0;
          SetProgressValue(Handle, 0, MaxInt);

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

          StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
          ProgressEdit.Caption := 'Progress: 0/0';
          Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
          DisableUI;
          CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
          SetProgressState(Handle, tbpsNormal);
          if ImagePageDownloader1.Status <> gsStopped then
          begin
            ImagePageDownloader1.Stop;
          end;
          if ImagePageDownloader2.Status <> gsStopped then
          begin
            ImagePageDownloader2.Stop;
          end;
          UserNameEdit.Text := FFavs[FFavIndex];
          ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
          ImagePageDownloader1.Start;
            PosTimer.Enabled := True;
        end
        else
        begin
          // done
          EnableUI;
        end;
      end
      else
      begin
        // normal account download
        EnableUI;
      end;
    end;
  end;
end;

procedure TMainForm.VideoLinkDownloader1Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('VPD1: ' + ErrorMsg);
end;

procedure TMainForm.VideoLinkDownloader1Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  TotalBar.Position := (100 * FVideoPageIndex) div FPageURLs.Count;
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
          ProgressEdit.Caption := 'Progress: 0/' + FloatToStr(FLinksToDownload.Count);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
    end;

    // run next video page link
    CurrentLinkEdit.Caption := 'Link: ' + FPageURLs[FVideoPageIndex];
    VideoLinkDownloader1.Url := FPageURLs[FVideoPageIndex];
    VideoLinkDownloader1.Start;
  end
  else
  begin
    // start downloading
    if FLinksToDownload.Count > 0 then
    begin
      if not FDownloadingFavs then
      begin
        StateEdit.Caption := 'State: Downloading...';
      end
      else
      begin
        StateEdit.Caption := 'State [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Downloading...';
      end;
      FImageIndex := 0;
      // parallel download count
      FThreadCount := SettingsForm.ThreadList.ItemIndex+1;
      if FThreadCount > FLinksToDownload.Count then
      begin
        FThreadCount := FLinksToDownload.Count;
      end;
      LaunchDownloadThreads(FThreadCount);
    end
    else
    begin
        if not FDownloadingFavs then
        begin
          Application.MessageBox('No links were extracted.', 'Error', MB_ICONERROR);
        end;
      AddToProgramLog('Failed to extract links for ' + UserNameEdit.Text + '.');
      if FDownloadingFavs then
      begin
        PosTimer.Enabled := False;
        // downloading favourites
        Inc(FFavIndex);
        if FFavIndex < FFavs.Count then
        begin
          // start downloading next fav
          // reset lists
          FLinksToDownload.Clear;
          FPageURLs.Clear;
          TotalBar.Position := 0;
          SetProgressValue(Handle, 0, MaxInt);

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

          StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
          ProgressEdit.Caption := 'Progress: 0/0';
          Self.Caption := '0% [' + FloatToStr(FFavIndex+1) + '/' + FloatToStr(FFavs.Count) + '] [InstagramSaver]';
          DisableUI;
          CurrentLinkEdit.Caption := 'Link: http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
          SetProgressState(Handle, tbpsNormal);
          if ImagePageDownloader1.Status <> gsStopped then
          begin
            ImagePageDownloader1.Stop;
          end;
          if ImagePageDownloader2.Status <> gsStopped then
          begin
            ImagePageDownloader2.Stop;
          end;
          UserNameEdit.Text := FFavs[FFavIndex];
          ImagePageDownloader1.Url := 'http://web.stagram.com/n/' + FFavs[FFavIndex] + '/?vm=list';
          ImagePageDownloader1.Start;
            PosTimer.Enabled := True;
        end
        else
        begin
          // done
          EnableUI;
        end;
      end
      else
      begin
        // normal account download
        EnableUI;
      end;
    end;
  end;
end;

procedure TMainForm.VideoLinkDownloader2Error(Sender: TObject;
  ErrorMsg: string);
begin
  LogForm.LogList.Lines.Add('VPD2: ' + ErrorMsg);
end;

procedure TMainForm.VideoLinkDownloader2Progress(Sender: TObject; Position, TotalSize: Int64; Url: string; var Continue: Boolean);
begin
  TotalBar.Position := (100 * FVideoPageIndex) div FPageURLs.Count;
end;

end.
