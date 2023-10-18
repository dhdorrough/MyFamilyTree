unit LookupsTableUnit;

interface

uses
  SysUtils, DB, Classes, ADODB, PDB_Decl, PDBUtils, MyUtils, MyTables_Decl,
  MyTables;

const
  CKEYVALUE = 'KeyValue';
  CLOOKUPVALUE = 'LookupValue';
  cLOOKUPNAME  = 'LookupName';
  cLOOKUPS     = 'Lookups';

type
  TLookupCategory = (lc_All, lc_Exp, lc_Fil, lc_FuncKey, lc_Help, lc_Syn, lc_NoiseWords);

  TLookupsTable = class(TMyTable)
  private
    procedure FilterLookupsTable(DataSet: TDataSet; var Accept: boolean);
  public
    fldLookupName: TField;
    fldLookupValue: TField;
    fldLookupCategory: TField;
    fLookupCategory: TLookupCategory;
    Constructor Create( aOwner: TComponent;
                        aDBFilePathName, aTableName: string;
                        Options: TPhotoTableOptions;
                        LookupCategory: TLookupCategory); reintroduce; virtual;
    procedure DoBeforePost; override;
    procedure InitFieldPtrs; override;
  end;

  TFuncKeyTable = class(TMyTable)
  private
  public
    fldKeyName: TField;
    fldKeyValue: TField;
    Constructor Create( aOwner: TComponent;
                        aDBFilePathName, aTableName: string;
                        Options: TPhotoTableOptions); reintroduce; virtual;
    procedure InitFieldPtrs; override;
  end;

  TSynonymsTable = class(TLookupsTable)
  end;

  THelpTable = class(TLookupsTable)
  end;

  TLookupInfo = record
    Cat: string[3];
    Desc: string[20];
  end;

var
  LookupInfoArray: array[TLookupCategory] of TLookupInfo = (
    ({lc_all}        Cat: 'ALL'; Desc: 'All Lookups'),
    ({lc_Exp}        Cat: 'EXP'; Desc: 'Saved Expressions'),
    ({lc_Fil}        Cat: 'FIL'; Desc: 'Saved Filters'),
    ({lc_Key}        Cat: 'KEY'; Desc: 'Function Keys'),
    ({lc_Help}       Cat: 'HLP'; Desc: 'Help'),
    ({lc_Syn}        Cat: 'SYN'; Desc: 'Synonyms'),
    ({lc_NoiseWords} Cat: 'NSE'; Desc: 'Noise Words')
  );

implementation

uses PhotoDBCommonSettings;

{ TLookupsTable }

Constructor TLookupsTable.Create( aOwner: TComponent;
                        aDBFilePathName, aTableName: string;
                        Options: TPhotoTableOptions;
                        LookupCategory: TLookupCategory);
begin
  inherited Create( aOwner,
                    aDBFilePathName, aTableName,
                    Options);
  fLookupCategory  := LookupCategory;
  Filtered         := true;
  OnFilterRecord   := FilterLookupsTable;
end;

procedure TLookupsTable.FilterLookupsTable(DataSet: TDataSet; var Accept: boolean);
begin                             
  Assert(Dataset = self, 'System error in FilterLookupsTable');
  if not Assigned(fldLookupCategory) then
    InitFieldPtrs;

  if fLookupCategory = lc_all then
    Accept := true
  else
    Accept := SameText(fldLookupCategory.AsString, LookupInfoArray[fLookupCategory].Cat);
end;

procedure TLookupsTable.InitFieldPtrs;
begin
  fldLookupName     := FieldByName(cLOOKUPNAME);
  fldLookupValue    := FieldByName(cLOOKUPVALUE);
  fldLookupCategory := FieldByName('LookupCategory');
end;


procedure TLookupsTable.DoBeforePost;
begin
  inherited;
  fldLookupCategory.AsString := LookupInfoArray[fLookupCategory].Cat;
end;

{ TFuncKeyTable }

constructor TFuncKeyTable.Create(aOwner: TComponent; aDBFilePathName,
  aTableName: string; Options: TPhotoTableOptions);
begin
  inherited Create( aOwner,
                    aDBFilePathName, aTableName,
                    Options);
end;

procedure TFuncKeyTable.InitFieldPtrs;
begin
  inherited;
  fldKeyName     := FieldByName('KeyName');
  fldKeyValue    := FieldByName(CKEYVALUE);
end;

{ TSynonymsTable }



end.
