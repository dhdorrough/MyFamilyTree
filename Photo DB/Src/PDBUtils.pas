unit PDBUtils;

// 11/23/2010 use default values for PhotoDateToYearMonthDay

interface

uses
  Types, PDB_Decl, DB, Classes;

type
  TSearch_Type = (SEARCHING, SEARCH_FOUND, NOT_FOUND);

  TFileNameOptions = (fno_IncludeFilePath, fno_IncludeFileName,
                      fno_FileNameMayIncludeDate, fno_UseExifForPhotoDate,
                      fno_UseFileDateForPhotoDate);

  TFileNameOptionsSet = set of TFileNameOptions;

  TThumbnailProcessingStatus = (tps_Ignored, tps_CreatedUpdated, tps_Error);

var
  gNoiseWords: TStringList;

function  BuildMediaFilter(MediaClasses: TMediaClasses = ALLMEDIACLASSES): string;
function  CalcLogFileName(const Base: string): string;
function  CalcPhotoDateString(Year, Month, Day: integer; var HasChanged: boolean): string;
function  CheckLowDate(DateType: TDateTypes; LowDateStr: string; fldPhotoDate, fldAdded, fldUpdated, fldPhotoDateTime: TField;
                        Var FoundField: TField): boolean;
function  CheckHighDate(DateType: TDateTypes; HighDateStr: string; fldPhotoDate, fldAdded, fldUpdated, fldPhotoDateTime: TField;
                        Var FoundField: TField): boolean;
function  CheckParsedDates(LowYearStr,  HighYearStr,
                           LowMonthStr, HighMonthStr,
                           LowDayStr,   HighDayStr: string;
                           fldYear, fldMonth, fldDay: TField): boolean;
function  GetBestDate(DateType: TDateTypes; const s: string; HighLow: THighLow): TDateTime;
function  ConvertToCanonical(const Unknown: string; var Canonical: string): boolean;
function  FileNameContainsPartialDate(const FileName: string;
                                      var PartialDate: string;
                                      FileNameInfo: TFileNameInfo): boolean; overload;
function  FileNameContainsPartialDate(const FileName: string;
                                      var PartialDate: string;
                                      DateKinds: TDateKinds;
                                      var CharIdx: integer): boolean; overload
function  GetKeyList(const aString: string;
                     FileNameInfo: TFileNameInfo): string;
function  IsCameraFileName(const aFilePath: string): boolean;
function  IsDay(const DayNumber: integer; Month: integer): boolean; overload
function  IsMonth(const mon: string): boolean;
function  IsNameContainingDate(const FileName: string;
                               var Year, Month, Day: integer;
                               FileNameInfo: TFileNameInfo): boolean;
function  IsYear(var aWord: string; LowestYear: integer = BASEYEAR): boolean;
function  IsYYYYMMDD(aWord: string; var Year, Month, Day: word): boolean;
function  IsHH_MM_SS(aWord: string; var Hour, Min, Sec: word): boolean;
function  MyCreateThumbNail( const FileName: string;
                            ThumbNailPathAndName: string;
                            var   ErrorMsg: string;
                            Width: integer = THUMBNAILWIDTH;
                            Height: integer = THUMBNAILHEIGHT;
                            OverWrite: boolean = false): TThumbnailProcessingStatus; overload;
function  MyCreateThumbNail( const FileName: string;
                            var   ErrorMsg: string;
                            Width: integer = THUMBNAILWIDTH;
                            Height: integer = THUMBNAILHEIGHT;
                            OverWrite: boolean = false): TThumbnailProcessingStatus; overload;
function  MyExtractFileExt(Ext: string): string;
function  NoiseWord(const aWord: string;
                    FileNameInfo: TFileNameInfo): boolean;
function  PhotoDateToYearMonthDay(const DateStr: string;
                                  var YYYY, MM, DD: word): boolean;
function  PhotoDate2DateTime(const DateStr: string; DateDef: TDateDef): TDateTime;
function  ReportsPath: string;
function  StringContainsPartialDate(const aString: string; Var PartialDate: string; Var CharIdx: integer): boolean;
function  StripNoiseWords(aPhrase: string;
                          FileNameInfo: TFileNameInfo): string;
function  ThumbNailPathAndName(const FullFileName: string): string;
function  YearNumber(const aWord: string): integer;
function  YearMonthDayToPhotoDate(Year, Month, Day: integer): string;

implementation

uses
  SysUtils, StStrL, Dialogs, Controls, uGetString, ShellAPI,
  Windows, MyUtils, DateUtils, ExtCtrls, LocationUtils, JpegConv,
  Graphics, ThumbNailUnit, Jpeg;

(*
const
{$IfDef DHD}
  MAX_NOISE_WORDS = 20;
{$Else}
  MAX_NOISE_WORDS = 3;
{$EndIf}
*)

(*
{$IfDef DHD}
  NoiseWords: array[0..MAX_NOISE_WORDS-1] of string =
    ('PICTURE', 'IMAGE', 'NEWDELL',
     'NEWDELL-E', 'MY', 'PICTURES', 'FOR', 'JPG', 'DSCN', 'FRIENDS', 'FAMILY',
     'PICTURE', 'IMG', 'FRIENDS_FAMILY', 'MVI', 'VIDEOS',
     'TRIPS', 'HIKING', 'IMG_', 'DSCF');
{$Else}
  NoiseWords: array[0..MAX_NOISE_WORDS-1] of string =
    ('DSCN', 'IMG', 'DSCF');
{$EndIf}
  NoiseWords: array[0..MAX_NOISE_WORDS-1] of string =
    ('DSCN', 'IMG', 'DSCF');
*)

var
  gCameraFileNames: TStringList;

//  array[0..MAX_NOISE_WORDS-1] of string =
//    ('PICTURE', 'IMAGE', 'NEWDELL',
//     'NEWDELL-E', 'MY', 'PICTURES', 'FOR', 'JPG', 'DSCN', 'FRIENDS', 'FAMILY',
//     'PICTURE', 'IMG', 'FRIENDS_FAMILY', 'MVI', 'VIDEOS',
//     'TRIPS', 'HIKING', 'IMG_', 'DSCF');

function BuildMediaFilter(MediaClasses: TMediaClasses = ALLMEDIACLASSES): string;
var
  mc: TMediaClass;
  mt: TMediaType;
  MediaClassName: string;
  MediaTypes: TMediaTypes;
  MediaTypeList: string;
  Ext: string;
  FilterLine: string;
begin
  result := '';
  for mc := Succ(Low(TMediaClass)) to High(TMediaClass) do
    if mc in MediaClasses then
      begin
        FilterLine := '';
        MediaClassName := MediaClassInfoArray[mc].MediaClassName;
        MediaTypes     := MediaClassInfoArray[mc].MediaTypes;
        MediaTypeList  := '';
        for mt := Low(TMediaType) to High(TMediaType) do
          if mt in MediaTypes then
            begin
              Ext := '*.' + MediaInfoArray[mt].Ext;
              if MediaTypeList = '' then
                MediaTypeList := Ext
              else
                MediaTypeList := MediaTypeList + ';' + Ext;
            end;
        FilterLine := MediaClassName + ' (' + MediaTypeList + ')' + '|' + MediaTypeList;
        FilterLine := Format('%s files (%s)|%s', [MediaClassName, MediaTypeList, MediaTypeList]);
        if result = '' then
          result := FilterLine
        else
          result := result + '|' + FilterLine;
      end;
end;

function CalcLogFileName(const Base: string): string;
var
  Temp: string;
begin
  Temp := ReportsPath;
  if not DirectoryExists(Temp) then
    CreateDir(Temp);
  result := UniqueFileName(Temp + YYYYMMDD(Now) + ' - ' + Base);
end;

function ReportsPath: string;
begin
  result := ForceBackSlash(gExePath) + 'Reports\';
end;

function CalcPhotoDateString(Year, Month, Day: integer; var HasChanged: boolean): string;
begin
  HasChanged := false;
  if (Year <> 0) then
    begin
      if (Month <> 0) then
        if (Day <> 0) then
          begin
            result := Format('%4d%2s%2s', [Year,
                                           Rzero(Month, 2),
                                           Rzero(Day, 2)]);
            HasChanged := true;
          end
        else
          begin
            Result := Format('%4d%2s', [Year,
                                        Rzero(Month, 2)]);
            HasChanged := true;
          end
      else
        begin
          result := Format('%4d', [Year]);
          HasChanged := true;
        end;
    end;
end;

//*****************************************************************************
//   Function Name     : ConvertToCanonical
//   Useage            : if ConvertToCanonical(Unknown, Canonical) then...
//   Function Purpose  : Convert dates in odd formats into canonical format for easy comparison
//   Assumptions       :
//   Parameters        :
//   Return Value      : TRUE if the date can be converted
//*******************************************************************************}

function ConvertToCanonical(const Unknown: string; var Canonical: string): boolean;
var
  TempDate: TDateTime;
  CharIdx: integer;
  aYear, aMonth, aDay: word;
begin { ConvertToCanonical }
  result := false;
  if Empty(Unknown) then
    begin
      Canonical := '';
      result    := true;
    end;

  if not result then
    try
      TempDate  := StrToDate(Unknown);
      DecodeDate(TempDate, aYear, aMonth, aDay);
      Canonical := YearMonthDayToPhotoDate(aYear, aMonth, aDay);
      result    := true;
    except
      on e:EConvertError do
        result := false;
    end;

  if not result then
    result := StringContainsPartialDate(Unknown, Canonical, CharIdx);

  if not result then
    begin
      if IsYYYYMMDD(Unknown, aYear, aMonth, aDay) then
        begin
          Canonical := Unknown;
          result := true;
        end;
    end;
end;  { ConvertToCanonical }

function IsCameraFileName(const aFilePath: string): boolean;
// Return true if the file was created by a camera
var
  i: integer;
begin
  result := false;
  for i := 0 to gCameraFileNames.Count-1 do
    if Wild_Match(pchar(aFilePath), pchar(gCameraFileNames[i]), '*', '?', false) then
      begin
        result := true;
        break;
      end;
end;

function IsMonth(const mon: string): boolean;
begin
  result := MonthNumber(Mon) > 0;
end;

function IsDay(const DayNumber: integer; Month: integer): boolean; overload
begin
  result := false;
  if DayNumber >= 1 then
    begin
      if Month in [1 {Jan}, 3 {Mar}, 5 {May}, 7 {Jul}, 8 {Aug}, 10 {Oct}, 12 {Dec}] then
        result := (DayNumber <= 31) else
      if Month = 2 {Feb} then
        result := (DayNumber <= 29)
      else
        result := DayNumber <= 30;
    end;
end;

function IsDay(const aWord: string; Month: integer): boolean; overload;
var
  DayNumber: integer;
begin
  try
    if IsAllNumeric(aWord) then
      DayNumber := StrToInt(aWord)
    else
      DayNumber := 0;
  except
    on e:EConvertError do
      DayNumber := 0
    else
      raise
  end;

  result := IsDay(DayNumber, Month);
end;

function MyExtractFileExt(Ext: string): string;
begin
  Ext    := ExtractFileExt(Ext);
  result := UpperCase(Copy(Ext, 2, Length(Ext)-1));
end;


function InNoiseList(const aWord: string): boolean;
  var
    i: integer; u, l, m: integer; mode: TSearch_Type;
begin
  u := 0;
  l := gNoiseWords.Count-1;
  mode := SEARCHING;
  repeat
    if u <= l then
      begin
        m := (u + l) div 2;

        i := CompareText(aWord, gNoiseWords[m]);
        if i > 0 then
          begin
            if m < gNoiseWords.Count - 1 then
              u := m + 1
            else
              mode := NOT_FOUND
          end else
        if i < 0 then
          begin
            if m > 0 then
              l := m - 1
            else
              mode := NOT_FOUND
          end
        else
          mode := SEARCH_FOUND;
      end
    else
      mode := NOT_FOUND;
  until mode <> SEARCHING;

  result := mode = SEARCH_FOUND;
end;

(*
function IsMapName(const aWord: string): boolean;
begin
  result := false;
  if (Length(aWord) >= 3) and (Length(aWord) <= 5) then
    begin
      if (aWord[1] in ['M', 'B', 'L', 'I']) and
         (aWord[2] = '-') then
        result := true else
      if (aWord[1] = 'C') and (aWord[2] = 'T') and (aWord[3] = '-') then
        result := true;
    end
end;
*)

function PhotoDateToYearMonthDay( const DateStr: string;
                                  var YYYY, MM, DD: word): boolean;
  var
    MMStr, DDStr, YYYYStr: string;
begin
//  YYYY := 0; MM := 0; DD := 0;  // These should be initialized prior to the call
  result := false;
  try
    if Length(DateStr) >= 8 then
      begin
        DDStr := Copy(DateStr, 7, 2);
        if IsPureNumeric(DDStr) then
          begin
            DD    := StrToInt(DDStr);
            result := true;
          end
        else
          Exit;
      end;
    if Length(DateStr) >= 6 then
      begin
        MMStr := Copy(DateStr, 5, 2);
        MM    := StrToInt(MMStr);
      end;
    if Length(DateStr) >= 4 then
      begin
        YYYYStr := Copy(DateStr, 1, 4);
        YYYY    := StrToInt(YYYYStr);
      end;
  except
    result := false;
  end;
end;

function PhotoDate2DateTime(const DateStr: string; DateDef: TDateDef): TDateTime;
  var
    MM, DD, YYYY: word;
begin
  if DateDef = dd_UseLow then
    begin MM := 1; DD := 1; YYYY := 0; end else
  if DateDef = dd_UseHigh then
    begin MM := 12; DD := 28; YYYY := 10000 end else
  if DateDef = dd_NoDate then
    begin MM := 0; DD := 0; YYYY := 0 end;

  if DateDef = dd_NoDate then
    begin
      result := YYYYMMDD_hhmmss_to_DateTime(DateStr);
      if result = BAD_DATE then
        begin
          if PhotoDateToYearMonthDay(DateStr, YYYY, MM, DD) then
            try
              result := EncodeDate(YYYY, MM, DD)
            except
              on e:EConvertError do
                result := BAD_DATE;
            end
        end
    end
  else
    begin
      PhotoDateToYearMonthDay(DateStr, YYYY, MM, DD); // convert to YYYY, MM, DD and ignore the error, if any
      if (YYYY > 0) and (MM >= 1) and (MM <= 12) and (DD >= 1) then
        result := EncodeDate(YYYY, MM, DD)
      else
        result := BAD_DATE;
    end
end;

function StripNoiseWords(aPhrase: string;
                         FileNameInfo: TFileNameInfo): string;
const
  DELIM = ' ~';
var
  i, wc: integer;
  aWord, Contents: string;
begin
  result := '';
  wc := WordCountL(aPhrase, DELIM);
  for i := 1 to wc do
    begin
      aWord := ExtractWordL(i, aPhrase, DELIM);
      if aWord[1] = '(' then
        begin
          if aWord[Length(aWord)] = ')' then
            begin
              Contents := Copy(aWord, 2, Length(Aword)-2);
              if IsPureNumeric(Contents) then
                Continue;   // skip stuff like (1)
            end;
        end;
      if not NoiseWord(aWord, FileNameInfo) then
        if result = '' then
          result := aWord
        else
          result := result + ' ' + aWord;
    end;
end;

function StringContainsPartialDate(const aString: string; Var PartialDate: string; Var CharIdx: integer): boolean;
var
  aWord: string;
  i, wc: integer;
  Day, Month, Year: word;
  YearFound, MonthFound, DayFound, Done: boolean;
  LowestWordNumber, WordNumber: integer;
  Idx: Cardinal;
begin
  result := false;
  CharIdx := -1;
  // Do a hard-wired look for YYYYMMDD-hhmmss at the beginning
  if YYYYMMDD_hhmmss_to_DateTime(aString) <> BAD_DATE then
    begin
      PartialDate := aString;
      CharIdx     := 1;
      result      := true;
    end
  else
    begin
      // Look through the string to see if it appears to contain a year and/or month
      wc := WordCountL(aString, DELIMS);
      if wc >= 1 then
        begin
          Day        := 0;
          Month      := 0;
          Year       := 0;
          MonthFound := false;
          DayFound   := false;                        
          YearFound  := false;
          WordNumber := -1;
          LowestWordNumber := MAXINT;

          for i := 1 to wc do
            begin
              aWord := ExtractWordL(i, aString, DELIMS);
              if IsYYYYMMDD(aWord, Year, Month, Day) then
                begin
                  YearFound  := Year > 0;
                  MonthFound := Month > 0;
                  DayFound   := Day > 0;
                  WordNumber := i;
                  LowestWordNumber := i;
                  break;  // found it -- no reason to continue
                end else
              if IsYYYYMMDD(Copy(aWord, 1, 8), Year, Month, Day) then
                begin
                  YearFound  := Year > 0;
                  MonthFound := Month > 0;
                  DayFound   := Day > 0;
                  WordNumber := i;
                  LowestWordNumber := i;
                  break;  // found it -- no reason to continue
                end else
              if IsYear(aWord, 1500 {Use 1500 rather than 1900 for geneology purposes}) then
                begin
                  Year := YearNumber(aWord);
                  YearFound := true;
                  WordNumber := i;
                end else
              if IsMonth(aWord) then
                begin
                  Month := MonthNumber(aWord);
                  MonthFound := true;
                  WordNumber := i;
                end else
              if MonthFound and IsDay(aWord, Month) then
                begin
                  Day := StrToInt(aWord);
                  DayFound := true;
                  WordNumber := i;
                end else
              if SameText(aWord, 'ca') or
                 SameText(aWord, 'circa') or
                 SameText(aWord, 'before') or
                 SameText(aWord, 'after') then
                begin
                  WordNumber := i;
                end else
              if (not DayFound) and (Length(aWord) < 3) and IsPureNumeric(aWord) and (StrToInt(aWord) <= 31) and (StrToInt(aWord) > 0) then // assume that it is a day
                begin
                  Day := StrToInt(aWord);
                  DayFound := true;
                  WordNumber := i;
                end else
              if (WordNumber > 0) and (WordNumber < LowestWordNumber) then
                LowestWordNumber := WordNumber;
            end;

          if WordNumber > 0 then
            begin
              if WordPositionL(LowestWordNumber, aString, DELIMS, Idx) then
                begin
                  done := false;
                  repeat
                    Idx := Idx - 1;
                    if Idx < 1 then
                      done := true
                    else
                      begin
                        if not (aString[idx] in [' ', '-', ';']) then
                          done := true;
                      end;
                  until done;
                  CharIdx := Idx + 1;
                end;
            end;

          result := YearFound;
          if YearFound then
            begin
              PartialDate := RZero(Year, 4);
              if MonthFound then
                begin
                  PartialDate := PartialDate + RZero(Month, 2);
                  if DayFound then
                    PartialDate := PartialDate + RZero(Day, 2);
                end;
            end;
        end;
    end;

end;

function ThumbNailPathAndName(const FullFileName: string): string;
var
  FileName, FilePath: string;
begin
  FilePath := ExtractFilePath(FullFileName);
  FileName := ExtractFileName(FullFileName);
  result   := ForceBackSlash(FilePath) + 'TN\' + PREFIX_TN + ExtractFileBase(FileName) + JPG_FILE_EXT;
end;


function  FileNameContainsPartialDate(const FileName: string;
                                      var PartialDate: string;
                                      DateKinds: TDateKinds;
                                      var CharIdx: integer): boolean;
var
  aFileName: string;
begin
  result := false;
  CharIdx := -1;

//with FileNameInfo do
    if dk_From_FileName in DateKinds then  // 12/8/2016
      begin
        aFileName := ExtractFileBase(FileName);  // see if there is a date in the base filename
        result    := StringContainsPartialDate(aFileName, PartialDate, CharIdx);
        if Empty(PartialDate) then
          begin
            aFileName := ExtractFilePath(FileName);
            result    := StringContainsPartialDate(aFileName, PartialDate, CharIdx);
          end;
      end;
end;

function FileNameContainsPartialDate(const FileName: string;
                                     var PartialDate: string;
                                     FileNameInfo: TFileNameInfo): boolean;
var
  Dummy: integer;
begin
  result := FileNameContainsPartialDate(FileName,
                                        PartialDate,
                                        FileNameInfo.DateKinds,
                                        Dummy);
end;

function IsNameContainingDate(const FileName: string;
                              var Year, Month, Day: integer;
                              FileNameInfo: TFileNameInfo): boolean;
  var
    FileBase, temp: string;

  function IsPossibleDate(aYear, aMonth, aDay: integer): boolean;
  begin
    result := (aYear >= 1700) and (aYear < HIGHYEAR) and
              (aMonth > 0) and (aMonth <= 12) and
              (aDay > 0) and (aDay <= 31);
  end;

  function CheckFixedDate(ypos, mpos, dpos: integer): boolean;
  var
    aYear, aMonth, aDay: integer;
    temp: string;
  begin
    result := false;
    try
      temp   := Copy(FileBase, ypos, 4);
      aYear  := MyStrToInt(temp);

      temp   := Copy(FileBase, mpos, 2);
      aMonth := MyStrToInt(temp);

      temp   := Copy(FileBase, dpos, 2);
      aDay   := MyStrToInt(temp);

      if IsPossibleDate(aYear, aMonth, aDay) then
        begin
          EncodeDate(aYear, aMonth, aDay); // exception if not valid
          Year   := aYear;
          Month  := aMonth;
          Day    := aDay;
          result := true;  // if we were able to encode it
        end;
    except
    end;
  end;

begin { IsNameContainingDate }
  // Filename is like: "PC020001.JPG"
  //                        ^^^^--- sequence number
  //                      ^^--- Day
  //                     ^--- Month
  FileBase  := ExtractFileBase(FileName);
  result := (Length(FileBase) >= 8) and
            (FileBase[1] = 'P') and
            (FileBase[2] in ['1'..'9', 'A'..'C']) and
            IsAllNumeric(Copy(FileBase, 3, 5));
  Year := 0; Month := 0; Day := 0;
  if result then
    begin
      try
        if FileBase[2] in ['1'..'9'] then
          Month := StrToInt(FileBase[2]) else
        if FileBase[2] in ['A'..'C'] then
          Month := Ord(FileBase[2]) - Ord('A') + 10;
        Temp := Copy(FileBase, 3, 2);
        Day := StrToInt(Temp);
      except
        // let it ride
      end;
    end;

  if not result then
    if Length(FileBase) >= 8 then
      result := CheckFixedDate(1, 5, 7);  // like yyyymmdd

  if not result then
    if Length(FileBase) >= 10 then
      result := CheckFixedDate(1, 6, 9);  // like yyyy-mm-dd

  if not result then
    if length(FileBase) >= 11 then
      result := CheckFixedDate(2, 7, 10); // like: ?yyyy-mm-dd
end;  { IsNameContainingDate }

function CreateThumbNailGeneral(const ImagePathName, ThumbnailPathName: string; w, h: integer): TThumbnailProcessingStatus;
  var
    hBmp: HBITMAP;
    BitMap: TBitMap;
    JpegImage: TJpegImage;
begin
  result    := tps_Error;
  BitMap    := TBitMap.Create;
  JpegImage := TJpegImage.Create;
  try
    if Succeeded(GetThumbnail(ImagePathName, hBmp, w, h)) then
      begin
        Bitmap.Handle := hBmp;
        JpegImage.Assign(BitMap);
        JpegImage.SaveToFile(ThumbnailPathName);
        result := tps_CreatedUpdated;
      end;
  finally
    BitMap.Free;
    JpegImage.Free;
  end;
end;

(*
function CalcThumbNailPathAndName(const FileName: string): string;
var
  ThumbNailName, ThumbNailPath: string;
begin
  ThumbNailName     := 'tn_' + ExtractFileBase(ExtractFileName(FileName)) + GENERAL_MEDIA_FILENAME_EXT;    // TN/TN_1986-01.JPG
  ThumbNailPath     := ExtractFilePath(FileName) + 'tn\';
  result            := ThumbNailPath +  ThumbNailName; // c:/.../TN/TN_1986-01.JPG
end;
*)

function MyCreateThumbNail( const FileName: string;
                            ThumbNailPathAndName: string;
                            var   ErrorMsg: string;
                            Width: integer = THUMBNAILWIDTH;
                            Height: integer = THUMBNAILHEIGHT;
                            OverWrite: boolean = false): TThumbnailProcessingStatus;
var
  FileAgeImage, FileAgeThumb: integer;
  ThumbNailPath: string;
  mt: TMediaType;
  Ext: string;
begin                                                       
  result            := tps_Ignored;
  if OverWrite and FileExists(ThumbNailPathAndName) then
    MyDeleteFile(ThumbNailPathAndName, true, false);
  FileAgeImage      := FileAge(FileName);
  FileAgeThumb      := FileAge(ThumbNailPathAndName);
  if FileAgeImage > FileAgeThumb  then   // thumbnail out of date
    begin
      ThumbNailPath := ExtractFilePath(ThumbNailPathAndName);
      if not DirectoryExists(ThumbNailPath) then
        CreateDir(ThumbNailPath);
      try
        if FileExists(ThumbNailPathAndName) then
          MyDeleteFile(ThumbNailPathAndName, true, false);
        Ext := ExtractFileExt(FileName);
        mt  := MediaTypeFromExtension(Ext);
        if IsPhotoMedia(mt) then
          begin
            CreateThumbnail(FileName, ThumbNailPathAndName, Width, Height);
            result := tps_CreatedUpdated;
          end else
        if MediaInfoArray[mt].MediaClass = mc_Video then
          result := CreateThumbNailGeneral(FileName, ThumbNailPathAndName, Width, Height)
        else
          result := tps_Ignored;
      except
        on e:Exception do
          begin
            ErrorMsg := e.Message;
            result   := tps_Error;
          end;
      end;
    end;
end;

function MyCreateThumbNail( const FileName: string;
                            var   ErrorMsg: string;
                            Width: integer = THUMBNAILWIDTH;
                            Height: integer = THUMBNAILHEIGHT;
                            OverWrite: boolean = false): TThumbnailProcessingStatus;
var
  ThumbNailName: string;
begin
  ThumbNailName := ThumbNailPathAndName(FileName);
  result        := MyCreateThumbNail(FileName, ThumbNailName, ErrorMsg, Width, Height);
end;  { MyCreateThumbNail }

function NoiseWord(const aWord: string;
                   FileNameInfo: TFileNameInfo): boolean;
  var
    PartialDate: string;
    CharIdx: integer;
begin
  if InNoiseList(aWord) then
    result := true else
  if IsAllNumeric(aWord) and StringContainsPartialDate(aWord, PartialDate, CharIdx) and (CharIdx = 1) then
    result := true else
  if IsCameraFileName(aWord) then
    result := true
  else
    result := false;
end;

function GetKeyList(const aString: string;
                    FileNameInfo: TFileNameInfo): string;
  var
    List: TStringList; i, KeysAdded: integer;

  function AddKeys(const aDelims: string; LastChance: boolean): integer;
    var
      aWord: string; i, Count: integer;
  begin { AddKeys }
    Count := WordCountL(aString, aDelims);
    if (Count > 1) or LastChance then
      for i := 1 to Count do
        begin
          aWord := ExtractWordL(i, aString, aDelims);
          if Length(aWord) > 1 then
            if (not NoiseWord(aWord, FileNameInfo)) and (List.IndexOf(aWord) < 0) then
              List.Add(aWord);
        end;
    result := List.Count;
  end;  { AddKeys }

begin { GetKeyList }
  List := TStringList.Create;
  try
    KeysAdded := AddKeys(DELIMS, true);

    if Keysadded > 0 then
      begin
        result := '';
        for i := 0 to List.Count - 1 do
          if result = '' then
            result := List[i]
          else
            result := result + ' ' + List[i];
      end;
  finally
    List.Free;
  end;
end; { GetKeyList }

function YearMonthDayToPhotoDate(Year, Month, Day: integer): string;
begin
  result := '';

  if Year > 0 then
    begin
      result := RZero(Year, 4);
      if (Month > 0) and (Month <= 12) then
        begin
          result := result + RZero(Month, 2);
          if IsDay(Day, Month) then
            result := result + RZero(Day, 2);
        end;
    end;
end;

function YearNumber(const aWord: string): integer;
begin
  result := -1;
  if IsPureNumeric(aWord) then
    begin
      if Length(aWord) = 4 then
        begin
          try
            result := StrToInt(aWord)
          except
            result := -1;
          end
        end else
      if Length(aWord) = 2 then
        begin
          result := StrToInt(aWord);
          if (result >= 60) and (result <= 99) then
            result  := BASEYEAR + result;    // normalize
        end;
    end;
end;

function IsYear(var aWord: string; LowestYear: integer = BASEYEAR): boolean;
  var
    Year: integer;
begin
  Year   := YearNumber(aWord);
  result := (Year >= LowestYear) and (Year <= HIGHYEAR);
end;

function  IsYYYYMMDD(aWord: string; var Year, Month, Day: word): boolean;
var
  temp: string;
  aYear, aMonth, aDay: word;
begin
  aWord  := Trim(aWord);
  if Length(aWord) = 5 then  // could be like "1970s"
    begin
      temp   := Copy(aWord, 1, 4);
      if IsPureNumeric(temp) and (aword[5] in ['s', 'S']) then
        aWord := Temp;
    end;

  result := (Length(aWord) in [4, 6, 8]) and IsPureNumeric(aWord);
  if result then
    begin
      temp   := Copy(aWord, 1, 4);
      aYear  := YearNumber(temp);
      result := (aYear >= BASEYEAR) and (aYear <= HIGHYEAR);
      if result then
        Year := aYear;

      if result and (Length(aWord) in [6, 8]) then
        begin
          temp   := Copy(aWord, 5, 2);
          aMonth := StrToInt(temp);
          result := (aMonth >= 1) and (aMonth <= 12);
          if result then
            Month := aMonth;

          if result and (Length(aWord) = 8) then
            begin
              temp   := Copy(aWord, 7, 2);
              aDay   := StrToInt(temp);
              result := (aDay >= 1) and (aDay <= 31);
              if result then
                try
                  EncodeDate(aYear, aMonth, aDay);
                  Day    := aDay;
                except
                  result := false;
                end;
            end;
        end;
    end;
end;

function  IsHH_MM_SS(aWord: string; var Hour, Min, Sec: word): boolean;
var
  HH, MM, SS: variant;
begin
  try
    aWord  := Trim(aWord);
    HH     := Copy(aWord, 1, 2);
    MM     := Copy(aWord, 4, 2);
    SS     := Copy(aWord, 7, 2);
    Hour   := HH;
    Min    := MM;
    Sec    := SS;
    result := true;
  except
    result := false;
  end;
end;

procedure InitCameraFileNames;
begin
  gCameraFileNames := TStringList.Create;
  with gCameraFileNames do
    begin
      Add('IMG_????');
      Add('Image*');
      Add('Picture-??');
      Add('DSC?????');
      Add('P?999999');
      Add('???_???');
    end;
end;

  function GetBestDate(DateType: TDateTypes; const s: string; HighLow: THighLow): TDateTime;
  const
    DATEDELIMS = '/-';
  var
    Year, Month, Day, wc: integer;
    YearStr, MonthStr: string;
  begin { GetBestDate }
    result := BAD_DATE;
    try
      case DateType of
        dt_PhotoDateTime:
          begin
            result := StrToDateTime(s);
            if (Frac(result) = 0) and (HighLow = hl_UseHigh) then  // no time specified
              result := result + 1;   // so allow anything before midnight
          end;
        else
          begin
            wc := WordCountL(s, DATEDELIMS);
            if wc in [1,2] then
              begin
                if wc = 1 then
                  begin
                    YearStr := s;
                    Year    := StrToInt(YearStr);
                    if HighLow = hl_UseLow then
                      Month := 1
                    else // HighLow = hl_UseHigh
                      Month := 12;
                  end
                else // wc = 2, e.g. mm/yy
                  begin
                    MonthStr := ExtractWordL(1, s, DATEDELIMS);
                    Month    := StrToInt(MonthStr);
                    YearStr  := ExtractWordL(2, s, DATEDELIMS);
                    Year     := StrToInt(YearStr);
                  end;

                if Year < 100 then
                  Year := Year + (CurrentYear div 1000) * 1000;

                case HighLow Of
                  hl_UseLow:
                    result := EncodeDate(Year, Month, 1);
                  hl_UseHigh:
                    begin
                      case Month of
                        2:
                          Day := 28;
                        1, 3, 5, 7, 8, 10, 12:
                          Day := 31;
                        4, 6, 9, 11:
                          Day := 30;
                        else
                          raise Exception.CreateFmt('Invalid month: %d', [Month]);
                      end;
                      result := EncodeDate(Year, Month, Day);
                    end;
                end;
              end
            else
              result := StrToDate(s);
          end;
      end;
    except
      on e:Exception do
        begin
          AlertFmt('Exception=%s', [e.message]);
          if Length(s) = 4 then
            if IsPureNumeric(s) then
              begin
                Year := StrToInt(s);
                if (Year >= 1900) and (Year <= 2100) then
                  case HighLow Of
                    hl_UseLow:
                      result := EncodeDate(Year, 1, 1);
                    hl_UseHigh:
                      result := EncodeDate(Year, 12, 31);
                  end;
              end;
        end;
    end;
  end;  { GetBestDate }

  function CheckLowDate( DateType: TDateTypes;
                         LowDateStr: string;
                         fldPhotoDate, fldAdded, fldUpdated, fldPhotoDateTime: TField;
                         Var FoundField: TField): boolean;
  var
    LowDate: TDateTime;
    PhotoDate: TDateTime;
  begin { CheckLowDate }
    result := true;  FoundField := nil;
    if not Empty(LowDateStr) then
      begin
        try
          LowDate := GetBestDate(DateType, LowDateStr, hl_UseLow);
          case DateType of
            dt_PhotoDate:
              if not Empty(fldPhotoDate.AsString) then
                begin
                  PhotoDate := PhotoDate2DateTime(fldPhotoDate.AsString, dd_UseLow);
                  result := PhotoDate >= LowDate;
                  if result then
                    FoundField := fldPhotoDate;
                end
              else
                result := false;

            dt_DateAdded:
              if not fldADDED.IsNull then
                begin
                  result := Trunc(fldAdded.AsDateTime) >= LowDate;
                  if result then
                    FoundField := fldAdded;
                end
              else
                result := false;

            dt_DateUpdated:
              if not fldUPDATED.IsNull then
                begin
                  result := Trunc(fldUPDATED.AsDateTime) >= LowDate;
                  if result then
                    FoundField := fldUpdated;
                end
              else
                result := false;

            dt_PhotoDateTime:
              if not fldPhotoDateTime.IsNull then
                begin
//                result := Trunc(fldPhotoDateTime.AsDateTime) >= LowDate;
                  result := fldPhotoDateTime.AsDateTime >= LowDate;  // granularity to time, not just date
                  if result then
                    FoundField := fldPhotoDateTime;
                end
              else
                result := false;
          end;
        except
          result := false;   // can't accept if date is bad
        end;
      end;
  end;  { CheckLowDate }

  function CheckHighDate(DateType: TDateTypes; HighDateStr: string; fldPhotoDate, fldAdded, fldUpdated, fldPhotoDateTime: TField;
                         var FoundField: Tfield): boolean;
  var
    HighDate: TDateTime;
    PhotoDate: TDateTime;
  begin { CheckHighDate }
    result := true; FoundField := nil;
    if not Empty(HighDateStr) then
      begin
        try
          HighDate  := GetBestDate(DateType, HighDateStr, hl_UseHigh);
          case DateType of
            dt_PhotoDate:
              if not Empty(fldPhotoDate.AsString) then
                begin
                  PhotoDate := PhotoDate2DateTime(fldPhotoDate.AsString, dd_UseHigh);
                  result    := PhotoDate <= HighDate;
                  if result then
                    FoundField := fldPhotoDate;
                end
              else
                result := false;

            dt_DateAdded:
              if not fldADDED.IsNull then
                begin
                  result := Trunc(fldAdded.AsDateTime) <= HighDate;
                  if result then
                    FoundField := fldAdded;
                end
              else
                result := false;

            dt_DateUpdated:
              if not fldUPDATED.IsNull then
                begin
                  result := Trunc(fldUPDATED.AsDateTime) <= HighDate;
                  if result then
                    FoundField := fldUPDATED;
                end
              else
                result := false;

            dt_PhotoDateTime:
              if not fldPhotoDateTime.IsNull then
                begin
//                result := Trunc(fldPhotoDateTime.AsDateTime) <= HighDate;
                  result := fldPhotoDateTime.AsDateTime <= HighDate;  // granularity to time, not just date
                  if result then
                    FoundField := fldPhotoDateTime;
                end
              else
                result := false;
          end;
        except
          result := false;  // Can't accept if date is bad
        end;
      end;
  end;  { CheckHighDate }

  function CheckParsedDates( LowYearStr, HighYearStr,
                             LowMonthStr, HighMonthStr,
                             LowDayStr,   HighDayStr: string;
                             fldYear, fldMonth, fldDay: TField): boolean;
  var
    LowYear, HighYear, LowMonth, HighMonth, LowDay, HighDay: integer;

    function IsNull(Field: TField): boolean;
    begin
      result := Field.IsNull or (Field.AsString = '');
    end;

  begin { CheckParsedDates }
    result := true;
    if not Empty(LowYearStr) then
      begin
        if IsNull(fldYear) then
          begin
            result := false;
            Exit;
          end;
        LowYear := StrToInt(LowYearStr);
        result  := result and (fldYear.AsInteger >= LowYear);
      end;

    if not Empty(HighYearStr) then
      begin
        if IsNull(fldYear) then
          begin
            result := false;
            Exit;
          end;
        HighYear := StrToInt(HighYearStr);
        result   := result and (fldYear.AsInteger <= HighYear);
      end;

    if (not Empty(LowMonthStr)) then
      begin
        if IsNull(fldMonth) then
          begin
            result := false;
            Exit;
          end;
        LowMonth := StrToInt(LowMonthStr);
        result   := result and (fldMonth.AsInteger >= LowMonth);
      end;

    if (not Empty(HighMonthStr)) then
      begin
        if IsNull(fldMonth) then
          begin
            result := false;
            Exit;
          end;
        HighMonth := StrToInt(HighMonthStr);
        result    := result and (fldMonth.AsInteger <= HighMonth);
      end;

    if (not Empty(LowDayStr)) then
      begin
        if IsNull(fldDay) then
          begin
            result := false;
            Exit;
          end;
        LowDay := StrToInt(LowDayStr);
        result := result and (fldDay.AsInteger >= LowDay);
      end;

    if (not Empty(HighDayStr)) then
      begin
        if IsNull(fldDay) then
          begin
            result := false;
            Exit;
          end;
        HighDay := StrToInt(HighDayStr);
        result := result and (fldDay.AsInteger <= HighDay);
      end;
  end;  { CheckParsedDates }

initialization
  InitCameraFileNames;
finalization
  gNoiseWords.Free;
  gCameraFileNames.Free;
end.
