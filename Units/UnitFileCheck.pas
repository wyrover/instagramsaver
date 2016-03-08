unit UnitFileCheck;

interface

uses
  System.Classes, Windows, SysUtils, IdBaseComponent, IdThreadComponent, IdThread, UnitImageTypeExtractor, MediaInfoDLL;

type
  TFileChecker = class(TObject)
  private
    { Private declarations }
    FFiles: TStringList;
    FDone: Boolean;
    FOutput: TStringList;
    FThread: TIdThreadComponent;
    FReport: TStringList;
    FProgress: integer;
    FCurrentFile: string;
    FID: integer;

    function FileSizeEx(const FilePath: string): Int64;

    procedure ThreadRun(Sender: TIdThreadComponent);
    procedure ThreadStopped(Sender: TIdThreadComponent);
    procedure ThreadTerminate(Sender: TIdThreadComponent);
  public
    property Done: Boolean read FDone;
    property Report: TStringList read FReport;
    property ID: integer write FID;

    constructor Create(const Files: TStringList);
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TFileChecker }

constructor TFileChecker.Create(const Files: TStringList);
begin
  FDone := False;
  FFiles := TStringList.Create;
  FFiles.AddStrings(Files);
  FOutput := TStringList.Create;
  FReport := TStringList.Create;
  FProgress := 0;
  FCurrentFile := '';

  FThread := TIdThreadComponent.Create;
  FThread.Priority := tpIdle;
  FThread.StopMode := smTerminate;
  FThread.OnRun := ThreadRun;
  FThread.OnStopped := ThreadStopped;
  FThread.OnTerminate := ThreadTerminate;
  Start;
end;

destructor TFileChecker.Destroy;
begin
  inherited;
  FFiles.Free;
  FOutput.Free;
//  FThread.Free;
  FReport.Free;
end;

function TFileChecker.FileSizeEx(const FilePath: string): Int64;
var
  LInfo: TWin32FileAttributeData;
begin
  Result := -1;
  if GetFileAttributesEx(PWideChar(FilePath), GetFileExInfoStandard, @LInfo) then
  begin
    Result := Int64(LInfo.nFileSizeLow) or Int64(LInfo.nFileSizeHigh shl 32);
  end;
end;

procedure TFileChecker.Start;
begin
  FDone := False;
  FThread.Start;
end;

procedure TFileChecker.Stop;
begin
  if not FThread.Terminated then
  begin
    FThread.Terminate;
  end;
end;

procedure TFileChecker.ThreadRun(Sender: TIdThreadComponent);
var
  ListItem: string;
  LWidth, LHeight: Word;
  LFileExt: string;
  i: integer;
  LImageTypeEx: TImageTypeEx;
begin
  FDone := False;
  try
    for I := 0 to FFiles.Count - 1 do
    begin
      LImageTypeEx := TImageTypeEx.Create(FFiles[i], False);
      try
        if Length(LImageTypeEx.ImageType) < 1 then
        begin
          case LImageTypeEx.ErrorCode of
            1:
              FReport.Add('[ERROR] Unkown file type: ' + FFiles[i]);
            2:
              FReport.Add('[ERROR] File is empty: ' + FFiles[i]);
          end;
        end;
      finally
        LImageTypeEx.Free;
      end;
    end;
  finally
    FReport.SaveToFile('c:\' +  FloatToStr(FID) + '.txt');
    FThread.Terminate;
    FDone := True;
  end;
end;

procedure TFileChecker.ThreadStopped(Sender: TIdThreadComponent);
begin
  FDone := True;
end;

procedure TFileChecker.ThreadTerminate(Sender: TIdThreadComponent);
begin
  FDone := True;
end;

end.
