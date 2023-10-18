unit AdvancedSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, FamilyTables, ParseExpr, Menus, FamilyTree_Decl,
  ExtCtrls;

type
  TSearchMode = (smSearch, smEdit);

  TfrmAdvancedSearch = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblComments: TLabel;
    Label13: TLabel;
    lblDocFileName: TLabel;
    lblDocDescription: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    lblCanonDeath: TLabel;
    edtFirstName: TEdit;
    edtMiddleName: TEdit;
    edtLastName: TEdit;
    edtBirthDate: TEdit;
    edtDeathDate: TEdit;
    edtSex: TEdit;
    edtAFN: TEdit;
    edtBirthPlace: TEdit;
    edtSearch: TEdit;
    edtComments: TMemo;
    edtDocFileName: TEdit;
    edtDocDescription: TEdit;
    edtDABD: TEdit;
    edtSuffix: TEdit;
    edtDeathPlace: TEdit;
    edtPrefix: TEdit;
    edtCanonBirth: TEdit;
    edtCanonDeath: TEdit;
    lblSearch: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    btnClearAll: TButton;
    btnExpression: TButton;
    mmoExpression: TMemo;
    Label12: TLabel;
    edtRef: TEdit;
    edtDateAddedLow: TEdit;
    lblDateAdded: TLabel;
    edtDateUpdatedLow: TEdit;
    lblDateUpdated: TLabel;
    PopupMenu1: TPopupMenu;
    Parseselectedtextasname1: TMenuItem;
    SelectedTextToBirthDate1: TMenuItem;
    SelectedtexttoBirthPlace1: TMenuItem;
    SelectedtexttoDeathDate1: TMenuItem;
    SelectedtexttoDeathPlace1: TMenuItem;
    N1: TMenuItem;
    SelectedtexttoBirthDateBirthPlace1: TMenuItem;
    SelectedtexttoDeathDatePlace1: TMenuItem;
    lblNickName: TLabel;
    edtNickName: TEdit;
    pnlSearch: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    edtDateAddedHigh: TEdit;
    edtDateUpdatedHigh: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnExpressionClick(Sender: TObject);
    procedure Parseselectedtextasname1Click(Sender: TObject);
    procedure SelectedTextToBirthDate1Click(Sender: TObject);
    procedure SelectedtexttoBirthPlace1Click(Sender: TObject);
    procedure SelectedtexttoDeathDate1Click(Sender: TObject);
    procedure SelectedtexttoDeathPlace1Click(Sender: TObject);
    procedure SelectedtexttoBirthDateBirthPlace1Click(Sender: TObject);
    procedure SelectedtexttoDeathDatePlace1Click(Sender: TObject);
    procedure edtSexChange(Sender: TObject);
    procedure edtFirstNameChange(Sender: TObject);
    procedure edtLastNameChange(Sender: TObject);
  private
    { Private declarations }
    fSelectivityInfoPtr: pFamilyInfo;
    ffrmExpression: TForm;
    fSearchMode: TSearchMode;
    procedure Enable_Buttons;
    procedure SetSelectivityInfoPtr(const Value: pFamilyInfo);
    procedure ParseDateAndPlace(const temp: string; var Date, Place: string);
  public
    { Public declarations }
    Constructor Create(aOwner: TComponent; aSelectivityInfoPtr: pFamilyInfo; SearchMode: TSearchMode = smSearch); reintroduce; virtual;
    property SelectivityInfoPtr: pFamilyInfo
             read fSelectivityInfoPtr
             write SetSelectivityInfoPtr;
  end;


implementation

uses Expression, MyTables, MyUtils, StStrL, FamilyTree_Utils;

{$R *.dfm}

procedure TfrmAdvancedSearch.btnOkClick(Sender: TObject);
begin
  with fSelectivityInfoPtr^ do
    begin
      if fSearchMode = smSearch then
        begin
          AFN        := UpperCase(edtAFN.Text);
          Prefix     := UpperCase(edtPrefix.Text);
          FirstName  := UpperCase(edtFirstName.Text);
          MiddleName := UpperCase(edtMiddleName.Text);
          LastName   := UpperCase(edtLastName.Text);
          NickName   := UpperCase(edtNickName.Text);
          Suffix     := UpperCase(edtSuffix.Text);
          BirthDate  := UpperCase(edtBirthDate.Text);
          DeathDate  := UpperCase(edtDeathDate.Text);
          BirthPlace := UpperCase(edtBirthPlace.Text);
          DeathPlace := UpperCase(edtDeathPlace.Text);
          Sex        := UpperCase(edtSex.Text);
          Comments   := UpperCase(edtComments.Text);
          Ref        := UpperCase(edtRef.Text);
          Expr       := mmoExpression.Text;

          if not Empty(edtDateAddedLow.Text) then
            DateAddedLow  := StrToDate(edtDateAddedLow.Text)
          else
            DateAddedLow  := BAD_DATE;

          if not Empty(edtDateAddedHigh.Text) then
            DateAddedHigh  := StrToDate(edtDateAddedHigh.Text)
          else
            DateAddedHigh  := BAD_DATE;

          if not Empty(edtDateUpdatedLow.Text) then
            DateUpdatedLow := StrToDate(edtDateUpdatedLow.Text)
          else
            DateUpdatedLow := BAD_DATE;

          if not Empty(edtDateUpdatedHigh.Text) then
            DateUpdatedHigh := Trunc(StrToDate(edtDateUpdatedHigh.Text))
          else
            DateUpdatedHigh := BAD_DATE;
        end
      else
        begin
          AFN        := edtAFN.Text;
          Prefix     := edtPrefix.Text;
          FirstName  := edtFirstName.Text;
          MiddleName := edtMiddleName.Text;
          LastName   := edtLastName.Text;
          NickName   := edtNickName.Text;
          Suffix     := edtSuffix.Text;
          BirthDate  := edtBirthDate.Text;
          DeathDate  := edtDeathDate.Text;
          BirthPlace := edtBirthPlace.Text;
          DeathPlace := edtDeathPlace.Text;
          Sex        := edtSex.Text;
          Comments   := edtComments.Text;
          Ref        := edtRef.Text;

          if not Empty(edtDateAddedLow.Text) then
            DateAdded  := StrToDate(edtDateAddedLow.Text)
          else
            DateAdded  := BAD_DATE;

          if not Empty(edtDateUpdatedLow.Text) then
            DateUpdated := StrToDate(edtDateUpdatedLow.Text)
          else
            DateUpdated := BAD_DATE;
        end;
      CanonBirth := edtCanonBirth.Text;
      CanonDeath := edtCanonDeath.Text;
    end;
end;

constructor TfrmAdvancedSearch.Create(aOwner: TComponent;
  aSelectivityInfoPtr: pFamilyInfo; SearchMode: TSearchMode = smSearch);
var
  OldBottom: integer;
begin
  inherited Create(aOwner);
  fSelectivityInfoPtr := aSelectivityInfoPtr;
  fSearchMode := SearchMode;
  pnlsearch.Visible := fSearchMode = smSearch;
  case SearchMode of
    smSearch:
      begin
        Caption := 'Advanced Search';
        btnExpression.Visible := true;
//      edtDateAddedLow.Visible := true;
//      lblDateAdded.Visible := true;
//      edtDateUpdatedLow.Visible := true;
//      lblDateUpdated.Visible := true;
        edtDocFileName.Visible := true;
        lblDocFileName.Visible := true;
        edtDocDescription.Visible := true;
        lblDocDescription.Visible := true;
      end;
    smEdit:
      Begin
        Caption := 'Edit Personal information';
        btnExpression.Visible := false;
//      edtDateAddedLow.Visible := false;
//      lblDateAdded.Visible := false;
//      edtDateUpdatedLow.Visible := false;
//      lblDateUpdated.Visible := false;
        edtDocFileName.Visible := false;
        lblDocFileName.Visible := false;
        edtDocDescription.Visible := false;
        lblDocDescription.Visible := false;
        OldBottom                 := edtComments.Top + edtComments.Height;
        lblComments.Top           := lblDocFileName.Top;
        edtComments.Top           := edtDocFileName.Top;
        edtComments.Height        := OldBottom - edtComments.Top;
      end;
  end;
  Enable_Buttons;
end;

procedure TfrmAdvancedSearch.btnClearAllClick(Sender: TObject);
begin
  edtAFN.Text         := '';
  edtPrefix.Text      := '';
  edtFirstName.Text   := '';
  edtMiddleName.Text  := '';
  edtLastName.Text    := '';
  edtNickName.Text    := '';
  edtSuffix.Text      := '';
  edtBirthDate.Text   := '';
  edtDeathDate.Text   := '';
  edtCanonBirth.Text  := '';
  edtCanonDeath.Text  := '';
  edtBirthPlace.Text  := '';
  edtDeathPlace.Text  := '';
  edtSex.Text         := '';
  edtComments.Text    := '';
  edtRef.Text         := '';
  mmoExpression.Text  := '';
  btnExpression.Font.Style := btnExpression.Font.Style - [fsBold];
end;

procedure TfrmAdvancedSearch.Enable_Buttons;
begin
  with fSelectivityInfoPtr^ do
    if not Empty(Expr) then
      btnExpression.Font.Style := btnExpression.Font.Style + [fsBold]
    else
      btnExpression.Font.Style := btnExpression.Font.Style - [fsBold];
  case fSearchMode of
    smEdit:
      btnOK.Enabled := (not Empty(edtFirstName.Text)) and (not Empty(edtLastName.Text)) and (not Empty(edtSex.Text));
    smSearch:
      btnOk.Enabled := true;
  end;
end;


procedure TfrmAdvancedSearch.btnExpressionClick(Sender: TObject);
begin
  with fSelectivityInfoPtr^ do
    begin
      with (DataSet as TMyTable) do
        begin
          if not Assigned(ffrmExpression) then
            ffrmExpression := TfrmExpression.Create(self, DBFilePathName, Dataset, SelectivityParser);
          with (ffrmExpression as TfrmExpression) do
            begin
              Expression := fSelectivityInfoPtr^.Expr;
              if ShowModal = mrOk then
                begin
                  fSelectivityInfoPtr^.Expr := Expression;
                  mmoExpression.Text   := Expression;
                  Enable_Buttons;
                end;
            end;
        end;
    end;
end;

procedure TfrmAdvancedSearch.SetSelectivityInfoPtr(const Value: pFamilyInfo);
begin
  fSelectivityInfoPtr := Value;
  with fSelectivityInfoPtr^ do
    begin
      edtAFN.Text        := AFN;
      edtPrefix.Text     := Prefix;
      edtFirstName.Text  := FirstName;
      edtMiddleName.Text := MiddleName;
      edtLastName.Text   := LastName;
      edtNickName.Text   := NickName;
      edtSuffix.Text     := Suffix;
      edtBirthDate.Text  := BirthDate;
      edtDeathDate.Text  := DeathDate;
      edtCanonBirth.Text := CanonBirth;
      edtCanonDeath.Text := CanonDeath;
      edtBirthPlace.Text := BirthPlace;
      edtDeathPlace.Text := DeathPlace;
      edtSex.Text        := Sex;
      edtComments.Text   := Comments;
      mmoExpression.Text := Expr;
      edtRef.Text        := Ref;
      if DateAddedLow <> BAD_DATE then
        edtDateAddedLow.Text := DateToStr(DateAddedLow);
      if DateAddedHigh <> BAD_DATE then
        edtDateAddedLow.Text := DateToStr(DateAddedHigh);
      if DateUpdatedLow <> BAD_DATE then
        edtDateUpdatedLow.Text := DateToStr(DateUpdatedLow);
      if DateUpdatedHigh <> BAD_DATE then
        edtDateUpdatedHigh.Text := DateToStr(DateUpdatedHigh);
      Enable_Buttons;
    end;
end;

procedure TfrmAdvancedSearch.Parseselectedtextasname1Click(
  Sender: TObject);
var
  aFullName, aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName: string;
begin
  with edtComments do
    aFullName := Trim(Copy(edtComments.Text, edtComments.SelStart+1, edtComments.SelLength));
  if ParseName(aFullName, aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName) then
    begin
      edtPrefix.Text     := aPrefix;
      edtFirstName.Text  := aFirstName;
      edtMiddleName.Text := aMiddleName;
      edtLastName.Text   := aLastName;
      edtSuffix.Text     := aSuffix;
      edtNickName.Text   := aNickName;
    end
  else
    AlertFmt('Cannot parse "%s"', [aFullName]);
  Enable_Buttons;
end;

procedure TfrmAdvancedSearch.SelectedTextToBirthDate1Click(
  Sender: TObject);
begin
  edtBirthDate.Text := Copy(edtComments.Text, edtComments.SelStart+1, edtComments.SelLength);
end;

procedure TfrmAdvancedSearch.SelectedtexttoBirthPlace1Click(
  Sender: TObject);
begin
  edtBirthPlace.Text := Copy(edtComments.Text, edtComments.SelStart+1, edtComments.SelLength);
end;

procedure TfrmAdvancedSearch.SelectedtexttoDeathDate1Click(
  Sender: TObject);
begin
  edtDeathDate.Text := edtComments.SelText;
end;

procedure TfrmAdvancedSearch.SelectedtexttoDeathPlace1Click(
  Sender: TObject);
begin
  edtDeathPlace.Text := edtComments.SelText;
end;

procedure TfrmAdvancedSearch.ParseDateAndPlace(const temp: string; var Date, Place: string);
const
  DELIMS = ' .';
var
  wc, i, BreakWord: integer;
  aWord: string;
begin
  wc := WordCountL(temp, DELIMS);
  BreakWord := -1;
  for i := 1 to wc do
    begin
      aWord := ExtractWordL(i, temp, DELIMS);
      if SameText(aWord, 'in') then
        begin
          BreakWord := i;
          break;
        end;
    end;

  if BreakWord > 0 then
    begin
      Date := '';
      for i := 1 to BreakWord-1 do
        Date := Date + ' ' + ExtractWordL(i, temp, DELIMS);
      Date := Trim(Date);

      Place := '';
      for i := BreakWord+1 to wc do
        Place := Place + ' ' + ExtractWordL(i, temp, DELIMS);
      Place := Trim(Place);
    end
  else
    AlertFmt('"in" not found in text "%s"', [temp]);
end;

procedure TfrmAdvancedSearch.SelectedtexttoBirthDateBirthPlace1Click(
  Sender: TObject);
var
  temp, BirthDate, BirthPlace: string;
begin
  temp := Copy(edtComments.Text, edtComments.SelStart+1, edtComments.SelLength);
  ParseDateAndPlace(temp, BirthDate, BirthPlace);
  edtBirthDate.Text  := BirthDate;
  edtBirthPlace.Text := BirthPlace;
end;

procedure TfrmAdvancedSearch.SelectedtexttoDeathDatePlace1Click(
  Sender: TObject);
var
  temp, DeathDate, DeathPlace: string;
begin
  temp := Copy(edtComments.Text, edtComments.SelStart+1, edtComments.SelLength);
  ParseDateAndPlace(temp, DeathDate, DeathPlace);
  edtDeathDate.Text  := DeathDate;
  edtDeathPlace.Text := DeathPlace;
end;

procedure TfrmAdvancedSearch.edtSexChange(Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmAdvancedSearch.edtFirstNameChange(Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmAdvancedSearch.edtLastNameChange(Sender: TObject);
begin
  Enable_Buttons;
end;

end.
