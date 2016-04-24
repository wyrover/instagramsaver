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

unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  StrUtils, Vcl.Mask, Vcl.Buttons, Vcl.ComCtrls, JvComputerInfoEx, IniFiles,
  ShellAPI, Generics.Collections, JvThread, Vcl.Menus, System.Types, JvTrayIcon,
  JvThreadTimer, UnitPhotoPageLinkExtractorLauncher, UnitMediaLinkExtLauncher,
  UnitPhotoDownloadLauncher, JvUrlListGrabber, JvUrlGrabbers, JvComponentBase,
  JvExMask, JvToolEdit, System.Win.TaskbarCore, Vcl.Taskbar,
  UnitFileCheckerLauncher;

type
  TMainForm = class(TForm)
    sPanel1: TPanel;
    DownloadBtn: TBitBtn;
    StopBtn: TBitBtn;
    AboutBtn: TBitBtn;
    SettingsBtn: TBitBtn;
    sPanel2: TPanel;
    UserNameEdit: TEdit;
    Info: TJvComputerInfoEx;
    UpdateThread: TJvThread;
    UpdateDownloader: TJvHttpUrlGrabber;
    AboutMenu: TPopupMenu;
    A1: TMenuItem;
    c1: TMenuItem;
    H1: TMenuItem;
    R1: TMenuItem;
    S1: TMenuItem;
    TrayIcon: TJvTrayIcon;
    sPanel3: TPanel;
    GroupBox1: TGroupBox;
    OpenOutputBtn: TBitBtn;
    FavBtn: TBitBtn;
    FavMenu: TPopupMenu;
    D1: TMenuItem;
    E1: TMenuItem;
    D2: TMenuItem;
    ProgressEdit: TLabel;
    TimeLabel: TLabel;
    NormalPanel: TPanel;
    FileCheckPanel: TPanel;
    StopFileCheckBtn: TBitBtn;
    sLabel1: TLabel;
    CurrFileLabel: TLabel;
    FileCheckProgressLabel: TLabel;
    TimeTimer: TJvThreadTimer;
    sPageControl1: TPageControl;
    sTabSheet1: TTabSheet;
    LogList: TMemo;
    sPanel4: TPanel;
    sButton1: TButton;
    sButton2: TButton;
    sLabel2: TLabel;
    DonateBtn: TBitBtn;
    MediaLinkExtTimer: TTimer;
    DownloadTimer: TTimer;
    OutputEdit: TJvDirectoryEdit;
    TotalBar: TProgressBar;
    FileCheckProgressBar: TProgressBar;
    SaveDialog1: TSaveDialog;
    Taskbar1: TTaskbar;
    PhotoPageExtTimer: TTimer;
    StateEdit: TLabel;
    FileCheckTimer: TTimer;
    procedure DownloadBtnClick(Sender: TObject);
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
    procedure LogBtnClick(Sender: TObject);
    procedure UpdateThreadExecute(Sender: TObject; Params: Pointer);
    procedure UpdateDownloaderDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
    procedure A1Click(Sender: TObject);
    procedure c1Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure TimeTimerTimer(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure TrayIconBalloonClick(Sender: TObject);
    procedure TrayIconBalloonHide(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure FavBtnClick(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure StopFileCheckBtnClick(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure MediaLinkExtTimerTimer(Sender: TObject);
    procedure DownloadTimerTimer(Sender: TObject);
    procedure PhotoPageExtTimerTimer(Sender: TObject);
    procedure FileCheckTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FTime: Integer;
    FPageURLs: TStringList;
    FFilesToCheck: TStringList;
    FFavs: TStringList;
    FFavIndex: Integer;
    FDownloadingFavs: Boolean;
    FIgnoredImgCount: Cardinal;
    FDownloadedImgCount: Cardinal;
    FStopFileCheck: Boolean;
    FTotalDownloadedSize: int64;
    FURLs: array[0..15] of TStringList;
    FOutputFiles: array[0..15] of TStringList;
    FThreadCount: Integer;
    FFileCheckerPath: string;
    // backend paths
    FPhotoPageLinkExtPath: string;
    FMediaLinkExtPath: string;
    FPhotoDownloaderPath: string;
    // backend paths
    FMediaLinkExtLaunchers: array[0..15] of TMediaLinkExtLauncher;
    FPhotoDownloaderLaunchers: array[0..15] of TPhotoDownloadLauncher;
    FFileCheckerLaunchers: array[0..15] of TFileCheckerLauncher;
    FStop: Boolean;
    FPhotoPageExtractor: TPhotoPageLinkExtLauncher;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure DisableUI;
    procedure EnableUI;

    // checks if string is numeric
    function IsStringNumeric(Str: string): Boolean;

    // clears temp folder
    procedure ClearTempFolder;

    // int to hh:mm:ss
    function IntegerToTime(const Time: Integer): string;
  public
    { Public declarations }
    FAppDataFolder: string;
    FTempFolder: string;
    FFavFilePath: string;
    // list of media links extracted by the backends
    FMediaLinks: TStringList;
    // links of photo page links
    FPhotoPageLinks: TStringList;
    FOutputFileLinks: TStringList;
    FOKFileCount, FBrokenFileCount: integer;

    // adds msg to log
    // todo: save logs to text file
    procedure AddToProgramLog(const Line: string);
  end;

var
  MainForm: TMainForm;

const
  BuildInt = 674;
  Portable = False;

implementation

{$R *.dfm}

uses
  UnitSettings, UnitAbout, UnitFavs;

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
    LogList.Lines.Add('[' + DateTimeToStr(Now) + '] ' + Line)
  end
  else
  begin
    LogList.Lines.Add('');
  end;
end;

procedure TMainForm.c1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', pwidechar(ExtractFileDir(Application.ExeName) + '\changelog.txt'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.ClearTempFolder;
var
  Search: TSearchRec;
begin
  // search and delete all the files in the temp folder
  if DirectoryExists(FTempFolder) then
  begin
    if (FindFirst(FTempFolder + '\*.*', faAnyFile, Search) = 0) then
    begin
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
        for I := 0 to LFavFile.Count - 1 do
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
        for I := 0 to FFavs.Count - 1 do
        begin
          ForceDirectories(OutputEdit.Text + '\' + FFavs[i])
        end;

        // reset lists
        FFilesToCheck.Clear;
        FPageURLs.Clear;
        FTime := 0;
        FDownloadedImgCount := 0;
        FIgnoredImgCount := 0;
        TotalBar.Position := 0;
        FTotalDownloadedSize := 0;

        StateEdit.Caption := 'State: [' + FloatToStr(FFavIndex + 1) + '/' + FloatToStr(FFavs.Count) + '] Extracting image links...';
        ProgressEdit.Caption := 'Progress: 0/0';
        Self.Caption := '0% [InstagramSaver]';
        DisableUI;
        Taskbar1.ProgressState := TTaskBarProgressState.Normal;

        if LogList.Lines.Count > 0 then
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
  ShellExecute(0, 'open', 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6MSWEDR4AGBQG', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DownloadBtnClick(Sender: TObject);
begin
  if Length(Trim(UserNameEdit.Text)) > 0 then
  begin
    // only lowercase and no space
    UserNameEdit.Text := LowerCase(Trim(UserNameEdit.Text)).Replace(' ', '');

    if not ForceDirectories(OutputEdit.Text + '\' + UserNameEdit.Text) then
    begin
      Application.MessageBox('Cannot create output folder. Please enter a valid profile name.', 'Error', MB_ICONERROR);
      Exit;
    end;

    // reset
    FFilesToCheck.Clear;
    FPageURLs.Clear;
    FTime := 0;
    TotalBar.Position := 0;
    FDownloadedImgCount := 0;
    FIgnoredImgCount := 0;
    FTotalDownloadedSize := 0;

    StateEdit.Caption := 'State: Extracting image links...';
    ProgressEdit.Caption := 'Progress: 0/0';
    Self.Caption := '0% [InstagramSaver]';
    DisableUI;
    Taskbar1.ProgressState := TTaskBarProgressState.None;
    FDownloadingFavs := False;
    if LogList.Lines.Count > 0 then
    begin
      AddToProgramLog('');
    end;
    AddToProgramLog('Settings:');
    AddToProgramLog('Don''t download already downloaded files: ' + BoolToStr(SettingsForm.DontDoubleDownloadBtn.Checked, True));
    AddToProgramLog('Download videos: ' + BoolToStr(SettingsForm.DownloadVideoBtn.Checked, True));
    AddToProgramLog('Check downloaded files: ' + BoolToStr(not SettingsForm.DontCheckBtn.Checked, True));
    AddToProgramLog('');
    AddToProgramLog('Starting to download user: ' + UserNameEdit.Text);
    AddToProgramLog('Extracting page links...');

    FStop := False;

    // extract photo pages
    FPhotoPageLinks.Clear;
    FOutputFileLinks.Clear;

    // start photo page link extractor
    FPhotoPageExtractor.ResetValues;
    FPhotoPageExtractor.AppPath := FPhotoPageLinkExtPath;
    FPhotoPageExtractor.ProfileName := UserNameEdit.Text;
    FPhotoPageExtractor.Start;
    TimeTimer.Enabled := True;
    PhotoPageExtTimer.Enabled := True;
  end
  else
  begin
    Application.MessageBox('Please enter a user name first.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.PhotoPageExtTimerTimer(Sender: TObject);
var
  I: integer;
begin
  if not FStop then
  begin
    if FPhotoPageExtractor.IsRunning then
    begin
      ProgressEdit.Caption := Format('Progress: 0/%d', [FPhotoPageLinks.Count]);
    end
    else
    begin
      PhotoPageExtTimer.Enabled := False;
      if not FStop then
      begin
        StateEdit.Caption := 'State: Extracting image and video links';
        AddToProgramLog('Extracting image and video links...');
        Taskbar1.ProgressState := TTaskBarProgressState.Normal;
        // extract photo and video links
        // reset
        for I := Low(FMediaLinkExtLaunchers) to High(FMediaLinkExtLaunchers) do
        begin
          FMediaLinkExtLaunchers[i].ResetValues;
        end;
        FMediaLinks.Clear;
        // parallel download count
        FThreadCount := SettingsForm.ThreadList.ItemIndex + 1;
        if FThreadCount > FPhotoPageLinks.Count then
        begin
          FThreadCount := FPhotoPageLinks.Count;
        end;

        // add jobs
        for I := 0 to FPhotoPageLinks.Count - 1 do
        begin
          FMediaLinkExtLaunchers[i mod FThreadCount].CommandLines.Add(FPhotoPageLinks[i]);
          FMediaLinkExtLaunchers[i mod FThreadCount].Paths.Add(FMediaLinkExtPath);
        end;

        // launch extractors
        for I := Low(FMediaLinkExtLaunchers) to High(FMediaLinkExtLaunchers) do
        begin
          if FMediaLinkExtLaunchers[i].CommandLines.Count > 0 then
          begin
            FMediaLinkExtLaunchers[i].Start;
          end;
        end;

        MediaLinkExtTimer.Enabled := True;
      end;
    end;
  end;
end;

procedure TMainForm.DownloadTimerTimer(Sender: TObject);
var
  LProgress: integer;
  I: Integer;
begin
  if not FStop then
  begin
  // calculate total progress
    LProgress := 0;
    for I := Low(FPhotoDownloaderLaunchers) to High(FPhotoDownloaderLaunchers) do
    begin
      if FPhotoDownloaderLaunchers[i].CommandCount > 0 then
      begin
        if FPhotoDownloaderLaunchers[i].Progress < FPhotoDownloaderLaunchers[i].CommandCount then
        begin
          Inc(LProgress, FPhotoDownloaderLaunchers[i].Progress);
        end
        else
        begin
          Inc(LProgress, FPhotoDownloaderLaunchers[i].CommandCount);
        end;
      end;
    end;

    // update the number of links added to the medialinks
    ProgressEdit.Caption := Format('Progress: %d/%d', [LProgress, FMediaLinks.Count]);
    if FMediaLinks.Count > 0 then
    begin
      TotalBar.Position := (100 * LProgress) div FMediaLinks.Count;
      Taskbar1.ProgressValue := TotalBar.Position;
      Self.Caption := FloatToStr(TotalBar.Position) + '% [InstagramSaver]';
    end;

    // finished downloading images
    if LProgress = FMediaLinks.Count then
    begin
      DownloadTimer.Enabled := False;
      // check downloaded files
      if not SettingsForm.DontCheckBtn.Checked then
      begin
        FOKFileCount := 0;
        FBrokenFileCount := 0;
        StateEdit.Caption := 'State: Cheking files';
        AddToProgramLog('Checking downloaded files...');
        AddToProgramLog('Number of files to check: ' + FloatToStr(FOutputFileLinks.Count));
        // check files
        for I := Low(FFileCheckerLaunchers) to High(FFileCheckerLaunchers) do
        begin
          FFileCheckerLaunchers[i].ResetValues;
        end;

        // add command lines
        for I := 0 to FOutputFileLinks.Count - 1 do
        begin
          FFileCheckerLaunchers[i mod FThreadCount].FilesToCheck.Add('"' + FOutputFileLinks[i] + '"');
          FFileCheckerLaunchers[i mod FThreadCount].Paths.Add(FFileCheckerPath);
        end;

        // start processes
        for I := Low(FFileCheckerLaunchers) to High(FFileCheckerLaunchers) do
        begin
          if FFileCheckerLaunchers[i].CommandCount > 0 then
          begin
            FFileCheckerLaunchers[i].Start;
          end;
        end;

        FileCheckTimer.Enabled := True;
      end
      else
      begin
        // do not check files, report process end
        AddToProgramLog(Format('Finished downloading. It took %s.', [IntegerToTime(FTime)]));
        AddToProgramLog('');
        EnableUI;
        ProgressEdit.Caption := 'Progress: 0/0';
      end;
    end;
  end
  else
  begin
    // todo: file check
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
  StateEdit.Caption := 'State: ';
  Self.Caption := 'InstagramSaver';
  Taskbar1.ProgressValue := 0;
  Taskbar1.ProgressState := TTaskBarProgressState.None;
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

procedure TMainForm.FileCheckTimerTimer(Sender: TObject);
var
  LProgress: integer;
  I: Integer;
begin
  if not FStop then
  begin
    // calculate total progress
    LProgress := 0;
    for I := Low(FFileCheckerLaunchers) to High(FFileCheckerLaunchers) do
    begin
      if FFileCheckerLaunchers[i].CommandCount > 0 then
      begin
        if FFileCheckerLaunchers[i].Progress < FFileCheckerLaunchers[i].CommandCount then
        begin
          Inc(LProgress, FFileCheckerLaunchers[i].Progress);
        end
        else
        begin
          Inc(LProgress, FFileCheckerLaunchers[i].CommandCount);
        end;
      end;
    end;

    // update the number of checked files
    ProgressEdit.Caption := Format('Progress: %d/%d', [LProgress, FOutputFileLinks.Count]);
    StateEdit.Caption := Format('State: Checking files: OK=%d, Failed=%d,  Total=%d', [FOKFileCount, FBrokenFileCount, (FBrokenFileCount + FOKFileCount)]);
    if FOutputFileLinks.Count > 0 then
    begin
      TotalBar.Position := (100 * LProgress) div FOutputFileLinks.Count;
      Taskbar1.ProgressValue := TotalBar.Position;
      Self.Caption := FloatToStr(TotalBar.Position) + '% [InstagramSaver]';
    end;
    // done
    if LProgress = FOutputFileLinks.Count then
    begin
      FileCheckTimer.Enabled := False;
      AddToProgramLog(Format('Finished downloading. It took %s.', [IntegerToTime(FTime)]));
      AddToProgramLog(Format('File check result: OK=%d, Failed=%d,  Total=%d', [FOKFileCount, FBrokenFileCount, (FBrokenFileCount + FOKFileCount)]));
      AddToProgramLog('');
      EnableUI;
      ProgressEdit.Caption := 'Progress: 0/0';
    end;
  end
  else
  begin
    // todo: file check
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;

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
  FFileCheckerPath := ExtractFileDir(Application.ExeName) + '\Backends\InstagramSaver.FileChecker.exe';
  if not DirectoryExists(FAppDataFolder) then
  begin
    CreateDir(FAppDataFolder);
  end;
  if not DirectoryExists(FTempFolder) then
  begin
    CreateDir(FTempFolder);
  end;
  FPhotoPageLinkExtPath := extractFileDir(Application.ExeName) + '\Backends\InstagramSaver.PhotoLinkExtractor.exe';
  FMediaLinkExtPath := extractFileDir(Application.ExeName) + '\Backends\InstagramSaver.MediaLinkExtractorLauncher.exe';
  FPhotoDownloaderPath := extractFileDir(Application.ExeName) + '\Backends\InstagramSaver.PhotoDownloader.exe';
  FMediaLinks := TStringList.Create;
  FPhotoPageLinks := TStringList.Create;
  FOutputFileLinks := TStringList.Create;
  for I := Low(FMediaLinkExtLaunchers) to High(FMediaLinkExtLaunchers) do
  begin
    FMediaLinkExtLaunchers[i] := TMediaLinkExtLauncher.Create;
  end;
  for I := Low(FPhotoDownloaderLaunchers) to High(FPhotoDownloaderLaunchers) do
  begin
    FPhotoDownloaderLaunchers[i] := TPhotoDownloadLauncher.Create;
  end;
  for I := Low(FFileCheckerLaunchers) to High(FFileCheckerLaunchers) do
  begin
    FFileCheckerLaunchers[i] := TFileCheckerLauncher.Create;
  end;

  FPhotoPageExtractor := TPhotoPageLinkExtLauncher.Create;

  // in any case
  ClearTempFolder;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FPageURLs.Free;
  FFilesToCheck.Free;
  FFavs.Free;
  for I := Low(FURLs) to High(FURLs) do
  begin
    FURLs[i].Free;
    FOutputFiles[i].Free;
  end;
  FMediaLinks.Free;
  FPhotoPageLinks.Free;
  FOutputFileLinks.Free;
  for I := Low(FMediaLinkExtLaunchers) to High(FMediaLinkExtLaunchers) do
  begin
    FMediaLinkExtLaunchers[i].Free;
  end;
  for I := Low(FPhotoDownloaderLaunchers) to High(FPhotoDownloaderLaunchers) do
  begin
    FPhotoDownloaderLaunchers[i].Free;
  end;
  for I := Low(FFileCheckerLaunchers) to High(FFileCheckerLaunchers) do
  begin
    FFileCheckerLaunchers[i].Free;
  end;
  try
    FPhotoPageExtractor.Free;
  except
    on E: Exception do


  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadSettings;
end;

procedure TMainForm.H1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.ozok26.com/categories/6/instagramsaver', nil, nil, SW_SHOWNORMAL);
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

    if (not CharInSet(P^, ['0'..'9'])) then
    begin
      Exit;
    end;

    Inc(P);
  end;

  Result := True;
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
    end;
  finally
    LSetFile.Free;
  end;
end;

procedure TMainForm.LogBtnClick(Sender: TObject);
begin
  Show;
end;

procedure TMainForm.MediaLinkExtTimerTimer(Sender: TObject);
var
  LProgress: integer;
  I: Integer;
  LLinkFile: string;
begin
  if not FStop then
  begin
    // calculate total progress
    LProgress := 0;
    for I := Low(FMediaLinkExtLaunchers) to High(FMediaLinkExtLaunchers) do
    begin
      if FMediaLinkExtLaunchers[i].CommandCount > 0 then
      begin
        if FMediaLinkExtLaunchers[i].Progress < FMediaLinkExtLaunchers[i].CommandCount then
        begin
          Inc(LProgress, FMediaLinkExtLaunchers[i].Progress);
        end
        else
        begin
          Inc(LProgress, FMediaLinkExtLaunchers[i].CommandCount);
        end;
      end;
    end;

    // update the number of links added to the medialinks
    ProgressEdit.Caption := Format('Progress: %d/%d', [LProgress, FPhotoPageLinks.Count]);
    if FPhotoPageLinks.Count > 0 then
    begin
      TotalBar.Position := (100 * LProgress) div FPhotoPageLinks.Count;
      Taskbar1.ProgressValue := TotalBar.Position;
      Self.Caption := FloatToStr(TotalBar.Position) + '% [InstagramSaver]';
    end;

    // when all lines are processed
    // start downloading
    if LProgress = FPhotoPageLinks.Count then
    begin
      MediaLinkExtTimer.Enabled := False;
      StateEdit.Caption := 'State: Downloading image and video links';
      AddToProgramLog('Downloading image and video links...');
      AddToProgramLog('Number of links to download: ' + FloatToStr(FMediaLinks.Count));

      if not FStop then
      begin
        for I := Low(FPhotoDownloaderLaunchers) to High(FPhotoDownloaderLaunchers) do
        begin
          FPhotoDownloaderLaunchers[i].ResetValues;
        end;

        for I := 0 to FMediaLinks.Count - 1 do
        begin
          LLinkFile := FMediaLinks[i].Replace('/', '\');
          LLinkFile := ExtractFileName(LLinkFile);
          LLinkFile := OutputEdit.Text + '\' + UserNameEdit.Text + '\' + LLinkFile;
          FOutputFileLinks.Add(LLinkFile);
          if not DirectoryExists(ExtractFileDir(LLinkFile)) then
          begin
            if not ForceDirectories(ExtractFileDir(LLinkFile)) then
            begin
              Continue;
            end;
          end;

          // dont download the files that are already downloaded
          if SettingsForm.DontDoubleDownloadBtn.Checked then
          begin
            if FileExists(LLinkFile) then
            begin
              Continue;
            end;
          end;

          // link file
          FPhotoDownloaderLaunchers[i mod FThreadCount].CommandLines.Add(FMediaLinks[i] + ' "' + LLinkFile + '"');
          FPhotoDownloaderLaunchers[i mod FThreadCount].Paths.Add(FPhotoDownloaderPath);
        end;

        for I := Low(FPhotoDownloaderLaunchers) to High(FPhotoDownloaderLaunchers) do
        begin
          if FPhotoDownloaderLaunchers[i].CommandCount > 0 then
          begin
            FPhotoDownloaderLaunchers[i].Start;
          end;
        end;

        DownloadTimer.Enabled := True;
      end;
    end;
  end;
end;

procedure TMainForm.OpenOutputBtnClick(Sender: TObject);
begin
  if DirectoryExists(OutputEdit.Text) then
  begin
    ShellExecute(Handle, 'open', PWideChar(OutputEdit.Text), nil, nil, SW_SHOWNORMAL);
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

procedure TMainForm.sButton2Click(Sender: TObject);
begin
  LogList.Lines.Clear;
end;

procedure TMainForm.sButton3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    LogList.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TMainForm.SettingsBtnClick(Sender: TObject);
begin
  Self.Enabled := False;
  SettingsForm.Show;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
var
  I: Integer;
begin
  if ID_YES = Application.MessageBox('Stop downloading?', 'Stop', MB_ICONQUESTION or MB_YESNO) then
  begin
    FStop := True;

    TimeTimer.Enabled := False;
    PhotoPageExtTimer.Enabled := False;
    MediaLinkExtTimer.Enabled := False;
    DownloadTimer.Enabled := False;

    if Assigned(FPhotoPageExtractor) then
    begin
      FPhotoPageExtractor.Stop;
      FPhotoPageExtractor.Free;
    end;
    for I := 0 to High(FMediaLinkExtLaunchers) do
    begin
      FMediaLinkExtLaunchers[i].Stop;
    end;
    for I := Low(FPhotoDownloaderLaunchers) to High(FPhotoDownloaderLaunchers) do
    begin
      FPhotoDownloaderLaunchers[i].Stop;
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

procedure TMainForm.UserNameEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    DownloadBtnClick(Self);
  end;
end;

end.

