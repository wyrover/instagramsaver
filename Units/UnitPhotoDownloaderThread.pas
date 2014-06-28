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

unit UnitPhotoDownloaderThread;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Vcl.ComCtrls, Generics.Collections, JvComponentBase, JvUrlListGrabber, JvUrlGrabbers,
  JvTypes;

type
  TDownloadStatus = (idle = 0, downloading = 1, done = 2, error = 3, gettinginfo = 4);

type
  TPhotoDownloadThread = class(TThread)
  private
    { Private declarations }
    FPicDownloader1, FPicDownloader2: TJvHttpUrlGrabber;
    FStatus: TDownloadStatus;
    FErrorMsg: string;
    FURLs: TStringList;
    FOutputFiles: TStringList;
    FURLIndex: Integer;
    FURL: string;
    FID: Integer;
    FDontDoubleDownload: Boolean;
    FDownloading: Boolean;

    // downloader events
    procedure PageDownloaderError1(Sender: TObject; ErrorMsg: string);
    procedure PageDownloaderDoneFile1(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    procedure PageDownloaderError2(Sender: TObject; ErrorMsg: string);
    procedure PageDownloaderDoneFile2(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
    // sync
    procedure ReportError;
  protected
    procedure Execute; override;
  public
    property Status: TDownloadStatus read FStatus;
    property Progress: Integer read FURLIndex;
    property ErrorMsg: string read FErrorMsg;
    property CurrentURL: string read FURL;
    property ID: Integer read FID write FID;
    property DontDoubleDownload: Boolean read FDontDoubleDownload write FDontDoubleDownload;

    constructor Create(const URLs: TStringList; const OutputFiles: TStringList);
    destructor Destroy; override;

    procedure Start();
    procedure Stop();
    procedure Reset();
  end;

implementation

{ TPhotoDownloadThread }
uses UnitLog;

constructor TPhotoDownloadThread.Create(const URLs: TStringList; const OutputFiles: TStringList);
var
  Def: TJvCustomUrlGrabberDefaultProperties;
begin
  inherited Create(False);

  // image downloader
  Def := TJvCustomUrlGrabberDefaultProperties.Create(nil);
  FPicDownloader1 := TJvHttpUrlGrabber.Create(nil, '', Def);
  with FPicDownloader1 do
  begin
    OnDoneFile := PageDownloaderDoneFile1;
    OnError := PageDownloaderError1;
    OutputMode := omFile;
    Agent := 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36';
  end;
  FPicDownloader2 := TJvHttpUrlGrabber.Create(nil, '', Def);
  with FPicDownloader2 do
  begin
    OnDoneFile := PageDownloaderDoneFile2;
    OnError := PageDownloaderError2;
    OutputMode := omFile;
    Agent := 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36';
  end;

  // defaults
  FStatus := idle;
  FOutputFiles := TStringList.Create;
  FURLs := TStringList.Create;
  FURLs.AddStrings(URLs);
  FOutputFiles.AddStrings(OutputFiles);
  FURLIndex := 0;
end;

destructor TPhotoDownloadThread.Destroy;
begin
  inherited Destroy;

  FPicDownloader1.Free;
  FPicDownloader2.Free;
  FURLs.Free;
  FOutputFiles.Free;
end;

procedure TPhotoDownloadThread.Execute;
begin
  FURLIndex := 0;
  FDownloading := True;
  if DontDoubleDownload then
  begin
    while FileExists(FOutputFiles[FURLIndex]) do
    begin
      Inc(FURLIndex);
      if FURLIndex >= FURLs.Count then
      begin
        Self.Stop;
        Exit;
      end;
    end;
    FPicDownloader1.Url := FURLs[FURLIndex];
    FURL := FURLs[FURLIndex];
    FPicDownloader1.FileName := FOutputFiles[FURLIndex];
    FPicDownloader1.Start;
    FStatus := downloading;
  end
  else
  begin
    FPicDownloader1.Url := FURLs[FURLIndex];
    FURL := FURLs[FURLIndex];
    FPicDownloader1.FileName := FOutputFiles[FURLIndex];
    FPicDownloader1.Start;
    FStatus := downloading;
  end;
end;

procedure TPhotoDownloadThread.PageDownloaderDoneFile1(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
begin
  if not FDownloading then
  begin
    FStatus := done;
    FURL := '';
    Self.Terminate;
    exit;
  end;
  Inc(FURLIndex);
  if (FURLIndex < FURLs.Count) then
  begin
    if DontDoubleDownload then
    begin
      // try next url if file exists
      while FileExists(FOutputFiles[FURLIndex]) do
      begin
        Inc(FURLIndex);
      end;
      // check if reached the end of the list
      if (FURLIndex < FURLs.Count) then
      begin
        FPicDownloader2.Url := FURLs[FURLIndex];
        FURL := FURLs[FURLIndex];
        FPicDownloader2.FileName := FOutputFiles[FURLIndex];
        FPicDownloader2.Start;
        FStatus := downloading;
      end
      else
      begin
        FStatus := done;
        FURL := '';
      end;
    end
    else
    begin
      FPicDownloader2.Url := FURLs[FURLIndex];
      FURL := FURLs[FURLIndex];
      FPicDownloader2.FileName := FOutputFiles[FURLIndex];
      FPicDownloader2.Start;
      FStatus := downloading;
    end;
  end
  else
  begin
    FStatus := done;
    FURL := '';
  end;
end;

procedure TPhotoDownloadThread.PageDownloaderDoneFile2(Sender: TObject; FileName: string; FileSize: Integer; Url: string);
begin
  if not FDownloading then
  begin
    FStatus := done;
    FURL := '';
    Self.Terminate;
    exit;
  end;
  Inc(FURLIndex);
  if (FURLIndex < FURLs.Count) then
  begin
    if DontDoubleDownload then
    begin
      // try next url if file exists
      while FileExists(FOutputFiles[FURLIndex]) do
      begin
        Inc(FURLIndex);
      end;
      // check if reached the end of the list
      if (FURLIndex < FURLs.Count) then
      begin
        FPicDownloader1.Url := FURLs[FURLIndex];
        FURL := FURLs[FURLIndex];
        FPicDownloader1.FileName := FOutputFiles[FURLIndex];
        FPicDownloader1.Start;
        FStatus := downloading;
      end
      else
      begin
        FStatus := done;
        FURL := '';
      end;
    end
    else
    begin
      FPicDownloader1.Url := FURLs[FURLIndex];
      FURL := FURLs[FURLIndex];
      FPicDownloader1.FileName := FOutputFiles[FURLIndex];
      FPicDownloader1.Start;
      FStatus := downloading;
    end;
  end
  else
  begin
    FStatus := done;
    FURL := '';
  end;
end;

procedure TPhotoDownloadThread.PageDownloaderError1(Sender: TObject; ErrorMsg: string);
begin
  FErrorMsg := ErrorMsg;
  Self.Synchronize(ReportError);
end;

procedure TPhotoDownloadThread.PageDownloaderError2(Sender: TObject; ErrorMsg: string);
begin
  FErrorMsg := ErrorMsg;
  Self.Synchronize(ReportError);
end;

procedure TPhotoDownloadThread.ReportError;
begin
  LogForm.ThreadsList.Lines.Add('[' + FloatToStr(FID) + '] ' + FErrorMsg);
  FErrorMsg := '';
end;

procedure TPhotoDownloadThread.Reset;
begin
  FURLs.Clear;
  FOutputFiles.Create;
  FURLIndex := 0;
  FErrorMsg := '';
end;

procedure TPhotoDownloadThread.Start;
begin

end;

procedure TPhotoDownloadThread.Stop;
begin
  FDownloading := False;
  FStatus := done;
  FURL := '';
  if FPicDownloader1.Status <> gsStopped then
  begin
    FPicDownloader1.Stop;
  end;
  if FPicDownloader2.Status <> gsStopped then
  begin
    FPicDownloader2.Stop;
  end;
  Self.Terminate;
end;

end.
