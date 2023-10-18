unit AddInfoFromDescendantsOfAbnerBDorrough;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, FamilyTables, Menus, MyUtils, FamilyTree_Decl;

const
  DESCENDENTS_OF_ABNER_B_DORROUGH_KEY = 26;  // key value for this document in my lookup table
  LOWEST_YEAR = 1500;

type
  TfrmAddInfoFromDescendantsOfAbnerBDorrough = class(TForm)
    Memo1: TMemo;
    btnCancel: TButton;
    leAFN: TLabeledEdit;
    leSex: TLabeledEdit;
    leBirthOrder: TLabeledEdit;
    leBirthDate: TLabeledEdit;
    leDeathDate: TLabeledEdit;
    leBirthPlace: TLabeledEdit;
    leDeathPlace: TLabeledEdit;
    lePersonName: TLabeledEdit;
    btnParse: TButton;
    btnClear: TButton;
    cbMoreToCome: TCheckBox;
    mmoComments: TMemo;
    leFirstName: TLabeledEdit;
    leMiddleName: TLabeledEdit;
    leLastName: TLabeledEdit;
    Label1: TLabel;
    mmoFather: TMemo;
    btnLoadFather: TButton;
    mmoMother: TMemo;
    btnLoadMother: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mmoSpouse: TMemo;
    btnLoadSpouse: TButton;
    btnAddAsChild: TButton;
    lblStatus: TLabel;
    leNickName: TLabeledEdit;
    btnClearSpouse: TButton;
    btnClearFather: TButton;
    btnClearMother: TButton;
    btnEditFather: TButton;
    btnEditMother: TButton;
    btnEditSpouse: TButton;
    PopupMenu1: TPopupMenu;
    Parseselectedtextasname1: TMenuItem;
    SelectedTextToBirthDate1: TMenuItem;
    SelectedtexttoBirthPlace1: TMenuItem;
    SelectedtexttoDeathDate1: TMenuItem;
    SelectedtexttoDeathPlace1: TMenuItem;
    N1: TMenuItem;
    SelectedtexttoBirthDateBirthPlace1: TMenuItem;
    SelectedtexttoDeathDatePlace1: TMenuItem;
    PopupMenu2: TPopupMenu;
    miParseSelectedTextAsName0: TMenuItem;
    miSelectedTextToBirthDate0: TMenuItem;
    miSelectedTextToBirthPlace0: TMenuItem;
    miSelectedTextToDeathDate0: TMenuItem;
    miSelectedTextToDeathPlace: TMenuItem;
    MenuItem6: TMenuItem;
    miSelectedTextToBirthDatePlace: TMenuItem;
    miSelectedTextToDeathPlaceDate: TMenuItem;
    N2: TMenuItem;
    ParseSelectedtext1: TMenuItem;
    leSuffix: TLabeledEdit;
    N3: TMenuItem;
    InsertParentsString1: TMenuItem;
    DeleteFirstSentenceinComments1: TMenuItem;
    lePrefix: TLabeledEdit;
    Label5: TLabel;
    PopupMenu3: TPopupMenu;
    AutoFillDABD1: TMenuItem;
    procedure btnParseClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnLoadFatherClick(Sender: TObject);
    procedure btnLoadMotherClick(Sender: TObject);
    procedure btnSetCurrentAsFatherClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnSetCurrentAsSpouseClick(Sender: TObject);
    procedure btnLoadSpouseClick(Sender: TObject);
    procedure btnAddAsChildClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearSpouseClick(Sender: TObject);
    procedure btnClearFatherClick(Sender: TObject);
    procedure btnClearMotherClick(Sender: TObject);
    procedure leSexChange(Sender: TObject);
    procedure leFirstNameChange(Sender: TObject);
    procedure leLastNameChange(Sender: TObject);
    procedure btnEditFatherClick(Sender: TObject);
    procedure btnEditMotherClick(Sender: TObject);
    procedure btnEditSpouseClick(Sender: TObject);
    procedure Parseselectedtextasname1Click(Sender: TObject);
    procedure SelectedTextToBirthDate1Click(Sender: TObject);
    procedure SelectedtexttoBirthPlace1Click(Sender: TObject);
    procedure SelectedtexttoDeathDate1Click(Sender: TObject);
    procedure SelectedtexttoDeathPlace1Click(Sender: TObject);
    procedure SelectedtexttoBirthDateBirthPlace1Click(Sender: TObject);
    procedure SelectedtexttoDeathDatePlace1Click(Sender: TObject);
    procedure miParseSelectedTextAsName0Click(Sender: TObject);
    procedure miSelectedTextToBirthDate0Click(Sender: TObject);
    procedure miSelectedTextToBirthPlace0Click(Sender: TObject);
    procedure miSelectedTextToDeathDate0Click(Sender: TObject);
    procedure miSelectedTextToDeathPlaceClick(Sender: TObject);
    procedure miSelectedTextToBirthDatePlaceClick(Sender: TObject);
    procedure miSelectedTextToDeathPlaceDateClick(Sender: TObject);
    procedure ParseSelectedtext1Click(Sender: TObject);
    procedure leSuffixChange(Sender: TObject);
    procedure InsertParentsString1Click(Sender: TObject);
    procedure DeleteFirstSentenceinComments1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1Change(Sender: TObject);
    procedure lePersonNameExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AutoFillDABD1Click(Sender: TObject);
  private
    fAnyUpdates: boolean;
    fFatherInfo: TPersonInfo;
    fMotherInfo: TPersonInfo;
    fSpouseInfo: TPersonInfo;
    fDefPersonInfo: TPersonInfo;
    fTempFamilyTable: TFamilyTable;
    fSelectivityInfo: TPersonInfo;
    function GetTempFamilyTable: TFamilyTable;
    function LookupIndividual(aCaption: string;
      aDefPersonInfo: TPersonInfo;
      var SelectedPersonInfo: TPersonInfo): boolean;
    procedure DisplayPersonInfo(mmo: TMemo; PersonInfo: TPersonInfo;
                                MarriageDate: string = ''; MarriagePlace: string = '');
    procedure LoadPersonInfo(var PersonInfo: TPersonInfo);
    function GetCanonBirth: string;
    function GetCanonDeath: string;
    function CalcPersonString(PersonInfo: TPersonInfo; Delim: string;
            MarriageDate: string = ''; MarriagePlace: string = ''): string;
    function GetNickName: string;
    procedure SetNickName(const Value: string);
    procedure Enable_Buttons;
    function EditInfo(var PersonInfo: TPersonInfo): boolean;
    procedure ParseDateAndPlace(const DateAndPlace: string; var Date,
      Place: string);
    procedure ParseComments(const TheComments: string);
    function ReadPhrase(var PhraseKind: TPhraseKind; TermCh: TSetOfChar;
      var Canonical: string; Var StartOfPhrase: integer; Endn: integer): string;
    function ReadString(TermCh: TSetOfChar; Endn: integer): string;
    procedure SkipBlanks;
    procedure SkipChar(SetOfChar: TSetOfChar);
    procedure NextCh;
    function StartOfNextPhrase(idx: integer; var PhraseKind: TPhraseKind): integer;
    function ReadNumber: string;
    function ReadRomanNumeral: string;
    function ReadSex: string;
    function IsStartingWordOfPhraseKey(const aWord: string; var PossiblePhraseKinds: TPhraseKindSet): boolean;
    procedure SavePersonInfo(var PersonInfo: TPersonInfo);
    function LookForNearestDate(idx: cardinal): cardinal;
    function DABDNumber(const Number: string): string;
    function GetSuffix: string;
    procedure SetSuffix(const Value: string);
    function GetPrefix: string;
    procedure SetPrefix(const Value: string);
    function MySameText(Word1, Word2, Which1, Which2: string;
      var ErrMsg: string): boolean;
  private
    fCanonicalDeathDate: string;
    fCanonicalBirthDate: string;
    fNdx: integer;
    fCh: char;
    fLine: string;
    fPhraseKind, fLastPhraseKind: TPhraseKind;

    function GetBirthOrder: string;
    function GetAFN: string;
    procedure SetBirthOrder(const Value: string);
    procedure SetAFN(const Value: string);
    function GetPersonName: string;
    procedure SetPersonName(Value: string);
    function GetSex: string;
    procedure SetSex(value: string);
    procedure ClearAll(ClearComments: boolean);
    function GetBirthDate: string;
    function GetDeathDate: string;
    procedure SetBirthDate(const Value: string);
    procedure SetDeathDate(const Value: string);
    function GetBirthPlace: string;
    function GetDeathPlace: string;
    procedure SetBirthPlace(const Value: string);
    procedure SetDeathPlace(const Value: string);
    function GetMoreToCome: boolean;
    procedure SetMoreToCome(const Value: boolean);
    function GetComments: string;
    procedure SetComments(const Value: string);
    function GetFirstName: string;
    function GetLastName: string;
    function GetMiddleName: string;
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetMiddleName(const Value: string);
    { Private declarations }
    property TempFamilyTable: TFamilyTable
             read GetTempFamilyTable;
  public
    { Public declarations }
    Destructor Destroy; override;
    procedure ParseInfo(Text: string; Reset: boolean);
    procedure SetFatherInfo(const FatherInfo: TPersonInfo);
    procedure SetMotherInfo(const MotherInfo: TPersonInfo);
    property AFN: string
             read GetAFN
             write SetAFN;
    property AnyUpdates: boolean
             read fAnyUpdates
             write fAnyUpdates;
    property BirthOrder: string
             read GetBirthOrder
             write SetBirthOrder;
    property Sex: string
             read GetSex
             write SetSex;
    property PersonName: string
             read GetPersonName
             write SetPersonName;
    property BirthDate: string
             read GetBirthDate
             write SetBirthDate;
    property CanonBirth: string
             read GetCanonBirth;
    property DeathDate: string
             read GetDeathDate
             write SetDeathDate;
    property CanonDeath: string
             read GetCanonDeath;
    property BirthPlace: string
             read GetBirthPlace
             write SetBirthPlace;
    property DeathPlace: string
             read GetDeathPlace
             write SetDeathPlace;
    property   MoreToCome: boolean
               read GetMoreToCome
               write SetMoreToCome;
    property Comments: string
             read GetComments
             write SetComments;
    property Prefix: string
             read GetPrefix
             write SetPrefix;
    property FirstName: string
             read GetFirstName
             write SetFirstName;
    property MiddleName: string
             read GetMiddleName
             write SetMiddleName;
    property LastName: string
             read GetLastName
             write SetLastName;
    property Suffix: string
             read GetSuffix
             write SetSuffix;
    property NickName: string
             read GetNickName
             write SetNickName;
    property CanonicalBirthDate: string
             read fCanonicalBirthDate
             write fCanonicalBirthDate;
    property CanonicalDeathDate: string
             read fCanonicalDeathDate
             write fCanonicalDeathDate;
  end;

var
  frmAddInfoFromDescendantsOfAbnerBDorrough: TfrmAddInfoFromDescendantsOfAbnerBDorrough;

implementation

uses PDBUtils, StStrL, FamilyTreePrivateSettings, MyTables_Decl,
  uLookupIndividual, DB, AdvancedSearch, FamilyTree_Utils;

{$R *.dfm}

function FindPhraseKind(const aWord: string): TPhraseKind;
var
  mode: TSearch_Type;
begin
  mode   := SEARCHING;
  result := Succ(Low(TPhraseKind));
  repeat
    if SameText(aWord, PhraseInfoArray[result].Key) then
      mode := SEARCH_FOUND else
    if result <= High(TPhraseKind) then
      inc(result)
    else
      mode := NOT_FOUND;
  until mode <> SEARCHING;
  if mode <> SEARCH_FOUND then
    result := dkUnknown;
end;

{ TfrmAddInfoFromDescendantsOfAbnerBDorrough }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetBirthOrder: string;
begin
  result := leBirthOrder.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetPersonName: string;
begin
  result := lePersonName.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetAFN: string;
begin
  result := leAFN.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetSex: string;
begin
  result := leSex.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.NextCh;
begin { NextCh }
  inc(fNdx);
  fCh := fLine[fNdx];
end;  { NextCh }

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SkipChar(SetOfChar: TSetOfChar);
begin { SkipChar }
  while (fNdx <= Length(fLine)) and (fCh in SetOfChar) do
    NextCh;
end;  { SkipChar }

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SkipBlanks;
begin { SkipBlanks }
  SkipChar([' ', #13, #10]);
end;  { SkipBlanks }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.ReadString(TermCh: TSetOfChar; Endn: integer): string;
begin { ReadString }
  SkipBlanks;
  result := '';
  while (fNdx <= Endn) and (not (fCh in TermCh)) do
    begin
      if not (fCh in TermCh) then
        begin
          if not (fCh in [#13, #10]) then
            result := result + fCh;
          NextCh;
        end;
    end;
end;  { ReadString }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.LookForNearestDate(idx: cardinal): cardinal;
const
  DELIMS = ' .;,'#13#10;
var
  N: integer;
  wc: integer;
  pos: cardinal;
  done: boolean;
  aWord, Month, Day, Year, aDate, Canonical: string;
begin
  wc := WordCountL(fLine, DELIMS);
  N := 1;
  done := false;
  while not done do
    begin
      done := not AsciiPositionL(N, fLine, DELIMS, #0, pos);
      if not done then
        begin
          done := pos >= idx;
          if not done then
            begin
              inc(N);
              done := N > wc;
            end;
        end;
    end;
  // assert that we should start looking at word N
  result := MAXINT; // If we don't find a date
  done   := false;
  repeat
    aWord := ExtractWordL(N, fLine, DELIMS);
    Month := ''; Day := ''; Year := '';
    if IsMonth(aWord) then // we found a month
      begin
        AsciiPositionL(N, fLine, DELIMS, #0, result);  // remember where we found the month
        Month := aWord;
        aWord := ExtractWordL(N - 1, fLine, DELIMS); // Get the proceding word
        if IsPureNumeric(aWord) and IsDay(StrToInt(aWord), MonthNumber(Month)) then
          begin
            Day := aWord;
            AsciiPositionL(N-1, fLine, DELIMS, #0, result); // No-- remember where we found the day
          end
        else
          Day := '';
        aWord := ExtractWordL(N + 1, fLine, DELIMS); // and the next word
        if IsYear(aWord, LOWEST_YEAR) then
          Year := aWord;
        aDate := Day + ' ' + Month + ' ' + Year;   // See if these constitute a date
        if ConvertToCanonical(aDate, Canonical) then
          done := true;
      end else
    if IsYear(aWord, LOWEST_YEAR) and (Year = '') then // found only a year- accept it as the date
      done := AsciiPositionL(N, fLine, DELIMS, #0, result);
    inc(N);
    done := done or (N > wc);
  until done;
end;


//*****************************************************************************
//   Function Name     : StartOfNextPhrase
//   Function Purpose  : Look for the offset to the next phrase key word(s)
//   Parameters        : idx = starting index for scan
//   Return Value      : index of next phrase RELATIVE TO BEGINNING OF fLINE
//*******************************************************************************}

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.StartOfNextPhrase(idx: integer; var PhraseKind: TPhraseKind): integer;
var
  N: integer;
  OffSet: integer;
  Buf, P, p0, p1: pchar;
  dk: TPhraseKind;
  FoundMatch: boolean;
//MaxNrWords: integer;
begin
  OffSet  := MAXINT;
  p0      := pchar(fLine);
  Buf     := p0 + idx - 1;
  p1      := nil;  // will point to character after phrase
//MaxNrWords := 0;
  for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
    begin
      p := MyStrPos(Buf, pchar(PhraseInfoArray[dk].Key), Length(fLine)-idx, true);
      if p <> nil then
        begin
          FoundMatch := true;
          if not ((p-1)^ in [' ', '.']) then // we require a preceding blank (or period)
            FoundMatch := false
          else
            begin
              p1 := p + Length(PhraseInfoArray[dk].Key);
              if not (p1^ in [' ', '.']) then  // and a trailing blank (or period)
                FoundMatch := false;
            end;

          if FoundMatch then
            begin
              N := P - Buf + 1;     // distance from where we started the search
              if N < OffSet then
                begin
                  OffSet     := N;  // shortest distance from where we started the search
                  PhraseKind := dk;
//                if PhraseInfoArray[dk].NrWords > MaxNrWords then
//                  MaxNrWords := PhraseInfoArray[dk].NrWords;
                end
//            else
//            if N = Offset then    // if its the same distance, use the longer phrase
//              begin
//                if PhraseInfoArray[dk].NrWords > MaxNrWords then
//                  begin
//                    PhraseKind := dk;
//                    MaxNrWords := PhraseInfoArray[dk].NrWords;
//                  end;
//              end;
            end;
        end;
    end;

  if OffSet <> MAXINT then   // found a match
    result     := idx + OffSet - 1     // return the starting distance PLUS additional offset
  else
    begin
      result     := Length(fLine);  // did not find a match
      PhraseKind := dkUnknown;
    end;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.IsStartingWordOfPhraseKey(const aWord: string; var PossiblePhraseKinds: TPhraseKindSet): boolean;
var
  dk: TPhraseKind;
begin
  PossiblePhraseKinds := [];
  for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
    if SameText(aWord, ExtractWordL(1, PhraseInfoArray[dk].Key, ' ')) then
      Include(PossiblePhraseKinds, dk);
  result := PossiblePhraseKinds <> [];
end;


function TfrmAddInfoFromDescendantsOfAbnerBDorrough.ReadPhrase
            (var PhraseKind: TPhraseKind;
                 TermCh: TSetOfChar;
             var Canonical: string;
             Var StartOfPhrase: integer;
                 Endn: integer): string;
const
  PHRASETERM = [' ', ','];
var
  aWord, aPossibleDate, PrefixWord: string;
  Cnt, SavedNdx: integer;
  Dummy, TestPhraseKind: TPhraseKind;
  PossiblePhraseKinds: TPhraseKindSet;
  PhraseMatches: boolean;

  function ReadPhraseInner(var PhraseKind: TPhraseKind; PossiblePhraseKinds: TPhraseKindSet): boolean;
  var
    SavedNdx, i, NrWords, MaxNrWords: integer;
    TargetWord, WordRead: string;
    dk: TPhraseKind;
  begin { ReadPhraseInner }
    SavedNdx := fNdx;
    result   := true;
    MaxNrWords := 0;
    for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
      if dk in PossiblePhraseKinds then
        begin
          PhraseMatches := true;
          fNdx          := SavedNdx;
          NrWords       := PhraseInfoArray[dk].NrWords;
          if NrWords > 1 then
            for i := 2 to NrWords do
              begin
                TargetWord := ExtractWordL(i, PhraseInfoArray[dk].Key, ' ');
                WordRead   := ReadString([' '], Length(fLine));
                if not SameText(TargetWord, WordRead) then
                  begin
                    PhraseMatches := false;
                    Exclude(PossiblePhraseKinds, dk);
                    break;
                  end;
              end;

          if PhraseMatches then
            begin
              if NrWords > MaxNrWords then
                begin
                  MaxNrWords := NrWords;
                  PhraseKind := dk;
                end;
            end
          else
            fNdx := SavedNdx;
        end;
    if PossiblePhraseKinds = [] then
      begin
        result := false;
        fNdx   := SavedNdx;
      end;
  end;  { ReadPhraseInner }

begin { ReadPhrase }
  PhraseKind := dkUnknown;
  aWord      := ReadString([' '], Length(fLine));
  if IsStartingWordOfPhraseKey(aWord, PossiblePhraseKinds) then
    if ReadPhraseInner(TestPhraseKind, PossiblePhraseKinds) then
      PhraseKind := TestPhraseKind;

  StartOfPhrase := fNdx;
  if PhraseKind in [dkBorn, dkDied, dkWasBorn, dkHeWasBorn, dkSheWasBorn, dkDiedInChildHood, dkDiedInInfancy] then // look for a following date
    begin
      cnt      := 0;
      aWord    := ReadString(PHRASETERM+TermCh, Endn);
      if SameText(aWord, 'about') or
         SameText(aWord, 'ca') or
         SameText(aWord, 'before') or
         SameText(aWord, 'after') then  // skip noise words
        begin
          PrefixWord := aWord;
          aWord := ReadString(PHRASETERM+TermCh, Endn);
        end;
      aPossibleDate := '';
      SavedNdx      := fNdx;
      while (cnt < 3) and (not Empty(aWord)) and
            ((IsPureNumeric(aWord) and (StrToInt(aWord) <= 31)) or IsMonth(aWord) or IsYear(aWord, LOWEST_YEAR)) do
        begin
          aPossibleDate := aPossibleDate + aWord + ' ';
          inc(cnt);
          if (cnt < 3) then
            begin
              SavedNdx := fNdx;
              aWord := ReadString(PHRASETERM+TermCh, Endn);
            end;
        end;
      if Cnt < 3 then
        begin
          fNdx := SavedNdx;
          fCh  := fLine[fNdx];
        end;
      if not ConvertToCanonical(aPossibleDate, Canonical) then
        PhraseKind := dkUnknown
      else
        if Empty(PrefixWord) then
          result := Trim(aPossibleDate)
        else
          result := PrefixWord + ' ' + Trim(aPossibleDate);
    end;
  if PhraseKind = dkHeMarried then
    begin
      Endn   := StartOfNextPhrase(fNdx+1, Dummy);
      result := 'He ' + ReadString(TermCh, Endn-1) + '. ';
    end else
  if PhraseKind = dkSheMarried then
    begin
      Endn   := StartOfNextPhrase(fNdx+1, Dummy);
      result := 'She ' + ReadString(TermCh, Endn-1) + '. ';
    end else
  if PhraseKind in [dkPlace, dkAtTheAgeOf] then
    begin
      Endn   := StartOfNextPhrase(fNdx+1, Dummy);
      result := ReadString(TermCh, Endn-1)
    end;
end;  { ReadPhrase }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.ReadNumber: string;
begin { ReadNumber }
  SkipBlanks;
  result := '';
  while (fNdx <= Length(fLine)) and (fCh in ['0'..'9']) do
    begin
      if fCh in ['0'..'9'] then
        begin
          result := result + fCh;
          NextCh;
        end;
    end;
end;  { ReadNumber }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.ReadSex: string;
var
  SexFound: boolean;
  SavedNdx: integer;
begin { ReadSex }
  SexFound := false;
  SavedNdx := fNdx;
  result   := '';
  SkipBlanks;
  if fCh in ['M', 'm'] then
    begin
      SexFound := true;
      result := 'M';
      NextCh;
    end else
  if fCh in ['F', 'f'] then
    begin
      SexFound := true;
      result := 'F';
      NextCh;
    end;
  if SexFound and (fCh <> ' ') then // its really not the sex
    fNdx := SavedNdx;
end;  { ReadSex }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.ReadRomanNumeral: string; // just skip it for now
begin { ReadRomanNumeral }
  SkipBlanks;
  result := '';
  while (fNdx <= Length(fLine)) and (ToLower(fCh) in ['i', 'v', 'x']) do
    begin
      if fCh <> '.' then
        begin
          result := result + fCh;
          NextCh;
        end;
    end;
  if fCh = '.' then
    NextCh;
end;  { ReadRomanNumeral }

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.DABDNumber(const Number: string): string;
begin
  result := 'dabd-' + Rzero(Number, 4);
end;


procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.ParseInfo(Text: string; Reset: boolean);
var
  aPhrase: string;
  CanonicalDate: string;
  HasPlus: boolean;
  PersonNumber: string;
  endn: integer;
  Temp2, Temp3, OldAFN, NewAFN: string;
  StartOfPhrase: integer;
begin { ParseInfo }
  if Reset then
    ClearAll(false);

  fNdx          := 0;
  fLine         := Text;
  if not Empty(fLine) then
    begin
      NextCh;    // get 1st character in line
      SkipBlanks;
      MoreToCome   := false;
      HasPlus      := fCh = '+';
      if HasPlus then  // skip over the '+' sign
        NextCh;
      PersonNumber := ReadNumber;
      if PersonNumber = '' then
        PersonNumber := IntToStr(gPrivateSettings.FakeDABDNr);
      OldAFN       := AFN;
      NewAFN       := DABDNumber(PersonNumber);
      if Empty(OldAFN) then
        AFN        := NewAFN
      else
        if not SameText(OldAFN, NewAFN) then
          AlertFmt('Mismatched AFN values: %s/%s', [OldAFN, NewAFN]);

      if Length(AFN) > 10 then
        AlertFmt('AFN (%s) exceeds max length of 10 characters', [AFN]);
      MoreToCome   := HasPlus and Empty(mmoComments.Text);  // set MoreToCome after the AFN has been set
      SkipChar(['.']);

      Temp2        := ReadSex;
      if Empty(Sex) and (not Empty(Temp2)) then
        Sex        := Temp2;

      Temp2        := ReadRomanNumeral;
      if Empty(BirthOrder) and (not Empty(Temp2)) then
        BirthOrder := Temp2;

      SkipChar(['.', ' ']);
      Endn         := StartOfNextPhrase(fNdx+1, fPhraseKind);

      Temp2        := ProperCase(ReadString([',', ';'], Endn-1));
      Temp3        := '';
      if (fCh = ',') and (fNdx < Endn) then  // look for a suffix
        begin
          SkipChar([',']);
          Temp3 := Trim(ReadString([',', ';'], Endn-1));
          Temp2 := Temp2 + ', ' + Temp3;
        end;

      if Empty(PersonName) and (not Empty(Temp2))then
        PersonName := Temp2;

      fLastPhraseKind := dkUnknown;
      while fNdx < Length(fLine) do
        begin
          SkipChar([' ', ',', ';', #13, #10]); // trying to skip over the ',' which might follow the name (e.g., "Rosa VANDIVER, born in Vandiver, Shelby, AL.")
          aPhrase := ReadPhrase(fPhraseKind, ['.'], CanonicalDate, StartOfPhrase, Length(fLine));
          if fPhraseKind in [dkBorn, dkDied] then
            fLastPhraseKind := fPhraseKind else
          if fPhraseKind in [dkDiedInChildHood, dkDiedInInfancy] then
            fPhraseKind := dkDied;

          case fPhraseKind of
            dkBorn:
              begin
                if Empty(BirthDate) then
                  BirthDate := aPhrase;
                if Empty(CanonicalBirthDate) then
                  CanonicalBirthDate := CanonicalDate;
              end;
            dkDied:
              begin
                if Empty(DeathDate) then
                  DeathDate := aPhrase;
                if Empty(CanonicalDeathDate) then
                  CanonicalDeathDate := CanonicalDate;
              end;
            dkPlace:
              begin
                case fLastPhraseKind of
                  dkBorn:
                    if Empty(BirthPlace) then
                      BirthPlace := TrimTrailing(aPhrase, [',', ' ']);
                  dkDied:
                    if Empty(DeathPlace) then
                      DeathPlace := TrimTrailing(aPhrase, [',', ' ']);
                end;
                fLastPhraseKind := dkUnknown;
              end;
//          dkBornIn:
//            begin
//              if Empty(BirthPlace) then
//                BirthPlace := TrimTrailing(aPhrase, [',', ' ']);
//            end;
//          dkDiedIn:
//            begin
//              if Empty(DeathPlace) then
//                DeathPlace := TrimTrailing(aPhrase, [',', ' ']);
//            end;
          end;
          if fCh = '.' then
            begin
              NextCh;
              if Empty(Comments) then
                begin
                  if fPhraseKind in [dkHeMarried, dkSheMarried] then
                    Comments := ParentsString(Sex, fFatherInfo, fMotherInfo) + CRLF + CRLF + aPhrase + ReadString([#0], Length(fLine))  // "He/She was the son/daughter of " + the remainder --> the comments
                  else
                    Comments := ReadString([#0], Length(fLine));

                  if not Empty(Comments) then
                    ParseComments(mmoComments.Text);              // and then try to parse them
                end;
            end;
        end;
    end
  else
    lblStatus.Caption := 'Appears to be empty!';
end;  { ParseInfo }

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetBirthOrder(
  const Value: string);
var
  Temp: string;
begin
  if not Empty(Value) then
    begin
      Temp := ConvertRomanToDigits(Value);
      if not SameText(Temp, BAD_ROMAN) then
        leBirthOrder.Text := Temp
      else
        AlertFmt('Unexpected Roman Numeral: %s', [Value])
    end
  else
    leBirthOrder.Text := '';
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetPersonName(
  Value: string);
var
  aPrefix, aFirstName, aMiddleName, aLastName, aNickName, aSuffix: string;
begin
  Value := TrimTrailing(Value, [',', ' ', '.']);
  lePersonName.Text := Value;
  if Empty(Value) then
    begin
      Prefix       := '';
      FirstName    := '';
      MiddleName   := '';
      LastName     := '';
      NickName     := '';
      Suffix       := '';
    end else
  if ParseName(Value, aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName) then
    begin
      Prefix       := aPrefix;
      FirstName    := aFirstName;
      MiddleName   := aMiddleName;
      LastName     := aLastName;
      NickName     := aNickName;
      Suffix       := aSuffix;
    end;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetAFN(
  const Value: string);
begin
  leAFN.Text := Value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetSex(value: string);
begin
  leSex.text := Value;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.MySameText(Word1, Word2, Which1, Which2: string; var ErrMsg: string): boolean;
var
  i: integer;
begin { MySameText }
  Word1 := Trim(Word1);
  Word2 := Trim(Word2);
  result := SameText(Word1, Word2);
  if not result then
    begin
      if Length(Word1) > Length(Word2) then
        ErrMsg := Format('%s is longer than %s', [Which1, Which2]) else
      if Length(Word1) < Length(Word2) then
        ErrMsg := Format('%s is shorter than %s', [Which1, Which2])
      else
        begin
          for i := 1 to Length(Word1) do
            if Word1[i] <> Word2[i] then
              break;
          ErrMsg := Format('%s differs from %s at position #%d', [Which1, Which2, i]);
        end;
    end;
end;  { MySameText }

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnParseClick(
  Sender: TObject);
var
  HadComments: boolean;
  ErrMsg: string;
begin
  HadComments := not Empty(mmoComments.Text); // set before calling ParseInfo since it may try to add comments
  ParseInfo(Memo1.Text, true);
  if HadComments then
    ParseComments(mmoComments.Text);
  if Empty(mmoComments.Text) then
    mmoComments.Text := ParentsString(Sex, fFatherInfo, fMotherInfo);

  Enable_Buttons;
  mmoComments.SetFocus;
  mmoComments.SelStart := 0;
  mmoComments.SelLength := 0;
  if (not Empty(fFatherInfo.LastName)) and
     (not UnknownName(fFatherInfo.LastName)) and
     (not MySameText(fFatherInfo.LastName, LastName, 'Father''s Last Name', 'Person''s Last Name', ErrMsg)) then
    Alert('Last names do not match between father and child!' + CRLF +
        fFatherInfo.LastName + CRLF +
        LastName + CRLF +
        ErrMsg);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.Enable_Buttons;
begin
  btnAddAsChild.Enabled := (Not Empty(FirstName)) and
                           (not Empty(LastName)) and
                           (not Empty(Sex));
end;


procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnClearClick(
  Sender: TObject);
begin
  Memo1.Text   := '';
  ClearAll(true);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.ClearAll(ClearComments: boolean);
begin
  AFN          := '';
  Sex          := '';
  BirthOrder   := '';
  PersonName   := '';
  FirstName    := '';
  MiddleName   := '';
  LastName     := '';
  Suffix       := '';
  NickName     := '';
  BirthDate    := '';
  BirthPlace   := '';
  DeathDate    := '';
  DeathPlace   := '';
  fCanonicalBirthDate := '';
  fCanonicalDeathDate := '';
  MoreToCome   := false;
  if ClearComments then
    Comments     := '';
  InitPersonInfo(fSpouseInfo);
  DisplayPersonInfo(mmoSpouse, fSpouseInfo);
  btnAddAsChild.Enabled := false;
  Memo1.SetFocus;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetBirthDate: string;
begin
  result := leBirthDate.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetDeathDate: string;
begin
  result := leDeathDate.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetBirthDate(
  const Value: string);
begin
  leBirthDate.Text := Value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetDeathDate(
  const Value: string);
begin
  leDeathDate.Text := Value;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetBirthPlace: string;
begin
  result := leBirthPlace.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetDeathPlace: string;
begin
  result := leDeathPlace.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetBirthPlace(
  const Value: string);
begin
  leBirthPlace.Text := value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetDeathPlace(
  const Value: string);
begin
  leDeathPlace.Text := value;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetMoreToCome: boolean;
begin
  result := cbMoreToCome.Checked;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetMoreToCome(
  const Value: boolean);
begin
  cbMoreToCome.Checked := Value;
  if Value then
    begin
      cbMoreToCome.Color   := clYellow;
      cbMoreToCome.Caption := 'Load comments for ' + AFN;
    end
  else
    cbMoreToCome.Color := clBtnFace;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetComments: string;
begin
  result := mmoComments.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetComments(
  const Value: string);
begin
  mmoComments.Text := Value;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetFirstName: string;
begin
  result := leFirstName.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetLastName: string;
begin
  result := leLastName.Text;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetMiddleName: string;
begin
  result := leMiddleName.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetFirstName(
  const Value: string);
begin
  leFirstName.Text := Value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetLastName(
  const Value: string);
begin
  leLastName.Text := value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetMiddleName(
  const Value: string);
begin
  leMiddleName.Text := value;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetTempFamilyTable: TFamilyTable;
begin
  if Not Assigned(fTempFamilyTable) then
    begin
      fTempFamilyTable := TFamilyTable.Create(self, gPrivateSettings.FamilyTreeDataBaseFileName, cFAMILY, [optUseClient]);
      with fTempFamilyTable do
        begin
          IndexFieldNames := 'AFN';
          Active := true;
//        OnFilterRecord := FilterFamilyRecords;
//        Filtered := HasFilterInfo(fSelectivityInfo);;
        end;
    end;
  result := fTempFamilyTable;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.LookupIndividual( aCaption: string;
                                          aDefPersonInfo: TPersonInfo;
                                          var SelectedPersonInfo: TPersonInfo): boolean;
begin
  InitPersonInfo(SelectedPersonInfo);
  with TfrmLookupIndividual.Create(self, true) do
    begin
      SelectivityInfoPtr    := @fSelectivityInfo;
      DefPersonInfoPtr      := @aDefPersonInfo;
      SelectedPersonInfoPtr := @SelectedPersonInfo;
      TheCaption            := aCaption;
      result                := ShowModal = mrOk;
      Free;
    end;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.CalcPersonString(PersonInfo: TPersonInfo; Delim: string;
            MarriageDate: string = ''; MarriagePlace: string = ''): string;
var
  TheFullName: string;
  fLine: string;

  procedure AddClause(const Event, EventDate, EventPlace: string);
  begin { AddClause }
    if not Empty(EventDate) then
      begin
        fLine := fLine + Delim + Event + ': ' + EventDate;
        if not Empty(EventPlace) then
          fLine := fLine + ' in ' + EventPlace;
      end else
    if not Empty(EventPlace) then
      fLine := fLine + Event + ' in ' + EventPlace;
  end;  { AddClause }

begin
  with PersonInfo do
    begin
      TheFullName := FullName(Prefix, FirstName, MiddleName, LastName, Suffix, NickName);
      fLine := '[' + AFN + '] ' + Delim +
              TheFullName;

      AddClause('married', MarriageDate, MarriagePlace);
      AddClause('born',    BirthDate,    BirthPlace);
      AddClause('died',    DeathDate,    DeathPlace);

      result := fLine;
    end;
end;


procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.DisplayPersonInfo(mmo: TMemo; PersonInfo: TPersonInfo;
   MarriageDate: string = ''; MarriagePlace: string = '');
const
  CRLF = #13#10;
begin
  mmo.Text := CalcPersonString(PersonInfo, CRLF, MarriageDate, MarriagePlace);
end;


procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnLoadFatherClick(
  Sender: TObject);
begin
  InitPersonInfo(fDefPersonInfo);
  fDefPersonInfo.Sex := 'M';
  if LookupIndividual( 'Select Father', fDefPersonInfo, fFatherInfo) then
    DisplayPersonInfo(mmoFather, fFatherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnLoadMotherClick(
  Sender: TObject);
begin
  InitPersonInfo(fDefPersonInfo);
  fDefPersonInfo.Sex := 'F';
  if LookupIndividual( 'Select Mother', fDefPersonInfo, fMotherInfo) then
    DisplayPersonInfo(self.mmoMother, fMotherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.LoadPersonInfo(var PersonInfo: TPersonInfo);
begin
    PersonInfo.AFN        := AFN;
    PersonInfo.FirstName  := FirstName;
    PersonInfo.MiddleName := MiddleName;
    PersonInfo.LastName   := LastName;
    PersonInfo.NickName   := NickName;
    PersonInfo.Suffix     := Suffix;
    PersonInfo.BirthDate  := BirthDate;
    PersonInfo.DeathDate  := DeathDate;
    PersonInfo.CanonBirth := CanonBirth;
    PersonInfo.BirthOrder := BirthOrder;
    PersonInfo.CanonDeath := CanonDeath;
    PersonInfo.Spouse_AFN := fSpouseInfo.AFN;
    PersonInfo.Father_AFN := fFatherInfo.AFN;
    PersonInfo.Mother_AFN := fMotherInfo.AFN;
    PersonInfo.BirthPlace := BirthPlace;
    PersonInfo.DeathPlace := DeathPlace;
    PersonInfo.Sex        := Sex;
    PersonInfo.Comments   := RemoveBadChars(Comments, [#13, #10]);
    PersonInfo.SourceID1  := DESCENDENTS_OF_ABNER_B_DORROUGH_KEY;
//  PersonInfo.SourceID2  := SourceID2;
    PersonInfo.Ref        := 'DABD';
end;


procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnSetCurrentAsFatherClick(
  Sender: TObject);
begin
  LoadPersonInfo(fFatherInfo);
  DisplayPersonInfo(mmoFather, fFatherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.Button1Click(
  Sender: TObject);
begin
  LoadPersonInfo(fMotherInfo);
  DisplayPersonInfo(mmoMother, fMotherInfo);
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetCanonBirth: string;
var
  Canonical: string;
begin
  if ConvertToCanonical(BirthDate, Canonical) then
    result := Canonical
  else
    result := '';
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetCanonDeath: string;
var
  Canonical: string;
begin
  if ConvertToCanonical(DeathDate, Canonical) then
    result := Canonical
  else
    result := '';
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnSetCurrentAsSpouseClick(
  Sender: TObject);
begin
  LoadPersonInfo(fSpouseInfo);
  DisplayPersonInfo(mmoSpouse, fSpouseInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnLoadSpouseClick(
  Sender: TObject);
begin
  InitPersonInfo(fDefPersonInfo);
  fDefPersonInfo.Sex := Opposite(Sex);

  if LookupIndividual( 'Select Spouse', fDefPersonInfo, fSpouseInfo) then
     DisplayPersonInfo(mmoSpouse, fSpouseInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnAddAsChildClick(
  Sender: TObject);
var
  ShowList: boolean;
  SelectedPersonInfo: TPersonInfo;
  OkToAdd: boolean;
  aCanonBirth: string;
begin
  // look for posible duplicate record
  if TempFamilyTable.State in [dsEdit, dsInsert] then
    begin
      Alert('Table is in edit/insert state. Cancelling');
      TempFamilyTable.Cancel;
      lblStatus.Caption := 'Add CANCELLED!';
      Exit;
    end;

  if ConvertToCanonical(BirthDate,aCanonBirth) then
    aCanonBirth := Copy(aCanonBirth, 1, 4)
  else
    aCanonBirth := '';

 if TempFamilyTable.Locate('FirstName;LastName;CanonBirth',
                            VarArrayOf([FirstName, LastName, aCanonBirth]),
                            [loCaseInsensitive, loPartialKey]) then
    begin
      ShowList := YesFmt('One or more records having the name %s %s and a birth year of %s already exist. Do you want to see the list?',
                         [FirstName, LastName, IIF(not Empty(aCanonBirth), aCanonBirth, 'Unknown')]);
      if ShowList then
        begin
          InitPersonInfo(fSelectivityInfo);
          fSelectivityInfo.FirstName  := FirstName;
          fSelectivityInfo.LastName   := LastName;
          fSelectivityInfo.CanonBirth := aCanonBirth;
          fSelectivityInfo.Sex        := Sex;
          LookupIndividual( 'Possible Duplicates', fSelectivityInfo, SelectedPersonInfo);
        end;
      OkToAdd := YesFmt('Do you want to add the current information for "%s" [%s] as a new record?',
                        [FullName('', FirstName, MiddleName, LastName, Suffix), BirthDate]);
    end
  else
    OkToAdd := true;

  if OkToAdd then
    begin
      if (not Empty(fSpouseInfo.FirstName)) or (not Empty(fSpouseInfo.LastName)) then
        SavePersonInfo(fSpouseInfo);       // Save the spouse and get his/her AFN
      LoadPersonInfo(SelectedPersonInfo);  // gather up all the info for the current person
      SelectedPersonInfo.DateAdded := Now;
      TempFamilyTable.Append;
      TempFamilyTable.SavePersonInfo(SelectedPersonInfo);
      if Empty(SelectedPersonInfo.AFN) then
        SelectedPersonInfo.AFN := 'dabd-' + IntToStr(gPrivateSettings.FakeDABDNr);
      TempFamilyTable.Post;
      lblStatus.Color   := clBtnFace;
      lblStatus.Caption := Format('Added record(s) for: %s', [CalcPersonString(SelectedPersonInfo, '; ')]);
      Memo1.Text := '';
      ClearAll(true);
      Memo1.SetFocus;
      Memo1.SelStart := 0;
      Memo1.SelLength := 0;
    end
  else
    begin
      lblStatus.Color   := clBtnFace;
      lblStatus.Caption := 'Add CANCELLED!';
    end;
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetNickName: string;
begin
  result := leNickName.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetNickName(
  const Value: string);
begin
  leNickName.Text := Value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnCancelClick(
  Sender: TObject);
begin
  if (not Empty(LastName)) or (not Empty(Memo1.Text)) then
    if not Yes('Record has not been saved yet. Exit anyway?') then
      ModalResult := mrNone;
end;

destructor TfrmAddInfoFromDescendantsOfAbnerBDorrough.Destroy;
begin
  FreeAndNil(fTempFamilyTable);
  inherited;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnClearSpouseClick(
  Sender: TObject);
begin
  InitPersonInfo(fSpouseInfo);
  DisplayPersonInfo(mmoSpouse, fSpouseInfo);
  mmoSpouse.Text := '';
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnClearFatherClick(
  Sender: TObject);
begin
  InitPersonInfo(fFatherInfo);
  DisplayPersonInfo(mmoFather, fFatherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnClearMotherClick(
  Sender: TObject);
begin
  InitPersonInfo(fMotherInfo);
  DisplayPersonInfo(mmoMother, fMotherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetFatherInfo(
  const FatherInfo: TPersonInfo);
begin
  fFatherInfo := FatherInfo;
  if Empty(fFatherInfo.AFN) then
    InitPersonInfo(fFatherInfo);
  DisplayPersonInfo(mmoFather, fFatherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetMotherInfo(
  const MotherInfo: TPersonInfo);
begin
  fMotherInfo := MotherInfo;
  if Empty(fMotherInfo.AFN) then
    InitPersonInfo(fMotherInfo);
  DisplayPersonInfo(mmoMother, fMotherInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.leSexChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.leFirstNameChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.leLastNameChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SavePersonInfo(var PersonInfo: TPersonInfo);
begin
  if not Empty(PersonInfo.AFN) then
    begin
      if TempFamilyTable.Locate('AFN', PersonInfo.AFN, []) then
        TempFamilyTable.Edit
      else
        TempFamilyTable.Append;
    end
  else
    TempFamilyTable.Append;

  TempFamilyTable.SavePersonInfo(PersonInfo);
  TempFamilyTable.Post;
  PersonInfo.AFN := TempFamilyTable.fldAFN.AsString;
end;


function TfrmAddInfoFromDescendantsOfAbnerBDorrough.EditInfo(var PersonInfo: TPersonInfo): boolean;
var
  InfoForm: TfrmAdvancedSearch;
  TempInfo: TPersonInfo;
begin
  InfoForm := TfrmAdvancedSearch.Create(self, @PersonInfo, smEdit);
  try
    TempInfo := PersonInfo;
    if PersonInfo.SourceID1 = 0 then
      PersonInfo.SourceID1 := DESCENDENTS_OF_ABNER_B_DORROUGH_KEY;
    if Empty(PersonInfo.Ref) then
      PersonInfo.Ref := 'dabd';
    InfoForm.SelectivityInfoPtr := @TempInfo;
    result := InfoForm.ShowModal = mrOk;
    if result then
      begin
        PersonInfo := TempInfo;
        SavePersonInfo(PersonInfo);
      end;
  finally
    FreeAndNil(InfoForm);
  end;
end;


procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnEditFatherClick(
  Sender: TObject);
begin
  if Empty(fFatherInfo.Sex) then
    fFatherInfo.Sex := 'M';
  if EditInfo(fFatherInfo) then
    begin
      DisplayPersonInfo(mmoFather, fFatherInfo);
      AnyUpdates := true;
    end;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnEditMotherClick(
  Sender: TObject);
begin
  if Empty(fMotherInfo.Sex) then
    fMotherInfo.Sex := 'F';
  if EditInfo(fMotherInfo) then
    begin
      DisplayPersonInfo(mmoMother, fMotherInfo);
      AnyUpdates := true;
    end;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.btnEditSpouseClick(
  Sender: TObject);
begin
  if Empty(fSpouseInfo.Sex) then
    fSpouseInfo.Sex := Opposite(Sex);
  if Empty(fSpouseInfo.Spouse_AFN) then
    fSpouseInfo.Spouse_AFN := AFN;
  if EditInfo(fSpouseInfo) then
    DisplayPersonInfo(mmoSpouse, fSpouseInfo);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miParseSelectedTextAsName0Click(
  Sender: TObject);
var
  aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName: string;
begin
  if ParseName(Trim(Memo1.SelText), aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName) then
    begin
      lePrefix.Text     := aPrefix;
      leFirstName.Text  := aFirstName;
      leMiddleName.Text := aMiddleName;
      leLastName.Text   := aLastName;
      leSuffix.Text     := aSuffix;
      leNickName.Text   := aNickName;
    end;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.Parseselectedtextasname1Click(
  Sender: TObject);
var
  aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName: string;
begin
  if ParseName(Trim(mmoComments.SelText), aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName) then
    begin
      lePrefix.Text     := aPrefix;
      leFirstName.Text  := aFirstName;
      leMiddleName.Text := aMiddleName;
      leLastName.Text   := aLastName;
      leSuffix.Text     := aSuffix;
      leNickName.Text   := aNickName;
    end;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miSelectedTextToBirthDate0Click(
  Sender: TObject);
begin
  leBirthDate.Text := Memo1.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SelectedTextToBirthDate1Click(
  Sender: TObject);
begin
  leBirthDate.Text := mmoComments.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miSelectedTextToBirthPlace0Click(
  Sender: TObject);
begin
  leBirthPlace.Text := Memo1.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SelectedtexttoBirthPlace1Click(
  Sender: TObject);
begin
  leBirthPlace.Text := mmoComments.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miSelectedTextToDeathDate0Click(
  Sender: TObject);
begin
  leDeathDate.Text := Memo1.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SelectedtexttoDeathDate1Click(
  Sender: TObject);
begin
  leDeathDate.Text := mmoComments.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miSelectedTextToDeathPlaceClick(
  Sender: TObject);
begin
  leDeathPlace.Text := memo1.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SelectedtexttoDeathPlace1Click(
  Sender: TObject);
begin
  leDeathPlace.Text := mmoComments.SelText;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.ParseDateAndPlace(const DateAndPlace: string; var Date, Place: string);
const
  DELIMS = ' .';
var
  wc, i, BreakWord: integer;
  aWord: string;
begin
  wc := WordCountL(DateAndPlace, DELIMS);
  BreakWord := -1;
  for i := 1 to wc do
    begin
      aWord := ExtractWordL(i, DateAndPlace, DELIMS);
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
        Date := Date + ' ' + ExtractWordL(i, DateAndPlace, DELIMS);
      Date := Trim(Date);

      Place := '';
      for i := BreakWord+1 to wc do
        Place := Place + ' ' + ExtractWordL(i, DateAndPlace, DELIMS);
      Place := Trim(Place);
    end
  else
    AlertFmt('"in" not found in text "%"', [DateAndPlace]);
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SelectedtexttoBirthDateBirthPlace1Click(
  Sender: TObject);
var
  aBirthDate, aBirthPlace: string;
begin
  ParseDateAndPlace(mmoComments.SelText, aBirthDate, aBirthPlace);
  BirthDate  := aBirthDate;
  BirthPlace := aBirthPlace;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SelectedtexttoDeathDatePlace1Click(
  Sender: TObject);
var
  aDeathDate, aDeathPlace: string;
begin
  ParseDateAndPlace(mmoComments.SelText, aDeathDate, aDeathPlace);
  DeathDate  := aDeathDate;
  DeathPlace := aDeathPlace;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miSelectedTextToBirthDatePlaceClick(
  Sender: TObject);
var
  BirthDate, BirthPlace: string;
begin
  ParseDateAndPlace(Memo1.SelText, BirthDate, BirthPlace);
  leBirthDate.Text  := BirthDate;
  leBirthPlace.Text := BirthPlace;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.miSelectedTextToDeathPlaceDateClick(
  Sender: TObject);
var
  DeathDate, DeathPlace: string;
begin
  ParseDateAndPlace(Memo1.SelText, DeathDate, DeathPlace);
  leDeathDate.Text  := DeathDate;
  leDeathPlace.Text := DeathPlace;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.ParseComments(const TheComments: string);
type
  TPhraseInfo = record
                  StartOfPhrase: integer;
                  EndOfPhrase: integer;
                  PhraseKind: TPhraseKind;
                  Phrase: string;
                end;
var
  PhraseInfo: array of TPhraseInfo;
  NextNdx, NextNdxD: integer;
  NrPhrases, i, aStartOfPhrase, DummyStartOfPhrase: integer;
  Canonical: string;
  aPhraseKind, LastPhraseKind, DummyPhraseKind: TPhraseKind;
  aPhrase: string;
  OldAFN, NewAFN, PersonNumber, Temp2: string;
  Len: integer;
  DoingSpouseInfo, HasDate: boolean;
  MarriageInfo: string;
  MarriageDate, MarriagePlace: string;
  VerifyInfo: TPersonInfo;
  MainName, CommentsName, ErrMsg: string;

    function HasMoreThanOneSpace(const aPhrase: string): boolean;
    var
      i, SpaceCount: integer;
    begin { HasMoreThanOneSpace }
      SpaceCount := 0;
      for i := 1 to Length(aPhrase) do
        if aPhrase[i] = ' ' then
          Inc(SpaceCount);
      result := SpaceCount > 1;
    end;  { HasMoreThanOneSpace }

    procedure Check(const What, Phrase, Value: string; PersonInfo: TPersonInfo; AllowInitial, AllowBlank: boolean);
    var
      BadPunct: TSetOfChar;
    begin { Check }
      if AllowInitial then
        BadPunct := [',']        // allow an initial, ie "J."
      else
        BadPunct := ['.', ','];  // Do not allow a period or a comma

      if ((not AllowBlank) and Empty(Value)) then
        AlertFmt('%s name of spouse is blank', [What]) else
      if ContainsAny(Value, BadPunct+DIGITS) or HasMoreThanOneSpace(Value) then
        with PersonInfo do
          AlertFmt('%s name did not parse correctly! ' + CRLF + CRLF + 
                   'Phrase: %s'     + CRLF +
                   'FirstName: %s'  + CRLF +
                   'MiddleName: %s' + CRLF +
                   'LastName: %s'   + CRLF +
                   'Suffix: %s. Contains punctuation or numeric characters.',
                   [What, Phrase, FirstName, MiddleName, LastName, Suffix]);
    end;  { Check }

begin { TfrmAddInfoFromDescendantsOfAbnerBDorrough.ParseComments }
  NrPhrases  := 0;
  fLine      := TheComments;
  if not Empty(fLine) then
    begin
      fNdx       := 0;
      NextCh;    // get 1st character in line
      SkipBlanks;
      PersonNumber := ReadNumber;
      if not Empty(PersonNumber) then
        begin
          OldAFN       := AFN;
          NewAFN       := DABDNumber(PersonNumber);
          if Empty(OldAFN) then
            AFN        := NewAFN
          else
            if not SameText(OldAFN, NewAFN) then
              AlertFmt('Mismatched AFN values: %s/%s', [OldAFN, NewAFN]);

          if Length(AFN) > 10 then
            AlertFmt('AFN (%s) exceeds max length of 10 characters', [AFN]);
        end;

      if not Empty(PersonNumber) then // if we found a person number, then look for the person name
        begin
          SkipChar(['.']);
          NextNdx      := StartOfNextPhrase(fNdx+1, fPhraseKind);

          Temp2        := ProperCase(ReadString([',', ';'], NextNdx-1));
          if not Empty(Temp2) then
            if Empty(PersonName) then
              PersonName := Trim(Temp2)
            else
              begin
                with VerifyInfo do
                  if ParseName(Temp2, Prefix, FirstName, MiddleName, LastName, Suffix, NickName) then
                    begin
                      if not (MySameText(Prefix,      lePrefix.Text,     'Prefix',    'Prefix',        ErrMsg) and
                              MySameText(FirstName,   leFirstName.Text,  'First Name', 'First Name',   ErrMsg) and
                              MySameText(MiddleName,  leMiddleName.Text, 'Middle Name', 'Middle Name', ErrMsg) and
                              MySameText(LastName,    leLastName.Text,   'Last Name', 'Last Name',     ErrMsg) and
                              MySameText(Suffix,      leSuffix.Text,     'Suffix',    'Suffix',        ErrMsg) and
                              MySameText(NickName,    leNickName.Text,   'Nick Name', 'Nick Name',     ErrMsg)) then
                        begin
                          MainName     := FullName(lePrefix.Text, leFirstName.Text, leMiddleName.Text, leLastName.Text, leSuffix.Text);
                          CommentsName := FullName(Prefix, FirstName, MiddleName, LastName, Suffix);
                          Alert('Names do not match between main and comments!' + CRLF +
                              MainName + CRLF +
                              CommentsName + CRLF +
                              ErrMsg);
                        end;
                    end;
              end;;
        end;

      DoingSpouseInfo := false;

      while fNdx <= Length(fLine) do
        begin
          NextNdx := StartOfNextPhrase(fNdx+1, fPhraseKind);
          if NextNdx < Length(fLine) then
            begin
              SetLength(PhraseInfo, NrPhrases+1);
              PhraseInfo[NrPhrases].StartOfPhrase := NextNdx;
              fNdx    := NextNdx;
              fCh     := fLine[fNdx];
              NextNdx := Length(fLine);
              if fPhraseKind in [dkHeMarried, dkSheMarried] then
                begin
                  Len      := Length(PhraseInfoArray[fPhraseKind].Key);
                  NextNdx  := StartOfNextPhrase(fNdx+Len, aPhraseKind);
                  NextNdxD := LookForNearestDate(fNdx+Len);
                  HasDate  := false;
                  if NextNdxD < NextNdx then
                    begin
                      NextNdx := NextNdxD;
                      HasDate := true;
                    end;
                  SkipBlanks;
                  fNdx := fNdx + Len;
                  aPhrase := '';
                  aStartOfPhrase := fNdx;
                  for i := fNdx to NextNdx-2 do   // read the name
                    begin
                      NextCh;
                      aPhrase := aPhrase + fCh;
                    end;
                  aPhrase := TrimTrailing(aPhrase, ['.', ';', ',', ' ', #10, #13]);
                  aPhraseKind := fPhraseKind;
                  if HasDate then
                    begin
                      fNdx := NextNdx;
                      NextNdx := StartOfNextPhrase(fNdx+1, DummyPhraseKind);
                      MarriageDate := Copy(fLine, fNdx, NextNdx-fNdx);
                      fNdx := NextNdx-1;
                      NextCh;
                      NextNdx := StartOfNextPhrase(fNdx, DummyPhraseKind);
                      MarriagePlace := ReadPhrase(DummyPhraseKind, [#0, '.'], Canonical, DummyStartOfPhrase, NextNdx);
                    end;
                end
              else
                aPhrase := ReadPhrase(aPhraseKind, [#0, '.'], Canonical, aStartOfPhrase, NextNdx);

              if fPhraseKind <> aPhraseKind then
                begin
                  lblStatus.Color := clYellow;
                  lblStatus.Caption := 'System error: unexpected PhraseKind: '
                                       + PhraseInfoArray[fPhraseKind].Key + '/'
                                       + PhraseInfoArray[aPhraseKind].Key

                end;

              with PhraseInfo[NrPhrases] do
                begin
                  Phrase      := aPhrase;
                  StartOfPhrase := aStartOfPhrase;
                  EndOfPhrase := fNdx;
                  PhraseKind  := aPhraseKind;
                end;
              Inc(NrPhrases);
            end
          else
            fNdx := NextNdx + 1; // force an exit from the loop
        end;
      LastPhraseKind := dkUnknown;
      for i := 0 to NrPhrases - 1 do
        with PhraseInfo[i] do
          begin
            if i < NrPhrases-1 then // see if it overlaps the next one
              if Length(Phrase) > (PhraseInfo[i+1].StartOfPhrase - StartOfPhrase) then
                Phrase := Copy(fLine, StartOfPhrase,  PhraseInfo[i+1].StartOfPhrase - StartOfPhrase); // truncate
            if not DoingSpouseInfo then
              case PhraseKind of
                dkBorn, dkWasBorn, dkHeWasBorn, dkSheWasBorn:
                  begin
                    if Empty(BirthDate) then
                      BirthDate := Phrase;
                    LastPhraseKind := dkBorn;
                  end;
                dkDied:
                  begin
                    if Empty(DeathDate) then
                      DeathDate := Phrase;
                    LastPhraseKind := dkDied;
                  end;
                dkPlace:
                  case LastPhraseKind of
                    dkBorn:
                      begin
                        if Empty(BirthPlace) then
                          BirthPlace := Phrase;
                        LastPhraseKind := dkUnknown;
                      end;
                    dkDied:
                      begin
                        if Empty(DeathPlace) then
                          DeathPlace := TrimTrailing(Phrase, [' ', ',']);
                        LastPhraseKind := dkUnknown;
                      end;
                  end;
                dkHeMarried, dkSheMarried:
                  begin
                    DoingSpouseInfo := true;
                    LastPhraseKind  := dkUnknown;
                    fSpouseInfo.Sex := Opposite(Sex);
                    MarriageInfo    := OppositeSexPronoun(Sex) + ' married ' + PersonName;
                    if not Empty(BirthDate) then
                      MarriageInfo := MarriageInfo + ' (born ' + BirthDate + ')';
                    with fSpouseInfo do
                      begin
                        if ParseName(Phrase, Prefix, FirstName, MiddleName, LastName, Suffix, NickName) then
                          begin
                            if Empty(FirstName) then
                              if Sex = 'F' then // no first name given-- assume that this is really the first name
                                begin
                                  FirstName := LastName;
                                  LastName  := UNKNOWNP;
                                end else
                              if Sex = 'M' then
                                FirstName := 'UNKNOWNP';  // How do we determine if this is really the first or the last name?

                            Check('Last',   Phrase, LastName,   fSpouseInfo, false, false);
                            Check('Middle', Phrase, MiddleName, fSpouseInfo, true,  true);
                            Check('First',  Phrase, FirstName,  fSpouseInfo, true,  false);
                          end
                        else
                          AlertFmt('"%s" could not be parsed as a name.', [aPhrase]);

                        if not Empty(MarriageDate) then
                          MarriageInfo := MarriageInfo + ' on ' + MarriageDate;
                        if not Empty(MarriagePlace) then
                          MarriageInfo := MarriageInfo + ' in ' + MarriagePlace;
                        MarriageInfo := MarriageInfo + '. ';
                        Comments := MarriageInfo + Copy(fLine, EndOfPhrase+1, Length(fLine)-EndOfPhrase);
                        Spouse_AFN := self.AFN;
                      end;
                  end;
              end
            else // DoingSpouseInfo
              with fSpouseInfo do
                case PhraseKind of
                  dkBorn, dkWasBorn, dkHeWasBorn, dkSheWasBorn:
                    if Empty(BirthDate) then
                      begin
                        BirthDate := Phrase;
                        LastPhraseKind := dkBorn;
                      end;
                  dkDied:
                    if Empty(DeathDate) then
                      begin
                        DeathDate := Phrase;
                        LastPhraseKind := dkDied;
                      end;
                  dkPlace:
                    case LastPhraseKind of
                      dkBorn:
                        begin
                          if Empty(BirthPlace) then
                            BirthPlace := Phrase;
                          LastPhraseKind := dkUnknown;
                        end;
                      dkDied:
                        begin
                          if Empty(DeathPlace) then
                            DeathPlace := TrimTrailing(Phrase, [' ', ',']);
                          LastPhraseKind := dkUnknown;
                        end;
                    end;
                end
          end;
      with fSpouseInfo do
        if (not Empty(FirstName) and Not Empty(LastName) and not Empty(Sex)) then
          if Empty(AFN) then
            AFN := self.AFN + Opposite(self.Sex);
      DisplayPersonInfo(mmoSpouse, fSpouseInfo, MarriageDate, MarriagePlace);
    end;
end;  { TfrmAddInfoFromDescendantsOfAbnerBDorrough.ParseComments }

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.ParseSelectedtext1Click(
  Sender: TObject);
begin
  if not Empty(mmoComments.Text) then
    ParseComments(mmoComments.Text);
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetSuffix: string;
begin
  result := leSuffix.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetSuffix(
  const Value: string);
begin
  leSuffix.Text := Value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.leSuffixChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.InsertParentsString1Click(
  Sender: TObject);
begin
  mmoComments.Text := ParentsString(Sex, fFatherInfo, fMotherInfo) + CRLF + CRLF + mmoComments.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.DeleteFirstSentenceinComments1Click(
  Sender: TObject);
var
  S2Pos: integer; Temp: string;
  LookFor: set of TPhraseKind;
begin
  if Sex = 'M' then
    LookFor := [dkHeIsTheSonOf, dkHeWasTheSonOf] else
  if Sex = 'F' then
    LookFor := [dkSheIsTheDaughterOf, dkSheWasTheDaughterOf]
  else
    LookFor := [];

  S2Pos := OffsetToPhrase(mmoComments.Text, LookFor, false);
  if S2Pos > 0 then
    mmoComments.Text := Copy(mmoComments.Text, S2Pos, Length(mmoComments.Text) - S2Pos) // delete stuff before "...he was the son/daughter of"
  else
    mmoComments.Text := ParentsString(Sex, fFatherInfo, fMotherInfo) + mmoComments.Text; // or insert "He was the son/daughter of "

  S2Pos := OffSetToPhrase(mmoComments.Text, [dkHeMarried, dkSheMarried], false);
  if S2Pos > 0 then
    begin
      Temp := mmoComments.Text;
      Insert(CRLF+CRLF, Temp, S2Pos);
      mmoComments.Text := Temp;
    end;

  with fSpouseInfo do // if no useful spouse info, then don't save it
    if (UnknownName(FirstName) or UnknownName(LastName)) then
      InitPersonInfo(fSpouseInfo);
end;

function TfrmAddInfoFromDescendantsOfAbnerBDorrough.GetPrefix: string;
begin
  result := lePrefix.Text;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.SetPrefix(
  const Value: string);
begin
  lePrefix.Text := Value;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.FormShow(
  Sender: TObject);
begin
  fAnyUpdates := false;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.Memo1KeyUp(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if key = VK_F2 then
   mmoComments.SetFocus;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.Memo1Change(
  Sender: TObject);
begin
  if Pos('+', Memo1.Text) > 0 then // more to come
    begin
      MoreToCome := true;
      if Empty(mmoComments.Text) then
        mmoComments.SetFocus;
    end;
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.lePersonNameExit(
  Sender: TObject);
begin
  PersonName := PersonName; // This implicitly changes Prefix, FirstName, ...
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.FormCreate(
  Sender: TObject);
begin
  lblStatus.Caption := '';
end;

procedure TfrmAddInfoFromDescendantsOfAbnerBDorrough.AutoFillDABD1Click(
  Sender: TObject);
begin
  AFN := 'dabd-' + IntToStr(gPrivateSettings.FakeDABDNr);
end;

end.
