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
unit UnitPhotoDownloadLauncher;

interface

uses
  Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils;

type
  TPhotoDownloadLauncher = class(TObject)
  private
    // process
    FProcess: TJvCreateProcess;
    // list of command lines to be executed
    FCommandLines: TStringList;
    // list of executables
    FPaths: TStringList;
    // index of current command line. Also progress.
    FCommandIndex: integer;
    FRunning: Boolean;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);

    // field variable read funcs
    function GetProcessID: integer;
    function GetCommandCount: integer;
  public
    property CommandLines: TStringList read FCommandLines write FCommandLines;
    property Paths: TStringList read FPaths write FPaths;
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CommandCount: integer read GetCommandCount;
    property IsRunning: Boolean read FRunning;
    property Progress: integer read FCommandIndex;
    constructor Create();
    destructor Destroy(); override;
    procedure Start();
    procedure Stop();
    procedure ResetValues();
    function GetConsoleOutput(): TStrings;
  end;

implementation

uses
  UnitMain;

{ TMediaLinkExtLauncher }

constructor TPhotoDownloadLauncher.Create;
begin
  inherited Create;

  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
  begin
    OnRead := ProcessRead;
    OnTerminate := ProcessTerminate;
    ConsoleOptions := [coRedirect];
    CreationFlags := [cfUnicode];
    Priority := ppIdle;

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := true;
  end;

  FCommandLines := TStringList.Create;
  FPaths := TStringList.Create;
  FCommandIndex := 0;
  FRunning := False;
end;

destructor TPhotoDownloadLauncher.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FCommandLines);
  FreeAndNil(FPaths);
  FProcess.Free;
end;

function TPhotoDownloadLauncher.GetCommandCount: integer;
begin
  Result := FCommandLines.Count;
end;

function TPhotoDownloadLauncher.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TPhotoDownloadLauncher.GetProcessID: integer;
begin
  Result := FProcess.ProcessInfo.hProcess;
end;

procedure TPhotoDownloadLauncher.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
begin
  
end;

procedure TPhotoDownloadLauncher.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  Inc(FCommandIndex);
  if FCommandIndex < FCommandLines.Count then
  begin
    FProcess.CommandLine := FPaths[FCommandIndex] + ' ' + FCommandLines[FCommandIndex];
//        FProcess.CommandLine := FCommandLines[0];
    FProcess.Run;
    FRunning := True;
  end
  else
  begin
    FRunning := False;
  end;
end;

procedure TPhotoDownloadLauncher.ResetValues;
begin
  // reset all lists, indexes etc
  FCommandLines.Clear;
  FPaths.Clear;
  FCommandIndex := 0;
  FProcess.ConsoleOutput.Clear;
end;

procedure TPhotoDownloadLauncher.Start;
begin
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    if FCommandLines.Count > 0 then
    begin
      if FileExists(FPaths[0]) then
      begin
        FProcess.CommandLine := FPaths[0] + ' ' + FCommandLines[0];
//        FProcess.CommandLine := FCommandLines[0];
        FProcess.Run;
        FRunning := True;
      end
    end
  end
end;

procedure TPhotoDownloadLauncher.Stop;
begin
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0);
  end;
end;

end.

