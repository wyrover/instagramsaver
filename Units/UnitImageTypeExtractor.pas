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



unit UnitImageTypeExtractor;

interface

uses
  Classes, Windows, SysUtils, Messages, StrUtils;

type
  TImageTypeEx = class(TObject)
  private
    FType: string;
    FErrorCode: integer;
    function ReadType(const ImagePath: string; const DeepCheck: Boolean): string;
  public
    property ImageType: string read FType;
    property ErrorCode: integer read FErrorCode;
    constructor Create(const ImagePath: string; const DeepCheck: Boolean);
    destructor Destroy; override;
  end;

implementation

const
  ERROR_OK = 0;
  ERROR_UNKKOWN_TYPE = 1;
  ERROR_EMPTY_FILE = 2;
  ERROR_INVALID_FILE = 3;

{ TImageTypeEx }


constructor TImageTypeEx.Create(const ImagePath: string; const DeepCheck: Boolean);
begin
  FErrorCode := 0;
  if FileExists(ImagePath) then
  begin
    FType := ReadType(ImagePath, DeepCheck);
  end
  else
  begin
    FType := '';
  end;
end;

destructor TImageTypeEx.Destroy;
begin
  inherited;
end;

function TImageTypeEx.ReadType(const ImagePath: string; const DeepCheck: Boolean): string;
var
  MediaInfoHandle: Cardinal;
  LFormat: string;
  LSize: string;
  LSizeInt: integer;
begin
  Result := '';
  if (FileExists(ImagePath)) then
  begin
    MediaInfoHandle := MediaInfo_New();
    if MediaInfoHandle <> 0 then
    begin
      try
        MediaInfo_Open(MediaInfoHandle, PWideChar(ImagePath));
        MediaInfo_Option(0, 'Complete', '1');

        LFormat := MediaInfo_Get(MediaInfoHandle, Stream_General, 0, 'Format', Info_Text, Info_Name);
        if LFormat = 'JPEG' then
        begin
          Result := '.jpg'
        end
        else if LFormat = 'MPEG-4' then
        begin
          Result := '.mp4'
        end
        else
        begin
          FErrorCode := ERROR_UNKKOWN_TYPE;
          //FileSize
          LSize := MediaInfo_Get(MediaInfoHandle, Stream_General, 0, 'FileSize', Info_Text, Info_Name);
          if Length(LSize) > 0 then
          begin
            if TryStrToInt(LSize, LSizeInt) then
            begin
              if LSizeInt = 0 then
              begin
                FErrorCode := ERROR_EMPTY_FILE;
              end;
            end
            else
            begin
              FErrorCode := ERROR_EMPTY_FILE;
            end;
          end;
        end;
      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

end.

