unit FamilyTables;

interface
  uses
    ADODB, DB, Classes, MyTables, MyTables_Decl, ParseExpr, FamilyTree_Decl;

const
  cSourceID1 = 'SourceID1';
  cSourceID2 = 'SourceID2';
  cFAMILY    = 'Family';
  cAFN       = 'AFN';

  MOTHER_AFN = 'Mother_AFN';
  FATHER_AFN = 'Father_AFN';
  SPOUSE_AFN = 'Spouse_AFN';
  
  AFN_WIDTH  = 6;
  AFN_FIELD_SIZE = 10;

type

  TGenealogySourcesTable = class(TMyTable)
  protected
    procedure DoAfterOpen; override;
    procedure DoBeforePost; override;
  public
    fldID: TField;
    fldSource: TField;
    fldAbbrev: TField;
    fldAuthor: TField;
  end;

  TFamilyQuery = class(TMyQuery)
  protected
    procedure DoAfterOpen; override;
    procedure DoBeforeOpen; override;
    procedure DoBeforePost; override;
    procedure DoAfterClose; override;
  public
    fldAFN: TField;
    fldPrefix: TField;
    fldFirstName: TField;
    fldMiddleName: TField;
    fldLastName: TField;
    fldNickName: TField;
    fldDocFile: TField;
    fldDocDescription: TField;
    fldSuffix: TField;
    fldBirthDate: TField;
    fldDeathDate: TField;
    fldBirthOrder: TField;
    fldCanonBirth: TField;
    fldCanonDeath: TField;
    fldSpouse_AFN: TField;
    fldFather_AFN: TField;
    fldMother_AFN: TField;
    fldImage: TField;
    fldBirthPlace: TField;
    fldDeathPlace: TField;
    fldSex: TField;
    fldDateUpdated: TField;
    fldSourceID1: TField;
    fldSourceID2: TField;
    fldRef: TField;
    fldComments: TField;
    fldDateAdded: TField;
    function FullName: string;
    procedure LoadPersonInfo(var PersonInfo: TPersonInfo);
    Constructor Create(aOwner: TComponent); override;
  end;

  TFamilyTable = class(TMyTable)
  private
    procedure GetIsRelatedTo(Eval_Tree: TEval_Tree);
    procedure GetIsChildOf(Eval_Tree: TEval_Tree);
    procedure GetNumberOfChildren(Eval_Tree: TEval_Tree);
    procedure GetBirthDay(Eval_Tree: TEval_Tree);
    procedure GetBirthMonth(Eval_Tree: TEval_Tree);
    procedure GetBirthYear(Eval_Tree: TEval_Tree);
    procedure GetDeathDay(Eval_Tree: TEval_Tree);
    procedure GetDeathMonth(Eval_Tree: TEval_Tree);
    procedure GetDeathYear(Eval_Tree: TEval_Tree);
    function CanonicalDate(Field: TField): string;
  protected
    procedure DoAfterOpen; override;
    procedure DoBeforeOpen; override;
    procedure DoBeforePost; override;
//  procedure DoAfterInsert; override;
  public
    fldAFN: TField;
    fldPrefix: TField;
    fldFirstName: TField;
    fldMiddleName: TField;
    fldLastName: TField;
    fldNickName: TField;
    fldDocFile: TField;
    fldDocDescription: TField;
    fldSearch: TField;
    fldSuffix: TField;
    fldBirthDate: TField;
    fldDeathDate: TField;
    fldBirthOrder: TField;
    fldCanonBirth: TField;
    fldCanonDeath: TField;
    fldSpouse_AFN: TField;
    fldFather_AFN: TField;
    fldMother_AFN: TField;
    fldImage: TField;
    fldBirthPlace: TField;
    fldDeathPlace: TField;
    fldSex: TField;
    fldDateUpdated: TField;
    fldSourceID1: TField;
    fldSourceID2: TField;
    fldRef: TField;
    fldComments: TField;
    fldDateAdded: TField;

    fFamilyQuery: TFamilyQuery;

    Constructor Create(aOwner: TComponent;
                       aDBFilePathName, aTableName: string;
                       Options: TPhotoTableOptions); override;
    procedure AddOptionalFunctionsToParser(aParser: TParser); override;
    function  FullName: string;
    function  UpdateCanonicalDate: boolean;
    procedure LoadPersonInfo(var PersonInfo: TPersonInfo);
    procedure SavePersonInfo(var PersonInfo: TPersonInfo);
//  procedure RecalcNextAFN;
    function FamilyQuery: TFamilyQuery;
  end;

var
//  NextAFN: integer;
  gTag: integer;

function HasFilterInfo(const FamilyInfo: TPersonInfo): boolean;
procedure InitPersonInfo(var PersonInfo: TPersonInfo);

implementation

uses
  uIndividual, SysUtils, PDBUtils, MyUtils, FamilyTreePrivateSettings;

procedure InitPersonInfo(var PersonInfo: TPersonInfo);
begin
  with PersonInfo do
    begin
      AFN        := '';
      Prefix     := '';
      FirstName  := '';
      MiddleName := '';
      LastName   := '';
      NickName   := '';
      Suffix     := '';
      BirthDate  := '';
      BirthOrder := '';
      DeathDate  := '';
      CanonBirth := '';
      CanonDeath := '';
      Spouse_AFN := '';
      Father_AFN := '';
      Mother_AFN := '';
      Image      := '';
      BirthPlace := '';
      DeathPlace := '';
      Sex        := '';
      DateUpdated    := BAD_DATE;
      DateAdded      := BAD_DATE;

      DateAddedLow   := BAD_DATE;
      DateAddedHigh  := BAD_DATE;

      DateUpdatedLow := BAD_DATE;
      DateUpdatedHigh:= BAD_DATE;

      Comments   := '';
      DataSet    := nil;
      Expr       := '';
      SourceID1  := 0;
      SourceID2  := 0;
      Ref        := '';
    end;
end;


function HasFilterInfo(const FamilyInfo: TPersonInfo): boolean;
begin
  result := false;
  with FamilyInfo do
    begin
      if not Empty(AFN) then
        result := true else
      if not Empty(Prefix) then
        result := true else
      if not Empty(FirstName) then
        result := true else
      if not Empty(MiddleName) then
        result := true else
      if not Empty(LastName) then
        result := true else
      if not Empty(NickName) then
        result := true else
      if not Empty(Suffix) then
        result := true else
      if not Empty(BirthDate) then
        result := true else
      if not Empty(BirthOrder) then
        result := true else
      if not Empty(DeathDate) then
        result := true else
      if not Empty(CanonBirth) then
        result := true else
      if not Empty(CanonDeath) then
        result := true else
      if not Empty(Spouse_AFN) then
        result := true else
      if not Empty(Father_AFN) then
        result := true else
      if not Empty(Mother_AFN) then
        result := true else
      if not Empty(Image) then
        result := true else
      if not Empty(BirthPlace) then
        result := true else
      if not Empty(DeathPlace) then
        result := true else
      if not Empty(Sex) then
        result := true else
      if DateAddedLow <> BAD_DATE then
        result := true else
      if DateAddedHigh <> BAD_DATE then
        result := true else
      if DateUpdatedLow <> BAD_DATE then
        result := true else
      if DateUpdatedHigh <> BAD_DATE then
        result := true else
      if not Empty(Comments) then
        result := true else
      if not Empty(Expr) then
        result := true else
      if not Empty(Ref) then
        result := true;
    end;
end;

{ TFamilyTable }

procedure TFamilyTable.GetIsChildOf(Eval_Tree: TEval_Tree);
var
  TargetAFN: string;
begin
  with Eval_Tree do
    begin
      TargetAFN := Arg[1].AsString;
      if (not Empty(TargetAFN)) then
        begin
          AsBoolean := (TargetAFN = fldFather_AFN.AsString) or
                       (TargetAFN = fldMother_AFN.AsString)
        end
      else
        raise ESyntaxError.Create('System error: IsParentOf: argument is empty');
    end;
end;

procedure TFamilyTable.GetIsRelatedTo(Eval_Tree: TEval_Tree);
var
  TargetAFN: string;
begin { TFamilyTable.GetIsRelatedTo }
  with Eval_Tree do
    begin
      if (not Empty(Arg[1].AsString)) then
        begin
          TargetAFN := Arg[1].AsString;
          AsBoolean := {(TargetAFN = fldAFN.AsString) or} // ignore relation = self
                       (TargetAFN = fldFather_AFN.AsString) or
                       (TargetAFN = fldMother_AFN.AsString) or
                       (TargetAFN = fldSpouse_AFN.AsString)
        end
      else
        raise ESyntaxError.Create('System error: IsRelatedTo: argument is empty');
    end;
end;  { TFamilyTable.GetIsRelatedTo }

procedure TFamilyTable.GetNumberOfChildren(Eval_Tree: TEval_Tree);
var
  result: integer;
  AFN: string;
  SQLString: string;
begin
  AFN := fldAFN.AsString;
  with FamilyQuery do
    begin
//    ConnectionString := gPhotoDBConnectionString;
//    Connection       := MyConnection(gPhotoDBConnectionString);
      Connection       := MyConnection(gPrivateSettings.FamilyTreeDataBaseFileName);
      SQL.Clear;
      SQLString := 'SELECT AFN FROM Family ' +
                   'WHERE (Father_AFN = "' + AFN + '") OR (Mother_AFN = "' + AFN + '")';
      SQL.Add(SQLString);
      ExecSQL;
      Active := true;
      First;
      result := 0;
      while not EOF do
        begin
          Inc(result);
          Next;
        end;
      Eval_Tree.AsInteger := result;
    end;
end;

function TFamilyTable.CanonicalDate(Field: TField): string;
begin
  result := PadR(Field.AsString, 8, '0');
end;

procedure TFamilyTable.GetBirthYear(Eval_Tree: TEval_Tree);
begin
  try
    Eval_Tree.AsInteger := StrToInt(Copy(CanonicalDate(fldCanonBirth), 1, 4));
  except
    Eval_Tree.AsInteger := 0;
  end;
end;

procedure TFamilyTable.GetBirthMonth(Eval_Tree: TEval_Tree);
begin
  try
    Eval_Tree.AsInteger := StrToInt(Copy(CanonicalDate(fldCanonBirth), 5, 2));
  except
    Eval_Tree.AsInteger := 0;
  end;
end;

procedure TFamilyTable.GetBirthDay(Eval_Tree: TEval_Tree);
begin
  try
    Eval_Tree.AsInteger := StrToInt(Copy(CanonicalDate(fldCanonBirth), 7, 2));
  except
    Eval_Tree.AsInteger := 0;
  end;
end;

procedure TFamilyTable.GetDeathYear(Eval_Tree: TEval_Tree);
begin
  try
    Eval_Tree.AsInteger := StrToInt(Copy(CanonicalDate(fldCanonDeath), 1, 4));
  except
    Eval_Tree.AsInteger := 0;
  end;
end;

procedure TFamilyTable.GetDeathMonth(Eval_Tree: TEval_Tree);
begin
  try
    Eval_Tree.AsInteger := StrToInt(Copy(CanonicalDate(fldCanonDeath), 5, 2));
  except
    Eval_Tree.AsInteger := 0;
  end;
end;

procedure TFamilyTable.GetDeathDay(Eval_Tree: TEval_Tree);
begin
  try
    Eval_Tree.AsInteger := StrToInt(Copy(CanonicalDate(fldCanonDeath), 7, 2));
  except
    Eval_Tree.AsInteger := 0;
  end;
end;

constructor TFamilyTable.Create(aOwner: TComponent;
                       aDBFilePathName, aTableName: string;
                       Options: TPhotoTableOptions);
begin
  inherited;
  CursorType := ctDynamic;
end;

procedure TFamilyTable.DoAfterOpen;
begin
  fldAFN         := FieldByName(cAFN);
  fldPrefix      := FieldByName('Prefix');
  fldFirstName   := FieldByName('FirstName');
  fldMiddleName  := FieldByName('MiddleName');
  fldLastName    := FieldByName('LastName');
  fldSuffix      := FieldByName('Suffix');
  fldNickName    := FieldByName('NickName');
  fldDocFile     := FieldByName('DocFile');
  fldDocDescription := FieldByName('DocDescription');
  fldSearch      := FieldByName('Search');

  fldBirthDate   := FieldByName('BirthDate');
  fldBirthOrder  := FieldByName('BirthOrder');
  fldDeathDate   := FieldByName('DeathDate');
  fldSpouse_AFN  := FieldByName(SPOUSE_AFN);
  fldFather_AFN  := FieldByName(FATHER_AFN);
  fldMother_AFN  := FieldByName(MOTHER_AFN);
  fldImage       := FieldByName('Image');
  fldCanonBirth  := FieldByName('CanonBirth');
  fldCanonDeath  := FieldByName('CanonDeath');
  fldBirthPlace  := FieldByName('BirthPlace');
  fldDeathPlace  := FieldByName('DeathPlace');
  fldSex         := FieldByName('Sex');
  fldDateUpdated := FieldByName('DateUpdated');
  fldSourceID1   := FieldByName('SourceID1');
  fldSourceID2   := FieldByName('SourceID2');
  fldRef         := FieldByName('Ref');
  fldComments    := FieldByName('Comments');
  fldDateAdded   := FieldByName('DateAdded');
  fldDateUpdated := FieldByName('DateUpdated');

  Assert(fldAFN.Size = AFN_FIELD_SIZE);
  Assert(fldSpouse_AFN.Size = AFN_FIELD_SIZE);
  Assert(fldFather_AFN.Size = AFN_FIELD_SIZE);
  Assert(fldMother_AFN.Size = AFN_FIELD_SIZE);
end;

procedure TFamilyTable.DoBeforeOpen;
begin
  inherited;
end;

procedure TFamilyTable.DoBeforePost;
begin
  fldDateUpdated.AsDateTime := Now;
  UpdateCanonicalDate;
  if Empty(fldAFN.AsString) then
    begin
      fldAFN.AsString := RZero(gPrivateSettings.NextAFN, AFN_WIDTH);
//    NextAFN := NextAFN + 1;  // moved to OnBeforePost  
    end;
  inherited;
end;

//*****************************************************************************
//   Function Name     : UpdateCanonicalDate
//   Useage            : if UpdateCanonicalDate then...
//   Function Purpose  : Convert dates in odd formats into canonical format for easy comparison
//   Assumptions       :
//   Parameters        :
//   Return Value      : TRUE if the db was changed
//*******************************************************************************}

function TFamilyTable.UpdateCanonicalDate: boolean;
var
  Temp: string;
begin { TFamilyTable.UpdateCanonicalDate }
  result := false;
  if ConvertToCanonical(fldBirthDate.AsString, temp) then
    begin
      result := fldCanonBirth.AsString <> temp;
      if result then
        fldCanonBirth.AsString := temp;
    end (* leave the canonical date alone - it may have been entered manually
  else
    begin
      result := not fldCanonBirth.IsNull;
      if result then
        fldCanonBirth.Clear;
    end *);

  if ConvertToCanonical(fldDeathDate.AsString, temp) then
    begin
      result := result or (fldCanonDeath.AsString <> temp);
      if result then
        fldCanonDeath.AsString := temp;
    end (* leave the canonical date alone - it may have been entered manually
  else
    begin
      result := result or (not fldCanonDeath.IsNull);
      if not fldCanonDeath.IsNull then
        fldCanonDeath.Clear;
    end *);
end;  { TFamilyTable.UpdateCanonicalDate }

procedure TFamilyTable.AddOptionalFunctionsToParser(aParser: TParser);
begin
  inherited;
  with aParser do
    begin
      InitFunc(funcExtra, 'IsRelatedTo',      ftBoolean, 1, 1, symIntRef, symUnknown, symUnknown, symUnknown, 'IsRelatedTo([AFN])', GetIsRelatedTo);
      InitFunc(funcExtra, 'IsChildOf',        ftBoolean, 1, 1, symIntRef, symUnknown, symUnknown, symUnknown, 'IsChildOf([AFN])',   GetIsChildOf);
      InitFunc(funcExtra, 'NumberOfChildren', ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'NumberOfChildren()', GetNumberOfChildren);
      InitFunc(funcExtra, 'BirthYear',        ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'BirthYear()',        GetBirthYear);
      InitFunc(funcExtra, 'BirthMonth',       ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'BirthMonth()',       GetBirthMonth);
      InitFunc(funcExtra, 'BirthDay',         ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'BirthDay()',         GetBirthDay);
      InitFunc(funcExtra, 'DeathYear',        ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'DeathYear()',        GetDeathYear);
      InitFunc(funcExtra, 'DeathMonth',       ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'DeathMonth()',       GetDeathMonth);
      InitFunc(funcExtra, 'DeathDay',         ftInteger, 0, 0, symUnknown,symUnknown, symUnknown, symUnknown, 'DeathDay()',         GetDeathDay);
    end;
end;

procedure TFamilyTable.LoadPersonInfo(var PersonInfo: TPersonInfo);
var
  Canonical: string;
begin
  with PersonInfo do
    begin
      AFN        := fldAFN.AsString;
      Prefix     := fldPrefix.AsString;
      FirstName  := fldFirstName.AsString;
      MiddleName := fldMiddleName.AsString;
      LastName   := fldLastName.AsString;
      NickName   := fldNickName.AsString;
      DocFile    := fldDocFile.AsString;
      DocDescription := fldDocDescription.AsString;
      Suffix     := fldSuffix.AsString;
      BirthDate  := fldBirthDate.AsString;
      BirthOrder := fldBirthOrder.AsString;
      DeathDate  := fldDeathDate.AsString;
      CanonBirth := fldCanonBirth.AsString;
      if Empty(CanonBirth) then
        if ConvertToCanonical(BirthDate, Canonical) then
          CanonBirth := Canonical;
      CanonDeath := fldCanonDeath.AsString;
      if Empty(CanonDeath) then
        if ConvertToCanonical(DeathDate, Canonical) then
          CanonDeath := Canonical;
      Spouse_AFN := fldSpouse_AFN.AsString;
      Father_AFN := fldFather_AFN.AsString;
      Mother_AFN := fldMother_AFN.AsString;
      Image      := fldImage.AsString;
      BirthPlace := fldBirthPlace.AsString;
      DeathPlace := fldDeathPlace.AsString;
      Sex        := fldSex.AsString;
  //  DateUpdated: string;
      Comments   := fldComments.AsString;
      SourceID1  := fldSourceID1.AsInteger;
      SourceID2  := fldSourceID2.AsInteger;
      Ref        := fldRef.AsString;
    end;
end;

function TFamilyTable.FullName: string;
begin
  result := MyUtils.FullName(fldPrefix.AsString, fldFirstName.AsString, fldMiddleName.AsString, fldLastName.AsString, fldSuffix.AsString, fldNickName.AsString)
end;

procedure TFamilyTable.SavePersonInfo(var PersonInfo: TPersonInfo);
var
  Canonical: string;
begin
  with PersonInfo do
    begin
      fldAFN.AsString        := AFN;
      fldPrefix.AsString     := Prefix;

      if Empty(FirstName) and Empty(LastName) then
        begin
          Alert('Both FirstName and LastName are blank. Record was not saved');
          Exit;
        end;

      if not Empty(FirstName) then
        fldFirstName.AsString  := FirstName
      else
        fldFirstName.AsString := UNKNOWNP;

      fldMiddleName.AsString := MiddleName;

      if not Empty(LastName) then
        fldLastName.AsString   := LastName
      else
        fldLastName.AsString := UNKNOWNP;

      fldNickName.AsString   := NickName;
      fldDocFile.AsString    := DocFile;
      fldDocDescription.AsString := DocDescription;
      fldSuffix.AsString     := Suffix;

      fldBirthDate.AsString  := BirthDate;
      fldBirthOrder.AsString := BirthOrder;

      if Empty(CanonBirth) then
        if ConvertToCanonical(fldBirthDate.AsString, Canonical) then
          fldCanonBirth.AsString := Canonical;

      fldDeathDate.AsString  := DeathDate;

      if Empty(CanonDeath) then
        if ConvertToCanonical(fldDeathDate.AsString, Canonical) then
          fldCanonDeath.AsString := Canonical;

      fldSpouse_AFN.AsString      := Spouse_AFN;
      fldFather_AFN.AsString      := Father_AFN;
      fldMother_AFN.AsString      := Mother_AFN;
      fldImage.AsString           := Image;
      fldBirthPlace.AsString      := BirthPlace;
      fldDeathPlace.AsString      := DeathPlace;
      fldSex.AsString             := Sex;
      fldComments.AsString        := Comments;
      fldSourceID1.AsInteger      := SourceID1;
      fldSourceID2.AsInteger      := SourceID2;
      fldRef.AsString             := Ref;
    end;
end;

(*
procedure TFamilyTable.RecalcNextAFN;
var
  TempFamilyTable: TFamilyTable;
begin
  TempFamilyTable := TFamilyTable.Create(self, DBFilePathName, cFAMILY, [optUseClient]);
  with TempFamilyTable do
    begin
      Active := true;
      First;
      while not eof do
        begin
          if IsPureNumeric(fldAFN.AsString) and (fldAFN.AsInteger > NextAFN) then
            NextAFN := fldAFN.AsInteger;
          Next;
        end;
    end;
  TempFamilyTable.Free;
  NextAFN := NextAFN + 1;
end;
*)

(*
procedure TFamilyTable.DoAfterInsert;
begin
  inherited;
  fldAFN.AsString := Rzero(NextAFN, AFN_WIDTH);
  fldDateAdded.AsDateTime := Now;
  Inc(NextAFN);
end;
*)
(*
procedure TFamilyTable.OnPostError;
begin
  inherited;

end;
*)

function TFamilyTable.FamilyQuery: TFamilyQuery;
begin
  if not Assigned(fFamilyQuery) then
    begin
      fFamilyQuery            := TFamilyQuery.Create(self);
      fFamilyQuery.Connection := MyConnection(gPrivateSettings.FamilyTreeDataBaseFileName);
    end;
  result := fFamilyQuery;
end;

{ TGenealogySourcesTable }

procedure TGenealogySourcesTable.DoAfterOpen;
begin
  inherited;
  fldID     := FieldByName('ID');
  fldSource := FieldByName('Source');
  fldAbbrev := FieldByName('Abbrev');
  fldAuthor := FieldByName('Author');
end;

procedure TGenealogySourcesTable.DoBeforePost;
begin
end;

{ TFamilyQuery }

constructor TFamilyQuery.Create(aOwner: TComponent);
begin
  inherited;
  Assert(CursorLocation = clUseClient, 'System error: unexpected cursor location');
end;

procedure TFamilyQuery.DoAfterClose;
begin
  inherited;
  fldAFN                := nil;
  fldPrefix             := nil;
  fldFirstName          := nil;
  fldMiddleName         := nil;
  fldLastName           := nil;
  fldSuffix             := nil;
  fldNickName           := nil;
  fldDocFile            := nil;
  fldDocDescription     := nil;
  fldBirthDate          := nil;
  fldBirthOrder         := nil;
  fldDeathDate          := nil;
  fldSpouse_AFN         := nil;
  fldFather_AFN         := nil;
  fldMother_AFN         := nil;
  fldImage              := nil;
  fldCanonBirth         := nil;
  fldCanonDeath         := nil;
  fldBirthPlace         := nil;
  fldDeathPlace         := nil;
  fldSex                := nil;
  fldDateUpdated        := nil;
  fldSourceID1          := nil;
  fldSourceID2          := nil;
  fldRef                := nil;
  fldComments           := nil;
  fldDateAdded          := nil;
  fldDateUpdated        := nil;
end;

procedure TFamilyQuery.DoAfterOpen;
begin
  inherited;
  fldAFN                := FindField(cAFN);
  fldPrefix             := FindField('Prefix');
  fldFirstName          := FindField('FirstName');
  fldMiddleName         := FindField('MiddleName');
  fldLastName           := FindField('LastName');
  fldSuffix             := FindField('Suffix');
  fldNickName           := FindField('NickName');
  fldDocFile            := FindField('DocFile');
  fldDocDescription     := FindField('DocDescription');
  fldBirthDate          := FindField('BirthDate');
  fldBirthOrder         := FindField('BirthOrder');
  fldDeathDate          := FindField('DeathDate');
  fldSpouse_AFN         := FindField(SPOUSE_AFN);
  fldFather_AFN         := FindField(FATHER_AFN);
  fldMother_AFN         := FindField(MOTHER_AFN);
  fldImage              := FindField('Image');
  fldCanonBirth         := FindField('CanonBirth');
  fldCanonDeath         := FindField('CanonDeath');
  fldBirthPlace         := FindField('BirthPlace');
  fldDeathPlace         := FindField('DeathPlace');
  fldSex                := FindField('Sex');
  fldDateUpdated        := FindField('DateUpdated');
  fldSourceID1          := FindField('SourceID1');
  fldSourceID2          := FindField('SourceID2');
  fldRef                := FindField('Ref');
  fldComments           := FindField('Comments');
  fldDateAdded          := FindField('DateAdded');
  fldDateUpdated        := FindField('DateUpdated');
  Tag                   := gTag;
  Inc(gTag);
end;

procedure TFamilyQuery.DoBeforeOpen;
begin
  inherited;

end;

procedure TFamilyQuery.DoBeforePost;
begin
  if Assigned(fldDateUpdated) then
    fldDateUpdated.AsDateTime := Now;
(*
  if Assigned(fldAFN) then
    if Empty(fldAFN.AsString) then
      begin
        fldAFN.AsString := RZero(NextAFN, AFN_WIDTH);
        NextAFN := NextAFN + 1;
      end;
*)
  inherited;
end;

function TFamilyQuery.FullName: string;

function F(fld: TField): string;
begin
  if Assigned(fld) then
    result := fld.AsString
  else
    result := '';
end;

begin
  result := MyUtils.FullName(F(fldPrefix), F(fldFirstName), F(fldMiddleName), F(fldLastName), F(fldSuffix), F(fldNickName))
end;

procedure TFamilyQuery.LoadPersonInfo(var PersonInfo: TPersonInfo);
var
  Canonical: string;
  
  function F(Field: TField): string;
  begin
    if Assigned(Field) then
      result := Field.AsString
    else
      result := '';
  end;

begin { TFamilyQuery.LoadPersonInfo }
  with PersonInfo do
    begin
      AFN        := F(fldAFN);
      Prefix     := F(fldPrefix);
      FirstName  := F(fldFirstName);
      MiddleName := F(fldMiddleName);
      LastName   := F(fldLastName);
      NickName   := F(fldNickName);
      DocFile    := F(fldDocFile);
      DocDescription := F(fldDocDescription);
      Suffix     := F(fldSuffix);
      BirthDate  := F(fldBirthDate);
      BirthOrder := F(fldBirthOrder);
      DeathDate  := F(fldDeathDate);
      CanonBirth := F(fldCanonBirth);
      if Empty(CanonBirth) then
        if ConvertToCanonical(BirthDate, Canonical) then
          CanonBirth := Canonical;
      CanonDeath := F(fldCanonDeath);
      if Empty(CanonDeath) then
        if ConvertToCanonical(DeathDate, Canonical) then
          CanonDeath := Canonical;
      Spouse_AFN := F(fldSpouse_AFN);
      Father_AFN := F(fldFather_AFN);
      Mother_AFN := F(fldMother_AFN);
      Image      := F(fldImage);
      BirthPlace := F(fldBirthPlace);
      DeathPlace := F(fldDeathPlace);
      Sex        := F(fldSex);
  //  DateUpdated: string;
      Comments   := F(fldComments);
      if Assigned(fldSourceID1) then
        SourceID1  := fldSourceID1.AsInteger;
      if Assigned(fldSourceID2) then
        SourceID2  := fldSourceID2.AsInteger;
      Ref        := F(fldRef);
    end;
end;  { TFamilyQuery.LoadPersonInfo }

initialization
  gTag := 0;
end.
