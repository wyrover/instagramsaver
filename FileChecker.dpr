program FileChecker;
{$IFOPT D-}{$WEAKLINKRTTI ON}{$ENDIF}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$APPTYPE CONSOLE}
{$R *.res}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  System.SysUtils,
  UnitImageTypeExtractor in 'Units\UnitImageTypeExtractor.pas',
  MediaInfoDLL in 'Units\MediaInfoDLL.pas',
  Classes,
  JclShell,
  Winapi.ShlObj;

var
  FFileListFilePath: string;
  FFileListFile: TStringList;
  FResults: TStringList;
  FImageTypeEx: TImageTypeEx;
  i: integer;

begin
  try
    // init mediainfo
    if not MediaInfoDLL_Load(ExtractFileDir(ParamStr(0)) + '\MediaInfo.dll') then
    begin
      WriteLn('FATAL ERROR: Unable to init mediainfo');
    end
    else
    begin
      FFileListFilePath := GetSpecialFolderLocation(CSIDL_APPDATA) + '\InstagramSaver\filelist.txt';
      if FileExists(FFileListFilePath) then
      begin
        FFileListFile := TStringList.Create;
        try       
          FFileListFile.LoadFromFile(FFileListFilePath);
          FResults := TStringList.Create;
          try  
            for i := 0 to FFileListFile.Count-1 do
            begin  
              // write progress info
              Writeln(FloatToStr(i+1) + '/' + FloatToStr(FFileListFile.Count) + '|' + ExtractFileName(FFileListFile[i]));
              // check file
              FImageTypeEx := TImageTypeEx.Create(FFileListFile[i], true);
              try
                if Length(FImageTypeEx.ImageType) < 1 then
                begin          
                  case FImageTypeEx.ErrorCode of
                    1:
                      FResults.Add('[ERROR] Unkown file type: ' + FFileListFile[i]);
                    2:
                      FResults.Add('[ERROR] File is empty: ' + FFileListFile[i]);
                  end;
                end;
              finally
                FImageTypeEx.Free;
              end;
            end;
          finally
            // delete previous one
            if FileExists(GetSpecialFolderLocation(CSIDL_APPDATA) + '\InstagramSaver\fileresult.txt') then
            begin
              DeleteFile(GetSpecialFolderLocation(CSIDL_APPDATA) + '\InstagramSaver\fileresult.txt')
            end;
            FResults.SaveToFile(GetSpecialFolderLocation(CSIDL_APPDATA) + '\InstagramSaver\fileresult.txt', TEncoding.UTF8);
            FResults.Free;
          end;
        finally
          FFileListFile.Free;
        end;
      end
      else
      begin
        Writeln('Cannot find file list file.');
        ExitCode := 1;
      end;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
