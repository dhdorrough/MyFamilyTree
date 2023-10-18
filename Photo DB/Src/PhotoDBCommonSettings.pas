unit PhotoDBCommonSettings;

interface

uses
  SettingsFiles, Classes, PDB_Decl;

type
  TPhotoDBCommonSettings = class(TSettingsFile)
  private
    fCopyRight               : string;
    fDayCount                : integer;
    fDefaultLocationKind     : TDefaultLocationKind;
    fDefaultLocation         : string;
    fDefaultGPXFilter        : string;
    fExePath                 : string;
    fFolderNo                : integer;
    fImportExportFolder      : string;
    fInterval                : integer;
    fLocalCssLfn             : string;
    fLocalWebFolder          : string;
    fPhotoDBFolder           : string;
    fPhotoTableLastUsed      : TDateTime;
    fPhotoDBDatabaseFileName : string;
    fHikingDBDatabaseFileName: string;
    fPhotoEditingProgram     : string;
    fRecentOnly              : boolean;
    fRemoteCssLfn            : string;
//  fSynonymsFileName        : string;
    fUpdateDB                : boolean;
    fUseLocalCSS             : boolean;
    fUseSynonymsByDefault    : boolean;
    fSavedTrackDataLfn       : string;
    fCopyRightID             : string;
    fWebsiteURL              : string;
    fWebSitePassword         : string;
    fWebSiteUserID           : string;
    fWebSiteFilePath         : string;
    fAlternatePhotoEditingProgram: string;
    function GetPhotoDBDatabaseFileName: string;
    function GetLocalWebFolder: string;
    function GetPhotoDBFolder : string;
    function GetLocalCssLfn   : string;
    function GetPhotoEditingProgram: string;
    function GetRemoteCssLfn  : string;
//  function GetSynonymsFileName: string;
    procedure SetPhotoDBDatabaseFileName(const Value: string);
    procedure SetDefaultGPXFilter(const Value: string);
    function GetHikingDBDatabaseFileName: string;
    procedure SetHikingDBDatabaseFileName(const Value: string);
    function GetCopyRight: string;
    function GetSavedTrackDataLfn: string;
    function GetDefaultLocationKind: TDefaultLocationKind;
    procedure SetPhotoDBFolder(const Value: string);
    function GetImportExportFolder: string;
    procedure SetImportExportFolder(const Value: string);
    function GetAlternatePhotoEditingProgram: string;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure IgnoreString(Reader: TReader);
  public
    Constructor Create(aOwner: TComponent); override;
    Destructor Destroy; override;
    procedure LoadSettings; override;
    procedure SaveSettings(const SettingsFileName: string); override;
  published
    property CopyRight: string
             read GetCopyRight
             write fCopyRight;
    property CopyRightID: string
             read fCopyRightID
             write fCopyRightID;
    property DayCount: integer
             read fDayCount
             write fDayCount;
    property DefaultGPXFilter: string
             read fDefaultGPXFilter
             write SetDefaultGPXFilter;
    property DefaultLocation: string
             read fDefaultLocation
             write fDefaultLocation;
    property DefaultLocationKind: TDefaultLocationKind
             read GetDefaultLocationKind
             write fDefaultLocationKind;
    property ExePath: string
             read fExePath
             write fExePath;
    property FolderNo: integer
             read fFolderNo
             write fFolderNo;
    property LocalCssLfn: string
             read GetLocalCssLfn
             write fLocalCssLfn;
    property LocalWebFolder: string   // "C:\NewDell\NewDell-C\Inetpub\wwwroot\MyWeb2"
             read GetLocalWebFolder
             write fLocalWebFolder;
    property PhotoDBDatabaseFileName: string  // cRootPath + '\PhotoDB.mdb';
             read GetPhotoDBDatabaseFileName
             write SetPhotoDBDatabaseFileName;
    property HikingDBDatabaseFileName: string
             read GetHikingDBDatabaseFileName
             write SetHikingDBDatabaseFileName;
    property ImportExportFolder: string
             read GetImportExportFolder
             write SetImportExportFolder;
    property PhotoDBFolder: string           //
             read GetPhotoDBFolder
             write SetPhotoDBFolder;
    property PhotoEditingProgram: string
             read GetPhotoEditingProgram
             write fPhotoEditingProgram;
    property AlternatePhotoEditingProgram: string
             read GetAlternatePhotoEditingProgram
             write fAlternatePhotoEditingProgram;
    property PhotoTableLastUsed: TDateTime
             read fPhotoTableLastUsed
             write fPhotoTableLastUsed;
    property RecentOnly: boolean
             read fRecentOnly
             write fRecentOnly;
    property RemoteCssLfn: string
             read GetRemoteCssLfn
             write fRemoteCssLfn;
    property SavedTrackDataLfn: string  // should this be obsolete?
             read GetSavedTrackDataLfn
             write fSavedTrackDataLfn;
    property SlideShowInterval: integer
             read fInterval
             write fInterval;
    property UpdateDB: boolean
             read fUpdateDB
             write fUpdateDB;
    property UseLocalCSS: boolean
             read fUseLocalCSS
             write fUseLocalCSS;
    property UseSynonymsByDefault: boolean
             read fUseSynonymsByDefault
             write fUseSynonymsByDefault;
    property WebsiteURL: string
             read fWebsiteURL
             write fWebsiteURL;
    property WebSiteUserID: string
             read fWebSiteUserID
             write fWebSiteUserID;
    property WebSitePassword: string
             read fWebSitePassword
             write fWebSitePassword;
    property WebSiteFilePath: string
             read fWebSiteFilePath
             write fWebSiteFilePath;
  end;

var
  gCommonPhotoSettings: TPhotoDBCommonSettings;
  gUsingTemporarySettingsFile: boolean;
  gCommonSettingsFileName: string;

function CommonPhotoSettings: TPhotoDBCommonSettings;
function PrivateSettingsFileName: string;
function CommonSettingsFileName(ForceComputerName: boolean): string;

implementation

uses
  MyUtils, Registry, SysUtils{, Hiking_Decl};

function CommonPhotoSettings: TPhotoDBCommonSettings;
begin
  if not Assigned(gCommonPhotoSettings) then
    gCommonPhotoSettings := TPhotoDBCommonSettings.Create(nil);
  result := gCommonPhotoSettings;
end;

function PrivateSettingsFileName: string;
begin
  result := ForceExtension(ParamStr(0), 'ini');
end;

function CommonSettingsFileName(ForceComputerName: boolean): string;
var
  ExePath, Parameter1, NormalIniPath: string;
begin
  ExePath    := ExtractFilePath(ParamStr(0));
  Parameter1 := ParamStr(1);
  if Empty(gCommonSettingsFileName) then
    if (Empty(Parameter1)) then
      gCommonSettingsFileName := '.\PhotoDB.ini'  // default to simplest
    else
      begin
        gCommonSettingsFileName := Parameter1; // default to Parameter 1
  {$IfNDef debugging}
        MessageFmt('Settings file name: %s (from Parameter #1)', [gCommonSettingsFileName]);
  {$EndIf}
      end;

  if (Empty(Parameter1)) and (Empty(gCommonSettingsFileName) or ForceComputerName) then
    begin
      NormalIniPath := Format('%s%s-%s.%s', [ExePath, PHOTODB_, ComputerName, _INI]);
      if ForceComputerName then
        gCommonSettingsFileName := NormalIniPath
      else
        begin
          gCommonSettingsFileName := NormalIniPath;
          if not FileExists(gCommonSettingsFileName) then
            begin
              gCommonSettingsFileName := ExePath + PHOTODB__INI;  // See if an old version exists. If so, use it.
              if not FileExists(gCommonSettingsFileName) then
                gCommonSettingsFileName := NormalIniPath
            end;
        end;
    end;

  result := gCommonSettingsFileName;
end;

{ TPhotoDBCommonSettings }

procedure TPhotoDBCommonSettings.DefineProperties(Filer: TFiler);
begin
  inherited;
  with Filer do
    begin
      { obsolete stuff }
      DefineProperty('SavedTrackDataLfn',        IgnoreString, nil, false);
      DefineProperty('SynonymsFileName',         IgnoreString, nil, false);
    end;
end;

procedure TPhotoDBCommonSettings.IgnoreString(Reader: TReader);
begin
  Reader.ReadString;
end;

procedure TPhotoDBCommonSettings.LoadSettings;
var
  SettingsFileName: string;
begin { LoadSettings }
{$IfDef debugging}
  Message('Entering LoadSettings');
{$endIf}
  SettingsFileName := CommonSettingsFileName(true);
  if FileExists(SettingsFileName) then
    LoadFromFile(SettingsFileName)
  else    { set up some useable defaults }
    begin
      gRootPath               := RemoveTrailingBackSlash(ExtractFilePath(ParamStr(0)));
      ExePath                 := gRootPath;
      ChDir(gRootPath);

      CopyRight               := 'Copyright (c) 2020- Daniel H Dorrough';
      CopyRightID             := 'DHD';
      DefaultLocationKind     := dl_LastWord;
      PhotoDBDatabaseFileName := gRootPath + '\PhotoDB.mdb';

      ImportExportFolder      := 'c:\TEMP\';
      PhotoDBFolder           := gRootPath + '\My Pictures\';
      PhotoEditingProgram     := 'Paint.exe';
      PhotoTableLastUsed      := Now;
      RecentOnly              := true;
      UpdateDB                := true;
      UseSynonymsByDefault    := false;
    end;

  gRootPath := RemoveTrailingBackSlash(CommonPhotoSettings.PhotoDBFolder);    // never have trailing backslash '\' on gRootPath
  if (not Empty(gRootPath)) and DirectoryExists(gRootPath) then
    ChDir(gRootPath);
{$IfDef debugging}
  Message('Exiting LoadSettings');
{$endIf}
end;  { LoadSettings }

procedure TPhotoDBCommonSettings.SaveSettings(const SettingsFileName: string);
begin
  SaveToFile(SettingsFileName);
end;

constructor TPhotoDBCommonSettings.Create(aOwner: TComponent);
begin       
  inherited;
end;

destructor TPhotoDBCommonSettings.Destroy;
begin
  inherited;
end;

function TPhotoDBCommonSettings.GetLocalCssLfn: string;
begin
  Result := fLocalCssLfn
end;

function TPhotoDBCommonSettings.GetLocalWebFolder: string;
begin
  if Empty(fLocalWebFolder) then
    fLocalWebFolder := cLocalWebPath;
  Result := fLocalWebFolder;
end;

function TPhotoDBCommonSettings.GetPhotoDBDatabaseFileName: string;
begin
  if Empty(fPhotoDBDatabaseFileName) then
{$If MSACCESS_VERSION = 2000}
    fPhotoDBDataBaseFileName := ForceBackSlash(ExtractFilePath(ParamStr(0))) + 'PhotoDB.mdb';
{$IfEnd}
{$If MSACCESS_VERSION = 2007}
    fPhotoDBDataBaseFileName := ForceBackSlash(ExtractFilePath(ParamStr(0))) + 'PhotoDB.accdb';
{$IfEnd}
  result := fPhotoDBDataBaseFileName;
end;

function TPhotoDBCommonSettings.GetPhotoDBFolder: string;
begin
  if fPhotoDBFolder <> '' then
    Result := fPhotoDBFolder
  else
    begin
      fPhotoDBFolder := ForceBackSlash(ExtractFilePath(ParamStr(0))) + 'My Pictures\';
      Result         := fPhotoDBFolder
    end;
end;

procedure TPhotoDBCommonSettings.SetPhotoDBFolder(const Value: string);
begin
  fPhotoDBFolder := Value;
end;

function TPhotoDBCommonSettings.GetPhotoEditingProgram: string;
begin
  Result := fPhotoEditingProgram;
end;

function TPhotoDBCommonSettings.GetRemoteCssLfn: string;
begin
  Result := fRemoteCssLfn
end;

(*
function TPhotoDBCommonSettings.GetSynonymsFileName: string;  // OBSOLETE - now stored in a Lookups table
begin
  if Empty(fSynonymsFileName) then
    fSynonymsFileName := ForceBackSlash(PhotoDBFolder) + PHOTODB_SYNONYMS;
  Result := fSynonymsFileName;
end;
*)

procedure TPhotoDBCommonSettings.SetDefaultGPXFilter(const Value: string);
begin
  fDefaultGPXFilter := Value;
end;

procedure TPhotoDBCommonSettings.SetPhotoDBDatabaseFileName(
  const Value: string);
begin
  fPhotoDBDataBaseFileName := Value;
end;

function TPhotoDBCommonSettings.GetHikingDBDatabaseFileName: string;
begin
  result := fHikingDBDatabaseFileName;
end;

procedure TPhotoDBCommonSettings.SetHikingDBDatabaseFileName(
  const Value: string);
begin
  fHikingDBDatabaseFileName := Value;
end;

function TPhotoDBCommonSettings.GetCopyRight: string;
begin
  if Empty(fCopyRight) then
    result := '?'
  else
    result := fCopyRight;
end;

function TPhotoDBCommonSettings.GetSavedTrackDataLfn: string;
begin
  Result := fSavedTrackDataLfn;
end;

function TPhotoDBCommonSettings.GetDefaultLocationKind: TDefaultLocationKind;
begin
  if fDefaultLocationKind = dl_Unknown then
    fDefaultLocationKind := dl_LastWord;
  Result := fDefaultLocationKind;
end;

function TPhotoDBCommonSettings.GetImportExportFolder: string;
begin
  if not Empty(fImportExportFolder) then
    result := fImportExportFolder
  else
    result := 'C:\temp';
end;

procedure TPhotoDBCommonSettings.SetImportExportFolder(
  const Value: string);
begin
  fImportExportFolder := Value;
end;

function TPhotoDBCommonSettings.GetAlternatePhotoEditingProgram: string;
begin
  if Empty(fAlternatePhotoEditingProgram) then
    Result := 'c:\windows\system32\mspaint.exe'
  else
    Result := fAlternatePhotoEditingProgram;
end;

initialization
finalization
  FreeAndNil(gCommonPhotoSettings);
end.
