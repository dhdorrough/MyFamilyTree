unit PDB_Decl;

interface

uses
  Types, Forms, Messages;

const
  MSACCESS_VERSION = 2007;
  

  cPhotoEditingProgram = 'c:\windows\system32\mspaint.exe';
{$IfDef DHD}
  cCopyRight     = 'All photos Copyright (c) 2021 - Dan and Ruth Dorrough';
  cLocalWebPath  = 'C:\Inetpub\wwwroot\MyWeb3';
{$else}
  cLocalWebPath  = '';
{$EndIf}
  cFILENAMES     = 'FileNames';
  cFILEPATHS     = 'FilePaths';
  cCOPYRIGHTS    = 'CopyRights';
  cLOCATIONS     = 'Locations';
  cLOCATIONINDEX = 'LocationIndex';
  cSCENES        = 'Scenes';
  cRecentOnly    = true;
  cDayCount      = 10;
{$IfDef DHD}
  cLocalCSSLfn   = 'C:\InetPub\wwwroot\MyWeb5\MyStyle.css';
  cRemoteCSSLfn  = 'http://RuthAndDan.net/MyStyle.css';
{$EndIf}  
  REG_PHOTODB    = 'SoftWare\R & D Systems\PhotoDB';

  PHOTODB        = 'PhotoDB';
  EXPORTDB       = 'ExportDB.mdb';
  ROOTPATH       = 'RootPath';
  PHOTOEDITPROG  = 'PhotoEditProg';
  FOLDERNO       = 'FolderNo';
  COPYRIGHT      = 'CopyRight';
  DAYCOUNT       = 'DayCount';
  RECENTONLY     = 'RecentOnly';
  LOCAL_CSS_LFN  = 'LocalCssLfn';
  REMOTE_CSS_LFN = 'RemoteCssLfn';
  USE_LOCAL_CSS  = 'UseLocalCss';
  SLIDE_SHOW_INTERVAL = 'SlideShowInterval';
  SYNONYMS_FILE_NAME  = 'SynonymsFileName';
  USE_SYNONYMS_BY_DEFAULT = 'UseSynonymsByDefault';

  PHOTODB_    = 'PhotoDb';
  _INI        = 'ini';
  PHOTODB__INI = PHOTODB_ + '.' + _INI;
  PHOTODB_SYNONYMS = 'Synonyms.txt';
  FUNCKEYNAME      = 'FUNCKEY.txt';

  PREFIX_TN        = 'TN_';
  WILD_CHAR        = '?';
  WILD_STRING      = '*';
  HOME_LATITUDE    = 42.885;
  HOME_LONGITUDE   = -77.289;
  HOME_DESCRIPTION = '180 West Avenue Canandaigua NY';

  JPG_FILE_EXT               = '.jpg';
  JPEG_FILE_EXT              = '.JPEG';
  WAV_FILE_EXT               = '.WAV';
  GENERAL_MEDIA_FILENAME_EXT = JPG_FILE_EXT;  // When creating a thumbnail for a video, etc

  BAD_DATE: TDateTime = -1;
  BASEYEAR = 1900;
  HIGHYEAR = 2100;
  THUMBNAILWIDTH  = 240;
  THUMBNAILHEIGHT = 180;

  WM_HideScenes = WM_APP + 1;

type
  TMediaType  = (mt_Unk, mt_JPG, mt_JPEG, mt_RM, mt_RV, mt_RAD, mt_WMV, mt_MPG,
                 mt_AVI, mt_MOV, mt_ISO, mt_WAV, mt_MP4, mt_MP3, mt_WMA, mt_PDF,
                 mt_DOC, mt_TXT, mt_RTF, mt_m4a, mt_PPT, mt_PPTX, mt_3GP, mt_M2TS,
                 mt_DOCX, mt_ODP, mt_MTS, mt_XLS, mt_XLSX, mt_PSH, mt_PPR, mt_PDS,
                 mt_MMP, mt_VOB{, mt_PNG});

  // TUpdateReason: reason that record was updated-- NEVER DELETE- ALWAYS ADD AT END - stored as integers
  TUpdateReason = (ur_GeneralEditing,
                   ur_WasMissingNowFound,
                   ur_KeywordsChanged,
                   ur_RemoveTrailingDate,
                   ur_DateTimeFromPhotoDate,
                   ur_DropTarget,
                   ur_LocationFromEXIF,
                   ur_EnteredLocation,
                   ur_LocationEdited,
                   ur_LocationDeleted,
                   ur_ClearLocationForSelected,
                   ur_FillYearMonthDayFromPhotoDate,
                   ur_WasScanned,
                   ur_KeywordsReplaced,
                   ur_DatesTimesAdjusted,
                   ur_LocationChangedByNumber,
                   ur_FileRenamed,
                   ur_RatingChanged,
                   ur_HasSound,
                   ur_UpdateFieldInSelectedRecords,
                   ur_ClearDistance,
                   ur_SettingDistance,
                   ur_LatLonFromLocation,
                   ur_HeightWidthForSelectedPhotos,
                   ur_LoadTextFromFile,
                   ur_LoadTextFromPDF,
                   ur_FillPhotoDateTime,
                   ur_ReplaceCurrentPhoto,
                   ur_DateAddedFromFileDate,
                   ur_FileMover,
                   ur_FileMoverRenameFile,
                   ur_FillFileSize,
                   ur_FillYearMonthDayFromPhotoDateTime,
                   ur_FileDateIsAGuess,
                   ur_Imported,
                   ur_PhotoInfoUpdated,
                   ur_MediaLength,
                   ur_CustomKeySet);

  TMediaClass = (mc_Unknown, mc_Photos, mc_Video, mc_Audio, mc_DVD, mc_Document,
                 mc_Powerpoint, mc_Spreadsheet, mc_VideoProject);

  TMediaClasses = set of TMediaClass;

  TMyWindowInfo = record
    TopLeft: TPoint;
    Size: TPoint;
    TheState: TWindowState;
  end;

  TMediaInfo = record
    Ext: string;
    Desc: string;
    MediaType: TMediaType;
    MediaClass: TMediaClass;
  end;

  TDefaultLocationKind = (dl_Unknown, dl_LatLong, dl_LastWord, dl_SpecifiedValue);

  TLocationSource = (ls_Unknown, ls_PhotoEXIF, ls_GPSLogs, ls_Manual, ls_FileName);

  TDateKind = (dk_Unknown, dk_From_EXIF, dk_From_FileName, dk_Date_Modified, dk_Date_Created,
               dk_Last_Access, dk_MediaInfo);
  TDateKinds = set of TDateKind;

  TFileNameInfo = packed record
    DateKinds: TDateKinds;
    IncludeFilePath,
    IncludeFileName,
    ExcludeNumbersInKeywords: boolean;
    ExtractComments: boolean;
    ExtractCustomKey: boolean;
    IgnoreLeadingNumeric: boolean;
  end;

  TUpdateInfo = record
    FileName: string;
    FilePath: string;
    ImagePathName: string;
    PhotoDateYYYYMMDD: string;
    PhotoDateTime: TDateTime;
    RecordExists: boolean;
    UpdateIt: boolean;
    HasSoundFile: boolean;
    FileNameInfo: TFileNameInfo;
    PixelWidth, PixelHeight: integer;
    MediaLength: string;
    MinutesToAdd: integer;
    PhotoOwner: string;
    isPrivate: boolean;
  end;

  TLocationInfo = record
    MaxDistanceInFeet: integer;
    DefaultLocation: string;
    DefaultState: string;
    OkToAdd: boolean;   { add if needed }
    AlwaysAdd: boolean; { add is not mandatory }
    LocationSource: TLocationSource;
    Simulate: boolean;  { do not simulate }
    DefaultLocationKind: TDefaultLocationKind;
//  ScanAllSubFolders: boolean;
    ScanSelectedSubFolders: boolean;
    SelectedSubFolders: string;
    SaveUpdatedTrackLog: boolean;
    UseGPXLogsForLocation: boolean;
    UseSavedTracksLogFile: boolean;
    ExtractLatLonFromFileName: boolean;
    LowestDateToScan: TDateTime;
    DefaultKeyWords: string;
  end;

  TMediaTypes = Set of TMediaType;

  TMediaClassInfo= record
    MediaClassName: string;
    MediaTypes: TMediaTypes;
  end;

  TDateDef = (dd_NoDate, dd_UseLow, dd_UseHigh);

  TDateTypes = (dt_PhotoDate, dt_DateAdded, dt_DateUpdated, dt_PhotoDateTime);

  TFromWhat = (fw_Unknown, fw_FileDateTime, fw_FileCreationDateTime, fw_ExifInfo, fw_EnteredDateTime, fw_MediaInfo);

  TDateType = record
                Desc: string;
              end;

  THighLow    = (hl_UseLow, hl_UseHigh);

  TCurrentOrder = (coNone, coFileName, coPathName, coPhotoDate, coPhotoDateTime, coFileSize,
                   coDateAdded, coDateUpdated, coDistanceFromLocation, coLatitude, coLongitude,
                   coNearness, coLatitudeDec, coLongitudeDec, coPhotoDateDesc,
                   coPhotoDateTimeDesc, coMediaLength, coCustomKey);
const
  ALLMEDIACLASSES = [Succ(Low(TMediaClass))..High(TMediaClass)];

var
  DateTypesArray: array[TDateTypes] of TDateType =
    (
      ({dt_PhotoDate}         DESC: 'Photo Date'),
      ({dt_DateAdded}         DESC: 'Date Added'),
      ({dt_DateUpdated}       DESC: 'Date Updated'),
      ({dt_PhotoDateTime}     DESC: 'Photo Date + Time')
    );
  MediaInfoArray: array[TMediaType] of TMediaInfo =
    ( ({mt_Unk}  Ext: '';     Desc: ''),
      ({mt_JPG}  Ext: 'JPG';  Desc: 'Photo';                          MediaType: mt_JPG;   MediaClass: mc_Photos),
      ({mt_JPEG} Ext: 'JPEG'; Desc: 'Photo';                          MediaType: mt_JPEG;  MediaClass: mc_Photos),
      ({mt_RM}   Ext: 'RM';   Desc: 'RealMedia Recording';            MediaType: mt_RM;    MediaClass: mc_Audio),
      ({mt_RV}   Ext: 'RV';   Desc: 'RealMedia Video Recording';      MediaType: mt_RV;    MediaClass: mc_Video),
      ({mt_RAD}  Ext: 'RA';   Desc: 'RealMedia Audio Recording';      MediaType: mt_RAD;   MediaClass: mc_Audio),
      ({mt_WMV}  Ext: 'WMV';  Desc: 'Windows Media Audio/Video file'; MediaType: mt_WMV;   MediaClass: mc_Video),
      ({mt_AVI}  Ext: 'MPG';  Desc: 'Movie Clip';                     MediaType: mt_MPG;   MediaClass: mc_Video),
      ({mt_AVI}  Ext: 'AVI';  Desc: 'Video Clip';                     MediaType: mt_AVI;   MediaClass: mc_Video),
      ({mt_MOV}  Ext: 'MOV';  Desc: 'Apple Quicktime Video';          MediaType: mt_MOV;   MediaClass: mc_Video),
      ({mt_ISO}  Ext: 'ISO';  Desc: 'DVD Image file (ISO)';           MediaType: mt_ISO;   MediaClass: mc_DVD),
      ({mt_WAV}  Ext: 'WAV';  Desc: 'Sound Recording (WAV)';          MediaType: mt_WAV;   MediaClass: mc_Audio),
      ({mt_MP4}  Ext: 'MP4';  Desc: 'MP4 Video';                      MediaType: mt_MP4;   MediaClass: mc_Video),
      ({mt_MP3}  Ext: 'MP3';  Desc: 'MP3 Audio';                      MediaType: mt_MP3;   MediaClass: mc_Audio),
      ({mt_WMA}  Ext: 'WMA';  Desc: 'Windows Audio';                  MediaType: mt_WMA;   MediaClass: mc_Audio),
      ({mt_PDF}  Ext: 'PDF';  Desc: 'Portable Document Format';       MediaType: mt_PDF;   MediaClass: mc_Document),
      ({mt_DOC}  Ext: 'DOC';  Desc: 'MS Word Document';               MediaType: mt_DOC;   MediaClass: mc_Document),
      ({mt_TXT}  Ext: 'TXT';  Desc: 'Text File';                      MediaType: mt_TXT;   MediaClass: mc_Document),
      ({mt_RTF}  Ext: 'RTF';  Desc: 'Rich Text File';                 MediaType: mt_RTF;   MediaClass: mc_Document),
      ({mt_m4a}  Ext: 'M4A';  Desc: 'M4A Audio';                      MediaType: mt_M4A;   MediaClass: mc_Audio),
      ({mt_PPT}  Ext: 'PPT';  Desc: 'Power Point';                    MediaType: mt_PPT;   MediaClass: mc_PowerPoint),
      ({mt_PPTX} Ext: 'PPTX'; Desc: 'Power Point XML';                MediaType: mt_PPTX;  MediaClass: mc_PowerPoint),
      ({mt_3GP}  Ext: '3GP';  Desc: 'Cell phone video';               MediaType: mt_3GP;   MediaClass: mc_Video),
      ({mt_M2TS} Ext: 'M2TS'; Desc: 'M2TS Video Recording';           MediaType: mt_M2TS;  MediaClass: mc_Video),
      ({mt_DOCX} Ext: 'DOCX'; Desc: 'MS Word XML Document';           MediaType: mt_DOCX;  MediaClass: mc_Document),
      ({mt_ODP}  Ext: 'ODP';  Desc: 'LibreOffice Impress Presentation';  MediaType: mt_ODP;   MediaClass: mc_PowerPoint),
      ({mt_mts}  Ext: 'MTS';  Desc: 'Blu-Ray Video';                  MediaType: mt_MTS;   MediaClass: mc_Video),
      ({mt_XLS}  Ext: 'XLS';  Desc: 'Excel Spreadsheet';              MediaType: mt_XLS;   MediaClass: mc_Spreadsheet),
      ({mt_XLSX} Ext: 'XLSX'; Desc: 'Excel Spreadsheet';              MediaType: mt_XLSX;  MediaClass: mc_Spreadsheet),
      ({mt_PSH}  Ext: 'PSH';  Desc: 'Proshow Show';                   MediaType: mt_PSH;   MediaClass: mc_VideoProject),
      ({mt_PPR}  Ext: 'PPR';  Desc: 'Proshow Project';                MediaType: mt_PPR;   MediaClass: mc_VideoProject),
      ({mt_PDS}  Ext: 'PDS';  Desc: 'PowerDirector Project';          MediaType: mt_PDS;   MediaClass: mc_VideoProject),
      ({mt_MMP}  Ext: 'MMP';  Desc: 'Media Impression';               MediaType: mt_MMP;   MediaClass: mc_VideoProject),
      ({mt_VOB}  EXT: 'VOB';  Desc: 'Video from DVD';                 MediaType: mt_VOB;   MediaClass: mc_Video)(*,
      ({mt_PNG}  Ext: 'PNG';  Desc: 'Portable Network Graphic';       MediaType: mt_PNG;   MediaClass: mc_Photos)*)
    );

  LocationSourceStrings: array[TLocationSource] of string = (
      {ls_Unknown}   'Unknown',
      {ls_PhotoEXIF} 'Photo EXIF',
      {ls_GPSLogs}   'GPS Logs',
      {ls_Manual}    'Manual',
      {ls_FileName}  'File Name'
      );

  MediaClassInfoArray: array[TMediaClass] of TMediaClassInfo = (   // THIS IS OBSOLETE - Use MediaClass in MediaInfoArray instead
    ({mc_Unknown}     MediaClassName: 'All'),
    ({mc_Photos}      MediaClassName: 'Photo';       MediaTypes: [mt_JPG, mt_JPEG]),
    ({mc_Video}       MediaClassName: 'Video';       MediaTypes: [mt_RV, mt_WMV, mt_MPG, mt_AVI, mt_MOV, mt_MP4, mt_3GP, mt_M2TS, mt_MTS]),
    ({mc_Audio}       MediaClassName: 'Audio';       MediaTypes: [mt_RM, mt_RAD, mt_WAV, mt_MP3, mt_WMA, mt_M4A]),
    ({mc_DVD}         MediaClassName: 'DVD';         MediaTypes: [mt_ISO]),
    ({mc_Document}    MediaClassName: 'Document';    MediaTypes: [mt_PDF, mt_DOC, MT_docx, mt_TXT]),
    ({mc_Powerpoint}  MediaClassName: 'PowerPoint';  MediaTypes: [mt_PPT, mt_PPTX, mt_ODP]),
    ({mc_SpreadSheet} MediaClassName: 'SpreadSheet'; MediaTypes: [mt_XLS, mt_XLSX]),
    ({mc_VideoProject}MediaClassName: 'VideoProject';MediaTypes: [mt_PSH, mt_PPR, mt_PDS, mt_MMP])
  );

  UpdateReasons: array[TUpdateReason] of string =
    ({00: ur_GeneralEditing}                'General Editing',
     {01: ur_WasMissingNowFound}            'Was Missing, Now Found',    // OK
     {02: ur_KeywordsChanged}               'Keywords Changed',          // OK
     {03: ur_RemoveTrailingDate}            'Remove Trailing Date',      // OK
     {04: ur_DateTimeFromPhotoDate}         'DateTime From PhotoDate',   // OK
     {05: ur_DropTarget}                    'Drop Target',               // OK
     {06: ur_LocationFromEXIF}              'Location From EXIF',        // OK
     {07: ur_EnteredLocation}               'Entered Location',          // OK
     {08: ur_LocationEdited}                'Location Edited',           // OK
     {09: ur_LocationDeleted}               'Location Deleted',          // OK
     {10: ur_ClearLocationForSelected}      'Clear Location For Selected', // OK
     {11: ur_FillYearMonthDayFromPhotoDate} 'Fill Year Month Day From PhotoDate',  // OK
     {12: ur_WasScanned}                    'Was Scanned',               // OK
     {13: ur_KeywordsReplaced}              'Keywords Replaced',         // OK
     {14: ur_DatesTimesAdjusted}            'DatesTimes Adjusted',       // OK
     {15: ur_LocationChangedByNumber}       'Location Changed By Number', // OK
     {16: ur_FileRenamed}                   'File Renamed',               // OK
     {17: ur_RatingChanged}                 'Rating Changed',             // OK
     {18: ur_HasSound}                      'Has Sound',                  // OK
     {19: ur_UpdateFieldInSelectedRecords}  'Update Field In Selected Records', // OK
     {20: ur_ClearDistance}                 'Clear Distance',             // OK
     {21: ur_SettingDistance}               'Setting Distance',           // OK
     {22: ur_LatLonFromLocation}            'LatLon From Location',       // OK
     {23: ur_HeightWidthForSelectedPhotos}  'Height Width For Selected Photos',  // OK
     {24: ur_LoadTextFromFile}              'Load Text From File',
     {25: ur_LoadTextFromPDF}               'Load Text From PDF',
     {26: ur_FillPhotoDateTime}             'Fill Photo DateTime',       // OK
     {27: ur_ReplaceCurrentPhoto}           'Replace Current Photo',
     {28: ur_DateAddedFromFileDate}         'Date Added From File Date', // OK
     {29: ur_FileMover}                     'File Mover',                // OK
     {30: ur_FileMoverRenameFile}           'File Mover Rename File',    // OK
     {31: ur_FillFileSize}                  'Fill File Size',            // OK
     {32: ur_FillYearMonthDayFromPhotoDateTime} 'Fill Year Month Day from PhotoDateTime',  // NOT TESTED
     {33: ur_FileDateIsAGuess}              'File Date is a Guess',
     {34: ur_Imported}                      'Imported',
     {35: ur_PhotoInfoUpdated}              'Photo Info Updated',
     {36: ur_MediaLength}                   'Media Length set',
     {37: ur_CustomKeySet}                  'Custom Key Set'
    );

  gRootPath            : string;
  gExePath             : string;

function IsAudioMedia(mt: TMediaType): boolean;
function IsPhotoMedia(mt: TMediaType): boolean;
function IsVideoMedia(mt: TMediaType): boolean;
function IsOpenableFile(mt: TMediaType): boolean;
function MediaTypeFromExtension(Ext: string): TMediaType;
procedure SetWindowInfo(Form: TForm; const MyWindowInfo: TMyWindowInfo);
procedure SaveWindowInfo(Form: TForm; var MyWindowInfo: TMyWindowInfo);
function ValidPath(const FolderName: string; var ErrorMsg: string): boolean;

implementation

uses
  Registry, MyUtils, SysUtils;

procedure SaveWindowInfo(Form: TForm; var MyWindowInfo: TMyWindowInfo);
begin
  with MyWindowInfo, Form do
    begin
      TopLeft.X  := Left;
      TopLeft.Y  := Top;
      Size.X     := Width;
      Size.Y     := Height;
      TheState   := WindowState;
    end;
end;



procedure SetWindowInfo(Form: TForm; const MyWindowInfo: TMyWindowInfo);
begin
  with Form, MyWindowInfo do
    begin
      Left    := TopLeft.x;
      Top     := TopLeft.y;
      Width   := Size.x;
      Height  := Size.y;
      WindowState := TheState;
    end;
end;

function IsVideoMedia(mt: TMediaType): boolean;
begin
  result := (MediaInfoArray[mt].MediaClass = mc_Video) or (mt = mt_ISO);
end;

function IsAudioMedia(mt: TMediaType): boolean;
begin
  result := (MediaInfoArray[mt].MediaClass = mc_Audio) or (mt = mt_ISO);
end;

function IsOpenableFile(mt: TMediaType): boolean;
begin
  result := MediaInfoArray[mt].MediaClass in [mc_Photos, mc_Video, mc_Audio,
              mc_Document, mc_Powerpoint, mc_Spreadsheet, mc_VideoProject];
end;

function IsPhotoMedia(mt: TMediaType): boolean;
begin
  result := MediaInfoArray[mt].MediaClass = mc_Photos;
end;

function MediaTypeFromExtension(Ext: string): TMediaType;
var
  mt: TMediaType;
begin
  result := mt_Unk;
  if Length(Ext) >= 1 then
    if Ext[1] = '.' then
      Delete(Ext, 1, 1);
  for mt := Succ(Low(TMediaType)) to High(TMediaType) do
    if SameText(Ext, MediaInfoArray[mt].Ext) then
      begin
        result := mt;
        break;
      end;
end;

function ValidPath(const FolderName: string; var ErrorMsg: string): boolean;
var
  Temp: string;
begin
  Temp       := Copy(FolderName, 1, Length(gRootPath));
  result     := Sametext(gRootPath, Temp);
  if not result then
    ErrorMsg := Format('The path "%s"is not a sub-folder of "%s"', [FolderName, gRootPath])
end;

end.
