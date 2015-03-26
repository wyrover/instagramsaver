{ *
  * Copyright (C) 2014-2015 ozok <ozok26@gmail.com>
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

uses Classes, Windows, SysUtils, Messages, StrUtils, Vcl.ComCtrls, Generics.Collections, IdHTTP, IdComponent,
  IdBaseComponent, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TDownloadStatus = (idle = 0, downloading = 1, done = 2, error = 3, gettinginfo = 4);

type
  TPhotoDownloadThread = class(TThread)
  private
    { Private declarations }
    FStatus: TDownloadStatus;
    FErrorMsg: string;
    FURLs: TStringList;
    FOutputFiles: TStringList;
    FProgress: Integer;
    FURL: string;
    FID: Integer;
    FDontDoubleDownload: Boolean;
    FDownloading: Boolean;
    FDownloadedImgCount: Cardinal;
    FIgnoredImgCount: Cardinal;
    FWaitMS: integer;

    // sync
    procedure ReportError;
    // force directory creation everytime a file is downloaded
    procedure CreateOutputFolder(const FileName: string);

    procedure DownloadFile(const URL: string; const FileName: string);
    procedure Wait;
  protected
    procedure Execute; override;
  public
    property Status: TDownloadStatus read FStatus;
    property Progress: Integer read FProgress;
    property ErrorMsg: string read FErrorMsg;
    property CurrentURL: string read FURL;
    property ID: Integer read FID write FID;
    property DontDoubleDownload: Boolean read FDontDoubleDownload write FDontDoubleDownload;
    property DownloadedImgCount: Cardinal read FDownloadedImgCount;
    property IgnoredImgCount: Cardinal read FIgnoredImgCount;

    constructor Create(const URLs: TStringList; const OutputFiles: TStringList; const WaitMS: integer);
    destructor Destroy; override;

    procedure Stop();
  end;

implementation

{ TPhotoDownloadThread }
uses UnitMain;

constructor TPhotoDownloadThread.Create(const URLs: TStringList; const OutputFiles: TStringList; const WaitMS: integer);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  // defaults
  FStatus := idle;
  FOutputFiles := TStringList.Create;
  FURLs := TStringList.Create;
  FURLs.AddStrings(URLs);
  FOutputFiles.AddStrings(OutputFiles);
  FProgress := 0;
  FWaitMS := WaitMS;
end;

procedure TPhotoDownloadThread.CreateOutputFolder(const FileName: string);
begin
  if not DirectoryExists(ExtractFileDir(FileName)) then
  begin
    ForceDirectories(ExtractFileDir(FileName))
  end;
end;

destructor TPhotoDownloadThread.Destroy;
begin
  inherited Destroy;

  FURLs.Free;
  FOutputFiles.Free;
end;

procedure TPhotoDownloadThread.DownloadFile(const URL, FileName: string);
var
  LMS: TMemoryStream;
  LIdHTTP: TIdHTTP;
  LSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  LIdHTTP := TIdHTTP.Create(nil);
  LSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    LMS := TMemoryStream.Create;
    try
      try
        LIdHTTP.IOHandler := LSSLHandler;
        LIdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36';
        LIdHTTP.Get(URL, LMS);
        LMS.SaveToFile(FileName);
      except on E: EIdHTTPProtocolException do
        begin
          FErrorMsg := LIdHTTP.ResponseText + ' [' + FloatToStr(LIdHTTP.ResponseCode) + '] Error msg: ' + E.ErrorMessage;
          Synchronize(ReportError);
        end;
      end;
    finally
      LMS.Free;
    end;
  finally
    LSSLHandler.Free;
    LIdHTTP.Free;
  end;
end;

procedure TPhotoDownloadThread.Execute;
var
  I: Integer;
begin
  FDownloadedImgCount := 0;
  FIgnoredImgCount := 0;
  FDownloading := True;
  FStatus := downloading;
  try
    for I := 0 to FURLs.Count-1 do
    begin
      FProgress := i;
      FURL := FURLs[i];
      CreateOutputFolder(FOutputFiles[i]);
      if FDownloading then
      begin
        // do not download twice
        if FDontDoubleDownload then
        begin
          // download only if file doesn't exist
          if not FileExists(FOutputFiles[i]) then
          begin
            DownloadFile(FURLs[i], FOutputFiles[i]);
            Inc(FDownloadedImgCount);
          end
          else
          begin
            Inc(FIgnoredImgCount);
          end;
        end
        else
        begin
          // download all the same
          DownloadFile(FURLs[i], FOutputFiles[i]);
          Inc(FDownloadedImgCount);
        end;
      end;
      Wait;
    end;
  finally
    FStatus := done;
  end;
end;

procedure TPhotoDownloadThread.ReportError;
begin
  MainForm.ThreadsList.Lines.Add('[PhotoDownloaderThread_' + FloatToStr(FID) + '] ' + FErrorMsg + ' Link: ' + FURLs[FProgress]);
  FErrorMsg := '';
end;

procedure TPhotoDownloadThread.Stop;
begin
  FDownloading := False;
  FStatus := done;
  FURL := '';
  Self.Terminate;
end;

procedure TPhotoDownloadThread.Wait;
begin
  if FWaitMS > 0 then
  begin
    Sleep(FWaitMS);
  end;
end;

end.
