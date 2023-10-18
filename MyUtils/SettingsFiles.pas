unit SettingsFiles;

//*****************************************************************************
//   Function Name     : SettingsFiles
//                       Save settings
//                       Property of R & D Systems
//                       Canandaigua, NY 14424
//*******************************************************************************}

interface

uses
  Classes;

type
  TSettingsFileState = (fsUnknown, fsSaving, fsLoading);

  TSettingsFile = class(TComponent)
  private
    fOnSaveFile: TNotifyEvent;
    fOnLoadFile: TNotifyEvent;
    fOnLoadStream: TNotifyEvent;
    fSettingsFileState: TSettingsFileState;
  protected
    procedure LoadSettings; virtual; abstract;
    procedure SaveSettings(const SettingsFileName: string); virtual; abstract;
    procedure ClearSettings; virtual;
  public
    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    Constructor Create(aOwner: TComponent); override;
    Destructor Destroy; override; 

    property OnLoadFile: TNotifyEvent
             read fOnLoadFile
             write fOnLoadFile;
    property OnSaveFile: TNotifyEvent
             read fOnSaveFile
             write fOnSaveFile;
    property SettingsFileState: TSettingsFileState
             read fSettingsFileState;
  published
  end;

implementation

uses
  SysUtils, MyUtils;

{ TSettingsFile }

procedure TSettingsFile.ClearSettings;
begin
  // override this if needed
end;

constructor TSettingsFile.Create(aOwner: TComponent);
begin
  inherited;

end;

destructor TSettingsFile.Destroy;
begin

  inherited;
end;

procedure TSettingsFile.LoadFromFile(const FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream   := TFileStream.Create(FileName, fmOpenRead);

  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
    if Assigned(fOnLoadFile) then
      fOnLoadFile(self);
    fSettingsFileState := fsUnknown;
  end;
end;

procedure TSettingsFile.LoadFromStream(Stream: TStream);
var
  MemoryStream: TMemoryStream;
begin
  ClearSettings;
  MemoryStream := TMemoryStream.Create;

  fSettingsFileState := fsLoading;
  try
    ObjectTextToBinary(Stream, MemoryStream);
    MemoryStream.Position := 0;
    MemoryStream.ReadComponent(self);
  finally
    MemoryStream.Free;
    if Assigned(fOnLoadStream) then
      fOnLoadStream(self);
    fSettingsFileState := fsUnknown;
  end;
end;

procedure TSettingsFile.SaveToFile(const FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream   := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TSettingsFile.SaveToStream(Stream: TStream);
var
  MemoryStream: TMemoryStream;
begin
  MemoryStream := TMemoryStream.Create;

  fSettingsFileState := fsSaving;
  try
    MemoryStream.WriteComponent(self);
    MemoryStream.Position := 0;
    ObjectBinaryToText(MemoryStream, Stream);
    if Assigned(fOnSaveFile) then
      fOnSaveFile(self);
    fSettingsFileState := fsUnknown;
  finally
    MemoryStream.Free;
  end;

end;

end.
