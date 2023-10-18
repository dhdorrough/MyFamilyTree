unit MyTables;

interface

uses
  Classes, ADODB, MyTables_Decl, ParseExpr, DB;


type

  TMyTable = class(TADOTable)
  private
    function GetSelectivityParser: TParser;
  protected
    fDBFilePathName: string;
    fFilterExpression: string;
    fOptions: TPhotoTableOptions;
    fSelectivityParser: TParser;
    procedure InternalOpen; Override;
  public
    procedure AddFields; virtual;
    procedure AddField(aOwner: TDataSet; const FieldName,
      DisplayLabel: string; FieldClass: TFieldClass; FieldKind: TFieldKind;
      DisplayWidth, Size: integer); virtual;
    procedure InitFieldPtrs; Virtual;
    property Options: TPhotoTableOptions
             read fOptions
             write fOptions;
    property SelectivityParser: Tparser
             read GetSelectivityParser;
    function HasParser: boolean;
    procedure ClearParser; virtual;
    procedure AddOptionalFunctionsToParser(aParser: TParser); virtual;
    Constructor Create( aOwner: TComponent;
                        aDBFilePathName, aTableName: string;
                        Options: TPhotoTableOptions); reintroduce; virtual;
    destructor Destroy; override;
    procedure SetSelectivityParserExpression(const Expr: string); virtual;
    procedure MyDisableControls; virtual;
    procedure MyEnableControls; virtual;
    property DBFilePathName: string
             read fDBFilePathName;
  end;

  TMyQuery = class(TADOQuery)
  private
    function GetParser: Tparser;
  protected
    fParser: TParser;
  public
    property Parser: Tparser
             read GetParser;
    function HasParser: boolean;
    procedure AddOptionalFunctionsToParser; virtual;
  end;

  TConnectionInfo = record
    Provider: string;
    ConnectionString: string;
    ConnectionTypeName: string;
  end;

var
  gDBFileName: string;
  MyConnections: TStringList;

  ConnectionVersion: array[TDBVersion] of TConnectionInfo =
                       (
                        ({dv_Unknown}    Provider: ''; ConnectionString: ''),
                        ({dv_Access2000} Provider: ACCESS_2000_PROVIDER; ConnectionString: ACCESS_2000_CONNECTION_STRING; ConnectionTypeName: 'Access 2000'),
                        ({dv_Access2007} Provider: ACCESS_2007_PROVIDER; ConnectionString: ACCESS_2007_CONNECTION_STRING; ConnectionTypeName: 'Access 2007'),
                        ({dv_Access2019} Provider: ACCESS_2019_PROVIDER; ConnectionString: ACCESS_2019_CONNECTION_STRING; ConnectionTypeName: 'Access 2019')
                       );

function BuildConnectionString(const FileName: string): string;
function DBVersionFromFileName(const FileName: string): TDBVersion;
procedure FreeConnections;
function MyConnection(const DBFileName: string): TADOConnection;

implementation

uses
  SysUtils, MyUtils;

function DBVersionFromFileName(const FileName: string): TDBVersion;
var
  Ext: string;
begin
  result := dv_Unknown;
  Ext    := ExtractFileExt(FileName);
  if (Length(Ext) >= 1) and (Ext[1] = '.') then
    begin
      Ext := Copy(Ext, 2, Length(Ext)-1);
      if SameText(Ext, MDB_EXT) then
        result := dv_Access2000 else
      if SameText(Ext, ACCDB_EXT) then
        result := DBVersion;
    end;
end;

function BuildConnectionString(const FileName: string): string;
var
  DBVersion: TDBVersion;
begin
  DBVersion   := DBVersionFromFileName(FileName);
  with ConnectionVersion[DBVersion] do
    result := Format(ConnectionString, [Provider, FileName]);
end;

function MyConnection( const DBFileName: string): TADOConnection;
var
  idx: integer;
  aConnection: TADOConnection;
begin
  idx := MyConnections.IndexOf(DBFileName);
  if idx < 0 then
    begin
      aConnection := TADOConnection.Create(nil);

      aConnection.ConnectionString := BuildConnectionString(DBFileName); // Format(ConnectionString, [Provider, DBFileName]);

      aConnection.LoginPrompt := false;
      idx := MyConnections.AddObject(DBFileName, aConnection);
    end;

  result := TADOConnection(MyConnections.Objects[idx]);
end;

{ TMyTable }

procedure TMyTable.AddField( aOwner: TDataSet;
                    const FieldName, DisplayLabel: string;
                    FieldClass: TFieldClass;
                    FieldKind: TFieldKind;
                    DisplayWidth: integer;
                    Size: integer);
var
  aField: TField;
begin { AddField }
  aField              := FieldClass.Create(aOwner); // Does the dataset get set?
  aField.FieldName    := FieldName;
  aField.DisplayLabel := DisplayLabel;
  aField.FieldKind    := FieldKind;
//aField.DataType     := DataType;
  aField.DisplayWidth := DisplayWidth;
  aField.Size         := Size;
  aField.DataSet      := aOwner;
end;  { AddField }

procedure TMyTable.AddFields;
var
  i: integer;

begin { AddFields }
  // override, if necessary
  Fields.Clear;

  // Create persistant fields that do not exist
  FieldDefs.Update;
  for i := 0 to FieldDefs.Count-1 do
    begin
      if FindField(FieldDefs.Items[i].Name) = nil then
        FieldDefs.Items[i].CreateField(self);
    end;
end;  { AddFields }

procedure TMyTable.ClearParser;
begin
  FreeAndNil(fSelectivityParser);
end;

constructor TMyTable.Create(aOwner: TComponent; aDBFilePathName, aTableName: string;
  Options: TPhotoTableOptions);
begin
  inherited Create(aOwner);

  fDBFilePathName := aDBFilePathName;
  fOptions        := Options;

  Connection       := MyConnection(aDBFilePathName);
  TableName        := aTableName;
  TableDirect      := true;

  if optUseClient in Options then
    CursorLocation  := clUseClient
  else
    CursorLocation  := clUseServer;  // enabled 2/16/2005- trying to speed up

  if OptReadOnly in Options then
    LockType       := ltReadOnly;
end;

function TMyTable.GetSelectivityParser: TParser;
begin
  if not Assigned(fSelectivityParser) then
    begin
      fSelectivityParser := TParser.Create;
      AddOptionalFunctionsToParser(fSelectivityParser);
    end;
  result := fSelectivityParser;
end;

function TMyTable.HasParser: boolean;
begin
  result := Assigned(fSelectivityparser);
end;

procedure TMyTable.AddOptionalFunctionsToParser;
begin
end;

procedure TMyTable.SetSelectivityParserExpression(const Expr: string);
var
  ErrorMsg: string;
begin
  fFilterExpression := Expr;
  if not Empty(Expr) then
    begin
      if not SelectivityParser.Valid_Expr(Expr, self, ErrorMsg) then
        raise Exception.CreateFmt('The expression {%s} is not valid for the table %s [%s]',
          [Expr, TableName, ErrorMsg]);
    end
  else
    FreeAndNil(fSelectivityParser);
end;


destructor TMyTable.Destroy;
begin
  FreeAndNil(fSelectivityParser);
  inherited;
end;

procedure TMyTable.InternalOpen;
begin
  inherited;
  InitFieldPtrs;
end;

procedure TMyTable.InitFieldPtrs;
begin
  // override this
end;

procedure TMyTable.MyDisableControls;
begin
  DisableControls;
end;

procedure TMyTable.MyEnableControls;
begin
  EnableControls;
end;

{ TMyQuery }

procedure TMyQuery.AddOptionalFunctionsToParser;
begin
  inherited;
end;

function TMyQuery.GetParser: Tparser;
begin
  if not Assigned(fParser) then
    begin
      fParser := TParser.Create;
      AddOptionalFunctionsToParser;
    end;
  result := fParser;
end;

function TMyQuery.HasParser: boolean;
begin
  result := Assigned(fParser);
end;

procedure FreeConnections;
var
  i: integer;
begin
  if Assigned(MyConnections) then
    begin
      for i := MyConnections.Count-1 downto 0 do
        begin
          MyConnections.Objects[i].Free;
          MyConnections.Delete(i);
        end;
    end;
end;



initialization
  MyConnections := TStringList.Create;
  MyConnections.Duplicates := dupError;
finalization
  FreeConnections;
  FreeAndNil(MyConnections);
end.
