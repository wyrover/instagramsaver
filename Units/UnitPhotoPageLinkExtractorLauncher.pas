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
unit UnitPhotoPageLinkExtractorLauncher;

interface

uses
  Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils;

type
  TPhotoPageLinkExtLauncher = class(TObject)
  private
    // process
    FProcess: TJvCreateProcess;
    FProfileName: string;
    FAppPath: string;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    function GetIsRunning: Boolean;
  public
    property AppPath: string read FAppPath write FAppPath;
    property ProfileName: string read FProfileName write FProfileName;
    property IsRunning: Boolean read GetIsRunning;
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

{ TPhotoPageLinkExtLauncher }

constructor TPhotoPageLinkExtLauncher.Create();
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
end;

destructor TPhotoPageLinkExtLauncher.Destroy;
begin
  inherited Destroy;
  FProcess.Free;
end;

function TPhotoPageLinkExtLauncher.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TPhotoPageLinkExtLauncher.GetIsRunning: Boolean;
begin
  Result := FProcess.ProcessInfo.hProcess > 0;
end;

procedure TPhotoPageLinkExtLauncher.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
begin
  if Length(Trim(S)) > 0 then
  begin
    MainForm.FPhotoPageLinks.Add(Trim(S));
  end;
end;

procedure TPhotoPageLinkExtLauncher.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin

end;

procedure TPhotoPageLinkExtLauncher.ResetValues;
begin
  // reset all lists, indexes etc
  FProcess.ConsoleOutput.Clear;
end;

procedure TPhotoPageLinkExtLauncher.Start;
begin
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    FProcess.CommandLine := FAppPath + ' ' + FProfileName;
//    FProcess.CommandLine := FProfileName;
    FProcess.Run;
  end
  else
  begin

  end;
end;

procedure TPhotoPageLinkExtLauncher.Stop;
begin
  if Assigned(FProcess) then
  begin
    if FProcess.ProcessInfo.hProcess > 0 then
    begin
      TerminateProcess(FProcess.ProcessInfo.hProcess, 0);
    end;
  end;
end;

end.

