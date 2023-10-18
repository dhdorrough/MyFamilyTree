unit uLookupIndividual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Buttons, Grids, DBGrids, ExtCtrls, DBCtrls,
  Menus, FamilyTables, MyTables_Decl, FamilyTree_Decl;

type
  TfrmLookupIndividual = class(TForm)
    DBGrid1: TDBGrid;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    edtAFN: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtFirstName: TEdit;
    Label3: TLabel;
    edtLastName: TEdit;
    DBNavigator1: TDBNavigator;
    MainMenu1: TMainMenu;
    NAvigate1: TMenuItem;
    First1: TMenuItem;
    Last1: TMenuItem;
    Next1: TMenuItem;
    Previous1: TMenuItem;
    N1: TMenuItem;
    Add1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    SetFilter1: TMenuItem;
    N3: TMenuItem;
    ClearFilter1: TMenuItem;
    Order1: TMenuItem;
    CanonicalBirthdate1: TMenuItem;
    LastNameFirstName1: TMenuItem;
    AFN1: TMenuItem;
    LastNameCanonBirthFirstName1: TMenuItem;
    Label4: TLabel;
    edtMiddleName: TEdit;
    Post1: TMenuItem;
    DateAdded1: TMenuItem;
    DateUpdated1: TMenuItem;
    procedure edtAFNChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FamilyTable1BeforePost(DataSet: TDataSet);
    procedure FamilyTable1AfterInsert(DataSet: TDataSet);
    procedure edtLastNameChange(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtFirstNameChange(Sender: TObject);
    procedure First1Click(Sender: TObject);
    procedure Last1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure Previous1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure SetFilter1Click(Sender: TObject);
    procedure ClearFilter1Click(Sender: TObject);
    procedure CanonicalBirthdate1Click(Sender: TObject);
    procedure AFN1Click(Sender: TObject);
    procedure LastNameFirstName1Click(Sender: TObject);
    procedure LastNameCanonBirthFirstName1Click(Sender: TObject);
    procedure edtMiddleNameChange(Sender: TObject);
    procedure Post1Click(Sender: TObject);
    procedure DateAdded1Click(Sender: TObject);
    procedure DateUpdated1Click(Sender: TObject);
  private
    fBrowseMemoList: TList;
    fFindingAdvanced : boolean;
    fFamilyTable     : TFamilyTable;
    fDataSource1     : TDataSource;
    fSelectivityInfo  : TPersonInfo;
    fSettingFamilyInfo: boolean;
    fTableUpdated     : boolean;
    fAdvancedSearchForm: TForm;
    fDefPersonInfo    : TPersonInfo;
    fSelectedPersonInfoPtr: pFamilyInfo;
    procedure SetTheCaption(const Value: string);
    procedure FilterPersonFunction(DataSet: TDataSet; var Accept: Boolean);
    procedure SetSelectivityInfo(const Value: PFamilyInfo);
    procedure FamilyTableAfterPost(Dataset: TDataSet);
    procedure SetDefPersonInfo(const Value: PFamilyInfo);
    procedure SetSelectedPersonInfo(const Value: pFamilyInfo);
    function GetSelectedPersonInfo: pFamilyInfo;
    function GetBrowseMemoList: TList;
    procedure CloseMemos;
    { Private declarations }
  public
    { Public declarations }
    property BrowseMemoList: TList
             read GetBrowseMemoList;
    property SelectivityInfoPtr: PFamilyInfo
             write SetSelectivityInfo;
    property DefPersonInfoPtr: PFamilyInfo
             write SetDefPersonInfo;
    property SelectedPersonInfoPtr: pFamilyInfo
             read GetSelectedPersonInfo
             write SetSelectedPersonInfo;
    property TheCaption: string
             write SetTheCaption;
    property TableUpdated: boolean
             read fTableUpdated
             write fTableUpdated;
    function FamilyTable: TFamilyTable;
    Constructor Create(aOwner: TComponent; FindingAdvanced: boolean); reintroduce;
    Destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses MyUtils, uIndividual, SetFilter,
  PDBUtils, uGetString, PDB_Decl, StStrL, AdvancedSearch, uBrowseMemo,
  FamilyTreePrivateSettings, Math;

{ TfrmLookupIndividual }

procedure TfrmLookupIndividual.SetTheCaption(const Value: string);
begin
  Caption := Format('Lookup Individual (%s)', [Value]);
end;

procedure TfrmLookupIndividual.btnOkClick(Sender: TObject);
begin
  FamilyTable.LoadPersonInfo(fSelectedPersonInfoPtr^);

(*  // This FamilyTable is a read-only copy and cannot be updated

  // If we are just trying to attach a child record to a parent record, fill in the defaults to Mother & Father
  // or if we are just trying link to a spouse, fill in the default spouse.
  with FamilyTable do
    begin
      if (not Empty(fDefPersonInfo.Mother_AFN)) or
         (not Empty(fDefPersonInfo.Father_AFN)) or
         (not Empty(fDefPersonInfo.Spouse_AFN)) then
        begin
          Edit;
          with fDefPersonInfo do
            begin
              if not SameText(fldMother_AFN.AsString, Mother_AFN) then
                if Empty(fldMother_AFN.AsString) or
                   YesFmt('Override previous mother AFN (%s) with new mother AFN (%s)',
                          [fldMother_AFN.AsString, Mother_AFN]) then
                     fldMother_AFN.AsString := fDefPersonInfo.Mother_AFN;

              if not SameText(fldFather_AFN.AsString, Father_AFN) then
                if Empty(fldFather_AFN.AsString) or
                   YesFmt('Override previous father AFN (%s) with new father AFN (%s)',
                          [fldFather_AFN.AsString, Father_AFN]) then
                     fldFather_AFN.AsString := fDefPersonInfo.Father_AFN;

              if not SameText(fldSpouse_AFN.AsString, Spouse_AFN) then
                if Empty(fldSpouse_AFN.AsString) or
                   YesFmt('Override previous spouse AFN (%s) with new spouse AFN (%s)',
                          [fldSpouse_AFN.AsString, Spouse_AFN]) then
                     fldSpouse_AFN.AsString := fDefPersonInfo.Spouse_AFN;
            end;
        end;

      if State in [dsEdit, dsInsert] then
        Post;
    end;
*)
end;

procedure TfrmLookupIndividual.FamilyTableAfterPost(Dataset: TDataSet);
begin
  with Dataset do
    fDefPersonInfo.BirthPlace := FieldByName('BirthPlace').AsString; // if the birthplace has been changed, use it as the default for the next add
end;

procedure TfrmLookupIndividual.FamilyTable1BeforePost(DataSet: TDataSet);
begin
  with DataSet do
    begin
      if Empty(FieldByName('Sex').AsString) then
        if GetString('Sex must be entered', 'Sex', SelectedPersonInfoPtr^.Sex) then
          FieldByName('Sex').AsString := SelectedPersonInfoPtr^.Sex;
      FieldByName('DateUpdated').AsDateTime := Now;
      if FieldByName('DateAdded').IsNull then
        FieldByName('DateAdded').AsDateTime := Now;
    end;
end;

procedure TfrmLookupIndividual.FamilyTable1AfterInsert(DataSet: TDataSet);
var
  i: integer;
begin
  with DataSet do
    begin
(*
      if Empty(FieldByName('AFN').AsString) then
        begin
          FieldByName('AFN').AsString := RZero(NextAFN, 3);
          NextAFN := NextAFN + 1;
        end;
*)
      fSelectedPersonInfoPtr^.AFN := FieldByName(cAFN).AsString;
      if Empty(FieldByName('Sex').AsString) then
        FieldByName('Sex').AsString := fDefPersonInfo.Sex;
      if Empty(FieldByName('Mother_AFN').AsString) then
        FieldByName('Mother_AFN').AsString := fDefPersonInfo.Mother_AFN;
      if Empty(FieldByName('Father_AFN').AsString) then
        FieldByName('Father_AFN').AsString := fDefPersonInfo.Father_AFN;
      if Empty(FieldByName('BirthPlace').AsString) then
        FieldByName('BirthPlace').AsString := fDefPersonInfo.BirthPlace;
      if Empty(FieldByName('LastName').AsString) then
        FieldByName('LastName').AsString := fDefPersonInfo.LastName;
      if FieldByName(cSourceID1).IsNull then
        FieldByName(cSourceID1).AsInteger := fDefPersonInfo.SourceID1;
      if FieldByName(cSourceID2).IsNull then
        FieldByName(cSourceID2).AsInteger := fDefPersonInfo.SourceID2;
      if Empty(FieldByName('Ref').AsString) then
        FieldByName('Ref').AsString := fDefPersonInfo.Ref;

      // Select the firstname column when adding a record
      DBGrid1.SetFocus;
      for i := 0 to DBGrid1.FieldCount - 1 do
        begin
          if SameText(DBGrid1.Fields[i].FieldName, 'FirstName') then
            begin
              DBGrid1.SelectedField := DBGrid1.Fields[i];
              Break;
            end;
        end;
    end;
  fTableUpdated := true;
end;

constructor TfrmLookupIndividual.Create(aOwner: TComponent; FindingAdvanced: boolean);
const
  NEEDED_HEIGHT = 529;
  NEEDED_WIDTH  = 1224;
begin
  inherited Create(aOwner);
  BorderStyle         := bsSizeable;
  Width               := Math.Min(NEEDED_WIDTH, ClientWidth);
  Height              := Math.Min(NEEDED_HEIGHT, ClientHeight);
  HorzScrollBar.Range := NEEDED_WIDTH;
  VertScrollBar.Range := NEEDED_HEIGHT;

  fFindingAdvanced             := FindingAdvanced;
  FamilyTable.Active           := true;
  DBGrid1.DataSource           := fDataSource1;
  DBNavigator1.DataSource      := fDataSource1;
end;

procedure TfrmLookupIndividual.FilterPersonFunction(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := true;
  Assert(Dataset = FamilyTable, 'System error in Lookup Individual');
  with fSelectivityInfo, FamilyTable do
   if Filtered then
    begin
      if Accept and (not Empty(AFN)) then
        Accept := Pos(AFN, UpperCase(fldAFN.AsString)) > 0;
      if Accept and (not Empty(FirstName)) then
        Accept := Pos(FirstName, UpperCase(fldFirstName.AsString)) > 0;
      if Accept and (not Empty(LastName)) then
        Accept := (Pos(LastName, UpperCase(fldLastName.AsString)) > 0) or
                  (Soundex(LastName) = Soundex(fldLastName.AsString));
      if Accept and (not Empty(MiddleName)) then
        Accept := Pos(MiddleName, UpperCase(fldMiddleName.AsString)) > 0;
      if fFindingAdvanced then
        begin
          if Accept and (not Empty(Prefix)) then
            Accept := Pos(Prefix, UpperCase(fldPrefix.AsString)) > 0;
          if Accept and (not Empty(NickName)) then
            Accept := Pos(NickName, UpperCase(fldNickName.AsString)) > 0;
          if Accept and (not Empty(Suffix)) then
            Accept := Pos(Suffix, UpperCase(fldSuffix.AsString)) > 0;
          if Accept and (not Empty(BirthDate)) then
            Accept := Pos(BirthDate, UpperCase(fldBirthDate.AsString)) > 0;
          if Accept and (not Empty(DeathDate)) then
            Accept := Pos(DeathDate, UpperCase(fldDeathDate.AsString)) > 0;
          if Accept and (not Empty(CanonBirth)) then
            Accept := Pos(CanonBirth, UpperCase(fldCanonBirth.AsString)) > 0;
          if Accept and (not Empty(CanonDeath)) then
            Accept := Pos(CanonDeath, UpperCase(fldCanonDeath.AsString)) > 0;
          if Accept and (not Empty(Spouse_AFN)) then                            // currently unused
            Accept := Pos(Spouse_AFN, UpperCase(fldSpouse_AFN.AsString)) > 0;
          if Accept and (not Empty(Father_AFN)) then                            // currently unused
            Accept := Pos(Father_AFN, UpperCase(fldFather_AFN.AsString)) > 0;
          if Accept and (not Empty(Mother_AFN)) then                            // currently unused
            Accept := Pos(Mother_AFN, UpperCase(fldMother_AFN.AsString)) > 0;
          if Accept and (not Empty(Image)) then                                 // currently unused
            Accept := Pos(Image, UpperCase(fldImage.AsString)) > 0;
          if Accept and (not Empty(BirthPlace)) then
            Accept := Pos(BirthPlace, UpperCase(fldBirthPlace.AsString)) > 0;
          if Accept and (not Empty(DeathPlace)) then
            Accept := Pos(DeathPlace, UpperCase(fldDeathPlace.AsString)) > 0;
          if Accept and (not Empty(Sex)) then
            Accept := Pos(Sex, UpperCase(fldSex.AsString)) > 0;

          if Accept and (DateAddedLow <> BAD_DATE) then
            Accept := Trunc(fldDateAdded.AsDateTime) >= DateAddedLow;
          if Accept and (DateAddedHigh <> BAD_DATE) then
            Accept := Trunc(fldDateAdded.AsDateTime) <= DateAddedHIgh;

          if Accept and (DateUpdatedLow <> BAD_DATE) then
            Accept := Trunc(fldDateUpdated.AsDateTime) >= DateUpdatedLow;
          if Accept and (DateUpdatedHigh <> BAD_DATE) then
            Accept := Trunc(fldDateUpdated.AsDateTime) <= DateUpdatedHIgh;

          if Accept and (not Empty(Comments)) then
            Accept := Pos(Comments, UpperCase(fldComments.AsString)) > 0;
          if Accept and (not Empty(Ref)) then
            Accept := Pos(Ref, UpperCase(fldRef.AsString)) > 0;
          if Accept and (not Empty(Expr)) then
            with FamilyTable.SelectivityParser.Eval_Tree do
              begin
                EvaluateTree;
                Accept := AsBoolean;
              end;
        end;
    end;
end;

procedure TfrmLookupIndividual.DBGrid1DblClick(Sender: TObject);
var
  aBrowseMemo: TfrmBrowseMemo;
  i: integer;
begin
  aBrowseMemo := nil;
  for i := 0 to BrowseMemoList.Count-1 do
    if DBGrid1.SelectedField = TfrmBrowseMemo(BrowseMemoList.Items[i]).SelectedField then
      begin
        aBrowseMemo := TfrmBrowseMemo(BrowseMemoList[i]);
        break;
      end;
  if not Assigned(aBrowseMemo) then
    begin
      aBrowseMemo := TfrmBrowseMemo.Create(self, fDataSource1, DBGrid1.SelectedField, bhAsText);
      BrowseMemoList.Add(aBrowseMemo);
    end;
  aBrowseMemo.Show;
end;

procedure TfrmLookupIndividual.edtFirstNameChange(Sender: TObject);
begin
  if not fSettingFamilyInfo then
    begin
      FamilyTable.Filtered := false;

      fSelectivityInfo.FirstName := UpperCase(edtFirstName.Text);
      FamilyTable.OnFilterRecord := FilterPersonFunction;
      FamilyTable.Filtered       := HasFilterInfo(fSelectivityInfo);
    end;
end;

procedure TfrmLookupIndividual.edtLastNameChange(Sender: TObject);
begin
  if not fSettingFamilyInfo then
    begin
      FamilyTable.Filtered := false;

      fSelectivityInfo.LastName  := UpperCase(edtLastName.Text);
      FamilyTable.OnFilterRecord := FilterPersonFunction;
      FamilyTable.Filtered       := HasFilterInfo(fSelectivityInfo);
    end;
end;

procedure TfrmLookupIndividual.edtAFNChange(Sender: TObject);
begin
  if not fSettingFamilyInfo then
    begin
      FamilyTable.Filtered := false;

      fSelectivityInfo.AFN       := UpperCase(edtAFN.Text);
      FamilyTable.OnFilterRecord := FilterPersonFunction;
      FamilyTable.Filtered       := HasFilterInfo(fSelectivityInfo);
    end;
end;

function TfrmLookupIndividual.FamilyTable: TFamilyTable;
begin
  if not Assigned(fFamilyTable) then
    begin
      fFamilyTable := TFamilyTable.Create( self,
                                           gPrivateSettings.FamilyTreeDataBaseFileName,
                                           cFAMILY,
                                           [optUseClient, optReadOnly]);
      with fFamilyTable do
        begin
          AfterInsert     := FamilyTable1AfterInsert;
          BeforePost      := FamilyTable1BeforePost;
          AfterPost       := FamilyTableAfterPost;
          IndexFieldNames := 'LastName;CanonBirth;FirstName';
          TableName       := cFAMILY;
        end;
    end;
  result := fFamilyTable;
  if not Assigned(fDataSource1) then
    begin
      fDataSource1 := TDataSource.Create(self);
      fDataSource1.DataSet      := fFamilyTable;
    end;
end;

procedure TfrmLookupIndividual.First1Click(Sender: TObject);
begin
  FamilyTable.First;
end;

procedure TfrmLookupIndividual.Last1Click(Sender: TObject);
begin
  FamilyTable.Last;
end;

procedure TfrmLookupIndividual.Next1Click(Sender: TObject);
begin
  FamilyTable.Next;
end;

procedure TfrmLookupIndividual.Previous1Click(Sender: TObject);
begin
  FamilyTable.Prior;
end;

procedure TfrmLookupIndividual.Add1Click(Sender: TObject);
begin
  FamilyTable.Append;
end;

procedure TfrmLookupIndividual.Close1Click(Sender: TObject);
begin
  if FamilyTable.State in [dsEdit, dsInsert] then
    FamilyTable.Post;
  ModalResult := mrOK;
  Close;
end;

procedure TfrmLookupIndividual.SetSelectivityInfo(const Value: PFamilyInfo);
var
  ErrorMsg: string;
begin
  fSettingFamilyInfo := true;
  try
    edtFirstName.Text  := UpperCase(Value^.FirstName);
    edtMiddleName.Text := UpperCase(Value^.MiddleName);
    edtLastName.Text   := Uppercase(Value^.LastName);
    fSelectivityInfo   := Value^;
    if fFindingAdvanced then
      begin
        with fSelectivityInfo do
          begin
            AFN        := UpperCase(AFN);
            Prefix     := UpperCase(Prefix);
            FirstName  := UpperCase(FirstName);
            MiddleName := UpperCase(MiddleName);
            LastName   := UpperCase(LastName);
            NickName   := UpperCase(NickName);
            Suffix     := UpperCase(Suffix);
            Spouse_AFN := UpperCase(Spouse_AFN);
            Father_AFN := UpperCase(Father_AFN);
            Mother_AFN := UpperCase(Mother_AFN);
            Image      := UpperCase(Image);
            BirthPlace := UpperCase(BirthPlace);
            DeathPlace := UpperCase(DeathPlace);
            Sex        := UpperCase(Sex);
            Ref        := UpperCase(Ref);
            Dataset    := FamilyTable;
          end;
      with FamilyTable do
        begin
//        OnFilterRecord := FilterPersonFunction;
          if not SelectivityParser.Valid_Expr(fSelectivityInfo.Expr, FamilyTable, ErrorMsg) then
            AlertFmt('Invalid expression [%s] for family table', [ErrorMsg]);
//        Filtered       := true;
        end;
      end;
    FamilyTable.Filtered := false;
    FamilyTable.OnFilterRecord := FilterPersonFunction;
    FamilyTable.Filtered       := HasFilterInfo(fSelectivityInfo);
  finally
    fSettingFamilyInfo := false;
  end;
end;

procedure TfrmLookupIndividual.SetFilter1Click(Sender: TObject);
begin
  fSelectivityInfo.DataSet := FamilyTable;
  if not Assigned(fAdvancedSearchForm) then
    fAdvancedSearchForm := TfrmAdvancedSearch.Create(self, @fSelectivityInfo);
  (fAdvancedSearchForm as TfrmAdvancedSearch).SelectivityInfoPtr := @fSelectivityInfo;
  if fAdvancedSearchForm.ShowModal = mrOk then
    with FamilyTable do
      begin
        Filtered := false;
        fFindingAdvanced := true;
        SetSelectivityInfo(@fSelectivityInfo);
      end;
end;

procedure TfrmLookupIndividual.CloseMemos;
var
  i: integer;
begin
  if Assigned(fBrowseMemoList) then
    begin
      for i := 0 to BrowseMemoList.Count-1 do
        TForm(BrowseMemoList[i]).Free;
      FreeAndNil(fBrowseMemoList);
    end;
end;

destructor TfrmLookupIndividual.Destroy;
begin
  CloseMemos;
  FreeAndNil(fAdvancedSearchForm);
  inherited;
end;

procedure TfrmLookupIndividual.SetDefPersonInfo(const Value: PFamilyInfo);
begin
  fDefPersonInfo := Value^;
end;

procedure TfrmLookupIndividual.SetSelectedPersonInfo(
  const Value: pFamilyInfo);
begin
  fSelectedPersonInfoPtr := Value;
end;

function TfrmLookupIndividual.GetSelectedPersonInfo: pFamilyInfo;
begin
  result := fSelectedPersonInfoPtr;
end;

procedure TfrmLookupIndividual.ClearFilter1Click(Sender: TObject);
begin
  InitPersonInfo(fSelectivityInfo);
  FamilyTable.SetSelectivityParserExpression(fSelectivityInfo.Expr);
  FamilyTable.Filtered := false;
end;

procedure TfrmLookupIndividual.CanonicalBirthdate1Click(Sender: TObject);
begin
  FamilyTable.IndexFieldNames := 'CanonBirth';
end;

procedure TfrmLookupIndividual.AFN1Click(Sender: TObject);
begin
  FamilyTable.IndexFieldNames := cAFN;
end;

procedure TfrmLookupIndividual.LastNameFirstName1Click(Sender: TObject);
begin
  FamilyTable.IndexFieldNames := 'LastName,FirstName';
end;

procedure TfrmLookupIndividual.LastNameCanonBirthFirstName1Click(
  Sender: TObject);
begin
  FamilyTable.IndexFieldNames := 'LastName,CanonBirth,FirstName';
end;

function TfrmLookupIndividual.GetBrowseMemoList: TList;
begin
  if not Assigned(fBrowseMemoList) then
    fBrowseMemoList := TList.Create;
  result := fBrowseMemoList;
end;

procedure TfrmLookupIndividual.edtMiddleNameChange(Sender: TObject);
begin
  if not fSettingFamilyInfo then
    begin
      FamilyTable.Filtered := false;

      fSelectivityInfo.MiddleName := UpperCase(edtMiddleName.Text);
      FamilyTable.OnFilterRecord  := FilterPersonFunction;
      FamilyTable.Filtered        := HasFilterInfo(fSelectivityInfo);
    end;
end;

procedure TfrmLookupIndividual.Post1Click(Sender: TObject);
begin
  FamilyTable.Post;
end;

procedure TfrmLookupIndividual.DateAdded1Click(Sender: TObject);
begin
  FamilyTable.IndexFieldNames := 'DateAdded';
end;

procedure TfrmLookupIndividual.DateUpdated1Click(Sender: TObject);
begin
  FamilyTable.IndexFieldNames := 'DateUpdated';
end;

end.
