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
unit UnitFileChecker;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Vcl.ComCtrls, UnitImageTypeExtractor;

type
  TFileCheckerThread = class(TThread)
  private
    { Private declarations }
    FFilePaths: TStringList;
    FResults: TStringList;
    FDone: Boolean;
    FStop: Boolean;
    FResult: Boolean;

    FCurrentFile: string;
    FProgress: string;
    FPercentage: integer;
  protected
    procedure Execute; override;
  public
    property FilePaths: TStringList read FFilePaths write FFilePaths;
    property Results: TStringList read FResults;
    property Done: Boolean read FDone;
    property Result: Boolean read FResult;

    constructor Create(const Files: TStringList);
    destructor Destroy; override;

    procedure Stop();

    procedure UpdateUI;
  end;

implementation

{ TFileCheckerThread }
uses UnitMain;

constructor TFileCheckerThread.Create(const Files: TStringList);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FFilePaths := TStringList.Create;
  FResults := TStringList.Create;

  FFilePaths.AddStrings(Files);
  FDone := False;
end;

destructor TFileCheckerThread.Destroy;
begin
  inherited Destroy;

  FFilePaths.Free;
  FResults.Free;
end;

procedure TFileCheckerThread.Execute;
var
  i: integer;
  LITE: TImageTypeEx;
begin
  FDone := False;
  FStop := False;
  try
    if FFilePaths.Count > 0 then
    begin
      for I := 0 to FFilePaths.Count - 1 do
      begin
        if FStop then
        begin
          FResults.Add('File check is stopped by user.');
          Break;
        end;
        // update main form
        FCurrentFile := 'Current file: ' + ExtractFileName(FFilePaths[i]);
        FProgress := 'Progress: ' + FloatToStr(i + 1) + '/' + FloatToStr(FFilePaths.Count);
        FPercentage := (100 * i) div FFilePaths.Count;
        Synchronize(UpdateUI);
        if FileExists(FFilePaths[i]) then
        begin
          // check file
          LITE := TImageTypeEx.Create(FFilePaths[i], True);
          try
            // empty extension means something went wrong
            if Length(LITE.ImageType) < 1 then
            begin
              case LITE.ErrorCode of
                1:
                  FResults.Add('[ERROR] Unkown file type: ' + FFilePaths[i]);
                2:
                  FResults.Add('[ERROR] File is empty: ' + FFilePaths[i]);
              end;
              FResult := True;
            end;
          finally
            LITE.Free;
          end;
        end
        else
        begin
          case LITE.ErrorCode of
            1:
              FResults.Add('[ERROR] Unkown file type: ' + FFilePaths[i]);
            2:
              FResults.Add('[ERROR] File is empty: ' + FFilePaths[i]);
          end;
          FResult := True;
        end;
      end;
    end;
  finally
    FDone := True;
  end;
end;

procedure TFileCheckerThread.Stop;
begin
  FStop := True;
end;

procedure TFileCheckerThread.UpdateUI;
begin
  MainForm.CurrFileLabel.Caption := FCurrentFile;
  MainForm.FileCheckProgressLabel.Caption := FProgress;
  MainForm.FileCheckProgressBar.Position := FPercentage;
end;

end.
