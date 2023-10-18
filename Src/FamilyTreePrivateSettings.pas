unit FamilyTreePrivateSettings;

interface

uses
  SettingsFiles, SysUtils, Classes;

const
  DEFAULT_IMAGES = 'Images\';
  DEFAULT_DOCS   = 'Docs\';
  DEFAULT_HTML_FOLDER = 'html\';
  DEFAULT_DATABASE_FILENAME = 'FamilyTree.accdb';
  cPhotoEditingProgram = 'c:\windows\system32\mspaint.exe';

type
  TFTPrivateSettings = class(TSettingsFile)
  private
    fExePath: string;
    fLocalWebFolder: string;
    fFamilyTreeDataBaseFileName: string;
    fNextAFN: integer;
    fLastAFN: string;
    fLastOrderFields: string;
    fFakeDABDNr: integer;
    fHTMLOutputFolder: string;
    fPhotoEditorPathName: string;
    function GetLocalWebFolder: string;
    function GetFamilyTreeDataBaseFileName: string;
    function GetFakeDABDNr: integer;
    function GetHTMLOutputFolder: string;
    procedure SetFamilyTreeDataBaseFileName(const Value: string);
    function GetPhotoEditorPathName: string;
    procedure IgnoreString(Reader: TReader);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    Destructor Destroy; override;
  published
    property ExePath: string
             read fExePath
             write fExePath;
    property FakeDABDNr: integer
             read GetFakeDABDNr
             write fFakeDABDNr;
    property FamilyTreeDataBaseFileName: string  // This is the full file path and file name of FamilyTree.accdb
             read GetFamilyTreeDataBaseFileName
             write SetFamilyTreeDataBaseFileName;
    property HTMLOutputFolder: string
             read GetHTMLOutputFolder
             write fHTMLOutputFolder;
    property LastAFN: string
             read fLastAFN
             write fLastAFN;
    property LastOrderFields: string
             read fLastOrderFields
             write fLastOrderFields;
    property LocalWebFolder: string   // this is the folder containing Photos\ and Docs\
             read GetLocalWebFolder
             write fLocalWebFolder;
    property NextAFN: integer
             read fNextAFN
             write fNextAFN;
    property PhotoDBDataBaseFileName: string
             read GetFamilyTreeDataBaseFileName
             write fFamilyTreeDataBaseFileName
             stored false;
//  property PhotoDBFolder: string
//           read GetPhotoDBFolder
//           write fPhotoDBFolder;
    property PhotoEditorPathName: string
             read GetPhotoEditorPathName
             write fPhotoEditorPathName;
  end;

var
  gPrivateSettings     : TFTPrivateSettings;

  gEXEPath2            : string; // '\\Newdell\newdell-c\Inetpub\wwwroot\MyWeb3\';
  gPHOTOPATH           : string; // ROOTPATH + 'images\';
  gDOCFILEPATH         : string; // ROOTPATH + 'Docs\';
  gTempFolder          : string; // C:\temp\
//gPhotoDBConnectionString: string;

function PrivateSettingsFileName: string;

implementation

uses
  MyUtils;

function PrivateSettingsFileName: string;
begin
  result := ForceExtension(ParamStr(0), 'ini');
end;

{ TFTPrivateSettings }

procedure TFTPrivateSettings.DefineProperties(Filer: TFiler);
begin
  inherited;
  with Filer do
    begin
      { obsolete stuff }
      DefineProperty('FamilyTreeDataBaseFieldName', IgnoreString, nil, false);
      DefineProperty('PhotoDBFolder',               IgnoreString, nil, false);

    end;
end;

procedure TFTPrivateSettings.IgnoreString(Reader: TReader);
begin
  Reader.ReadString;
end;

function TFTPrivateSettings.GetLocalWebFolder: string;
begin
  if Empty(fLocalWebFolder) then
    fLocalWebFolder := ForceBackSlash(ExtractFilePath(ParamStr(0)));
  Result := fLocalWebFolder;
end;

function TFTPrivateSettings.GetFamilyTreeDataBaseFileName: string;
// Note: fFamilyTreeDataBaseFileName ALWAYS contains the actual file name
begin
(*
  if Empty(fFamilyTreeDataBaseFileName) then
    case SettingsFileState of
      fsSaving:
        fFamilyTreeDataBaseFileName := CURRENT_USER_CONST + '\' + DEFAULT_DATABASE_FILENAME;
      fsLoading:
        fFamilyTreeDataBaseFileName := gEXEPath2 + DEFAULT_DATABASE_FILENAME;
      else
        raise Exception.Create('System Error in GetFamilyTreeDataBaseFileName');
    end;
  result := MakePathGeneric(fFamilyTreeDataBaseFileName, SettingsFileState = fsSaving)
*)
  if Empty(fFamilyTreeDataBaseFileName) then
    fFamilyTreeDataBaseFileName := gEXEPath2 + DEFAULT_DATABASE_FILENAME;
  result := fFamilyTreeDataBaseFileName;
end;

(*
function TFTPrivateSettings.GetPhotoDBFolder: string;
begin
  if Empty(fPhotoDBFolder) then
    fPhotoDBFolder := LocalWebFolder; // default to same directory as the executable
  Result := fPhotoDBFolder;
end;
*)

function TFTPrivateSettings.GetFakeDABDNr: integer;
begin
  if fFakeDABDNR = 0 then
    fFakeDABDNR := 9999;
  result := fFakeDABDNR;
  Dec(fFakeDABDNR);
end;

function TFTPrivateSettings.GetHTMLOutputFolder: string;
begin
  if fHTMLOutputFolder <> '' then
    Result := fHTMLOutputFolder
  else
    Result := gExePath2 + DEFAULT_HTML_FOLDER;;
end;

procedure TFTPrivateSettings.SetFamilyTreeDataBaseFileName(
  const Value: string);
begin
//fFamilyTreeDataBaseFileName := MakePathSpecific(Value, SettingsFileState = fsLoading);
  fFamilyTreeDataBaseFileName := Value;
end;

function TFTPrivateSettings.GetPhotoEditorPathName: string;
begin
  if fPhotoEditorPathName <> '' then
    Result := fPhotoEditorPathName
  else
    REsult := cPhotoEditingProgram;
end;

destructor TFTPrivateSettings.Destroy;
begin
  inherited;
end;

initialization
  gPrivateSettings := nil;
finalization
  FreeAndNil(gPrivateSettings);
end.
