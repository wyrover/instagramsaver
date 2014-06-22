{ *
  * Copyright (C) 2014 ozok <ozok26@gmail.com>
  *
  * This file is part of TFlickrDownloader.
  *
  * TFlickrDownloader is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * TFlickrDownloader is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with TFlickrDownloader.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }

unit UnitImageTypeExtractor;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils;

type
  TImageTypeEx = class(TObject)
  private
    FType: string;

    function ReadType(const ImagePath: string): string;
  public
    property ImageType: string read FType;

    constructor Create(const ImagePath: string);
    destructor Destroy; override;
  end;

implementation

const
  JPG_HEADER: array [0 .. 2] of byte = ($FF, $D8, $FF);
  MP4_HEADER: array [0 .. 11] of byte = ($00, $00, $00, $20, $66, $74, $79, $70, $69, $73, $6F, $6D);

{ TImageTypeEx }

constructor TImageTypeEx.Create(const ImagePath: string);
begin
  if FileExists(ImagePath) then
  begin
    FType := ReadType(ImagePath);
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

function TImageTypeEx.ReadType(const ImagePath: string): string;
var
  LFS: TFileStream;
  LMS: TMemoryStream;
begin
  Result := '';
  LFS := TFileStream.Create(ImagePath, fmOpenRead);
  LMS := TMemoryStream.Create;
  try
    LMS.CopyFrom(LFS, 12);
    if LMS.Size > 4 then
    begin
      if CompareMem(LMS.Memory, @JPG_HEADER, SizeOf(JPG_HEADER)) then
      begin
        Result := '.jpg'
      end
      else if CompareMem(LMS.Memory, @MP4_HEADER, SizeOf(MP4_HEADER)) then
      begin
        Result := '.mp4';
      end;
    end;
  finally
    LFS.Free;
    LMS.Free;
  end;
end;

end.
