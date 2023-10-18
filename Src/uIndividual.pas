unit uIndividual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBTables, DB, ADODB, Jpeg,
  ovctcmmn, ovctcell, ovctcstr, ovctchdr, ovcbase, ovctable, ovctcedt,
  Mask, DBCtrls, Buttons, Menus, FamilyTreePrivateSettings, PDB_Decl,
  FamilyTables, BrowserUnit, AdvancedSearch, MyTables, FamilyTree_Decl,
  ComCtrls, Math;

const
  c_CnStr       = 'Provider=Microsoft.Jet.OLEDB.4.0;'+
                  'Data Source=%s;'+
                  'Persist Security Info=False';

  col_Relation  = 0;
  col_Name      = 1;
  col_Birthdate = 2;
  col_Deathdate = 3;
  col_BirthPlace = 4;

  OLDEST_KNOWN_PERSON = 112;

type

  TPersonNumber = (pnSpouse, pnFather, pnMother);

  TPersonDisplayed = record
    LinkToButton: TButton;
    lblName: TLabel;
    lblBirth: TLabel;
    lblDeath: TLabel;
    LookupButton: TButton;
    Relation: string;
  end;

  TRelation = (r_Unknown, r_Son, r_Daughter, r_Brother, r_Sister, r_Child, r_Sibling);
  TRelationType = (rt_Siblings, rt_Children);

  TPersonDisplayed2 = record
    AFN: string;
    Relation: TRelation;
    TheFullName: string;
    BirthDate: string;
    DeathDate: string;
    BirthPlace: string;
  end;

  TBackList = class
  private
    fItems: Array of TPersonDisplayed2;
    function GetCount: integer;
    procedure SetCount(const Value: integer);
    procedure AddItem(aAFN: string; aRelation: TRelation; aFullName: string; aBirthDate, aDeathDate: string);
    function GetTop: integer;
    function GetItem(index: integer): TPersonDisplayed2;
    procedure SetItem(index: integer; const Value: TPersonDisplayed2);
    procedure DeleteItem(index: integer);
  public
    property Count: integer
             read GetCount
             write SetCount;
    property Top: integer
             read GetTop;
    property Items[index: integer]: TPersonDisplayed2
             read GetItem
             write SetItem;
  end;

type
  TNextPrev = (npPrev, npNext);

  TGenealogyStringList = class(TStringList)
  public
    function AbbrevFromID(ID: integer): string;
  end;

  TfrmIndividual = class(TForm)
    Image1: TImage;
    lblPerson: TLabel;
    btnSpouse: TButton;
    btnFather: TButton;
    btnMother: TButton;
    lblName: TLabel;
    lblBirth: TLabel;
    lblDeath: TLabel;
    btnLookupSpouse: TButton;
    btnLookupFather: TButton;
    btnLookupMother: TButton;
    btnLocatePicture: TButton;
    lblSpouseName: TLabel;
    lblSpouseBirth: TLabel;
    lblSpouseDeath: TLabel;
    lblFatherName: TLabel;
    lblFatherBirth: TLabel;
    lblFatherDeath: TLabel;
    lblMotherName: TLabel;
    lblMotherBirth: TLabel;
    lblMotherDeath: TLabel;
    otRelations: TOvcTable;
    OvcTCString1: TOvcTCString;
    OvcTCColHead1: TOvcTCColHead;
    RelationCol: TOvcTCString;
    Label1: TLabel;
    dbFirstName: TDBEdit;
    Label2: TLabel;
    dbMiddleName: TDBEdit;
    Label3: TLabel;
    dbLastName: TDBEdit;
    Label4: TLabel;
    dbBirthDate: TDBEdit;
    Label5: TLabel;
    dbDeathDate: TDBEdit;
    Label6: TLabel;
    dbSex: TDBEdit;
    Label7: TLabel;
    dbAFN: TDBEdit;
    DBNavigator1: TDBNavigator;
    OpenDialog1: TOpenDialog;
    btnLookup: TButton;
    btnBack: TBitBtn;
    Label8: TLabel;
    dbBirthPlace: TDBEdit;
    lblSearch: TLabel;
    dbSearch: TDBEdit;
    lblNickName: TLabel;
    dbNickName: TDBEdit;
    Label11: TLabel;
    dbComments: TDBMemo;
    lblDoubleClick: TLabel;
    OpenDialog2: TOpenDialog;
    btnBrowseDocument: TButton;
    dbDocFileName: TDBEdit;
    dbDocDescription: TDBEdit;
    dbDABD: TDBEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    pmPersonName: TPopupMenu;
    CopyText1: TMenuItem;
    CopyTextnoblanks1: TMenuItem;
    PopupMenuForm: TPopupMenu;
    Changedatafilelocations2: TMenuItem;
    N1: TMenuItem;
    AboutFamilyTree1: TMenuItem;
    dbSuffix: TDBEdit;
    Label16: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    Navigate1: TMenuItem;
    First1: TMenuItem;
    Prev1: TMenuItem;
    Next1: TMenuItem;
    Last1: TMenuItem;
    Utilities1: TMenuItem;
    UpdateCanonicalDates1: TMenuItem;
    SCanCanonicalDatesforErrors1: TMenuItem;
    DataSource1: TDataSource;
    btnClearSpouse: TButton;
    btnClearFather: TButton;
    btnClearMother: TButton;
    Label17: TLabel;
    dbDeathPlace: TDBEdit;
    Label18: TLabel;
    dbPrefix: TDBEdit;
    Label19: TLabel;
    dbCanonBirth: TDBEdit;
    lblCanonDeath: TLabel;
    dbCanonDeath: TDBEdit;
    N3: TMenuItem;
    fIfIND1: TMenuItem;
    puRelations: TPopupMenu;
    Addmalechild1: TMenuItem;
    Addfemalechild1: TMenuItem;
    AddUnknownChild1: TMenuItem;
    AdvancedFind1: TMenuItem;
    btnSourceID1: TButton;
    dbSource1: TDBText;
    btnSourceID2: TButton;
    dbSource2: TDBText;
    btnAdvancedSearch: TButton;
    ReScanforHighestKey1: TMenuItem;
    N4: TMenuItem;
    AddMaleChild2: TMenuItem;
    AddFemaleChild2: TMenuItem;
    N5: TMenuItem;
    dbAdded: TDBEdit;
    Label9: TLabel;
    Label10: TLabel;
    DBEdit2: TDBEdit;
    Individual1: TMenuItem;
    SetbirthplaceforallChildren1: TMenuItem;
    SetSourcesForAllChildren1: TMenuItem;
    ScanForSimilarRecords1: TMenuItem;
    dbRef: TDBEdit;
    Label12: TLabel;
    Help1: TMenuItem;
    ShowShortcuts1: TMenuItem;
    ClearFilter1: TMenuItem;
    pnlFiltered: TPanel;
    N6: TMenuItem;
    Refresh1: TMenuItem;
    SetParentsOfAllChildrenToCurrent1: TMenuItem;
    AddInfoFromDABD: TMenuItem;
    N7: TMenuItem;
    ReCalcNextAFN1: TMenuItem;
    N8: TMenuItem;
    SetOrder1: TMenuItem;
    LastFirstMiddle1: TMenuItem;
    CanonBirth1: TMenuItem;
    AFN1: TMenuItem;
    ChangeAFNsForSelectedRecords1: TMenuItem;
    btnEditSpouse: TButton;
    btnEditFather: TButton;
    btnEditMother: TButton;
    CountSelectedRecords1: TMenuItem;
    DateAdded1: TMenuItem;
    DateUpdated1: TMenuItem;
    Label20: TLabel;
    dbBirthOrder: TDBEdit;
    PopupMenu1: TPopupMenu;
    Parseselectedtextasname1: TMenuItem;
    SelectedTextToBirthDate1: TMenuItem;
    SelectedtexttoBirthPlace1: TMenuItem;
    SelectedtexttoDeathDate1: TMenuItem;
    SelectedtexttoDeathPlace1: TMenuItem;
    MenuItem1: TMenuItem;
    SelectedtexttoBirthDateBirthPlace1: TMenuItem;
    SelectedtexttoDeathDatePlace1: TMenuItem;
    MenuItem2: TMenuItem;
    InsertParentsString1: TMenuItem;
    FixDeathDateFormatforSelectedRecords1: TMenuItem;
    AboutFamilyTree2: TMenuItem;
    N9: TMenuItem;
    Options1: TMenuItem;
    CleanUpComments1: TMenuItem;
    lblStatus: TLabel;
    AddDABD1: TMenuItem;
    N10: TMenuItem;
    Post1: TMenuItem;
    AddRecord1: TMenuItem;
    CreateSpousefromSelectedText1: TMenuItem;
    btnClearPictureRef: TButton;
    N11: TMenuItem;
    NormalizeDABDAFNs1: TMenuItem;
    ScanforMissingRelations1: TMenuItem;
    btnFindNext: TButton;
    btnFindPrev: TButton;
    ViewLastLogFileTxt1: TMenuItem;
    Print1: TMenuItem;
    GenerateHTMLforSelectedRecords1: TMenuItem;
    EnlargeAFNs1: TMenuItem;
    ProgressBar1: TProgressBar;
    CalendarArithmetic1: TMenuItem;
    N12: TMenuItem;
    puCalendar: TPopupMenu;
    CalendarArithmetic2: TMenuItem;
    DeathDateCalendarArithmetic1: TMenuItem;
    btnEditPhoto: TButton;
    EditPhoto1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnSpouseClick(Sender: TObject);
    procedure btnFatherClick(Sender: TObject);
    procedure btnMotherClick(Sender: TObject);
    procedure otRelationsGetCellData(Sender: TObject; RowNum,
      ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    procedure btnLocatePictureClick(Sender: TObject);
    procedure btnLookupSpouseClick(Sender: TObject);
    procedure btnLookupFatherClick(Sender: TObject);
    procedure btnLookupMotherClick(Sender: TObject);
    procedure btnLookupClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure otRelationsDblClick(Sender: TObject);
    procedure btnBrowseDocumentClick(Sender: TObject);
    procedure btnPersonalEventsClick(Sender: TObject);
    procedure CopyTextnoblanks1Click(Sender: TObject);
    procedure CopyText1Click(Sender: TObject);
    procedure dbSearchEnter(Sender: TObject);
    procedure dbSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Changedatafilelocations2Click(Sender: TObject);
    procedure AboutFamilyTree1Click(Sender: TObject);
    procedure First1Click(Sender: TObject);
    procedure Prev1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure Last1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure UpdateCanonicalDates1Click(Sender: TObject);
    procedure SCanCanonicalDatesforErrors1Click(Sender: TObject);
    procedure btnClearSpouseClick(Sender: TObject);
    procedure btnClearFatherClick(Sender: TObject);
    procedure btnClearMotherClick(Sender: TObject);
    procedure dbDeathPlaceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Addmalechild1Click(Sender: TObject);
    procedure Addfemalechild1Click(Sender: TObject);
    procedure AddUnknownChild1Click(Sender: TObject);
//  procedure AdvancedFind1Click(Sender: TObject);
    procedure btnSourceID1Click(Sender: TObject);
    procedure btnSourceID2Click(Sender: TObject);
    procedure btnAdvancedSearchClick(Sender: TObject);
    procedure ReScanforHighestKey1Click(Sender: TObject);
    procedure SetFilter1Click(Sender: TObject);
    procedure AddMaleChild2Click(Sender: TObject);
    procedure AddFemaleChild2Click(Sender: TObject);
    procedure dbBirthDateExit(Sender: TObject);
    procedure dbDeathDateExit(Sender: TObject);
    procedure SetbirthplaceforallChildren1Click(Sender: TObject);
    procedure SetSourcesForAllChildren1Click(Sender: TObject);
    procedure ScanForSimilarRecords1Click(Sender: TObject);
    procedure ShowShortcuts1Click(Sender: TObject);
    procedure ClearFilter1Click(Sender: TObject);
    procedure pnlFilteredClick(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure SetParentsOfAllChildrenToCurrent1Click(Sender: TObject);
    procedure AddInfoFromDABDClick(Sender: TObject);
    procedure ReCalcNextAFN1Click(Sender: TObject);
    procedure LastFirstMiddle1Click(Sender: TObject);
    procedure CanonBirth1Click(Sender: TObject);
    procedure AFN1Click(Sender: TObject);
    procedure ChangeAFNsForSelectedRecords1Click(Sender: TObject);
    procedure btnEditSpouseClick(Sender: TObject);
    procedure btnEditFatherClick(Sender: TObject);
    procedure btnEditMotherClick(Sender: TObject);
    procedure CountSelectedRecords1Click(Sender: TObject);
    procedure DateAdded1Click(Sender: TObject);
    procedure DateUpdated1Click(Sender: TObject);
    procedure Parseselectedtextasname1Click(Sender: TObject);
    procedure SelectedTextToBirthDate1Click(Sender: TObject);
    procedure SelectedtexttoBirthPlace1Click(Sender: TObject);
    procedure SelectedtexttoDeathDate1Click(Sender: TObject);
    procedure SelectedtexttoDeathPlace1Click(Sender: TObject);
    procedure SelectedtexttoBirthDateBirthPlace1Click(Sender: TObject);
    procedure SelectedtexttoDeathDatePlace1Click(Sender: TObject);
    procedure FixDeathDateFormatforSelectedRecords1Click(Sender: TObject);
    procedure AboutFamilyTree2Click(Sender: TObject);
    procedure InsertParentsString1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure CleanUpComments1Click(Sender: TObject);
    procedure Post1Click(Sender: TObject);
    procedure AddRecord1Click(Sender: TObject);
    procedure CreateSpousefromSelectedText1Click(Sender: TObject);
    procedure btnClearPictureRefClick(Sender: TObject);
    procedure NormalizeDABDAFNs1Click(Sender: TObject);
    procedure ScanforMissingRelations1Click(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure btnFindPrevClick(Sender: TObject);
    procedure ViewLastLogFileTxt1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure GenerateHTMLforSelectedRecords1Click(Sender: TObject);
    procedure EnlargeAFNs1Click(Sender: TObject);
    procedure CalendarArithmetic1Click(Sender: TObject);
    procedure CalendarArithmetic2Click(Sender: TObject);
    procedure DeathDateCalendarArithmetic1Click(Sender: TObject);
    procedure EditPhoto1Click(Sender: TObject);
    procedure btnEditPhotoClick(Sender: TObject);
  private
    { Private declarations }
    fAFN: string;
    fDataSourcesBrowser: TfrmDataSetBrowser;
    fSelectivityInfo: TPersonInfo;
    fPersonInfo: TPersonInfo;
    fFilterInfo: TPersonInfo;
    fRecentlyAddedAFNs: TStringList;
    fSpouseInfo: TPersonInfo;
    fFatherInfo: TPersonInfo;
    fLogPathFileName: string;
    fMotherInfo: TPersonInfo;
    fFindingAdvanced: boolean;
    fOutFile: TextFile;
    fSourcesList: TGenealogyStringList;
    fTempFileName: string;
    fGenealogySourcesTable: TGenealogySourcesTable;
    fPeopleDisplayed: array[TPersonNumber] of TPersonDisplayed;
    fRelations: array of TPersonDisplayed2;

    fSpouse_AFN, fFather_AFN, fMother_AFN: string;
    fAdvancedSearchForm: TfrmAdvancedSearch;

    fBackList: TBackList;
    fInhibitShow: boolean;
    fFamilyTable: TFamilyTable;
    fTempFamilyTable: TFamilyTable;

    procedure ShowRelation(const AFN: string; pn: TPersonNumber; Var PersonInfo: TPersonInfo);
    procedure LinkToRelation(aRow: integer);
    procedure ShowPerson(AFN: string);
    function LookupIndividual(aCaption: string; aDefPersonInfo: TPersonInfo;
                              var SelectedPersonInfo: TPersonInfo;
                              var TableWasUpdated: boolean): boolean;
    procedure GetRelation( aCaption,
                           FieldName: string;
                           DefInfo: TPersonInfo);
    procedure Enable_Buttons;
    procedure UpdateSearchName(Force: boolean);
    function LoadPrivateSettings: TFTPrivateSettings;
    function GetPrivateSettingsFromUser(
      PrivateSettings: TFTPrivateSettings): boolean;
    function GetFamilyTable: TFamilyTable;
    procedure FamilyTableBeforePost(DataSet: TDataSet);
    procedure FamilyTableAfterScroll(DataSet: TDataSet);
    procedure FamilyTablePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ClearAFN(Field: TField; relName, relBirth, relDeath: TLabel; var PersonInfo: TPersonInfo);
    procedure LoadAFN(const AFN, Relation: string);
    procedure AddChild(Caption, ChildSex: string);
    function DataSourcesBrowser: TFrmDataSetBrowser;
    function GenealogySourcesTable: TGenealogySourcesTable;
    function GenealogySourcesList: TGenealogyStringList;
    procedure UpdateDataSourceHint;
    procedure FilterFamilyRecords(aDataset: TDataSet; var Accept: boolean);
    function CompareCanonicalDates(DateI, DateJ: string; YearsToAdd: integer;
      var ErrorMsg: string): integer;
    function FilesClosed(state: boolean): boolean;
    procedure LogError(const Msg: string; Args: array of const; var ErrorCount: integer);
    function EditInfo(var PersonInfo: TPersonInfo; Relation: string; FieldToUpdate: string): boolean;
    function GetTempFamilyTable: TFamilyTable;
    procedure DisplayPersonInfo(pn: TPersonNumber;
      PersonInfo: TPersonInfo);
    procedure CheckRelationAFNs;
    procedure FamilyTableBeforeScroll(DataSet: TDataSet);
    procedure ChangeToIndex(MenuItem: TMenuItem; const FieldNames: string);
    procedure ShowStatus(const Msg: string; HighLight: boolean = false);
    procedure CreateSpouseFromSelectedText(const TheText: string);
    function GetRecentlyAddedAFNs: TStringList;
    procedure FindNextPrev(NextPrev: TNextPrev);
    function GetSelectivityInfo: boolean;
    procedure FamilyTableAfterInsert(DataSet: TDataSet);
    procedure RecalcNextAFN;
    procedure OpenFamilyTable;
  protected
  public
    { Public declarations }
    Query: TFamilyQuery;
    property FamilyTable: TFamilyTable
             read GetFamilyTable;
    property TempFamilyTable: TFamilyTable
             read GetTempFamilyTable
             write fTempFamilyTable;
    property RecentlyAddedAFNs: TStringList
             read GetRecentlyAddedAFNs;

    Constructor Create(aOwner: TComponent); override;
    Destructor Destroy; override;
    function Locate_AFN(DataSet: TDataSet; const AFN: string): boolean;
    procedure AddSiblings(const AFN, Father_AFN, Mother_AFN: string);
    procedure AddChildren(const AFN: string);
    procedure AddPerson(Query: TFamilyQuery; rt: TRelationType);
  end;

var
  frmIndividual        : TfrmIndividual;

implementation

uses
  uLookupIndividual, MyUtils, PersonalEvents,
  Clipbrd, FamilyTreePrivateSettingsDialog, About, PDBUtils, MyTables_Decl,
  PhotoDBCommonSettings, uGetString, ShortCuts,
  AddInfoFromDescendantsOfAbnerBDorrough, ChangeAFNs, FamilyTree_Utils,
  StStrL, DateUtils, HTML_Stuff, CalendarArithmetic;

{$R *.dfm}

const
  cMOTHER = 'Mother';
  cFATHER = 'Father';
  cSPOUSE = 'Spouse';

  LOGFILENAME = 'LogFile.txt';

var
  Relations: array[TRelation] of string =
             (  { r_Unknown }   '',
                { r_Son }       'Son',
                { r_Daughter }  'Daughter',
                { r_Brother }   'Brother',
                { r_Sister }    'Sister',
                { r_Child }     'Child',
                { r_Sibling }   'Sibling'
             );

{ TfrmIndividual }

function TfrmIndividual.LoadPrivateSettings: TFTPrivateSettings;
begin
  result      := TFTPrivateSettings.Create(nil);
  try
    result.LoadFromFile(PrivateSettingsFileName);
  except
    result.SaveToFile(PrivateSettingsFileName);
    raise
  end;
end;

function TfrmIndividual.GetPrivateSettingsFromUser(PrivateSettings: TFTPrivateSettings): boolean;
begin
  result := false;
  frmGetPrivateSettingsFromUser := TfrmGetPrivateSettingsFromUser.Create(self);
  try
    with frmGetPrivateSettingsFromUser do
      begin
        leDatabaseName.Text     := PrivateSettings.FamilyTreeDataBaseFileName;
        leDataFolder.Text       := PrivateSettings.LocalWebFolder;
        leNextAFN.Text          := IntToStr(PrivateSettings.NextAFN);
        leLastAFN.Text          := PrivateSettings.LastAFN;
        leLastOrderFields.Text  := PrivateSettings.LastOrderFields;
        leFakeDABDNr.Text       := IntToStr(PrivateSettings.FakeDABDNr);
        leHTMLOutputFolder.Text := PrivateSettings.HTMLOutputFolder;
        lePhotoEditorPathName.Text := PrivateSettings.PhotoEditorPathName;

        if ShowModal = mrOk then
          begin
            PrivateSettings.FamilyTreeDataBaseFileName := leDatabaseName.Text;
            PrivateSettings.LocalWebFolder              := leDataFolder.Text;
            PrivateSettings.NextAFN                     := StrToInt(leNextAFN.Text);
            PrivateSettings.LastAFN                     := leLastAFN.Text;
            PrivateSettings.LastOrderFields             := leLastOrderFields.Text;
            PrivateSettings.FakeDABDNr                  := StrToInt(leFakeDABDNr.Text);
            PrivateSettings.HTMLOutputFolder            := leHTMLOutputFolder.Text;
            PrivateSettings.PhotoEditorPathName         := lePhotoEditorPathName.Text;

            result       := true;
          end;
      end;
  finally
    FreeAndNil(frmGetPrivateSettingsFromUser);
  end;
end;


procedure TfrmIndividual.RecalcNextAFN;
var
  TempFamilyTable: TFamilyTable;
begin
  TempFamilyTable := TFamilyTable.Create( self,
                                          gPrivateSettings.FamilyTreeDataBaseFileName,
                                          cFAMILY,
                                          [optUseClient, optReadOnly]);
  with TempFamilyTable do
    begin
      Active := true;
      First;
      while not eof do
        begin
          if IsPureNumeric(fldAFN.AsString) and (fldAFN.AsInteger > gPrivateSettings.NextAFN) then
            gPrivateSettings.NextAFN := fldAFN.AsInteger;
          Next;
        end;
    end;
  TempFamilyTable.Free;
  gPrivateSettings.NextAFN := gPrivateSettings.NextAFN + 1;
end;

procedure TfrmIndividual.OpenFamilyTable;
var
  OK: boolean;

begin
  repeat
    Query := TFamilyQuery.Create(self);
    Query.Connection       := MyConnection(gPrivateSettings.FamilyTreeDataBaseFileName);
    Ok := false;
    try
      FamilyTable.Active := true;
      Ok := FamilyTable.Active;
    except
      on e:Exception do
        if YesFmt('The FamilyTable (%s) could not be opened [%s]. Would you like to change it?',
                [gPrivateSettings.FamilyTreeDataBaseFileName, e.Message]) then
          begin
          { Locate new path for DB }
            GetPrivateSettingsFromUser(gPrivateSettings);
            gDBFileName := '';
            FreeAndNil(fFamilyTable);
            FreeAndNil(Query);
          end
        else
          Halt;
    end;
  until Ok;
end;


constructor TfrmIndividual.Create(aOwner: TComponent);
const
  NEEDED_WIDTH  = 996;
  NEEDED_HEIGHT = 842;
begin { TfrmIndividual.Create }
  inherited Create(aOwner);

  BorderStyle         := bsSizeable;
  Width               := Math.Min(NEEDED_WIDTH, ClientWidth);
  Height              := Math.Min(NEEDED_HEIGHT, ClientHeight);
  HorzScrollBar.Range := NEEDED_WIDTH;
  VertScrollBar.Range := NEEDED_HEIGHT;

  ShowStatus('', false);

  gEXEPath2    := ExtractFilePath(ParamStr(0));
  gEXEPath2    := ForceBackSlash(gEXEPath2);
  gPHOTOPATH   := gEXEPath2 + DEFAULT_IMAGES;
  gDOCFILEPATH := gEXEPath2 + DEFAULT_DOCS;
  gTempFolder  := TempPath;

  try
    gPrivateSettings := LoadPrivateSettings;
  except
    gPrivateSettings := TFTPrivateSettings.Create(nil);
    if not GetPrivateSettingsFromUser(gPrivateSettings) then
      Exit;
  end;
  gPHOTOPATH   := ForceBackSlash(gPrivateSettings.LocalWebFolder) + DEFAULT_IMAGES;
  gDOCFILEPATH := ForceBackSlash(gPrivateSettings.LocalWebFolder) + DEFAULT_DOCS;

  if not SameText(gExePath2, gPrivateSettings.ExePath) then
    begin
      AlertFmt('Executable path [%s] '+CRLF+
               'has been changed to [%s].'+CRLF+
               'Please update location settings.',
               [gPrivateSettings.ExePath, gExePath2]);
      if not GetPrivateSettingsFromUser(gPrivateSettings) then
        Exit;
    end;

  fBackList := TBackList.Create;
  fBackList.Count := 0;

  with fPeopleDisplayed[pnSpouse] do
    begin
      LinkToButton := btnSpouse;
      lblName      := lblSpouseName;
      lblBirth     := lblSpouseBirth;
      lblDeath     := lblSpouseDeath;
      LookupButton := btnLookupSpouse;
      Relation     := 'Spouse';
    end;

  with fPeopleDisplayed[pnFather] do
    begin
      LinkToButton := btnFather;
      lblName      := lblFatherName;
      lblBirth     := lblFatherBirth;
      lblDeath     := lblFatherDeath;
      LookupButton := btnLookupFather;
      Relation     := 'Father';
    end;

  with fPeopleDisplayed[pnMother] do
    begin
      LinkToButton := btnMother;
      lblName      := lblMotherName;
      lblBirth     := lblMotherBirth;
      lblDeath     := lblMotherDeath;
      LookupButton := btnLookupMother;
      Relation     := 'Mother';
    end;

  InitPersonInfo(fSelectivityInfo);
  InitPersonInfo(fFilterInfo);

  OpenFamilyTable;

  gPrivateSettings.ExePath := gExePath2;

  if (not FilesClosed(false)) or (gPrivatesettings.NextAFN = 0) then // mark the files as OPEN 
    RecalcNextAFN;    // so recalculate the next AFN number

  GenealogySourcesTable;    // load the list of genealogy sources

  ChangeToIndex(nil, gPrivateSettings.LastOrderFields);

  if Locate_AFN(FamilyTable, gPrivateSettings.LastAFN) then
    ShowPerson(gPrivateSettings.LastAFN)
  else
    FamilyTable.First;

  fLogPathFileName := gTempFolder + LOGFILENAME;
end;  { TfrmIndividual.Create }

procedure TfrmIndividual.LinkToRelation(aRow: integer);
  var
    PersonNr: integer;
begin
  PersonNr := aRow - 1;

  with fRelations[PersonNr] do
    LoadAFN(fRelations[PersonNr].AFN, 'relation');
end;

destructor TfrmIndividual.Destroy;
begin
  FreeAndNil(Query);
  FreeAndNil(fBackList);
  FreeAndNil(fFamilyTable);
  FreeAndNil(fAdvancedSearchForm);
//  FreeAndNil(frmAddInfoFromDescendantsOfAbnerBDorrough);

  inherited;
end;

procedure TfrmIndividual.LogError(const Msg: string; Args: array of const; var ErrorCount: integer);
var
  Temp: string;
begin { LogError }
  Temp := Format(Msg, Args);
  WriteLn(fOutFile, Temp);
  Inc(ErrorCount);
end;  { LogError }

procedure TfrmIndividual.ScanCanonicalDatesforErrors1Click(
  Sender: TObject);
var
  SavedRecNo : integer;
  Count, ErrorCount: integer;
  TheFullName, Temp: string;
  i1: integer;
  ErrorMsg: string;

  procedure ValidateSpouseDatesAndSexes(PersonAFN, SpouseAFN, TheFullName, PersonBirthDate, PersonDeathDate, PersonSex: string);
  var
    i1, i2: integer;
    ErrorMsg: string;
    CanonSpouseBirthDate, CanonSpouseDeathDate, SpouseSex: string;
  begin
    if not Empty(SpouseAFN) then
      with TempFamilyTable do
        if Locate('AFN', SpouseAFN, [loCaseInsensitive]) then
          begin
            CanonSpouseDeathDate := fldCanonDeath.AsString;
            CanonSpouseBirthDate := fldCanonBirth.AsString;
            SpouseSex            := fldSex.AsString;
            if SameText(PersonSex, SpouseSex) then
              LogError('%10s: %-25s: Sex [%s] is same as spouse''s [%s]',
                [PersonAFN, TheFullName, PersonSex, SpouseSex], ErrorCount);
            i2 := CompareCanonicalDates(PersonBirthDate, CanonSpouseDeathDate, 0, ErrorMsg);
            if i2 = +1 then // person born after spouse died
              LogError('%10s: %-25s: Birth Date [%s] is after spouse''s Death Date [%s]',
                          [PersonAFN, TheFullName, PersonBirthDate, CanonSpouseDeathDate], ErrorCount) else
            if i2 = -2 then
              LogError('%10s: %-25s: Birth Date [%s] or spouse''s Death Date [%s] is not valid',
                          [PersonAFN, TheFullName, PersonBirthDate, CanonSpouseDeathDate], ErrorCount);

            i1 := CompareCanonicalDates(PersonDeathDate, CanonSpouseBirthDate, 0, ErrorMsg);
            if i1 = -1 then // person died before spouse born
              LogError('%10s: %-25s: Death Date [%s] is before spouse''s Birth Date [%s]',
                       [PersonAFN, TheFullName, PersonBirthDate, CanonSpouseBirthDate], ErrorCount) else
            if i1 = -2 then // error in date
             LogError('%10s: %-25s: Death Date [%s] or spouse''s Birth Date [%s] is not valid',
                          [PersonAFN, TheFullName, PersonBirthDate, CanonSpouseBirthDate], ErrorCount)
          end;
  end;

  procedure ValidateParentInfo(const Relation, ChildAFN, ParentAFN, TheFullName, CanonChildBirthDate: string);
  const
    MENARCH = 13;
  var
    i1, i2: integer;
    ErrorMsg: string;
    CanonParentBirthDate, CanonParentDeathDate: string;
  begin { ValidateParentInfo }
    if not Empty(ParentAFN) then
      with TempFamilyTable do
        begin
          if Locate('AFN', ParentAFN, [loCaseInsensitive]) then
            begin
              CanonParentBirthDate := TempFamilyTable.fldCanonBirth.AsString;
              i1 := CompareCanonicalDates(CanonChildBirthDate, CanonParentBirthDate, MENARCH, ErrorMsg);
              if i1 = -1 then // child born before parent was at least 13 years old
                LogError('%10s: %-25s: Birth Date [%s] is NOT more than %d years after %s''s Birth Date [%s]',
                            [ChildAFN, TheFullName, CanonChildBirthDate, MENARCH, Relation, CanonParentBirthDate], ErrorCount) else
              if i1 = -2 then // error in date
                LogError('%10s: %-25s: Birth Date [%s] or %s''s Birth Date [%s] is not valid',
                            [ChildAFN, TheFullName, CanonChildBirthDate, Relation, CanonParentBirthDate], ErrorCount);

              CanonParentDeathDate := TempFamilyTable.fldCanonDeath.AsString;
              i2 := CompareCanonicalDates(CanonChildBirthDate, CanonParentDeathDate, 1, ErrorMsg);
              if i2 = +1 then // child born before parent died
                LogError('%10s: %-25s: Birth Date [%s] is more than %d years %s''s Death Date [%s]',
                            [ChildAFN, TheFullName, CanonChildBirthDate, 1, Relation, CanonParentDeathDate], ErrorCount) else
              if i2 = -2 then
                LogError('%10s: %-25s: Birth Date [%s] or %s''s Death Date [%s] is not valid',
                            [ChildAFN, TheFullName, CanonChildBirthDate, Relation, CanonParentDeathDate], ErrorCount);
            end
          else
            LogError('%10s: %-25s: %s record [%s] could not be found', [ChildAFN, TheFullName, Relation, ParentAFN], ErrorCount);
        end;
  end;  { ValidateParentInfo }

begin { TfrmIndividual.ScanCanonicalDatesforErrors1Click }
  with FamilyTable do
    begin
      if State in [dsEdit, dsInsert] then
        Post;
      SavedRecNo := RecNo;
      AssignFile(fOutFile, fLogPathFileName);
      ReWrite(fOutFile);
      Count := 0; ErrorCount := 0;
      TempFamilyTable.Filtered := false;

      try
        DisableControls;
        ShowStatus('Processed=0, Errors=0', false);
        Application.ProcessMessages;
        First;
        while not Eof do
          begin
            if not Empty(fldCanonBirth.AsString) then
              begin
                TheFullName := FullName;

                i1 := CompareCanonicalDates(fldCanonBirth.AsString, fldCanonDeath.AsString, 0, ErrorMsg);
                if i1 > 0 then
                  LogError('%10s: %-25s: Birth Date [%s] is after Death Date [%s]',
                           [fldAFN.AsString, TheFullName, fldCanonBirth.AsString, fldCanonDeath.AsString], ErrorCount)
                else if i1 = -2 then
                  LogError('%10s: %-25s: Birth Date [%s] or s Death Date [%s] is not valid',
                            [fldAFN.AsString, TheFullName, fldCanonBirth.AsString, fldCanonDeath.AsString], ErrorCount);

                i1 := CompareCanonicalDates(fldCanonDeath.AsString, fldCanonBirth.AsString, OLDEST_KNOWN_PERSON, ErrorMsg);
                if i1 > 0 then
                  LogError('%10s: %-25s: Death Date [%s] is more than %d years after Birth Date [%s]',
                           [fldAFN.AsString, TheFullName, fldCanonDeath.AsString, OLDEST_KNOWN_PERSON, fldCanonBirth.AsString], ErrorCount);

                ValidateParentInfo(cMOTHER, fldAFN.AsString, fldMother_AFN.AsString, TheFullName, fldCanonBirth.AsString);
                ValidateParentInfo(cFATHER, fldAFN.AsString, fldFather_AFN.AsString, TheFullName, fldCanonBirth.AsString);
                ValidateSpouseDatesAndSexes(fldAFN.AsString,
                                            fldSpouse_AFN.AsString,
                                            TheFullName,
                                            fldCanonBirth.AsString,
                                            fldCanonDeath.AsString,
                                            fldSex.AsString);
              end;
            Next;
            inc(Count);
            if (Count mod 100) = 0 then
              ShowStatus(Format('Processed = %d, Errors = %d', [Count, ErrorCount]), false);
          end;
      finally
        if ErrorCount > 0 then
          begin
            CloseFile(fOutFile);
            if ErrorCount > 0 then
              begin
                AlertFmt('%d errors were found', [ErrorCount]);
                temp := Format('Notepad.exe %s', [fLogPathFileName]);
                FileExecute(temp, false);
              end
            else
              Alert('No errors were detected');
          end
        else
          Alert('No errors were detected');

        EnableControls;
        FreeAndNil(fTempFamilyTable);  // force it to be re-created
        RecNo := SavedRecNo;
      end;
    end;
end;  { TfrmIndividual.ScanCanonicalDatesforErrors1Click }

procedure TfrmIndividual.ShowPerson(AFN: string);
var
  FileName: string;
  Saved_Cursor: TCursor;

  procedure ShowPicture;
  begin { ShowPicture }
    with FamilyTable do
      begin
        lblPerson.Caption := FullName;

        FileName := gPhotoPath + fldImage.AsString;
        Image1.Picture.Graphic := nil;
        Image1.ShowHint := false;
        if FileExists(FileName) then
          with Image1 do
            if Assigned(Picture) then
              try
                Picture.LoadFromFile(FileName);  // Copy JPEG to bitmap:
                btnLocatePicture.Hint := FileName;
                btnLocatePicture.ShowHint := true;
                Hint := FileName;
                ShowHint := true;
              except
                on EInvalidGraphic do
                  Image1.Picture.Graphic := nil;
              end
        else
          ShowStatus(Format('Photo "%s" could not be located', [FileName]), true);
      end;
  end; { ShowPicture }

  procedure AddBackList;
  var
    aFullName: string;
  begin { AddBackList }
    with FamilyTable do
      begin
        aFullName := FullName;
        fBackList.AddItem(fldAFN.AsString, r_Unknown, aFullName, '', '');
      end;
    with fBackList do
      if Count > 1 then
        btnBack.Hint := Items[Top-1].TheFullName;
    btnBack.ShowHint := true;
  end;  { AddBackList }

begin { ShowPerson }
  if fInhibitShow then
    exit;

  Saved_Cursor  := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    fAFN := AFN;

    with fBackList do
      begin
        if Count = 0 then
          AddBackList else
        if Items[top].AFN <> AFN then // We're not already on the top of the stack
          AddBackList;
      end;

    Enable_Buttons;
    otRelations.Invalidate;
    SetLength(fRelations, 0);  // empty the table

    with FamilyTable do
      begin
        ShowPicture;

        LoadPersonInfo(fPersonInfo);

        fSpouse_AFN := fldSpouse_AFN.AsString;
        fMother_AFN := fldMother_AFN.AsString;
        fFather_AFN := fldFather_AFN.AsString;

        ShowRelation(fSpouse_AFN, pnSpouse, fSpouseInfo);

        ShowRelation(fFather_AFN, pnFather, fFatherInfo);

        ShowRelation(fMother_AFN, pnMother, fMotherInfo);

        otRelations.AllowRedraw := false;
        otRelations.RowLimit    := 2;
        AddSiblings(AFN, fFather_AFN, fMother_AFN);
        AddChildren(AFN);
        dbBirthDate.Hint := fldCanonBirth.AsString;
        dbDeathDate.Hint := fldCanonDeath.AsString;
        UpdateDataSourceHint;
        pnlFiltered.Visible := FamilyTable.Filtered;
        otRelations.AllowRedraw := true;
      end;
  finally
    Screen.Cursor := Saved_Cursor;
  end;
end;  { ShowPerson }

procedure TfrmIndividual.UpdateDataSourceHint;
var
  Temp: string;
begin
  with FamilyTable do
    if Assigned(fSourcesList) then
      begin
        if fldSourceID1.AsInteger > 0 then
          begin
            temp := GenealogySourcesList.AbbrevFromID(fldSourceID1.AsInteger);
            dbSource1.Hint    := temp;
            dbSource1.ShowHint := true;
            btnSourceID1.Hint := temp;
            btnSourceID1.ShowHint := true;
          end;
        if fldSourceID2.AsInteger > 0 then
          begin
            temp := GenealogySourcesList.AbbrevFromID(fldSourceID2.AsInteger);
            dbSource2.Hint    := temp;
            dbSource2.ShowHint := true;
            btnSourceID2.Hint := temp;
            btnSourceID2.ShowHint := true;
          end;
      end;
end;


function TfrmIndividual.Locate_AFN(DataSet: TDataSet; const AFN: string): boolean;
begin
  if DataSet.State in [dsEdit, dsInsert] then
    DataSet.Post;

  try
    result := DataSet.Locate('AFN', AFN, []);
  except
    result := false;
  end;
end;

procedure TfrmIndividual.ShowRelation(const AFN: string; pn: TPersonNumber; Var PersonInfo: TPersonInfo);
begin
  if Assigned(Query) then
    begin
      with Query do
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('SELECT AFN, Prefix, FirstName, MiddleName, LastName, NickName, Suffix, BirthDate, BirthOrder, CanonBirth, Birthplace, DeathDate, CanonDeath, DeathPlace, Sex, Spouse_AFN, Father_AFN, Mother_AFN ');
          SQL.Add('FROM Family ');
          Sql.Add(Format('Where (AFN = "%s")', [AFN]));
          ExecSQL;
          Active := true;
        end;

      with fPeopleDisplayed[pn], Query do
        begin
          if not Empty(AFN) then
            if Locate_AFN(Query, AFN) then
              begin
                LoadPersonInfo(PersonInfo);
                DisplayPersonInfo(pn, PersonInfo);
                LinkToButton.Enabled := true;
              end
            else
              begin
                InitPersonInfo(PersonInfo);
                DisplayPersonInfo(pn, PersonInfo);
                lblName.Caption  := Format('%s [%s] Could not be found', [Relation, AFN]);
              end
          else
            begin
              InitPersonInfo(PersonInfo);
              DisplayPersonInfo(pn, PersonInfo);
            end;
        end;
    end;
end;

procedure TfrmIndividual.LoadAFN(const AFN, Relation: string);
var
  Saved_Cursor: TCursor;
begin
  Saved_Cursor  := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    if not Locate_AFN(FamilyTable, AFN) then
      begin
        FamilyTable.Close;
        FamilyTable.Open;
        if not Locate_AFN(FamilyTable, AFN) then
          AlertFmt('Cannot locate %s [%s]', [Relation, AFN]);
      end;
  finally
    Screen.Cursor := Saved_Cursor;
  end;
end;

procedure TfrmIndividual.btnSpouseClick(Sender: TObject);
begin
  LoadAFN(fSpouse_AFN, 'spouse');
end;

procedure TfrmIndividual.btnFatherClick(Sender: TObject);
begin
  LoadAFN(fFather_AFN, 'father');
end;

procedure TfrmIndividual.btnMotherClick(Sender: TObject);
begin
  LoadAFN(fMother_AFN, 'mother');
end;

procedure TfrmIndividual.AddChildren(const AFN: string);
begin
  if not Empty(AFN) then
    if Assigned(Query) then
      try
        with Query do
          begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT AFN, Prefix, FirstName, MiddleName, LastName, Suffix, NickName, BirthDate, BirthOrder, DeathDate, BirthPlace, Sex ');
            SQL.Add('FROM Family ');

            // children must have this person as father or mother

            Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s") ORDER BY BirthOrder, CanonBirth',
                                 [AFN, AFN]));

            with Query do
              begin
                ExecSQL;
                Active := true;
                First;
                while not Eof do
                  begin
                    AddPerson(Query, rt_Children);
                    Next;
                  end;
              end;
          end;
      finally
        Query.Active := false;
      end;
end;

procedure TfrmIndividual.AddPerson(Query: TFamilyQuery; rt: TRelationType);
  var
    Len: integer; Sex: string;  aRelation: TRelation;

  function GetRelationship(const Sex: string): TRelation;
  begin { GetRelationship }
    result := r_Unknown;
    if Length(Sex) >= 1 then
      case rt of
        rt_Siblings:
          case Sex[1] of
            'M': result := r_Brother;
            'F': result := r_Sister;
            '?': result := r_Sibling;
          end;
        rt_Children:
          case Sex[1] of
            'M': result := r_Son;
            'F': result := r_Daughter;
            '?': result := r_Child;
          end;
      end;
  end;  { GetRelationship }

begin { AddPerson }
  with Query do
    begin
      Sex := UpperCase(fldSEX.AsString);

      aRelation := GetRelationship(Sex);;

      if aRelation <> r_Unknown then
        begin
          len := Length(fRelations);
          SetLength(fRelations, len+1);
          with fRelations[len] do
            begin
              AFN         := fldAFN.AsString;
              Relation    := aRelation;
              TheFullName := FullName;
              BirthDate   := fldBirthDate.AsString;
              DeathDate   := fldDeathDate.AsString;
              BirthPlace  := fldBirthPlace.AsString;
            end;
        end;
    end;

  Len := Length(fRelations);
  if Len >= otRelations.RowLimit then
    otRelations.RowLimit := Len + 1;
end;  { AddPerson }

procedure TfrmIndividual.AddSiblings(const AFN, Father_AFN, Mother_AFN: string);
begin
  if Assigned(Query) then
    try
      with Query do
        begin
          Active := false;
//        with gPrivateSettings do
//          ConnectionString := gPhotoDBConnectionString;
          SQL.Clear;
          SQL.Add('SELECT AFN, Prefix, FirstName, MiddleName, LastName, Suffix, NickName, BirthDate, BirthOrder, DeathDate, BirthPlace, Sex ');
          SQL.Add('FROM Family ');

          // siblings must have the same father or the same mother

          if (not Empty(Father_AFN)) or (not Empty(Mother_AFN)) then
            begin
              if (not Empty(Father_AFN)) and (not Empty(Mother_AFN)) then
                Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s")',
                                     [Father_AFN, Mother_AFN])) else
              if not Empty(Father_AFN) then
                Sql.Add(Format('Where (Father_AFN = "%s") ', [Father_AFN])) else
              if not Empty(Mother_AFN) then
                Sql.Add(Format('Where (Mother_AFN = "%s") ', [Mother_AFN]));
              Sql.Add(' ORDER BY CanonBirth');

              with Query do
                begin
                  ExecSQL;
                  Active := true;
                  First;
                  while not Eof do
                    begin
                      if fldAFN.AsString <> AFN then
                        AddPerson(Query, rt_Siblings);
                      Next;
                    end;
                end;
            end;

        end;
    finally
      Query.Active := false;
    end;
end;

procedure TfrmIndividual.otRelationsGetCellData(Sender: TObject; RowNum,
  ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
var
  pn: integer;
begin
  if RowNum > 0 then
    begin
      pn := RowNum - 1;   // person number
      if pn < Length(fRelations) then
        with fRelations[pn] do
          case ColNum of
            { 0 } col_Relation:
                    Data := pchar(Relations[Relation]);
            { 1 } col_Name:
                    Data := pchar(TheFullName);
            { 2 } col_Birthdate:
                    Data := pchar(Birthdate);
            { 3 } col_Deathdate:
                    Data := pchar(DeathDate);
            { 4 } col_BirthPlace:
                    Data := pchar(BirthPlace);
          end;
    end;
end;

procedure TfrmIndividual.FormShow(Sender: TObject);
begin
//  Locate_AFN(FamilyTable, '001');
end;

procedure TfrmIndividual.FamilyTableAfterScroll(DataSet: TDataSet);
begin
  with DataSet as TFamilyTable do
    if not ControlsDisabled then
      ShowPerson(fldAFN.AsString);
end;

{ TMyButton }

procedure TfrmIndividual.btnLocatePictureClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      InitialDir := gPhotoPath;
      FileName   := FamilyTable.fldImage.AsString;
      if Execute then
        begin
          with FamilyTable do
            begin
              if not (State in [dsEdit, dsInsert]) then
                Edit;
              fldImage.AsString := ExtractFileName(FileName);
              ShowPerson(fldAFN.AsString);
            end;
        end;
    end;
end;

function TfrmIndividual.LookupIndividual( aCaption: string;
                                          aDefPersonInfo: TPersonInfo;
                                          var SelectedPersonInfo: TPersonInfo;
                                          var TableWasUpdated: boolean): boolean;
begin
  InitPersonInfo(SelectedPersonInfo);
  with TfrmLookupIndividual.Create(self, fFindingAdvanced) do
    begin
      SelectivityInfoPtr    := @fSelectivityInfo;
      DefPersonInfoPtr      := @aDefPersonInfo;
      SelectedPersonInfoPtr := @SelectedPersonInfo;
      TheCaption            := aCaption;
      result                := ShowModal = mrOk;
      if result then
        TableWasUpdated := TableUpdated;
      Free;
    end;
end;

procedure TfrmIndividual.btnLookupSpouseClick(Sender: TObject);
  var
    Sex, TargetSex: string;
    DefInfo: TPersonInfo;
begin
  TargetSex := '';
  with FamilyTable do
    begin
      if Length(fldSex.AsString) >= 1 then
        begin
          Sex := fldSex.AsString[1];
          if Length(Sex) >= 1 then
            begin
              if ToUpper(Sex[1]) = 'M' then
                TargetSex := 'F' else
              if ToUpper(Sex[1]) = 'F' then
                TargetSex := 'M'
              else
                AlertFmt('Unknown sex for %s', [FullName]);
            end;
        end
      else
        AlertFmt('Unknown sex for %s', [FullName]);

      InitPersonInfo(DefInfo);
      DefInfo.SourceID1  := fldSourceID1.AsInteger;
      DefInfo.SourceID2  := fldSourceID2.AsInteger;
      DefInfo.Spouse_AFN := fldAFN.AsString;
      DefInfo.Sex        := TargetSex;
      GetRelation('Spouse', SPOUSE_AFN, DefInfo);
    end;
end;

procedure TfrmIndividual.btnLookupFatherClick(Sender: TObject);
var
  DefInfo: TPersonInfo;
begin
  InitPersonInfo(DefInfo);
  with DefInfo, FamilyTable do
    begin
      Sex       := 'M';
      LastName  := fldLastName.AsString;
      SourceID1 := fldSourceID1.AsInteger;
      SourceID2 := fldSourceID2.AsInteger;
      GetRelation(cFATHER, FATHER_AFN, DefInfo);
    end;
end;

procedure TfrmIndividual.btnLookupMotherClick(Sender: TObject);
var
  DefInfo: TPersonInfo;
begin
  InitPersonInfo(DefInfo);
  with DefInfo, FamilyTable do
    begin
      Sex       := 'F';
      LastName  := fldLastName.AsString;
      SourceID1 := fldSourceID1.AsInteger;
      SourceID2 := fldSourceID2.AsInteger;
      GetRelation(cMOTHER, MOTHER_AFN, DefInfo);
    end;
end;

procedure TfrmIndividual.GetRelation(aCaption, FieldName: string; DefInfo: TPersonInfo);
var
  TableWasUpdated: boolean;
  aCanonBirth, aCanonDeath: string;
  Ok: boolean;
  Saved_Cursor: TCursor;
  ErrorMsg: string;
  SelectedPersonInfo, ParentInfo: TPersonInfo;
  ParentSex: char;

  function BadDates(CanonBirth, CanonDeath: string; var ErrorMsg: string): boolean;
  const
    MAXAGE = 120;
  var
    ApproxAge: integer;
  begin { BadDates }
    result := false;
    if (not Empty(CanonBirth)) and (not Empty(CanonDeath)) then
      begin
        CanonBirth := Copy(CanonBirth, 1, 4); // copy only the year
        CanonDeath := Copy(CanonDeath, 1, 4);

        // assert: now they are the same length

        if CanonBirth > CanonDeath then
          begin
            result := true;
            ErrorMsg := 'Birthdate of individual is after the deathdate';
          end
        else
          begin
            if IsPureNumeric(CanonBirth) and IsPureNumeric(CanonDeath) then
              begin
                ApproxAge := StrToInt(CanonDeath) - StrToInt(CanonBirth);
                if ApproxAge > MAXAGE then
                  begin
                    result := true;
                    ErrorMsg := Format('The indivisual appears to be more than %s years old at death', [MAXAGE]);
                  end;
              end
            else
              begin
                result := true;
                ErrorMsg := Format('The birth [%s] / death [%s] dates are not numeric', [CanonBirth, CanonDeath]);
              end;
          end;
      end;
  end;  { BadDates }

begin { TfrmIndividual.GetRelation }
  Saved_Cursor  := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    with FamilyTable do
      begin
        if State in [dsInsert] then
          Post;  //  make sure that we have an AFN

        if LookupIndividual(aCaption, DefInfo, SelectedPersonInfo, TableWasUpdated) then
          begin
            fAfn := FamilyTable.fldAFN.AsString;  // individual's AFN

            if not Locate_AFN(FamilyTable, fAFN) then  // make sure that we have up-to-date data on the current individual
              AlertFmt('Unable to load AFN = %s', [fAFN]);
            LoadPersonInfo(ParentInfo);

            if not Empty(fldSex.AsString) then
              ParentSex := ToUpper(fldSex.AsString[1])
            else
              ParentSex := '?';

            Ok := true;
            if BadDates(fldCanonBirth.AsString, fldCanonDeath.AsString, ErrorMsg) then
              Ok := YesFmt('%s. Proceed anyway?', [ErrorMsg]);
            if ((aCaption = cMOTHER) or (aCaption = cFATHER)) then
              if (not Empty(fldCanonBirth.AsString)) then
                begin
                  if (not Empty(aCanonBirth))
                      and (fldCanonBirth.AsString < aCanonBirth) then
                    Ok := YesFmt('Birthdate of individual is BEFORE the BIRTH date of the %s! Proceed anyway?', [aCaption]);

                  if Ok and (not Empty(aCanonDeath))
                     and (fldCanonBirth.AsString > aCanonDeath) then
                    Ok := YesFmt('Birthdate of individual is AFTER the DEATH date of the %s! Proceed anyway?', [aCaption]);
                end;

              if Ok then
                begin
                  if (not Empty(FieldName)) then  // update parent or spouse
                    begin
                      if not (State in [dsEdit, dsInsert]) then
                        Edit;
                      FieldByName(FieldName).AsString := SelectedPersonInfo.AFN;
                      ShowPerson(FamilyTable.fldAFN.AsString);
                    end else // add child
                  if SameText(aCaption, 'Male Child') or
                     SameText(aCaption, 'Female Child') then
                    begin  // Update the child's parent link
                      if Locate_AFN(FamilyTable, SelectedPersonInfo.AFN {child's info}) then
                        begin
                          if not (State in [dsEdit, dsInsert]) then
                            Edit;

                          if (ParentSex = 'M') then // This is father's child
                            begin
                              fldFather_AFN.AsString := ParentInfo.AFN;
                              fFatherInfo.AFN        := ParentInfo.AFN;
                            end else
                          if (ParentSex = 'F') then // This is mother's child
                            begin
                              fldMother_AFN.AsString := ParentInfo.AFN;
                              fMotherInfo.AFN        := ParentInfo.AFN;
                            end;
                          Post;
                        end;
                    end;
                end
          end;
      end;
  finally
    ShowStatus('', true);
    Screen.Cursor := Saved_Cursor;
  end;
end;  { TfrmIndividual.GetRelation }


procedure TfrmIndividual.CheckRelationAFNs;

  function CheckAFN(const relation: string; AFNInTable, AFNInPersonInfo: string): boolean;
  begin
    result := SameText(AFNInTable, AFNInPersonInfo);
    if not result then
      AlertFmt('%s AFN mismatch: Table: %s / Info: %s', [relation, AFNInTable, AFNInPersonInfo]);
  end;

begin { CheckRelationAFNs }
  with FamilyTable do
    begin
      CheckAFN('Spouse', fldSpouse_AFN.AsString, fSpouseInfo.AFN);
      CheckAFN('Father', fldFather_AFN.AsString, fFatherInfo.AFN);
      CheckAFN('Mother', fldMother_AFN.AsString, fMotherInfo.AFN);
    end;
end;  { CheckRelationAFNs }

procedure TfrmIndividual.FamilyTableBeforeScroll(DataSet: TDataSet);
begin
end;

procedure TfrmIndividual.FamilyTableBeforePost(DataSet: TDataSet);
var
  Canonical, Birth, Death: string;
begin
  Canonical := '';
  with DataSet as TFamilyTable do
    begin
      if State = dsInsert then
        RecentlyAddedAFNs.Add(fldAFN.AsString);  // 1/4/2018: I think that RecentlyAddedAFNs is obsolete

      if not ControlsDisabled then
        CheckRelationAFNs;
      if ConvertToCanonical(fldBirthDate.AsString, Canonical) then
        fldCanonBirth.AsString := Canonical
      else
        if not YesFmt('The birthdate {%s} cannot be converted into a canonical date. Proceed anyway?', [fldBirthDate.AsString]) then
          Abort;

      if ConvertToCanonical(fldDeathDate.AsString, Canonical) then
        fldCanonDeath.AsString := Canonical
      else
        if not YesFmt('The deathdate {%s} cannot be converted into a canonical date. Proceed anyway?', [fldDeathDate.AsString]) then
          Abort;

      Birth := fldCanonBirth.AsString;
      Death := fldCanonDeath.AsString;
      if (not Empty(Birth)) and (not Empty(Death)) then
        begin
          if Length(Birth) > Length(Death) then
            Birth := Copy(Birth, 1, Length(Death)) else
          if Length(Death) > Length(Birth) then
            Death := Copy(Death, 1, Length(Birth));
          if (Birth > Death) then
            begin
              AlertFmt('Birth date [%s] appears to be after death date [%s]',
                       [fldCanonBirth.AsString, fldCanonDeath.AsString]);
              Abort;
            end;
        end;

      if fldAFN.IsNull or Empty(fldAFN.AsString) then
        begin
          fldAFN.AsString := RZero(gPrivateSettings.NextAFN, AFN_WIDTH);
          gPrivateSettings.NextAFN := gPrivateSettings.NextAFN + 1;  // moved to OnBeforePost
        end;

      UpdateSearchName(false);
    end;
end;

procedure TfrmIndividual.ShowStatus(const Msg: string; HighLight: boolean = false);
begin
  lblStatus.Caption := Msg;
  if HighLight then
    lblStatus.Color := clYellow
  else
    lblStatus.Color := clBtnFace;
  Application.ProcessMessages;
end;


procedure TfrmIndividual.btnLookupClick(Sender: TObject);
var
  Ok: boolean;
  SelectedPersonInfo: TPersonInfo;
  TableWasUpdated: boolean;
  Saved_Cursor: TCursor;
begin
  Saved_Cursor  := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    InitPersonInfo(SelectedPersonInfo);
    with FamilyTable do
      begin
        fSelectivityInfo.SourceID1 := fldSourceID1.AsInteger;
        fSelectivityInfo.SourceID2 := fldSourceID2.AsInteger;
        if LookupIndividual('Lookup Individual', fSelectivityInfo, SelectedPersonInfo, TableWasUpdated) then
          begin
            ShowStatus('Locating...', false);
            Ok := Locate_AFN(FamilyTable, SelectedPersonInfo.AFN);
            if not Ok then
              begin
                ShowStatus('Locate failed. Refreshing', true);
                Refresh;
                Ok := Locate_AFN(FamilyTable, SelectedPersonInfo.AFN);
                if not Ok then
                  begin
                    ShowStatus('Refresh failed. Closing and re-opening', true);
                    Close;
                    Open;
                    Ok := Locate_AFN(FamilyTable, SelectedPersonInfo.AFN);
                  end;
                if not Ok then
                  Alertfmt('Unable to locate individual %s', [SelectedPersonInfo.AFN]);
              end;
          end;
      end;
  finally
    ShowStatus('', false);
    Screen.Cursor := Saved_Cursor;
  end;
end;

procedure TfrmIndividual.btnBackClick(Sender: TObject);
  var
    AFN: string;
begin
  with fBackList do
    begin
      if Count > 1 then
        begin
          AFN := fBackList.Items[Top-1].AFN; // get the previous entry
          Count := Count - 1;                // pop the stack
          Locate_AFN(FamilyTable, AFN);
          Enable_Buttons;
        end
      else
        begin
          Enable_Buttons;
          SysUtils.Beep;
        end;
    end;
end;

procedure TfrmIndividual.Enable_Buttons;
var
  b: boolean;
begin
  btnBack.Enabled := fBackList.Count > 1;
  b := HasFilterInfo(fSelectivityInfo);
  btnFindPrev.Enabled := b;
  btnFindNext.Enabled := b;
end;

function TfrmIndividual.FilesClosed(state: boolean): boolean;
var
  TempFile: TextFile;
  Path, FileName: string;
begin
  result := false;
  if Empty(fTempFileName) then
    begin
      Path     := gEXEPath2;
      FileName := RemoveBadChars(ComputerName, BAD_FILENAME_CHARS);
      fTempFileName := UniqueFileName(Format('%sFamilyTree[%s].tmp',
                                             [Path,
                                             FileName]));
    end;
  case state of
    false: // mark the files as having been opened
      begin
        result := not  FileExists(fTempFileName); // if the file exists, it means that the files never got closed
        if result then                       // if the file doesn't exist, create it to indicate that the files are now open
          begin
            AssignFile(TempFile, fTempFileName);
            ReWrite(TempFile);
            Writeln(TempFile, 'Opened');
            CloseFile(TempFile);
          end;
      end;
    true:  // mark the files as closed
      begin
        if not FileExists(fTempFileName) then
          AlertFmt('System error: temporary FilesOpened file "%s" not found.', [fTempFileName])
        else
          MyDeleteFile(fTempFileName, false, false);
      end;
  end;
end;

procedure TfrmIndividual.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    with FamilyTable do
      if State in [dsInsert, dsEdit] then
        Post;
  except
  end;
  with gPrivateSettings do
    begin
      LastAFN := fAFN;       // save the current AFN
      NextAFN := NextAFN;    // and the default for the next to create (Does this make any sense?)
      LastOrderFields := FamilyTable.IndexFieldNames;
      SaveToFile(PrivateSettingsFileName);
    end;
  FilesClosed(true);
end;

procedure TfrmIndividual.FamilyTablePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
  Msg: string;
  mb: integer;
begin
  Msg := Format('Post error [%s]. Fail, Retry, Abort', [E.Message]);
  mb := MessageDlg(Msg, mtConfirmation, [mbCancel, mbAbort], 0);

  case mb of
    idCancel:
      begin
        Action := daFail;
        DataSet.Cancel;
      end;
    idAbort:
      begin
        Action := daAbort;
        DataSet.Cancel;
      end;
  end;
end;

procedure TfrmIndividual.otRelationsDblClick(Sender: TObject);
begin
  LinkToRelation(otRelations.ActiveRow);
end;

procedure TfrmIndividual.btnBrowseDocumentClick(Sender: TObject);
var
  Len: integer;
  PathPart: string;
begin
  with OpenDialog2 do
    begin
      InitialDir := gDOCFILEPATH; // gEXEPath2;
      FileName   := ReplaceAll(gDOCFILEPATH + dbDocFileName.Text, '/', '\') + '*.*';
      if Execute then
        begin
          Len := Length(gEXEPath2);
          PathPart := Copy(FileName, 1, Len);
          if SameText(PathPart, gEXEPath2) then
            begin
              FamilyTable.Edit;
              dbDocFileName.Text := Copy(FileName, Len+1, Length(FileName)-Len)
            end
          else
            raise Exception.CreateFmt('Document must be in a sub-directory or the root path [%s]',
                                      [gEXEPath2]);
        end;
    end;
end;

procedure TfrmIndividual.btnPersonalEventsClick(Sender: TObject);
begin
  if FamilyTable.State in [dsEdit, dsInsert] then
    FamilyTable.Post;
  frmPersonalEvents := TfrmPersonalEvents.Create(self);
  with frmPersonalEvents do
    begin
      AFN        := FamilyTable.fldAFN.AsString;
      FirstName  := FamilyTable.fldFirstName.AsString;
      MiddleName := FamilyTable.fldMiddleName.AsString;
      LastName   := FamilyTable.fldLastName.AsString;
      ShowModal;
      Free;
    end;
end;

procedure TfrmIndividual.CopyTextnoblanks1Click(Sender: TObject);
begin
  with FamilyTable do
    Clipboard.AsText := RemoveBadChars(
                          FullName,
                          [' ']);
end;

procedure TfrmIndividual.CopyText1Click(Sender: TObject);
begin
  with FamilyTable do
    Clipboard.AsText := FullName;
end;

procedure TfrmIndividual.UpdateSearchName(Force: boolean);
var
  FirstName, LastName, Temp: string;
begin
  if Empty(FamilyTable.fldSearch.AsString) or Force then
    begin
      FamilyTable.Edit;

      FirstName := FamilyTable.fldFirstName.AsString;
      if not Empty(FirstName) then
        temp := FirstName
      else
        temp := '';

      LastName := FamilyTable.fldLastName.AsString;
      if not Empty(LastName) then
        if not Empty(FirstName) then
          temp := FirstName + ' ' + LastName
        else
          temp := LastName;

      FamilyTable.fldSearch.AsString := temp;

      if Force then
        Clipboard.AsText := temp;
    end;
end;


procedure TfrmIndividual.dbSearchEnter(Sender: TObject);
begin
  UpdateSearchName(false);
end;

procedure TfrmIndividual.dbSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_F2) and (Shift = []) then
    UpdateSearchName(true);
end;

procedure TfrmIndividual.Changedatafilelocations2Click(Sender: TObject);
begin
  GetPrivateSettingsFromUser(gPrivateSettings);
end;

procedure TfrmIndividual.AboutFamilyTree1Click(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(self);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TfrmIndividual.First1Click(Sender: TObject);
begin
  FamilyTable.First;
end;

procedure TfrmIndividual.Prev1Click(Sender: TObject);
begin
  FamilyTable.Prior;
end;

procedure TfrmIndividual.Next1Click(Sender: TObject);
begin
  FamilyTable.Next;
end;

procedure TfrmIndividual.Last1Click(Sender: TObject);
begin
  FamilyTable.Last;
end;

procedure TfrmIndividual.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmIndividual.UpdateCanonicalDates1Click(Sender: TObject);
var
  SavedRecno: integer;
begin
  with FamilyTable do
    begin
      SavedRecno := RecNo;
      DisableControls;
      try
        First;
        while not Eof do
          begin
            Edit;
            if UpdateCanonicalDate then
              Post
            else
              Cancel;
            Next;
          end;
      finally
        RecNo := SavedRecNo;
        EnableControls;
      end;
    end;
end;

procedure TfrmIndividual.FilterFamilyRecords(aDataset: TDataSet; var Accept: boolean);
var
  Temp: string;
  ErrorMsg: string;
begin
  Accept := true;
  if aDataset is TFamilyTable then
    with fFilterInfo, aDataSet as TFamilyTable do
      begin
        temp := UpperCase(fldFirstName.AsString);
        if Accept and (not Empty(FirstName)) then
          Accept := Pos(FirstName, UpperCase(fldFirstName.AsString)) > 0;
        if Accept and (not Empty(LastName)) then
          Accept := (Pos(LastName, UpperCase(fldLastName.AsString)) > 0) or
                    (Soundex(LastName) = Soundex(fldLastName.AsString));
        if Accept and (not Empty(AFN)) then
          Accept := Pos(AFN, UpperCase(fldAFN.AsString)) > 0;
        if Accept and (not Empty(Prefix)) then
          Accept := Pos(Prefix, UpperCase(fldPrefix.AsString)) > 0;
        if Accept and (not Empty(MiddleName)) then
          Accept := Pos(MiddleName, UpperCase(fldMiddleName.AsString)) > 0;
        if Accept and (not Empty(NickName)) then
          Accept := Pos(NickName, UpperCase(fldNickName.AsString)) > 0;
        if Accept and (not Empty(Suffix)) then
          Accept := Pos(Suffix, UpperCase(fldSuffix.AsString)) > 0;
        if Accept and (not Empty(BirthDate)) then
          Accept := Pos(BirthDate, UpperCase(fldBirthDate.AsString)) > 0;
        if Accept and (not Empty(BirthOrder)) then
          Accept := SameText(BirthOrder, fldBirthOrder.AsString);
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
          Accept := Trunc(fldDateAdded.AsDateTime) <= DateAddedHigh;

        if Accept and (DateUpdatedLow <> BAD_DATE) then
          Accept := Trunc(fldDateUpdated.AsDateTime) >= DateUpdatedLow;
        if Accept and (DateUpdatedHigh <> BAD_DATE) then
          Accept := Trunc(fldDateUpdated.AsDateTime) <= DateUpdatedHigh;

        if Accept and (not Empty(Comments)) then
          Accept := Pos(Comments, UpperCase(fldComments.AsString)) > 0;
        if Accept and (not Empty(Ref)) then
          Accept := Pos(Ref, Uppercase(fldRef.AsString)) > 0;
          
        if Accept and (not Empty(Expr)) then
          begin
            if not HasParser then
              if not SelectivityParser.Valid_Expr(Expr, aDataSet, ErrorMsg) then
                raise Exception.CreateFmt('Invalid filter expression: %s [%s]', [Expr, ErrorMsg]);
            SelectivityParser.Eval_Tree.EvaluateTree;
            Accept := SelectivityParser.Eval_Tree.AsBoolean;
          end;
      end
  else
    Alert('Dataset is not a TFamilyTable');
end;

function TfrmIndividual.GetFamilyTable: TFamilyTable;
begin
  if not Assigned(fFamilyTable) then
    begin
      fFamilyTable := TFamilyTable.Create( self,
                                           gPrivateSettings.FamilyTreeDataBaseFileName,
                                           cFAMILY,
                                           [optUseClient]);
      with fFamilyTable do
        begin
          BeforePost     := FamilyTableBeforePost;
          AfterInsert    := FamilyTableAfterInsert;
          AfterScroll    := FamilyTableAfterScroll;
          BeforeScroll   := FamilyTableBeforeScroll;
          OnPostError    := FamilyTablePostError;
          OnFilterRecord := FilterFamilyRecords;

          Filtered       := HasFilterInfo(fFilterInfo);
        end;
      DataSource1.DataSet := fFamilyTable;
    end;
  result := fFamilyTable;
end;

procedure TfrmIndividual.FamilyTableAfterInsert(DataSet: TDataSet);
begin
  with DataSet as TFamilyTable do
    begin
      fldAFN.AsString := Rzero(gPrivateSettings.NextAFN, AFN_WIDTH);
      fldDateAdded.AsDateTime := Now;
      gPrivateSettings.NextAFN := gPrivateSettings.NextAFN + 1; 
    end;
end;


procedure TfrmIndividual.ClearAFN(Field: TField; relName, relBirth, relDeath: TLabel; var PersonInfo: TPersonInfo);
begin
  InitPersonInfo(PersonInfo);
  with FamilyTable do
    begin
      Edit;
      Field.Clear;
      Post;
    end;
  relName.Caption  := '';
  relName.Color    := clBtnFace;
  relBirth.Caption := '';
  relDeath.Caption := '';
  ShowPerson(FamilyTable.fldAFN.AsString);
end;


procedure TfrmIndividual.btnClearSpouseClick(Sender: TObject);
begin
  ClearAFN(FamilyTable.fldSpouse_AFN, lblSpouseName, lblSpouseBirth, lblSpouseDeath, fSpouseInfo)
end;

procedure TfrmIndividual.btnClearFatherClick(Sender: TObject);
begin
  ClearAFN(FamilyTable.fldFather_AFN, lblFatherName, lblFAtherBirth, lblFatherDeath, fFatherInfo)
end;

procedure TfrmIndividual.btnClearMotherClick(Sender: TObject);
begin
  ClearAFN(FamilyTable.fldMother_AFN, lblMotherName, lblMotherBirth, lblMotherDeath, fMotherInfo)
end;

procedure TfrmIndividual.dbDeathPlaceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_F11 then
    with FamilyTable do
      begin
        Edit;
        fldDeathPlace.AsString := fldBirthPlace.AsString;
      end;
end;

procedure TfrmIndividual.AddChild(Caption, ChildSex: string);
var
  ParentSex: char;
  Saved_AFN: string;
  DefInfo: TPersonInfo;
  Temp: string;
begin
  with FamilyTable do
    begin
      ParentSex := fldSex.AsString[1];
      Saved_AFN := fldAFN.AsString;
      InitPersonInfo(DefInfo);
      with DefInfo do
        begin
          Sex        := ChildSex;
          BirthPlace := fldBirthPlace.AsString;
          LastName   := fldLastName.AsString;
          SourceID1  := fldSourceID1.AsInteger;
          SourceID2  := fldSourceID2.AsInteger;
          Ref        := fldRef.AsString;
        end;
      if Length(ParentSex) > 0 then
        begin
          if ToUpper(ParentSex) = 'M' then // this is a man. Then use his AFN for the father and the spouse's AFN for the mother
            begin
              DefInfo.Father_AFN := fldAFN.AsString;
              DefInfo.Mother_AFN := fldSpouse_AFN.AsString;
              DefInfo.FirstName  := '';
              DefInfo.LastName   := fldLastName.AsString;
              GetRelation(Caption, '', DefInfo);
            end else
          if ToUpper(ParentSex) = 'F' then // this is a woman. Then use her AFN for the mother and the spouse's AFN for the father
            begin
              DefInfo.Father_AFN := fldSpouse_AFN.AsString;
              DefInfo.Mother_AFN := fldAFN.AsString;
              DefInfo.FirstName  := '';
              if not Empty(FamilyTable.fldSpouse_AFN.AsString) then
                with FamilyQuery do
                  begin
                    Close;
                    Temp := Format('SELECT LastName FROM Family WHERE AFN = "%s"', [FamilyTable.fldSpouse_AFN.AsString]);
                    SQL.Add(Temp);
                    ExecSQL;
                    Open;
                    if not (Eof and Bof) then
                      DefInfo.LastName := fldLastName.AsString;
                  end;
              GetRelation(Caption, '', DefInfo);
            end
          else // invalid sex - this is really an error and shouldn't happen
            GetRelation(Caption, '', DefInfo);
        end
      else // no sex given - this is really an error and shouldn't happen
        GetRelation(Caption, '', DefInfo);

//    Refresh;  // Is this really necessary? GetRelation is calling ShowPerson...?
      LoadAFN(Saved_AFN, 'Saved Individual');
      FamilyTableAfterScroll(FamilyTable);
    end;
end;

procedure TfrmIndividual.Addmalechild1Click(Sender: TObject);
begin
  AddChild('Male Child', 'M');
end;

procedure TfrmIndividual.Addfemalechild1Click(Sender: TObject);
begin
  AddChild('Female Child', 'F');
end;

procedure TfrmIndividual.AddUnknownChild1Click(Sender: TObject);
begin
  AddChild('Unknown Child', '?');
end;

function TfrmIndividual.GenealogySourcesTable: TGenealogySourcesTable;
begin
  if not Assigned(fGenealogySourcesTable) then
    begin
      fGenealogySourcesTable := TGenealogySourcesTable.Create(self, gPrivateSettings.FamilyTreeDataBaseFileName, 'GenealogySources', [optUseClient]);
      with fGenealogySourcesTable do
        begin
          IndexFieldNames := 'Abbrev';
          Active := true;
          First;
          while Not Eof do
            begin
              GenealogySourcesList.AddObject(fldAbbrev.AsString, TObject(fldID.AsInteger));
              Next;
            end;
          First;
        end;
    end;
  result := fGenealogySourcesTable;
end;


function TfrmIndividual.DataSourcesBrowser: TFrmDataSetBrowser;
begin
  if not Assigned(fDataSourcesBrowser) then
    begin
      fDataSourcesBrowser := TfrmDataSetBrowser.Create(self, GenealogySourcesTable, 'GenealogySources');
    end;
  result := fDataSourcesBrowser;
end;

function TfrmIndividual.GenealogySourcesList: TGenealogyStringList;
begin
  if not Assigned(fSourcesList) then
    begin
      fSourcesList         := TGenealogyStringList.Create;
      dbSource1.ShowHint    := true;
      btnSourceID1.ShowHint := true;
      dbSource2.ShowHint    := true;
      btnSourceID2.ShowHint := true;
    end;
  result := fSourcesList;
end;

function TfrmIndividual.GetTempFamilyTable: TFamilyTable;
begin
  if not Assigned(fTempFamilyTable) then
    begin
      fTempFamilyTable := TFamilyTable.Create( self,
                                               gPrivateSettings.FamilyTreeDataBaseFileName,
                                               cFAMILY,
                                               [optUseClient, optReadOnly]);
      with fTempFamilyTable do
        begin
          IndexFieldNames := 'AFN';
          Active          := true;
          OnFilterRecord  := FilterFamilyRecords;
          Filtered        := HasFilterInfo(fFilterInfo);;
        end;
    end;
  result := fTempFamilyTable;
end;

function TfrmIndividual.GetRecentlyAddedAFNs: TStringList;
begin
  if not Assigned(fRecentlyAddedAFNs) then
    fRecentlyAddedAFNs := TStringList.Create;
  result := fRecentlyAddedAFNs;
end;

{ TBackList }

procedure TBackList.AddItem(aAFN: string; aRelation: TRelation; aFullName,
  aBirthDate, aDeathDate: string);
begin
  Count := Count + 1;
  with fItems[Top] do
    begin
      AFN         := aAFN;
      Relation    := aRelation;
      TheFullName := aFullName;
    end;
end;

procedure TBackList.DeleteItem(index: integer);
var
  i: integer;
begin
  for i := index to Count-2 do
    Items[i] := Items[i+1];
  Count := Count - 1;
end;

function TBackList.GetCount: integer;
begin
  result := Length(fItems);
end;

function TBackList.GetItem(index: integer): TPersonDisplayed2;
begin
  result := fItems[Index];
end;

function TBackList.GetTop: integer;
begin
  result := Count - 1;
end;

procedure TBackList.SetCount(const Value: integer);
begin
  SetLength(fItems, Value);
end;

procedure TBackList.SetItem(index: integer;
  const Value: TPersonDisplayed2);
begin
  fItems[index] := Value;
end;

procedure TfrmIndividual.btnSourceID1Click(Sender: TObject);
begin
  with FamilyTable do
    begin
      if fldSourceID1.AsInteger > 0 then
        GenealogySourcesTable.Locate('ID', fldSourceID1.AsInteger, []);
      if DataSourcesBrowser.ShowModal = mrOk then
        begin
          Edit;
          fldSourceID1.AsInteger := GenealogySourcesTable.fldID.AsInteger;
        end;
      UpdateDataSourceHint;
    end;
end;

procedure TfrmIndividual.btnSourceID2Click(Sender: TObject);
begin
  with FamilyTable do
    begin
      if fldSourceID2.AsInteger > 0 then
        GenealogySourcesTable.Locate('ID', fldSourceID2.AsInteger, []);
      if DataSourcesBrowser.ShowModal = mrOk then
        begin
          Edit;
          fldSourceID2.AsInteger := GenealogySourcesTable.fldID.AsInteger;
        end;
      UpdateDataSourceHint;
    end;
end;

{ TGenealogyStringList }

function TGenealogyStringList.AbbrevFromID(ID: integer): string;
var
  idx: integer;
begin
  idx := IndexOfObject(TObject(ID));
  if idx >= 0 then
    result := Strings[idx]
  else
    result := 'Unknown';
end;

procedure TfrmIndividual.btnAdvancedSearchClick(Sender: TObject);
begin
  if not Assigned(fAdvancedSearchForm) then
    begin
      fSelectivityInfo.DataSet := FamilyTable;
      fAdvancedSearchForm := TfrmAdvancedSearch.Create(self, @fSelectivityInfo);
    end;
  fAdvancedSearchForm.SelectivityInfoPtr := @fSelectivityInfo;
  if fAdvancedSearchForm.ShowModal = mrOk then
    begin
      fFindingAdvanced := true;
      fSelectivityInfo.Expr := fAdvancedSearchForm.mmoExpression.Text;
      try
        btnLookupClick(nil);
      finally
        fFindingAdvanced := false;
      end;
    end;
end;

procedure TfrmIndividual.ReScanforHighestKey1Click(Sender: TObject);
begin
  RecalcNextAFN;
end;

procedure TfrmIndividual.SetFilter1Click(Sender: TObject);
var
  AFN: string;
begin
  fFilterInfo.DataSet := FamilyTable;
  if not Assigned(fAdvancedSearchForm) then
    fAdvancedSearchForm := TfrmAdvancedSearch.Create(self, @fFilterInfo);
  fAdvancedSearchForm.SelectivityInfoPtr := @fFilterInfo;
  if fAdvancedSearchForm.ShowModal = mrOk then
    with FamilyTable do
      begin
        AFN := fldAFN.AsString;
        Filtered := false;
        SetSelectivityParserExpression(fFilterInfo.Expr);
        Filtered := HasFilterInfo(fFilterInfo);
        try
          if Not Empty(AFN) then
            FamilyTable.Locate('AFN', AFN, []);  // try to reposition on the previously filtered record
        except
        end;
      end;
end;

procedure TfrmIndividual.ClearFilter1Click(Sender: TObject);
var
  AFN: string;
begin
  AFN := FamilyTable.fldAFN.AsString;
  InitPersonInfo(fFilterInfo);
  FamilyTable.SetSelectivityParserExpression(fFilterInfo.Expr);
  FamilyTable.Filtered := false;
  try
    FamilyTable.Locate('AFN', AFN, []);  // try to reposition on the previously filtered record
  except
  end;
end;

procedure TfrmIndividual.AddMaleChild2Click(Sender: TObject);
begin
  AddChild('Male Child', 'M');   // this isn't setting the parent's AFNs
end;

procedure TfrmIndividual.AddFemaleChild2Click(Sender: TObject);
begin
  AddChild('Female Child', 'F');   // this isn't setting the parent's AFNs
end;

procedure TfrmIndividual.dbBirthDateExit(Sender: TObject);
var
  temp: string;
begin
  with FamilyTable do
    if ConvertToCanonical(fldBirthDate.AsString, temp) then
      begin
        if fldCanonBirth.AsString <> temp then
          fldCanonBirth.AsString := temp;
      end;
end;

procedure TfrmIndividual.dbDeathDateExit(Sender: TObject);
var
  temp: string;
begin
  with FamilyTable do
    if ConvertToCanonical(fldDeathDate.AsString, temp) then
      if fldCanonDeath.AsString <> temp then
        fldCanonDeath.AsString := temp;
end;

procedure TfrmIndividual.SetbirthplaceforallChildren1Click(
  Sender: TObject);
var
  BirthPlace, AFN: string;
  Saved_Cursor: TCursor;
  Overwrite: boolean;
begin
  if GetString('Set Birthplace for children', 'BirthPlace', BirthPlace) then
    begin
      Overwrite := Yes('Overwrite existing birthplace?');
      Saved_Cursor := Screen.Cursor;
      Screen.Cursor := crSQLWait;
      try
        AFN := FamilyTable.fldAFN.AsString;
        if Assigned(Query) then
          try
            with Query do
              begin
                Active := false;
                SQL.Clear;
                SQL.Add('SELECT AFN, BirthPlace ');
                SQL.Add('FROM Family ');
                // children must have this person as father or mother

                Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s") ORDER BY CanonBirth',
                                     [AFN, AFN]));

                with Query do
                  begin
                    ExecSQL;
                    Active := true;
                    First;
                    while not Eof do
                      begin
                        Edit;
                        if Overwrite or fldBirthPlace.IsNull then
                          fldBirthPlace.AsString := BirthPlace;
                        Post;

                        Next;
                      end;
                  end;
              end;
            FamilyTable.Refresh;
            FamilyTable.Locate('AFN', AFN, []);
          finally
            Query.Active := false;
          end;
      finally
        Screen.Cursor := Saved_Cursor;
      end;
    end;
end;

procedure TfrmIndividual.SetSourcesForAllChildren1Click(Sender: TObject);
var
  AFN, Ref: string;
  SourceID1, SourceID2: integer;
  Saved_Cursor: TCursor;
begin
  Saved_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    AFN       := FamilyTable.fldAFN.AsString;
    SourceID1 := FamilyTable.fldSourceID1.AsInteger;
    SourceID2 := FamilyTable.fldSourceID2.AsInteger;
    Ref       := FamilyTable.fldRef.AsString;

    if Assigned(Query) then
      try
        with Query do
          begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT AFN, FirstName, LastName, SourceID1, SourceID2, Ref ');
            SQL.Add('FROM Family ');
            // children must have this person as father or mother

            Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s")',
                                 [AFN, AFN]));

            with Query do
              begin
                ExecSQL;
                Active := true;
                First;
                while not Eof do
                  begin
                    Edit;
                    if (fldSourceID1.IsNull) or (fldSourceID1.AsString = '') or (fldSourceID1.AsInteger = 0) then
                      fldSourceID1.AsInteger := SourceID1;
                    if (fldSourceID2.IsNull) or (fldSourceID2.AsString = '') or (fldSourceID2.AsInteger = 0) then
                      fldSourceID2.AsInteger := SourceID2;
                    if fldRef.IsNull or Empty(fldRef.AsString) then
                      fldRef.AsString := Ref;
                    Post;

                    Next;
                  end;
              end;
          end;
        FamilyTable.Refresh;
        FamilyTable.Locate('AFN', AFN, []);
      finally
        Query.Active := false;
      end;
  finally
    Screen.Cursor := Saved_Cursor;
  end;
end;

//*****************************************************************************
//   Function Name     : CompareCanonicalDates
//   Useage            :
//   Function Purpose  : Compare two canonical dates accomodating for length and menarch
//   Assumptions       :
//   Parameters        : DateI = Left date in YYYYMMDD format
//                       DateJ = Right date in YYYYMMDD format
//                       YearsToAdd = Years to add to date on the right before doing the compare
//                       ErrorMsg
//   Return Value      : -1: DateI < DateJ;
//                       0: same date;
//                       +1: DateI > DateJ;
//                       -2: Erroneous date
//                       -3: missing date
//*******************************************************************************}

function TfrmIndividual.CompareCanonicalDates(DateI, DateJ: string; YearsToAdd: integer; var ErrorMsg: string): integer;
var
  LenI, LenJ, Len, YYYYI, YYYYJ: integer;
begin { CompareCanonicalDates }
  if (not Empty(DateI)) and (not Empty(DateJ)) then
    begin
      LenI := Length(DateI);
      LenJ := Length(DateJ);
      Len  := Min(LenI, Lenj);
      if Len >= 4 then
        begin
          YYYYI := StrToInt(Copy(DateI, 1, 4));
          YYYYJ := StrToInt(Copy(DateJ, 1, 4)) + YearsToAdd;
          if YYYYI < YYYYJ then
            result := -1 else
          if YYYYI > YYYYJ then
            result := + 1
          else
            result := 0
        end
      else
        begin
          result := -2;
          ErrorMsg := 'Improperly formed canonical date';
        end;
    end
  else
    begin
      result := -3;
      ErrorMsg := 'Missing date';
    end;
end;  { CompareCanonicalDates }

procedure TfrmIndividual.ScanForSimilarRecords1Click(Sender: TObject);
const
  SCORE_FIRSTNAME  = 40;
  SCORE_MIDDLENAME = 5;
  SCORE_CANONBIRTH = 20;
  SCORE_CANONDEATH = 20;
  SCORE_SPOUSE_AFN = 10;
  SCORE_FATHER_AFN = 10;
  SCORE_MOTHER_AFN = 10;
  SCORE_BIRTHPLACE = 20;  // Unused
  SCORE_SEX        = 5;

  MIN_SCORE_FOR_MATCH = 60;
type
  TGroup = record
    GrpScore: integer;
    FirstNameSoundex: string[5];
  end;
var
  FamilyInfoArray: array of TPersonInfo;
  FamilyInfoArrayCount: integer;
  PreviousLastName: string;
  SimilarityMatrix: array of array of TGroup;
  LogFile: TextFile;
  temp: string;
  Count: integer;

  procedure AddRecord;
  begin { AddRecord }
    SetLength(FamilyInfoArray, FamilyInfoArrayCount+1);
    Query.LoadPersonInfo(FamilyInfoArray[FamilyInfoArrayCount]);
    Inc(FamilyInfoArrayCount);
  end;  { AddRecord }

  procedure ProcessOneGroup;
  var
    Row, Col: integer;
    HighestScore: integer;
//  FirstInGroup: boolean;
    Calc_FirstName, Calc_MiddleName, Calc_CanonBirth, Calc_CanonDeath,
    Calc_Spouse_AFN, Calc_Father_AFN, Calc_Mother_AFN, Calc_SEX: integer;
    SubGroups, Individuals: TStringList;
    SubGroup, IndividualNumber: integer;
    GroupName: string;
    i: integer;

    procedure CompareTwo(i, j: integer);
    var
      Score: integer;
      
      function CompareNames(const NameI, NameJ: string; ScorePlus: integer): integer;
      begin { CompareNames }
        result := 0;
        if SameText(NameI, NameJ) then
          result := scorePlus else
        if Soundex(NameI) = Soundex(NameJ) then
          result := scorePlus div 2;
      end;  { CompareNames }

      function CompareCanonDates(const DateI, DateJ: string; ScorePlus: integer): integer;
      begin { CompareCanonDates }
        result := 0;
        if (not Empty(DateI)) and (not Empty(DateJ)) then
          begin
            if SameText(DateI, DateJ) then                          // same year, month, day
              result := ScorePlus else
            if SameText(Copy(DateI, 1, 6), Copy(DateJ, 1, 6)) then  // same year, month
              result := Round((ScorePlus * 3) / 4) else
            if SameText(Copy(DateI, 1, 4), Copy(DateJ, 1, 4)) then  // same year
              result := Round(ScorePlus div 2);
          end;
      end;  { CompareCanonDates }

      function CompareAFN(const AFNI, AFNJ: string; ScorePlus: integer): integer;
      begin { CompareAFN }
        result := 0;
        if (not Empty(AFNI)) and (not Empty(AFNJ)) then
          if SameText(AFNI, AFNJ) then
            Score := ScorePlus;
      end;  { CompareAFN}

    begin { CompareTwo }
      Calc_FirstName   := CompareNames(FamilyInfoArray[i].FirstName, FamilyInfoArray[j].FirstName,        SCORE_FIRSTNAME);
      Calc_MiddleName  := CompareNames(FamilyInfoArray[i].MiddleName, FamilyInfoArray[j].MiddleName,      SCORE_MIDDLENAME);
      Calc_CanonBirth  := CompareCanonDates(FamilyInfoArray[i].CanonBirth, FamilyInfoArray[j].CanonBirth, SCORE_CANONBIRTH);
      Calc_CanonDeath  := CompareCanonDates(FamilyInfoArray[i].CanonDeath, FamilyInfoArray[j].CanonDeath, SCORE_CANONDEATH);
      Calc_Spouse_AFN  := CompareAFN(FamilyInfoArray[i].Spouse_AFN, FamilyInfoArray[j].Spouse_AFN,        SCORE_SPOUSE_AFN);
      Calc_Father_AFN  := CompareAFN(FamilyInfoArray[i].Father_AFN, FamilyInfoArray[j].Father_AFN,        SCORE_FATHER_AFN);
      Calc_Mother_AFN  := CompareAFN(FamilyInfoArray[i].Mother_AFN, FamilyInfoArray[j].Mother_AFN,        SCORE_MOTHER_AFN);

      if SameText(FamilyInfoArray[i].Sex, FamilyInfoArray[j].Sex) then
        Calc_Sex := SCORE_SEX
      else
        Calc_Sex := 0;

      Score := Calc_FirstName + Calc_MiddleName + Calc_CanonBirth + Calc_CanonDeath + Calc_Spouse_AFN + Calc_Father_AFN + Calc_Mother_AFN;

      if Score >= MIN_SCORE_FOR_MATCH then
        begin
          SimilarityMatrix[i, j].GrpScore := Score;
          SimilarityMatrix[i, j].FirstNameSoundex := Soundex(FamilyInfoArray[i].FirstName);
          if Score > HighestScore then
            HighestScore := Score;
        end;
    end;  { CompareTwo }

    function PersonInfo(I: integer): string;
    begin { PersonInfo }
      with FamilyInfoArray[i] do
        result := Format(' {%-*s to %-*s} %s', [AFN_FIELD_SIZE, CanonBirth,
                                                AFN_FIELD_SIZE, CanonDeath,
                                                FullName(Prefix, FirstName, MiddleName, LastName, Suffix, NickName)]);
    end; { PersonInfo }

    procedure AddIndividual(Index: integer);
    begin { AddIndividual }
      if Individuals.IndexOfObject(TObject(Index)) < 0 then // not already in list
        Individuals.AddObject(FamilyInfoArray[index].AFN, TObject(Index))
    end;  { AddIndividual }

  begin { ProcessOneGroup }
    if (FamilyInfoArrayCount > 1) then
      begin
        if FamilyInfoArrayCount > 30 then
          begin
            lblStatus.Caption := Format('Processing %s', [FamilyInfoArray[0].LastName]);
            Application.ProcessMessages;
          end;

        HighestScore := 0;
        SetLength(SimilarityMatrix, FamilyInfoArrayCount, FamilyInfoArrayCount);
        for Row := 0 to FamilyInfoArrayCount-1 do
          for Col := 0 to FamilyInfoArrayCount-1 do
            with SimilarityMatrix[Row, Col] do
              begin
                GrpScore := 0;
                FirstNameSoundex := '';
              end;

        for row := 0 to FamilyInfoArrayCount-1 do
          for col := row+ 1 to FamilyInfoArrayCount-1 do
            CompareTwo(Row, Col);

        if HighestScore >= MIN_SCORE_FOR_MATCH then
          begin
            // Make a list of all of the subgroups (similar first names) within this group

            SubGroups := TStringList.Create;
            try
              for row := 0 to FamilyInfoArrayCount-1 do
                for col := row+ 1 to FamilyInfoArrayCount-1 do
                  with SimilarityMatrix[Row, Col] do
                    if GrpScore >= MIN_SCORE_FOR_MATCH THEN // i.e., non-zero
                      begin
                        if SubGroups.IndexOf(FirstNameSoundex) < 0 then // this sub-group is not already in the list
                          SubGroups.Add(FirstNameSoundex);
                      end;

              SubGroups.Sorted := true;

              // Print each of the sub-groups
              for SubGroup := 0 to SubGroups.Count-1 do
                begin
                  // find the individuals in this sub-group
                  GroupName   := SubGroups[SubGroup];
                  Individuals := TStringList.Create;
                  try
                    for row := 0 to FamilyInfoArrayCount-1 do
                      for col := row+1 to FamilyInfoArrayCount-1 do
                        if SimilarityMatrix[Row, Col].FirstNameSoundex = GroupName then // this individual is a member of the group of matching records
                          begin
                            AddIndividual(Row);
                            AddIndividual(Col);
                          end;

                    // Now print the list of individuals
                    Individuals.Sorted := true;
                    if Individuals.Count > 0 then
                      begin
                        IndividualNumber := Integer(Individuals.Objects[0]);
                        WriteLn(LogFile, 'Individuals in the group ', GroupName, ': ', FamilyInfoArray[0].LastName, ' are:');
                        WriteLn(LogFile, Format('%-*s: %s', [AFN_FIELD_SIZE, FamilyInfoArray[IndividualNumber].AFN, PersonInfo(IndividualNumber)]));
                        for i := 1 to Individuals.Count -1 do
                          begin
                            IndividualNumber := Integer(Individuals.Objects[i]);
                            WriteLn(LogFile, Format('%-*s: %s', [AFN_FIELD_SIZE,
                                                                 FamilyInfoArray[IndividualNumber].AFN,
                                                                 PersonInfo(IndividualNumber)]));
                          end;
                        WriteLn(LogFile);
                      end;
                  finally
                    Individuals.Free;
                  end;
(*
                  FirstInGroup := true;
                  for row := 0 to FamilyInfoArrayCount-1 do
                    begin
                      for col := row+1 to FamilyInfoArrayCount-1 do
                        if SimilarityMatrix[Row, Col].FirstNameSoundex = GroupName then // this individual is a member of the group of matching records
                          begin
                            if FirstInGroup then
                              begin
                                Writeln(LogFile);
                                WriteLn(LogFile, 'Individuals in the group ', GroupName, ': ', FamilyInfoArray[0].LastName, ' are:');
                                WriteLn(LogFile, Format('%-*s: %s', [AFN_FIELD_SIZE, FamilyInfoArray[Row].AFN, PersonInfo(Row)]));
                                FirstInGroup := false;
                              end;
                            WriteLn(LogFile, Format('%-*s: %s', [AFN_FIELD_SIZE, FamilyInfoArray[Col].AFN, PersonInfo(Col)]));
                          end;
                    end;
*)
                end;
            finally
              SubGroups.Free;
            end;

          end;
      end;
  end;  { ProcessOneGroup }

begin { TfrmIndividual.ScanForSimilarRecords1Click }
  AssignFile(LogFile, fLogPathFileName);
  ReWrite(LogFile);
  try
    with Query do
      begin
        Count  := 0;
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT AFN, Prefix, FirstName, MiddleName, LastName, NickName, Suffix, CanonBirth, CanonDeath, Birthplace, Sex, Spouse_AFN, Father_AFN, Mother_AFN ');
        SQL.Add('FROM Family ');
        Sql.Add('ORDER BY LastName');
        ExecSQL;
        Active := true;
        while not Eof do
          begin
            FamilyInfoArrayCount := 0; SetLength(FamilyInfoArray, 0);
            PreviousLastName := fldLastName.AsString;
            // load a group with records having the same/similar last name
            while (not Eof) and
                    (SameText(PreviousLastName, fldLastName.AsString)
                                     { or
                    (Soundex(PreviousLastName) = Soundex(fldLastName.AsString))}) do
              begin
                AddRecord;
                Next;
                Inc(Count);

                if (Count mod 1000) = 0 then
                  begin
                    lblStatus.Caption := Format('Processing %d', [Count]);
                    Application.ProcessMessages;
                  end;
              end;
            ProcessOneGroup;
          end;
      end;
  finally
    CloseFile(LogFile);
    temp := Format('Notepad.exe %s', [fLogPathFileName]);
    FileExecute(temp, false);
  end;
end;  { TfrmIndividual.ScanForSimilarRecords1Click }

procedure TfrmIndividual.ShowShortcuts1Click(Sender: TObject);
begin
  if not Assigned(frmShortCuts) then
    frmShortCuts := TfrmShortcuts.Create(self);
  frmShortcuts.Show;
end;

procedure TfrmIndividual.pnlFilteredClick(Sender: TObject);
var
  AFN: string;
begin
  AFN := FamilyTable.fldAFN.AsString;
  FamilyTable.DisableControls;
  try
    FamilyTable.Filtered := not FamilyTable.Filtered;
    pnlFiltered.Visible  := FamilyTable.Filtered;
  finally
    FamilyTable.EnableControls;
  end;
  try
    FamilyTable.Locate('AFN', AFN, []); // try to stay on the same record
  except
  end;
end;

procedure TfrmIndividual.Refresh1Click(Sender: TObject);
begin
  ShowPerson(FamilyTable.fldAFN.AsString);
end;

procedure TfrmIndividual.SetParentsOfAllChildrenToCurrent1Click(
  Sender: TObject);
var
  AFN: string;
  Father_AFN, Mother_AFN: string;
  Saved_Cursor: TCursor;
  OkToOverWrite: boolean;
begin
  Saved_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    OkToOverWrite := Yes('Is it OK to overwrite preexisting parent references?');
    AFN       := FamilyTable.fldAFN.AsString;
    with FamilyTable do
      if Length(FamilyTable.fldSex.AsString) >= 1 then
        if fldSex.AsString[1] in ['M', 'm'] then
          begin
            Father_AFN := AFN;
            Mother_AFN := fldSpouse_AFN.AsString;
          end else
        if fldSex.AsString[1] in ['F', 'f'] then
          begin
            Father_AFN := fldSpouse_AFN.AsString;
            Mother_AFN := AFN;
          end
        else
          begin
            Father_AFN := '';
            Mother_AFN := '';
          end;

      if Assigned(Query) then
        try
          with Query do
            begin
              Active := false;
              SQL.Clear;
              SQL.Add('SELECT AFN, Father_AFN, LastName, Mother_AFN ');
              SQL.Add('FROM Family ');

              // children must have this person as father or mother

              Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s")',
                                   [AFN, AFN]));

              with Query do
                begin
                  ExecSQL;
                  Active := true;
                  First;
                  while not Eof do
                    begin
                      Edit;
                      if OkToOverWrite or
                         ((fldFather_AFN.IsNull) or (fldFather_AFN.AsString = '')) then
                        fldFather_AFN.AsString := Father_AFN;
                      if OkToOverWrite or
                        ((fldMother_AFN.IsNull) or (fldMother_AFN.AsString = '')) then
                        fldMother_AFN.AsString := Mother_AFN;
                      Post;

                      Next;
                    end;
                end;
            end;
          FamilyTable.Refresh;
          FamilyTable.Locate('AFN', AFN, []);
        finally
          Query.Active := false;
        end;
  finally
    Screen.Cursor := Saved_Cursor;
  end;
end;

procedure TfrmIndividual.AddInfoFromDABDClick(Sender: TObject);
var
  CurrentAFN: string;
  Saved_Cursor: TCursor;
begin
  CurrentAFN := FamilyTable.fldAFN.AsString;
  if not Assigned(frmAddInfoFromDescendantsOfAbnerBDorrough) then
    frmAddInfoFromDescendantsOfAbnerBDorrough := TfrmAddInfoFromDescendantsOfAbnerBDorrough.Create(self);

  with frmAddInfoFromDescendantsOfAbnerBDorrough do
    begin
      if Length(FamilyTable.fldSex.AsString) >= 1 then
        begin
          if FamilyTable.State in [dsEdit, dsInsert] then // make sure everything is up-to-date in case the father or mother gets edited
            FamilyTable.Post;

          if FamilyTable.fldSex.AsString[1] in ['M', 'm'] then
            begin
              SetFatherInfo(fPersonInfo);  // this person becomes the father
              SetMotherInfo(fSpouseInfo);  // and his wife becomes the mother
            end else
          if FamilyTable.fldSex.AsString[1] in ['F', 'f'] then
            begin
              SetFatherInfo(fSpouseInfo);  // this person becomes the mother
              SetMotherInfo(fPersonInfo);  // and her husband becomes the father
            end;

          ShowModal;

          Saved_Cursor  := Screen.Cursor;
          Screen.Cursor := crSQLWait;
          try
            if AnyUpdates then
              begin
                ShowStatus('Refreshing table', true);
                FamilyTable.Refresh;
              end;
            Locate_AFN(FamilyTable, CurrentAFN);
            ShowStatus('', true);
          finally
            Screen.Cursor := Saved_Cursor;
          end;
        end
      else
        AlertFmt('Sex of %s must be set prior to calling DABD', [FamilyTable.FullName]);
    end;
end;

procedure TfrmIndividual.ReCalcNextAFN1Click(Sender: TObject);
begin
  RecalcNextAFN;
end;

procedure TfrmIndividual.ChangeToIndex(MenuItem: TMenuItem; const FieldNames: string);
var
  Saved_AFN: string;
  i: integer;
begin
  with FamilyTable do
    begin
      DisableControls;
      Saved_AFN     := fldAFN.AsString;
      try
        IndexFieldNames := FieldNames;

        if Assigned(MenuItem) then
          MenuItem.Checked := true
        else
          begin
            for i := 0 to SetOrder1.Count-1 do
              begin
                if SetOrder1.Items[i].Caption = FieldNames then
                  begin
                    SetOrder1.Items[i].Checked := true;
                    break;
                  end;
              end;
          end;

        if (Saved_AFN <> '') and not Locate_AFN(FamilyTable, Saved_AFN) then
          AlertFmt('System error: unable to locate AFN=%s', [Saved_AFN]);

      finally
        EnableControls;
      end;
    end;
end;


procedure TfrmIndividual.LastFirstMiddle1Click(Sender: TObject);
begin
  ChangeToIndex(LastFirstMiddle1, 'LastName; FirstName; MiddleName');
end;

procedure TfrmIndividual.CanonBirth1Click(Sender: TObject);
begin
  ChangeToIndex(CanonBirth1, 'CanonBirth');
end;

procedure TfrmIndividual.AFN1Click(Sender: TObject);
begin
  ChangeToIndex(AFN1, 'AFN');
end;

procedure TfrmIndividual.ChangeAFNsForSelectedRecords1Click(
  Sender: TObject);
const
  CANDO_SIMULATED = false;
var
  ErrorCount, ChangeCount, Count: integer;
  Temp, ChangeStr: string;
  frmChangeAFNs: TfrmChangeAFNs;
  OldAFN, NewAFN, Saved_AFN, CurrentAFN: string;
  TheFullName: string;
  AFNChanged, SpouseAFNChanged, MotherAFNChanged, FatherAFNChanged: boolean;
  Relation: string;
  Saved_RecNo: integer;
  Saved_Cursor: TCursor;
  i: integer;
  Simulated: boolean;
begin
  Saved_AFN := FamilyTable.fldAFN.AsString;
  AssignFile(fOutFile, fLogPathFileName);
  ReWrite(fOutFile);
  frmChangeAFNs := TfrmChangeAFNs.Create(self);
  frmChangeAFNs.leOldAFN.Text := FamilyTable.fldAFN.AsString;
  ErrorCount := 0; ChangeCount := 0; Count := 0;

  if CANDO_SIMULATED then
    Simulated := Yes('Simulated update only?')
  else
    Simulated := false;

  frmChangeAFNs.lblStatus.Caption := IIF(Simulated, 'SIMULATED', '');
  if Simulated then
    WriteLn(fOutFile, 'SIMULATED CHANGES');
  if frmChangeAFNs.ShowModal = mrOk then
    begin
      Saved_Cursor  := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
        if FamilyTable.State in [dsEdit, dsInsert] then
          FamilyTable.Post;
        FamilyTable.Close;     // trying to force it to be refreshed after rename process is complete
        OldAFN := frmChangeAFNs.leOldAFN.Text;
        NewAFN := frmChangeAFNS.leNewAFN.Text;
        FreeAndNil(fTempFamilyTable);  // re-create it w/o indexing

        fTempFamilyTable := TFamilyTable.Create( self,
                                                 gPrivateSettings.FamilyTreeDataBaseFileName,
                                                 cFAMILY,
                                                 [optUseClient]);
        with fTempFamilyTable do
          begin
            Active          := true;
            if Locate('AFN', NewAFN, [loCaseInsensitive]) then  // the desired AFN is already in use
              raise Exception.CreateFmt('AFN %s is already in use', [NewAFN]);

            Filtered        := false;  // do not filter the table that we use for processing
          end;

        with fTempFamilyTable do
          begin
            try
              First;
              while not Eof do
                begin
                  Saved_RecNo := RecNo;
                  Edit;
                  AFNChanged  := false;  SpouseAFNChanged := false; MotherAFNChanged := False; FatherAFNChanged := false;
                  CurrentAFN  := fldAFN.AsString;
                  TheFullName := FullName;
                  if SameText(OldAFN, CurrentAFN) then
                    begin
                      fldAFN.AsString        := NewAFN;
                      AFNChanged             := true;
                      Relation               := 'Person';
                    end;
                  if SameText(OldAFN, fldSpouse_AFN.AsString) then
                    begin
                      fldSpouse_AFN.AsString := NewAFN;
                      SpouseAFNChanged       := true;
                      Relation               := 'Spouse';
                    end;
                  if SameText(OldAFN, fldFather_AFN.AsString) then
                    begin
                      fldFather_AFN.AsString := NewAFN;
                      FatherAFNChanged       := true;
                      Relation               := 'Father';
                    end;
                  if SameText(OldAFN, fldMother_AFN.AsString) then
                    begin
                      fldMother_AFN.AsString := NewAFN;
                      MotherAFNChanged       := true;
                      Relation               := 'Mother';
                    end;

                  if AFNChanged or SpouseAFNChanged or FatherAFNChanged or MotherAFNChanged then
                    begin
                      try
                        if Simulated then
                          Cancel
                        else
                          Post;

                        inc(ChangeCount);
                        ShowStatus(Format('%d/%d records updated/processed', [ChangeCount, Count]), false);
                        temp := Format('%-12s [%-35s]: Changed %s''s AFN from %s to %s',
                                       [CurrentAFN, TheFullName, Relation, OldAFN, NewAFN]);
                        Writeln(fOutFile, temp);
                      except
                        on e: Exception do
                          begin
                            temp := Format('Posting Error (%s) when changing "%s" to "%s"',
                                           [e.Message, OldAFN, NewAFN]);
                            Writeln(fOutFile, temp);
                            Alert(temp);
                          end;
                      end;
                    end
                  else
                    Cancel;

                  if (Count mod 100) = 0 then
                    ShowStatus(Format('%d/%d records updated/processed.', [ChangeCount, Count]), false);

                  if RecNo = Saved_RecNo then // otherwise, previously selected record is no longer in selection set
                    Next;                     // and Next would skip a record

                  Inc(Count);
                end;
            finally
              CloseFile(fOutFile);
              if ChangeCount > 0 then
                begin
                  fTempFamilyTable.Close;
                  FreeAndNil(fTempFamilyTable);
                  FamilyTable.Open;
                end;
            end;
          end;
      finally
        frmChangeAFNs.Free;
        if ChangeCount > 0 then
          if SameText(Saved_AFN, OldAFN) and (not Simulated) then
            Locate_AFN(FamilyTable, NewAFN)
          else
            Locate_AFN(FamilyTable, Saved_AFN);

        if Simulated then
          ChangeStr := 'Updated (simulated)'
        else
          ChangeStr := 'Updated';

        if ErrorCount > 0 then
          begin
            if ErrorCount > 0 then
              begin
                temp := Format('%d errors occurred. %d records were %s. See LogFile.txt for details.', [ErrorCount, ChangeCount, ChangeStr]);
                Alert(temp);
                temp := Format('Notepad.exe %s', [fLogPathFileName]);
                FileExecute(temp, false);
              end
            else
              AlertFmt('No errors were detected. %d records were %s. See LogFile.txt for details', [ChangeCount, ChangeStr]);
          end
        else
          AlertFmt('No errors were detected. %d records were %s. See LogFile.txt for details', [ChangeCount, ChangeStr]);

        with fBackList do
          begin
            for i := Count-1 downto 0 do
              if (Items[i].AFN = OldAFN) {or (Items[i].AFN = NewAFN)} then
                DeleteItem(i);

            if Count > 1 then
              btnBack.Hint := Items[Top-1].TheFullName
            else
              btnBack.ShowHint := false;
          end;
        Screen.Cursor := Saved_Cursor;
      end;
    end;
end;

//*****************************************************************************
//   Function Name     : EditInfo
//   Useage            : if EditInfo(fSpouseInfo, Format('Spouse of %s', [FamilyTable.FullName]), SPOUSE_AFN) then
//   Function Purpose  : Edit/Create the information for a Spouse, Father or Mother
//   Assumptions       : Assumes that FamilyTable is positioned at the primary individual
//   Parameters        : PersonInfo = Information about the related individual
//                       Relation, for example = 'Spouse of John Doe'
//                       FieldToUpdate = name of the link field in the
//                       primary individual to be updated (for example "Spouse_AFN")
//   Return Value      : True is the edti/create succeeded
//*******************************************************************************}

function TfrmIndividual.EditInfo(var PersonInfo: TPersonInfo; Relation: string; FieldToUpdate: string): boolean;
var
  SavedAFN: string;
  InfoForm: TfrmAdvancedSearch;
  TempInfo: TPersonInfo;
begin
  result := false;
  with FamilyTable do
    begin
      MyDisablecontrols;               // Don't want AfterScroll to load anything
      try
        SavedAFN := fldAFN.AsString;
        if Empty(PersonInfo.AFN) then  // assume that the related individual needs to be created
          begin
            PersonInfo.AFN := Rzero(gPrivateSettings.NextAFN, AFN_WIDTH); // use the next available individual
            if not (State in [dsEdit, dsInsert]) then
              Edit;
            FieldByName(FieldToUpdate).AsString := PersonInfo.AFN;        // update link for the primary individual
            Post;
            gPrivateSettings.NextAFN := gPrivateSettings.NextAFN + 1;     // ready for next
            Append;                                                       // add a blank record
            SavePersonInfo(PersonInfo);                                   // save new AFN in memory
            Post;                                                         // and save to DB
          end;
        if Locate_AFN(FamilyTable, PersonInfo.AFN) then  // Locate record for the related individual
          begin
            LoadPersonInfo(PersonInfo);                 // Load the information for the related individual
            TempInfo      := PersonInfo;                // Edit the copy in case user cancels out the edit
            InfoForm := TfrmAdvancedSearch.Create(self, @PersonInfo, smEdit);
            try
              InfoForm.SelectivityInfoPtr := @TempInfo; // Use the temporary copy
              InfoForm.Caption := Relation;             // Use the Caption "Spouse of John Doe"
              result := InfoForm.ShowModal = mrOk;      // Edit the temporary copy
              if result then
                begin
                  PersonInfo := TempInfo;               // User didn't cancel so update info for related individual
                  Edit;
                  SavePersonInfo(PersonInfo);           // Save related individual in memory
                  Post;                                 // and update the database
                end;
            finally
              InfoForm.Free;
            end;
          end;
      finally
        MyEnableControls;
        Locate_AFN(FamilyTable, SavedAFN);
      end;
    end;
end;

(*
function TfrmIndividual.EditInfo(var PersonInfo: TPersonInfo; Relation: string; FieldToUpdate: string): boolean;
var
  InfoForm: TfrmAdvancedSearch;
  TempInfo: TPersonInfo;
  SavedAFN: string;
begin
  SavedAFN := FamilyTable.fldAFN.AsString;
  InfoForm := TfrmAdvancedSearch.Create(self, @PersonInfo, smEdit);
  try
    TempInfo      := PersonInfo;
    InfoForm.SelectivityInfoPtr := @TempInfo;
    InfoForm.Caption := Relation;
    result := InfoForm.ShowModal = mrOk;
    if result then
      begin
        if FamilyTable.Locate('AFN', PersonInfo.AFN, []) then
          FamilyTable.Edit
        else
          begin
            FamilyTable.Append;
            TempInfo.AFN := FamilyTable.fldAFN.AsString;
          end;
        PersonInfo := TempInfo;   // This is now the related person's info

        // save the related person's info in the proper place
        if SameText(FieldToUpdate, FATHER_AFN) then
          fFatherInfo := PersonInfo else
        if SameText(FieldToUpdate, MOTHER_AFN) then
          fMotherInfo := PersonInfo else
        if SameText(FieldToUpdate, SPOUSE_AFN) then
          fSpouseInfo := PersonInfo;

        FamilyTable.SavePersonInfo(PersonInfo);  // Update the related person's info in memory

        FamilyTable.Post;                        // Update the related person's record to DB
         needs to update the FieldToUpdate without reloading the wrong informatiom
        if not Locate_AFN(FamilyTable, SavedAFN) then // this will reload the original and fFatherInfo, fMotherInfo, fSpouseInfo
          AlertFmt('Unable to return to AFN=%s', [SavedAFN])
        else
          begin // returned to the original record
            if not Empty(FieldToUpdate) then
              begin
                FamilyTable.LoadPersonInfo(PersonInfo);  // PersonInfo now contains the original person's information

                if SameText(FieldToUpdate, FATHER_AFN) then
                  PersonInfo.Father_AFN := fFatherInfo.AFN else
                if SameText(FieldToUpdate, MOTHER_AFN) then
                  PersonInfo.Mother_AFN := fMotherInfo.AFN else
                if SameText(FieldToUpdate, SPOUSE_AFN) then
                  PersonInfo.Spouse_AFN := fSpouseInfo.AFN;

                FamilyTable.Edit;
                FamilyTable.FieldByName(FieldToUpdate).AsString := TempInfo.AFN;  // update the link to the new location
              end;
          end;
//        TempInfo.AFN := FamilyTable.fldAFN.AsString;
      end;
  finally
    FreeAndNil(InfoForm);
  end;
end;
*)

procedure TfrmIndividual.DisplayPersonInfo(pn: TPersonNumber; PersonInfo: TPersonInfo);
begin
  with fPeopleDisplayed[pn], PersonInfo do
    begin
      lblName.Caption  := FullName(Prefix, FirstName, MiddleName, LastName, Suffix, NickName);
      lblName.Color    := clBtnFace;
      lblBirth.Caption := BirthDate;
      lblDeath.Caption := DeathDate;
      LinkToButton.Enabled := not Empty(AFN);
    end;
end;

procedure TfrmIndividual.btnEditSpouseClick(Sender: TObject);
begin
  if Empty(fSpouseInfo.Sex) then
    fSpouseInfo.Sex := Opposite(FamilyTable.fldSex.AsString);
  if Empty(fSpouseInfo.Spouse_AFN) then
    fSpouseInfo.Spouse_AFN := FamilyTable.fldAFN.AsString;
  if Empty(fSpouseInfo.AFN) and (not Empty(fSpouseInfo.Sex)) then
    fSpouseInfo.AFN := FamilyTable.fldAFN.AsString + fSpouseInfo.Sex;
  if EditInfo(fSpouseInfo, Format('Spouse of %s', [FamilyTable.FullName]), SPOUSE_AFN) then
    begin
      DisplayPersonInfo(pnSpouse, fSpouseInfo);
      FamilyTable.Edit;
      FamilyTable.fldSpouse_AFN.AsString := fSpouseInfo.AFN;
    end;
end;

procedure TfrmIndividual.btnEditFatherClick(Sender: TObject);
begin
  if Empty(fFatherInfo.Sex) then
    fFatherInfo.Sex := 'M';
  if Empty(fFatherInfo.LastName) then
    fFatherInfo.LastName := fPersonInfo.LastName;
  if EditInfo(fFatherInfo, Format('Father of %s', [FamilyTable.FullName]), FATHER_AFN) then
    begin
      DisplayPersonInfo(pnFather, fFatherInfo);
      FamilyTable.Edit;
      FamilyTable.fldFather_AFN.AsString := fFatherInfo.AFN;
    end;
end;

procedure TfrmIndividual.btnEditMotherClick(Sender: TObject);
begin
  if Empty(fMotherInfo.Sex) then
    fMotherInfo.Sex := 'F';
  if Empty(fMotherInfo.LastName) then
    fMotherInfo.LastName := fPersonInfo.LastName;
  if EditInfo(fMotherInfo, Format('Mother of ', [FamilyTable.FullName]), MOTHER_AFN) then
    begin
      DisplayPersonInfo(pnMother, fMotherInfo);
      FamilyTable.Edit;
      FamilyTable.fldMother_AFN.AsString := fMotherInfo.AFN;
    end;
end;

procedure TfrmIndividual.CountSelectedRecords1Click(Sender: TObject);
var
  Count: integer;
  AdvancedSearchForm: TfrmAdvancedSearch;
  SelectivityInfo: TPersonInfo;
begin
  SelectivityInfo     := fFilterInfo;
  try
    fFilterInfo.DataSet := FamilyTable;
    AdvancedSearchForm  := TfrmAdvancedSearch.Create(self, @fFilterInfo);

    AdvancedSearchForm.SelectivityInfoPtr := @fFilterInfo;
    if AdvancedSearchForm.ShowModal = mrOk then
      begin
        fFilterInfo.Expr := AdvancedSearchForm.mmoExpression.Text;
        with TempFamilyTable do
          begin
            Filtered       := false;
            fFilterInfo.Expr := AdvancedSearchForm.mmoExpression.Text;
//          SetSelectivityParserExpression(fFilterInfo.Expr);
            OnFilterRecord := FilterFamilyRecords;
            Filtered       := HasFilterInfo(fFilterInfo);

            First;
            Count := 0;
            while not eof do
              begin
                Inc(Count);
                Next;
              end;
          end;
        FreeAndNil(fTempFamilyTable);
        AlertFmt('%d records scanned', [Count]);
      end;
  finally
    fFilterInfo := SelectivityInfo;
  end;
end;

procedure TfrmIndividual.DateAdded1Click(Sender: TObject);
begin
  ChangeToIndex(DateAdded1, 'DateAdded');
end;

procedure TfrmIndividual.DateUpdated1Click(Sender: TObject);
begin
  ChangeToIndex(DateUpdated1, 'DateUpdated');
end;

procedure TfrmIndividual.Parseselectedtextasname1Click(Sender: TObject);
var
  aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName: string;
begin
  if ParseName(Trim(dbComments.SelText), aPrefix, aFirstName, aMiddleName, aLastName, aSuffix, aNickName) then
    with FamilyTable do
      begin
        Edit;
        fldPrefix.AsString     := aPrefix;
        fldFirstName.AsString  := aFirstName;
        fldMiddleName.AsString := aMiddleName;
        fldLastName.AsString   := aLastName;
        fldSuffix.AsString     := aSuffix;
        fldNickName.AsString   := aNickName;
      end;
end;

procedure TfrmIndividual.SelectedTextToBirthDate1Click(Sender: TObject);
begin
  with FamilyTable do
    begin
      Edit;
      fldBirthDate.AsString  := dbComments.SelText;
    end;
end;

procedure TfrmIndividual.SelectedtexttoBirthPlace1Click(Sender: TObject);
begin
  with FamilyTable do
    begin
      Edit;
      fldBirthPlace.AsString := dbComments.SelText;
    end;
end;

procedure TfrmIndividual.SelectedtexttoDeathDate1Click(Sender: TObject);
begin
  with FamilyTable do
    begin
      Edit;
      fldDeathDate.AsString := dbComments.SelText;
    end;
end;

procedure TfrmIndividual.SelectedtexttoDeathPlace1Click(Sender: TObject);
begin
  with FamilyTable do
    begin
      Edit;
      fldDeathPlace.AsString := dbComments.SelText;
    end;
end;

procedure TfrmIndividual.SelectedtexttoBirthDateBirthPlace1Click(
  Sender: TObject);
var
  aBirthDate, aBirthPlace: string;
begin
  ParseDateAndPlace(dbComments.SelText, aBirthDate, aBirthPlace);
  with FamilyTable do
    begin
      Edit;
      fldBirthDate.AsString  := aBirthDate;
      fldBirthPlace.AsString := aBirthPlace;
    end;
end;

procedure TfrmIndividual.SelectedtexttoDeathDatePlace1Click(
  Sender: TObject);
var
  aDeathDate, aDeathPlace: string;
begin
  ParseDateAndPlace(dbComments.SelText, aDeathDate, aDeathPlace);
  dbDeathDate.Text  := aDeathDate;
  dbDeathPlace.Text := aDeathPlace;
end;

procedure TfrmIndividual.FixDeathDateFormatforSelectedRecords1Click(
  Sender: TObject);
var
  SavedRecNo, LastRecNo, Count: integer;
begin
  with TempFamilyTable do
    begin
      SavedRecno := RecNo;
      DisableControls;
      try
        Count := 0;
        First;
        while not Eof do
          begin
            if (Length(fldDeathDate.AsString) > 4) and IsPureNumeric(fldDeathDate.AsString) then
              begin
                LastRecNo := RecNo;
                Edit;
                fldDeathDate.AsString := CanonicalDateToGenealogyDate(fldDeathDate.AsString);
                Inc(Count);
                Post;

                if RecNo = LastRecNo then
                  Next;
              end;
          end;
        AlertFmt('Complete. Updated %d records', [Count]);
      finally
        RecNo := SavedRecNo;
        EnableControls;
      end;
    end;
end;

procedure TfrmIndividual.AboutFamilyTree2Click(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(self);
  AboutBox.ShowModal;
  FreeAndNil(AboutBox);
end;

procedure TfrmIndividual.InsertParentsString1Click(Sender: TObject);
begin
  if not (FamilyTable.State in [dsEdit, dsInsert]) then
    FamilyTable.Edit;

  dbComments.Text := ParentsString(dbSex.Text, fFatherInfo, fMotherInfo) + dbComments.Text;
end;

procedure TfrmIndividual.Options1Click(Sender: TObject);
begin
  FamilyTable.Close;
  Query.Close;
  FreeAndNil(fFamilyTable);
  FreeAndNil(Query);
  GetPrivateSettingsFromUser(gPrivateSettings);
  gPHOTOPATH   := ForceBackSlash(gPrivateSettings.LocalWebFolder) + DEFAULT_IMAGES;
  gDOCFILEPATH := ForceBackSlash(gPrivateSettings.LocalWebFolder) + DEFAULT_DOCS;
  OpenFamilyTable;
end;

procedure TfrmIndividual.CleanUpComments1Click(Sender: TObject);
var
  S2Pos: integer; Temp: string;
  LookFor: set of TPhraseKind;
begin
  if not (FamilyTable.State in [dsEdit, dsInsert]) then
    FamilyTable.Edit;

  if dbSex.Text = 'M' then
    LookFor := [dkHeIsTheSonOf, dkHeWasTheSonOf] else
  if dbSex.Text = 'F' then
    LookFor := [dkSheIsTheDaughterOf, dkSheWasTheDaughterOf]
  else
    LookFor := [];

  S2Pos := OffsetToPhrase(dbComments.Text, LookFor, false);
  if S2Pos > 0 then
    dbComments.Text := Copy(dbComments.Text, S2Pos, Length(dbComments.Text) - S2Pos) // delete stuff before "...he was the son/daughter of"
  else
    dbComments.Text := ParentsString(dbSex.Text, fFatherInfo, fMotherInfo) + dbComments.Text; // or insert "He was the son/daughter of "

  if dbSex.Text = 'M' then
    LookFor := [dkHeMarried] else
  if dbSex.Text = 'F' then
    LookFor := [dkSheMarried]
  else
    LookFor := [];

  S2Pos := OffSetToPhrase(dbComments.Text, LookFor, true);
  if S2Pos > 0 then
    begin
      Temp := dbComments.Text;
      Insert(CRLF+CRLF, Temp, S2Pos);
      dbComments.Text := Temp;
    end;
end;

procedure TfrmIndividual.Post1Click(Sender: TObject);
begin
  FamilyTable.Post;
end;

procedure TfrmIndividual.AddRecord1Click(Sender: TObject);
begin
  FamilyTable.Append;
end;

procedure TfrmIndividual.CreateSpouseFromSelectedText(const TheText: string);
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
  Len: integer;
  HasDate: boolean;
  MarriageInfo: string;
  MarriageDate, MarriagePlace: string;
  Line: string;
  Ndx: integer;
  Ch: char;
  PhraseKind: TPhraseKind;
  NewSpouseInfo: TPersonInfo;
  Exists: boolean;

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

  procedure NextCh;
  begin { NextCh }
    inc(Ndx);
    Ch := Line[Ndx];
  end;  { NextCh }

  procedure SkipChar(SetOfChar: TSetOfChar);
  begin { SkipChar }
    while (Ndx <= Length(Line)) and (Ch in SetOfChar) do
      NextCh;
  end;  { SkipChar }

  procedure SkipBlanks;
  begin { SkipBlanks }
    SkipChar([' ', #13, #10]);
  end;  { SkipBlanks }

  //*******************************************************************************}
  //   Function Name     : StartOfNextPhrase
  //   Function Purpose  : Look for the offset to the next phrase key word(s)
  //   Parameters        : idx = starting index for scan
  //   Return Value      : index of next phrase RELATIVE TO BEGINNING OF fLINE
  //*******************************************************************************}

  function StartOfNextPhrase(idx: integer; var PhraseKind: TPhraseKind; RequirePrecedingSpace: boolean = true): integer;
  var
    N: integer;
    OffSet: integer;
    Buf, P, p0, p1: pchar;
    dk: TPhraseKind;
    FoundMatch: boolean;
  begin
    OffSet  := MAXINT;
    p0      := pchar(Line);
    Buf     := p0 + idx - 1;
    p1      := nil;  // will point to character after phrase
    for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
      begin
        p := MyStrPos(Buf, pchar(PhraseInfoArray[dk].Key), Length(Line)-idx, true);
        if p <> nil then
          begin
            FoundMatch := true;
            if RequirePrecedingSpace and (not ((p-1)^ in [' ', '.'])) then // we require a preceding blank (or period)
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
        result     := Length(Line);  // did not find a match
        PhraseKind := dkUnknown;
      end;
  end;

  function LookForNearestDate(idx: cardinal): cardinal;
  const
    DELIMS = ' .;,'#13#10;
  var
    N: integer;
    wc: integer;
    pos: cardinal;
    done: boolean;
    aWord, Month, Day, Year, aDate, Canonical: string;
    HasYear, HasMonth, HasDay: boolean;
  begin
    HasYear := false; HasMonth := false; HasDay :=  false;
    wc := WordCountL(Line, DELIMS);
    N := 1;
    done := false;
    while not done do
      begin
        done := not AsciiPositionL(N, Line, DELIMS, #0, pos);
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
      aWord := ExtractWordL(N, Line, DELIMS);
      Month := ''; Day := ''; Year := '';
      if IsMonth(aWord) then // we found a month
        begin
          HasMonth := true;
          AsciiPositionL(N, Line, DELIMS, #0, result);  // remember where we found the month
          Month := aWord;
          aWord := ExtractWordL(N - 1, Line, DELIMS); // Get the proceding word
          if IsPureNumeric(aWord) and IsDay(StrToInt(aWord), MonthNumber(Month)) then
            begin
              Day := aWord;
              AsciiPositionL(N-1, Line, DELIMS, #0, result); // No-- remember where we found the day
              HasDay := true;
            end
          else
            Day := '';
          aWord := ExtractWordL(N + 1, Line, DELIMS); // and the next word
          if IsYear(aWord, LOWEST_YEAR) then
            begin
              Year := aWord;
              HasYear := true;
            end;
          aDate := Day + ' ' + Month + ' ' + Year;   // See if these constitute a date
          if ConvertToCanonical(aDate, Canonical) then
            done := true;
        end else
      if IsYear(aWord, LOWEST_YEAR) and (Year = '') then // found only a year- accept it as the date
        begin
          done := AsciiPositionL(N, Line, DELIMS, #0, result);
          HasYear := true;
        end;
      inc(N);
      done := done or (N > wc);
    until done;
    if not HasYear then            // Can't be a date if it doesn't have a year
      result := MAXINT else        
    if (HasDay and (not HasMonth)) then // Can't be a date with just a day and a year AND NO MONTH
      result := MAXINT;
  end;

  function ReadString(TermCh: TSetOfChar; Endn: integer): string;
  begin { ReadString }
    SkipBlanks;
    result := '';
    while (Ndx <= Endn) and (not (Ch in TermCh)) do
      begin
        if not (Ch in TermCh) then
          begin
            if not (Ch in [#13, #10]) then
              result := result + Ch;
            NextCh;
          end;
      end;
  end;  { ReadString }

  function ReadPhrase
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
      SavedNdx := Ndx;
      result   := true;
      MaxNrWords := 0;
      for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
        if dk in PossiblePhraseKinds then
          begin
            PhraseMatches := true;
            Ndx          := SavedNdx;
            NrWords       := PhraseInfoArray[dk].NrWords;
            if NrWords > 1 then
              for i := 2 to NrWords do
                begin
                  TargetWord := ExtractWordL(i, PhraseInfoArray[dk].Key, ' ');
                  WordRead   := ReadString([' '], Length(Line));
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
              Ndx := SavedNdx;
          end;
      if PossiblePhraseKinds = [] then
        begin
          result := false;
          Ndx   := SavedNdx;
        end;
    end;  { ReadPhraseInner }

  function IsStartingWordOfPhraseKey(const aWord: string; var PossiblePhraseKinds: TPhraseKindSet): boolean;
  var
    dk: TPhraseKind;
  begin
    PossiblePhraseKinds := [];
    for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
      if SameText(aWord, ExtractWordL(1, PhraseInfoArray[dk].Key, ' ')) then
        Include(PossiblePhraseKinds, dk);
    result := PossiblePhraseKinds <> [];
  end;

  begin { ReadPhrase }
    PhraseKind := dkUnknown;
    aWord      := ReadString([' '], Length(Line));
    if IsStartingWordOfPhraseKey(aWord, PossiblePhraseKinds) then
      if ReadPhraseInner(TestPhraseKind, PossiblePhraseKinds) then
        PhraseKind := TestPhraseKind;

    StartOfPhrase := Ndx;
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
        SavedNdx      := Ndx;
        while (cnt < 3) and (not Empty(aWord)) and
              ((IsPureNumeric(aWord) and (StrToInt(aWord) <= 31)) or IsMonth(aWord) or IsYear(aWord, LOWEST_YEAR)) do
          begin
            aPossibleDate := aPossibleDate + aWord + ' ';
            inc(cnt);
            if (cnt < 3) then
              begin
                SavedNdx := Ndx;
                aWord := ReadString(PHRASETERM+TermCh, Endn);
              end;
          end;
        if Cnt < 3 then
          begin
            Ndx := SavedNdx;
            Ch  := Line[Ndx];
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
        Endn   := StartOfNextPhrase(Ndx+1, Dummy);
        result := 'He ' + ReadString(TermCh, Endn-1) + '. ';
      end else
    if PhraseKind = dkSheMarried then
      begin
        Endn   := StartOfNextPhrase(Ndx+1, Dummy);
        result := 'She ' + ReadString(TermCh, Endn-1) + '. ';
      end else
    if PhraseKind in [dkPlace, dkAtTheAgeOf] then
      begin
        Endn   := StartOfNextPhrase(Ndx+1, Dummy);
        result := ReadString(TermCh, Endn-1)
      end;
  end;  { ReadPhrase }

  function UniqueAFN(const LastAFN: string; Suffix: String = ' '): string;
  var
    AddChar: boolean;
    Base: string;
    LastChar: char;
  begin { UniqueAFN }
    LastChar := LastAFN[Length(LastAFN)];
    AddChar  := LastChar in ['0'..'9'];
    LastChar := Chr(Ord(LastChar) + 1);

    if AddChar then // if numeric, add a Alpha suffix starting with the default
      begin
        Base     := LastAFN;
        LastChar := Suffix[1];
      end
    else  // if not numeric, replace the last char with the next
      Base := Copy(LastAFN, 1, Length(LastAFN)-1);

    result   := Base + LastChar;
    if Length(result) > AFN_FIELD_SIZE then
      raise Exception.CreateFmt('Created AFN (%s) exceeds %d characters', [result, AFN_FIELD_SIZE]);
  end;  { UniqueAFN }

begin { TfrmIndividual.CreateSpouseFromSelectedText }
  NrPhrases  := 0;
  InitPersonInfo(NewSpouseInfo);
  Line       := TheText;
  PhraseInfoArray[dkPersonNameMarried].Key := Format('%s married', [dbFirstName.Text]); // Like "Ruth married"
  if not Empty(Line) then
    begin
      Ndx       := 0;
      NextCh;    // get 1st character in line
      SkipBlanks;

      while Ndx <= Length(Line) do
        begin
          NextNdx := StartOfNextPhrase(Ndx, PhraseKind, FALSE);
          if NextNdx < Length(Line) then
            begin
              SetLength(PhraseInfo, NrPhrases+1);
              PhraseInfo[NrPhrases].StartOfPhrase := NextNdx;
              Ndx    := NextNdx;
              Ch     := Line[Ndx];
              NextNdx := Length(Line);
              if PhraseKind in [dkHeMarried, dkSheMarried, dkPersonNameMarried] then
                begin
                  Len      := Length(PhraseInfoArray[PhraseKind].Key);
                  NextNdx  := StartOfNextPhrase(Ndx+Len, aPhraseKind);
                  NextNdxD := LookForNearestDate(Ndx+Len);
                  HasDate  := false;
                  if NextNdxD < NextNdx then
                    begin
                      NextNdx := NextNdxD;
                      HasDate := true;
                    end;
                  SkipBlanks;
                  Ndx := Ndx + Len;
                  aPhrase := '';
                  aStartOfPhrase := Ndx;
                  for i := Ndx to NextNdx-2 do   // read the name
                    begin
                      NextCh;
                      aPhrase := aPhrase + Ch;
                    end;
                  aPhrase := TrimTrailing(aPhrase, ['.', ';', ',', ' ', #10, #13]);
                  aPhraseKind := PhraseKind;
                  if HasDate then
                    begin
                      Ndx := NextNdx;
                      NextNdx := StartOfNextPhrase(Ndx+1, DummyPhraseKind);
                      MarriageDate := Copy(Line, Ndx, NextNdx-Ndx);
                      Ndx := NextNdx-1;
                      NextCh;
                      NextNdx := StartOfNextPhrase(Ndx, DummyPhraseKind);
                      MarriagePlace := ReadPhrase(DummyPhraseKind, [#0, '.'], Canonical, DummyStartOfPhrase, NextNdx);
                    end;
                end
              else
                aPhrase := ReadPhrase(aPhraseKind, [#0, '.'], Canonical, aStartOfPhrase, NextNdx);

              if PhraseKind <> aPhraseKind then
                begin
                  lblStatus.Color := clYellow;
                  lblStatus.Caption := 'System error: unexpected PhraseKind: '
                                       + PhraseInfoArray[PhraseKind].Key + '/'
                                       + PhraseInfoArray[aPhraseKind].Key

                end;

              with PhraseInfo[NrPhrases] do
                begin
                  Phrase      := aPhrase;
                  StartOfPhrase := aStartOfPhrase;
                  EndOfPhrase := Ndx;
                  PhraseKind  := aPhraseKind;
                end;
              Inc(NrPhrases);
            end
          else
            Ndx := NextNdx + 1; // force an exit from the loop
        end;

      LastPhraseKind := dkUnknown;
      for i := 0 to NrPhrases - 1 do
        with PhraseInfo[i] do
          begin
            if i < NrPhrases-1 then // see if it overlaps the next one
              if Length(Phrase) > (PhraseInfo[i+1].StartOfPhrase - StartOfPhrase) then
                Phrase := Copy(Line, StartOfPhrase,  PhraseInfo[i+1].StartOfPhrase - StartOfPhrase); // truncate
            with NewSpouseInfo do
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
                dkHeMarried, dkSheMarried, dkPersonNameMarried:
                  begin
                    LastPhraseKind  := dkUnknown;
                    Sex             := Opposite(dbSex.Text);
                    MarriageInfo    := OppositeSexPronoun(dbSex.Text) + ' married '
                                         + FullNAme(dbPrefix.Text, dbFirstName.Text, dbMiddleName.Text, dbLastName.Text, dbSuffix.Text, dbNickName.Text);
                    if not Empty(BirthDate) then
                      MarriageInfo := MarriageInfo + ' (born ' + BirthDate + ')';
                    with NewSpouseInfo do
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
                                FirstName := UNKNOWNP;  // How do we determine if this is really the first or the last name?

                            Check('Last',   Phrase, LastName,   NewSpouseInfo, false, false);
                            Check('Middle', Phrase, MiddleName, NewSpouseInfo, true,  true);
                            Check('First',  Phrase, FirstName,  NewSpouseInfo, true,  false);
                          end
                        else
                          AlertFmt('"%s" could not be parsed as a name.', [aPhrase]);

                        if not Empty(MarriageDate) then
                          MarriageInfo := MarriageInfo + ' on ' + MarriageDate;
                        if not Empty(MarriagePlace) then
                          MarriageInfo := MarriageInfo + ' in ' + MarriagePlace;
                        MarriageInfo := MarriageInfo + '. ';
                        Comments := MarriageInfo + Copy(Line, EndOfPhrase+1, Length(Line)-EndOfPhrase);
                      end;
                  end;
              end
          end;

          if (Empty(NewSpouseInfo.FirstName) or Empty(NewSpouseInfo.LastName) or Empty(NewSpouseInfo.Sex)) then
            begin
              AlertFmt('Missing info for newly created spouse. ' + CRLF +
                       'First: "%s", Last: "%s", Sex: "%s"',
                     [NewSpouseInfo.FirstName, NewSpouseInfo.LastName, NewSpouseInfo.Sex]);
              Exit;
            end;

          NewSpouseInfo.AFN := UniqueAFN(FamilyTable.fldAFN.AsString,
                                         Opposite(FamilyTable.fldSex.AsString));   // start with a default AFN for the newly to be created spouse
          NewSpouseInfo.Spouse_AFN := FamilyTable.fldAFN.AsString;

          // find a unique AFN for the spouse record that we are about to create
          with TempFamilyTable do
            begin
              repeat
                Exists := Locate('AFN', NewSpouseInfo.AFN, [loCaseInsensitive]);
                if Exists then
                  NewSpouseInfo.AFN := UniqueAFN(NewSpouseInfo.AFN)
                else
                  Exists := RecentlyAddedAFNs.IndexOf(NewSpouseInfo.AFN) >= 0; // may have been added but not yet shown up in this copy of the table
              until Not Exists;
            end;

          // assert that we now have a unique ID for the spouse record that we are about to create.
          // Update the current person's record with the new AFN if it doesn't already have one.
          if Empty(FamilyTable.fldSpouse_AFN.AsString) then
            begin
              FamilyTable.Edit;
              FamilyTable.fldSpouse_AFN.AsString := NewSpouseInfo.AFN;
              FamilyTable.Post;
              fSpouseInfo := NewSpouseInfo;
            end;

          with FamilyTable do
            begin
              Append;
              SavePersonInfo(NewSpouseInfo);
              FamilyTableAfterScroll(FamilyTable);
              Post;
            end;
    end;
end;  { TfrmIndividual.CreateSpouseFromSelectedText }

procedure TfrmIndividual.CreateSpousefromSelectedText1Click(
  Sender: TObject);
begin
  CreateSpouseFromSelectedText(dbComments.SelText)
end;

procedure TfrmIndividual.btnClearPictureRefClick(Sender: TObject);
begin
  with FamilyTable do
    begin
      if not (State in [dsEdit, dsInsert]) then
        Edit;
      fldImage.AsString := '';
      ShowPerson(fldAFN.AsString);
    end;
end;

procedure TfrmIndividual.NormalizeDABDAFNs1Click(Sender: TObject);
var
  RecsProcessed, RecsFixed: integer;
  temp, RecAFN: string;

  function Fix(const FieldName: string): boolean;
  var
    TheField: TField;
    OldAFN, NewAFN, Temp, Digits: string;
    DABDNR: integer;
  begin { Fix }
    result   := false;
    TheField := TempFamilyTable.FieldByName(FieldName);
    OldAFN := TheField.AsString;
    if (MyStrPos(pchar(OldAFN), 'dabd-', Length(OldAFN), true) <> nil) and
       (Length(OldAFN) < 9) then
      begin
        Digits := Copy(OldAFN, 6, 4);
        if IsPureNumeric(Digits) then
          begin
            DABDNR := StrToInt(Digits);
            NewAFN := 'dabd-' + Rzero(DABDNR, 4);
            TheField.AsString := NewAFN;

            Temp   := Format('%-10s: Changing %11s from %-10s to %-10s', [RecAFN, FieldName, OldAFN, NewAFN]);
            WriteLn(fOutFile, Temp);
            result := true;
          end;
      end;
  end;  { Fix }

begin { NormalizeDABDAFNs1Click }
  AssignFile(fOutFile, fLogPathFileName);
  ReWrite(fOutFile);
  RecsProcessed := 0; RecsFixed := 0;
  try
    FreeAndNil(fTempFamilyTable);
    with TempFamilyTable do
      begin
        Filtered := false;
        IndexFieldNames := '';
        First;
        while not Eof do
          begin
            RecAfn := fldAFN.AsString;
            Edit;
            if Fix('AFN') or
               Fix(SPOUSE_AFN) or
               Fix(FATHER_AFN) or
               Fix(MOTHER_AFN) then
              begin
                Post;
                inc(RecsFixed);
              end
            else
              Cancel;

            Next;
            Inc(RecsProcessed);
            if (RecsProcessed mod 100) = 0 then
              begin
                LblStatus.Caption := Format('Processed = %d, Fixed = %d', [RecsProcessed, RecsFixed]);
                Application.ProcessMessages;
              end;
          end;
      end;
  finally
    WriteLn(fOutFile, Format('%d records were processed', [RecsProcessed]));
    WriteLn(fOutFile, Format('%d records were fixed', [RecsFixed]));
    CloseFile(fOutFile);
    temp := Format('Notepad.exe %s', [fLogPathFileName]);
    FileExecute(temp, false);
  end;
end;  { NormalizeDABDAFNs1Click }

procedure TfrmIndividual.ScanforMissingRelations1Click(Sender: TObject);
var
  RecsProcessed, MissingRelations: integer;
  temp, CurrentAFN, LastAFN: string;
  AFNList: TStringList;
  TheFullName, TheBirthDate: string;
  TotalRecs: integer;

  procedure CheckRelation(const Relation, NeededAFN: string);
  begin { CheckRelation }
    if (not Empty(NeededAFN)) and (AFNList.IndexOf(NeededAFN) < 0) then
      begin
        if CurrentAFN <> LastAFN then
          begin
            WriteLn(fOutFile);
            Inc(MissingRelations);
            WriteLn(fOutFile, Format('%6d. %-10s: [%-10s] %s', [MissingRelations, CurrentAFN, TheBirthDate, TheFullName]));
          end;
        WriteLn(fOutFile, '': 20, Format('%s [%s] was not found', [Relation, NeededAFN]));
        LastAFN := CurrentAFN;
      end;
  end;  { CheckRelation }

begin
  AssignFile(fOutFile, fLogPathFileName);
  ReWrite(fOutFile);
  RecsProcessed := 0; CurrentAFN := ''; MissingRelations := 0;
  try
    FreeAndNil(fTempFamilyTable);
    // make a list of all of the AFN's

    AFNList               := TStringList.Create;
    AFNList.CaseSensitive := false;
    with TempFamilyTable do
      begin
        First;
        while not Eof do
          begin
            CurrentAFN := fldAFN.AsString;
            AFNList.Add(CurrentAFN);

            Next;
            Inc(RecsProcessed);
            if (RecsProcessed mod 100) = 0 then
              begin
                LblStatus.Caption := Format('Scanning = %d', [RecsProcessed]);
                Application.ProcessMessages;
              end;
          end;

        AFNList.Sorted := true;

        // Now make sure that all of the relations are found

        TotalRecs     := RecsProcessed;
        RecsProcessed := 0;
        IndexFieldNames := 'AFN';
        First;
        while not Eof do
          begin
            CurrentAFN   := fldAFN.AsString;
            TheFullName  := FullName;
            TheBirthDate := fldCanonBirth.AsString;
            CheckRelation('Spouse', fldSpouse_AFN.AsString);
            CheckRelation('Father', fldFather_AFN.AsString);
            CheckRelation('Mother', fldMother_AFN.AsString);

            Next;
            Inc(RecsProcessed);
            if (RecsProcessed mod 100) = 0 then
              begin
                LblStatus.Caption := Format('Processing = %d/%d', [RecsProcessed, TotalRecs]);
                Application.ProcessMessages;
              end;
          end;
        lblStatus.Caption := Format('%d records with missing relations were found', [MissingRelations]);
        Application.ProcessMessages;
      end;
  finally
    WriteLn(fOutFile, Format('%d records were processed', [RecsProcessed]));
    WriteLn(fOutFile, Format('%d records had missing relations', [MissingRelations]));
    CloseFile(fOutFile);
    temp := Format('Notepad.exe %s', [fLogPathFileName]);
    FileExecute(temp, false);
  end;
end;

procedure TfrmIndividual.FindNextPrev(NextPrev: TNextPrev);
var
  Accept: boolean;
  Saved_AFN: string;
  Saved_Cursor: TCursor;
begin
  with FamilyTable do
    begin
      Saved_Cursor  := Screen.Cursor;
      Screen.Cursor := crSQLWait;
      DisableControls;
      try
        ShowStatus('Locating...', false);
        Saved_AFN     := fldAFN.AsString;
        fFilterInfo   := fSelectivityInfo;
        fFilterInfo.DataSet := FamilyTable;
        Accept := false;
        repeat
          case NextPrev of
            npNext:
              Next;
            npPrev:
              Prior;
          end;
          FilterFamilyRecords(FamilyTable, Accept);
        until Eof or Bof or Accept;
      finally
        EnableControls;
        ShowStatus('', false);
        Screen.Cursor := Saved_Cursor;
      end;
      if (Eof or Bof) and (Not Accept) then   // We couldn't find the desired record
        begin
          if not Locate_AFN(FamilyTable, Saved_AFN) then
            AlertFmt('Unable to restore saved position', [Saved_AFN]);
          Alertfmt('Unable to locate %s individual %s', [IIF(NextPrev=npNext, 'next', 'previous'), fFilterInfo.AFN]);
        end
      else
        FamilyTableAfterScroll(FamilyTable); // nothing got displayed because the controls were disabled
    end;
end;


procedure TfrmIndividual.btnFindNextClick(Sender: TObject);
begin
  FindNextPrev(npNext);
end;

procedure TfrmIndividual.btnFindPrevClick(Sender: TObject);
begin
  FindNextPrev(npPrev);
end;

procedure TfrmIndividual.ViewLastLogFileTxt1Click(Sender: TObject);
var
  Temp: string;
begin
  temp := Format('Notepad.exe %s', [fLogPathFileName]);
  FileExecute(temp, false);
end;

procedure TfrmIndividual.Print1Click(Sender: TObject);
begin
  Print;
end;

function TfrmIndividual.GetSelectivityInfo: boolean;
var
  Expr: string;
{$IfNDef debugging2}
  AdvancedSearchForm: TfrmAdvancedSearch;
{$EndIf}
begin { GetSelectivityInfo }
  fFilterInfo.DataSet := TempFamilyTable;
{$IfNDef debugging2}
  AdvancedSearchForm  := TfrmAdvancedSearch.Create(self, @fFilterInfo);

  AdvancedSearchForm.SelectivityInfoPtr := @fFilterInfo;
  result := AdvancedSearchForm.ShowModal = mrOk;
  Expr   := AdvancedSearchForm.mmoExpression.Text;
{$else}
  InitPersonInfo(fFilterInfo);
  fFilterInfo.FirstName  := 'DANIEL';
  fFilterInfo.MiddleName := 'HAYES';
  fFilterInfo.LastName   := 'DORROUGH';
  Expr                   := '';
  result := true;
{$EndIf}
  if result then
    begin
      fFilterInfo.Expr := Expr;
      with TempFamilyTable do
        begin
          Filtered       := false;
          fFilterInfo.Expr := Expr;
          OnFilterRecord := FilterFamilyRecords;
          Active         := true;
          Filtered       := HasFilterInfo(fFilterInfo);
        end;
    end;
end;  { GetSelectivityInfo }

procedure TfrmIndividual.GenerateHTMLforSelectedRecords1Click(
  Sender: TObject);
const
  INDENT_SIZE = 4;
var
  HTMLFileName: string;
  ErrorCount, Count: integer;
  Temp: string;
  NeedsToBeUpdated: boolean;
{$IfNDef debugging}
  TheFileAge: integer;
{$EndIf}
  Saved_Cursor: TCursor;
  Indent: integer;
  ErrorMessage: string;
  RecCnt, Generated: integer;
  GenerateAllSelected: boolean;

  function DisplayedBirthDate(BirthDate, CanonBirth, CanonDeath: String): string;
  var
    OkToUseBirthDate: (byNo, byYes, byShort);
    BirthYearStr: string;
    BirthYear: integer;
  begin
    if not Empty(CanonDeath) then
      OkToUseBirthDate := byYes
    else     // there is no death date
      if Length(CanonBirth) <= 4 then   // but the birth date contains only the year so we can use it
        OkToUseBirthDate := byYes
      else
        begin
          BirthYearStr := Copy(CanonBirth, 1, 4);
          if IsPureNumeric(BirthYearStr) then
            begin
              BirthYear := StrToInt(BirthYearStr);
              if (YearOf(Now) - BirthYear) > 100 then  // its been more than 100 years since this person was born so we can use it
                OkToUseBirthDate := byYes
              else
                OkToUseBirthDate := byShort;  // display only the year
            end
          else  // this should never happen
            OkToUseBirthDate := byNo;
        end;

    case OkToUseBirthDate of
      byYes:   result := BirthDate;
      byNo:    result := '';
      byShort: result := Copy(CanonBirth, 1, 4);
    end;

  end;

  function GeneratePage(OutputFileName: string; var ErrorMessage: string): boolean;
  var
    HTMLFile: TextFile;

    procedure DoOpenTag(ht: THTMLTags; const Params: string = '');
    begin
      WriteLn(HTMLFile, '':Indent, OpenTag(ht, Params));
      Inc(Indent, INDENT_SIZE);
    end;

    procedure DoCloseTag(ht: THTMLTags; const Params: string = '');
    begin
      Dec(Indent, INDENT_SIZE);
      WriteLn(HTMLFile, '':Indent, CloseTag(ht, Params));
    end;

    procedure DoSelfCloseTag(ht: THTMLTags; const Params: string = '');
    begin
      WriteLn(HTMLFile, '':Indent, SelfCloseTag(ht, Params));
    end;

    procedure DoText(const text: string; DoFixHTMLChars: boolean = true);
    begin
      if DoFixHTMLChars then
//      WriteLn(HTMLFile, '':Indent, FixHTMLChars(Text, [fo_FixAmpersand, fo_FixLT, fo_FixGT]))
        WriteLn(HTMLFile, '':Indent, FixHTMLChars(Text))
      else
        WriteLn(HTMLFile, '':Indent, Text);
    end;

    procedure GenerateDocType;
    begin
      DoText('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">', false);
    end;

    procedure GenerateHead;
    begin
      DoOpenTag(ht_Head);
          DoSelfCloseTag(ht_META, 'http-equiv="Content-Type" content="text/html;charset=utf-8"');
          DoSelfCloseTag(ht_META, 'name = "viewport" content = "width = device-width"');
          DoSelfCloseTag(ht_META, 'name="author" content="Dan Dorrough"');
          DoSelfCloseTag(ht_META, 'name="copyright" content="&copy; ' + IntToStr(YearOf(Date)) + ' Dan and Ruth Dorrough"');
          DoSelfCloseTag(ht_META, 'name="viewport" content= "width = device-width"');
          DoOpenTag(ht_TITLE);
             DoText(TempFamilyTable.FullName);
          DoCloseTag(ht_TITLE);
          DoSelfCloseTag(ht_LINK, 'rel="stylesheet" type="text/css" href="' + PHOTODBROOT + 'MyStyle.css"');
      DoCloseTag(ht_Head);
    end;

    procedure GeneratePersonInfo;

      procedure GenerateFullName;
      begin
        with TempFamilyTable do
          begin
            DoOpenTag(ht_strong);
              DoOpenTag(ht_FONT, 'size="5"');
                DoText(FullName);
              DoCloseTag(ht_FONT);
            DoCloseTag(ht_strong);
          end;
      end;

      procedure GenerateBirthDeathDates;
      begin
        with TempFamilyTable do
          begin
            if (fldBirthDate.AsString <> '') and (fldDeathDate.AsString = '') then
              DoText(DisplayedBirthDate(fldBirthDate.AsString, fldCanonBirth.AsString, fldCanonDeath.AsString)) else
            if (fldBirthDate.AsString <> '') and (fldDeathDate.AsString <> '') then
              DoText(fldBirthDate.AsString + ' - ' + fldDeathDate.AsString)
            else if fldDeathDate.AsString <> '' then
              DoText('Died: ' + fldDeathDate.AsString);
          end;
      end;

      procedure GeneratePhoto;
      var
        JpgFileName, Search: string;
      begin { GeneratePhoto }
        with TempFamilyTable do
          if not (Empty(fldImage.AsString)) then
            begin
              JpgFileName :=  IMAGESFOLDER + fldImage.AsString;
              DoOpenTag(ht_TR);
              DoOpenTag(ht_TD);
              DoOpenTag(ht_P, 'align="center"');
              DoSelfCloseTag(ht_IMG, format('src="%s" alt="%s"', [JpgFileName, FullName]));

              DoCloseTag(ht_P);
              DoCloseTag(ht_TD);
              DoCloseTag(ht_TR);

              DoOpenTag(ht_TR);
              DoOpenTag(ht_TD);
              DoOpenTag(ht_P, 'align="center"');

              if not Empty(fldSearch.AsString) then
                Search := fldSearch.AsString
              else
                Search := fldFirstName.AsString + '+' + fldLastName.AsString;

              DoOpenTag(ht_A, 'href="' + PHOTODBROOT + 'ThumbnailsForm.asp?KeyWords=' + Search + '"');
                DoText('Photos');
              DoCloseTag(ht_A);

              DoCloseTag(ht_P);
              DoCloseTag(ht_TD);
              DoCloseTag(ht_TR);
            end;
      end;  { GeneratePhoto }

      procedure GenerateComments;
      begin { GenerateComments }
        with TempFamilyTable do
          if not Empty(fldComments.AsString) then
            begin
              DoOpenTag(ht_TR);
              DoOpenTag(ht_TD);
              DoOpenTag(ht_FONT, 'size="3"');
              DoText(fldComments.AsString);
              DoCloseTag(ht_FONT);
              DoCloseTag(ht_TD);
              DoCloseTag(ht_TR);
            end;
      end;  { GenerateComments }

      procedure GenerateDocumentReference;
      begin { GenerateDocumentReference }
        with TempFamilyTable do
          if not (Empty(fldDocFile.AsString)) then
            begin
              DoOpenTag(ht_TR);
              DoOpenTag(ht_TD);
              DoOpenTag(ht_FONT, 'size="3"');
              DoOpenTag(ht_A, 'href="' + PHOTODBROOT + fldDocFile.AsString + '"'); DoText(fldDocDescription.AsString); DoCloseTag(ht_A);
              DoCloseTag(ht_Font);
              DoCloseTag(ht_TD);
              DoCloseTag(ht_TR);
            end;
      end;  { GenerateDocumentReference }

      procedure GenerateRelationShips(const AFN: string);

        function LocateAFN(const AFN: string): boolean;
        begin { LocateAFN }
          result := false;
          if not Empty(AFN) then
            with TempFamilyTable.FamilyQuery do
              begin
                SQL.Clear;
                Close;
                SQL.Add('SELECT Prefix, FirstName, MiddleName, LastName, Suffix, ');
                SQL.Add('AFN, BirthDate, CanonBirth, DeathDate, CanonDeath ');
                SQL.Add('FROM Family WHERE AFN="' + AFN + '"');
                ExecSQL;
                Open;
                result := not (Bof and Eof);
              end;
        end;  { LocateAFN }

        procedure GeneratePersonRow(const RowTitle, AFN: string; aFullName: string);

          procedure GenerateRowNameColumn(const RowTitle: string);
          begin { GenerateRowNameColumn }
            DoOpenTag(ht_TD);
              DoOpenTag(ht_STRONG);
                DoText(RowTitle);
              DoCloseTag(ht_STRONG);
            DoCloseTag(ht_TD);
          end;  { GenerateRowNameColumn }

          procedure GeneratePersonNameColumn(const AFN: string; aFullName: string);

            procedure WritePersonLink(const AFN, aFullName: string);
            begin { WritePersonLink }
//            DoOpenTag(ht_A, 'href="' + PHOTODBROOT + 'FamilyTree.asp?AFN=' + AFN + '"'); DoText(aFullName);
              DoOpenTag(ht_A, 'href="' + AFN + '.htm"'); DoText(aFullName);
              DoCloseTag(ht_A);
            end;  { WritePersonLink }

          begin { GeneratePersonNameColumn }
            DoOpenTag(ht_TD);
            with TempFamilyTable.FamilyQuery do
              WritePersonLink(AFN, aFullName);
            DoCloseTag(ht_TD);
          end;  { GeneratePersonNameColumn }

          procedure GenerateCanonDateColumn(const CanonDate: string);
          begin { GenerateCanonDateColumn }
            DoOpenTag(ht_TD);
            DoText(CanonDate);
            DoCloseTag(ht_TD);
          end;  { GenerateCanonDateColumn }

        begin{ GeneratePersonRow }
          if not Empty(AFN) then
            begin
              DoOpenTag(ht_TR);

                GenerateRowNameColumn(RowTitle);
                with TempFamilyTable.FamilyQuery do
                  begin
                    GeneratePersonNameColumn(AFN, aFullName);
                    GenerateCanonDateColumn(DisplayedBirthDate(fldBirthDate.AsString, fldCanonBirth.AsString, fldCanonDeath.AsString));
                    GenerateCanonDateColumn(fldCanonDeath.AsString);
                  end;

              DoCloseTag(ht_TR);
            end;
        end;  { GeneratePersonRow }

        procedure GenerateChildren(const AFN: string);
        var
          Sex: char; Relation: string;
        begin { GenerateChildren }
          if not Empty(AFN) then
            try
              with TempFamilyTable.FamilyQuery do
                begin
                  Active := false;
                  SQL.Clear;
                  SQL.Add('SELECT AFN, Prefix, FirstName, MiddleName, LastName, Suffix, NickName, BirthDate, BirthOrder, DeathDate, CanonBirth, CanonDeath, BirthPlace, Sex ');
                  SQL.Add('FROM Family ');

                  // children must have this person as father or mother

                  Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s") ORDER BY BirthOrder, CanonBirth',
                                       [AFN, AFN]));

                  ExecSQL;
                  Active := true;
                  First;
                  while not Eof do
                    begin
                      if Length(fldSex.AsString) >= 1 then
                        Sex := UpperCase(fldSex.AsString)[1]
                      else
                        Sex := '?';

                      case Sex of
                        'M': Relation := 'Son';
                        'F': Relation := 'Daughter';
                        else
                             Relation := 'Child';
                      end;

                      GeneratePersonRow(Relation, fldAFN.AsString, FullName);
                      Next;
                    end;
                end;
            finally
              Query.Active := false;
            end;
        end;  { GenerateChildren }

        procedure GenerateSiblings(const Father_AFN, Mother_AFN: string);
        var
          Sex: char;
          Relation: string;
        begin { GenerateSiblings }
(*
          if (not Empty(Father_AFN)) or (not Empty(Mother_AFN)) then
            begin
              if (not Empty(Father_AFN)) and (not Empty(Mother_AFN)) then
                Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s")',
                                     [Father_AFN, Mother_AFN])) else
              if not Empty(Father_AFN) then
                Sql.Add(Format('Where (Father_AFN = "%s") ', [Father_AFN])) else
              if not Empty(Mother_AFN) then
                Sql.Add(Format('Where (Mother_AFN = "%s") ', [Mother_AFN]));
              Sql.Add(' ORDER BY CanonBirth');

              with Query do
                begin
                  ExecSQL;
                  Active := true;
                  First;
                  while not Eof do
                    begin
                      if fldAFN.AsString <> AFN then
                        AddPerson(Query, rt_Siblings);
                      Next;
                    end;
                end;
            end;
*)
          if (not Empty(Father_AFN)) or (not Empty(Mother_AFN)) then
            try
              with TempFamilyTable.FamilyQuery do
                begin
                  Active := false;
                  SQL.Clear;
                  SQL.Add('SELECT AFN, Prefix, FirstName, MiddleName, LastName, Suffix, NickName, BirthDate, BirthOrder, DeathDate, CanonBirth, CanonDeath, BirthPlace, Sex ');
                  SQL.Add('FROM Family ');

                  // siblings must have the same father or the same mother

                  if (not Empty(Father_AFN)) and (not Empty(Mother_AFN)) then
                    Sql.Add(Format('Where (Father_AFN = "%s") or (Mother_AFN = "%s")',
                                         [Father_AFN, Mother_AFN])) else
                  if not Empty(Father_AFN) then
                    Sql.Add(Format('Where (Father_AFN = "%s") ', [Father_AFN])) else
                  if not Empty(Mother_AFN) then
                    Sql.Add(Format('Where (Mother_AFN = "%s") ', [Mother_AFN]));
                  Sql.Add(' ORDER BY BirthOrder, CanonBirth');

                  ExecSQL;
                  Active := true;
                  First;
                  while not Eof do
                    begin
                      if Length(fldSex.AsString) >= 1 then
                        Sex := UpperCase(fldSex.AsString)[1]
                      else
                        Sex := '?';

                      case Sex of
                        'M': Relation := 'Brother';
                        'F': Relation := 'Sister';
                        else
                             Relation := 'Sibling';
                      end;

                      if not (SameText(AFN, fldAFN.AsString)) then
                        GeneratePersonRow(Relation, fldAFN.AsString, FullName);
                      Next;
                    end;
                end;
            finally
              Query.Active := false;
            end;
        end;  { GenerateSiblings }

      begin { GenerateRelationShips }
        DoOpenTag(ht_TD);
          DoOpenTag(ht_FONT, 'size="3"');
            DoOpenTag(ht_STRONG);
              DoText('Relationships');
            DoCloseTag(ht_STRONG);

            DoOpenTag(ht_TABLE, 'cellspacing="1" cellpadding="5" border="1"');

            with TempFamilyTable do
              begin
                if LocateAFN(fldSpouse_AFN.AsString) then  // locate using FamilyTable.Query
                  GeneratePersonRow('Spouse', fldSpouse_AFN.AsString, FamilyQuery.FullName);
                if LocateAFN(fldFather_AFN.AsString) then
                  GeneratePersonRow('Father', fldFather_AFN.AsString, FamilyQuery.FullName);
                if LocateAFN(fldMother_AFN.AsString) then
                  GeneratePersonRow('Mother', fldMother_AFN.AsString, FamilyQuery.FullName);
                GenerateChildren(fldAFN.AsString);
                GenerateSiblings(fldFather_AFN.aSsTRING, fldMOTHER_AFN.AsString);
              end;

            DoCloseTag(ht_TABLE);
          DoCloseTag(ht_FONT);
        DoCloseTag(ht_TD);
      end;  { GenerateRelationShips }

    begin { GeneratePersonInfo }
      with TempFamilyTable do
        begin
          DoOpenTag(ht_Table);
          DoOpenTag(ht_TR);
          DoOpenTag(ht_TD);

            DoOpenTag(ht_TABLE, 'id="TABLE1" style="WIDTH: 296px; HEIGHT: 190px" cellspacing="1" cellpadding="3" width="296" align="center" border="0"');
            DoOpenTag(ht_TR);
            DoOpenTag(ht_TD);

            DoOpenTag(ht_P, 'align="center"');
            DoOpenTag(ht_FONT, 'size="3"');

            GenerateFullName; DoSelfCloseTag(ht_BR);

            GenerateBirthDeathDates;

            DoCloseTag(ht_FONT);
            DoCloseTag(ht_P);

            DoCloseTag(ht_TD);
            DoCloseTag(ht_TR);
            GeneratePhoto;
            GenerateComments;
            GenerateDocumentReference;
            DoCloseTag(ht_Table);

          DoCloseTag(ht_TD);
          GenerateRelationships(fldAFN.AsString);
          DoCloseTag(ht_TR);
          DoCloseTag(ht_Table);
        end;
    end;  { GeneratePersonInfo }

    procedure GenerateSubmitForm;
    begin
      DoOpenTag(ht_FORM, 'name="frmSearchForIndividual" action="http://RuthAndDan.net/SearchFamily.asp"');
      DoSelfCloseTag(HT_input, 'type="submit" value="Search for Individual" id="submit1" name="btnSubmit"');
      DoCloseTag(ht_FORM);
    end;

    procedure GenerateFooter;
    begin
      DoOpenTag(ht_DIV,  'class="footer" align="center"');
        DoOpenTag(ht_FONT, 'size="2"');

          DoOpenTag(ht_A, 'href="http://RuthAndDan.net"');
            DoText('Home');
          DoCloseTag(ht_A);

          DoSelfCloseTag(ht_BR);

          DoText('Send corrections to Dan@RuthAndDan.net'); DoSelfCloseTag(ht_BR);

          DoText('Copyright (c) '+IntToStr(YearOf(Today))+' Ruth & Dan Dorrough'); DoSelfCloseTag(ht_BR);
          DoText('Family Web Site Developed by ');
          DoOpenTag(ht_A, 'href="http://r-and-d-systems.com/"');
          DoText('R & D Systems');
          DoCloseTag(ht_A);
          DoText('Canandaigua, NY 14424');
        DoCloseTag(ht_FONT);
      DoCloseTag(ht_DIV);
    end;

    procedure GenerateBody;
    begin { GenerateBody }
      DoOpenTag(ht_Body);
        GeneratePersonInfo;
        GenerateSubmitForm;
        GenerateFooter;
      DoCloseTag(ht_Body);
    end;  { GenerateBody }

  begin { GeneratePage }
    ShowStatus(Format('%s [%d/%d]', [TempFamilyTable.FullName, Count+1, RecCnt]));
    ProgressBar1.Position := Count;
    Application.ProcessMessages;
    result := true;
    try
      AssignFile(HTMLFile, HTMLFileName);
      ReWrite(HTMLFile);
      Indent := 1;
      try
        GenerateDocType;
        DoOpenTag(ht_HTML, 'lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml"');
          GenerateHead;
          GenerateBody;
        DoCloseTag(ht_HTML);
      finally
        CloseFile(HTMLFile);
      end;
    except
      on e:Exception do
        begin
          result := false;
          ErrorMessage := e.Message;
        end;
    end;
  end;  { GeneratePage }

begin { TfrmIndividual.GenerateHTMLforSelectedRecords1Click }
  AssignFile(fOutFile, fLogPathFileName);
  ReWrite(fOutFile);
  ErrorCount := 0; Count := 0; Generated := 0;

  FreeAndNil(fTempFamilyTable);  // re-create it w/o indexing
  fTempFamilyTable := TFamilyTable.Create( self,
                                           gPrivateSettings.FamilyTreeDataBaseFileName,
                                           cFAMILY, [optUseClient, optReadOnly]);
  fTempFamilyTable.Active := true;

  if GetSelectivityInfo then   // get options here.
    begin
      Saved_Cursor  := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      GenerateAllSelected := Yes('Yes = Generate page for all selected records? (No = Only for Updated Records)');

      try
        if FamilyTable.State in [dsEdit, dsInsert] then  // make sure that current record is posted
          FamilyTable.Post;

        with TempFamilyTable do
          begin
            try
              ShowStatus('Counting records to be processed');
              RecCnt                := 0;
              while not Eof do
                begin
                  Inc(RecCnt);
                  Next;
                end;
              ProgressBar1.Visible  := true;
              ProgressBar1.Position := 0;
              ProgressBar1.Max      := RecCnt;
              First;
              while not Eof do
                begin
                  try
                    HTMLFileName := ForceBackSlash(gPrivateSettings.HTMLOutputFolder) + TempFamilyTable.fldAFN.AsString + '.htm';
                    TheFileAge       := FileAge(HTMLFileName);
                    NeedsToBeUpdated := (TempFamilyTable.fldDateUpdated.IsNull) or
                                        (TempFamilyTable.fldDateUpdated.AsDateTime = 0) or  // If the record doesn't have a value for [DateUpdated];
                                        (TheFileAge < 0) or                                 // the file doesn't exist
                                        (TempFamilyTable.fldDateUpdated.AsDateTime > FileDateToDateTime(TheFileAge)); // or its been updated after the file was created

                    if NeedsToBeUpdated or GenerateAllSelected then
                      begin
                        if not GeneratePage(HTMLFileName, ErrorMessage) then
                          begin
                            WriteLn(fOutFile, 'Unable to generate page ', HTMLFileName);
                            WriteLn(fOutFile, '':10, ErrorMessage);
                            inc(ErrorCount);
                          end
                        else
                          Inc(Generated);
                      end;
                    Next;

                    if (Count mod 100) = 0 then
                      ShowStatus(Format('%d processed. %d Generated', [Count, Generated]), false);

                    Inc(Count);
                  except
                    on e:Exception do
                      begin
                        WriteLn(fOutFile, e.message);
                        inc(ErrorCount);
                      end;
                  end;
                end;
              ShowStatus(Format('%d processed. %d Generated', [Count, Generated]), false);
            finally
              ProgressBar1.Visible := false;
              CloseFile(fOutFile);
            end;
          end;
      finally
        if ErrorCount > 0 then
          begin
            if ErrorCount > 0 then
              begin
                temp := Format('%d errors occurred. %d photos generated. See LogFile.txt for details.', [ErrorCount, Generated]);
                Alert(temp);
                temp := Format('Notepad.exe %s', [fLogPathFileName]);
                FileExecute(temp, false);
              end
            else
              MessageFmt('No errors were detected. %d records processed. %d Generated', [Count, Generated]);
          end
        else
          MessageFmt('No errors were detected. %d records processed. %d Generated.', [Count, Generated]);

        TempFamilyTable.Close;
        FreeAndNil(fTempFamilyTable);  // re-create it w/o indexing
        Screen.Cursor := Saved_Cursor;
      end;
    end;
end;  { TfrmIndividual.GenerateHTMLforSelectedRecords1Click }

procedure TfrmIndividual.EnlargeAFNs1Click(Sender: TObject);
const
  CANDO_SIMULATED = TRUE;
var
  aResult: string;
  valid: boolean;
  NrDigits, ErrorCount, Pass1Count, Pass2Count, RefCount, UpdateCount: integer;
  Saved_Cursor: TCursor;
  Temp: string;
  FamilyTableLookup: TFamilyTable;
  Saved_RecNo: integer;
  ChangedAFNList: TStringList;
  Simulated: boolean;
  i: integer;
  p: pchar;

  procedure UpdateCurrentRecord;
  var
    OldAFN, NewAFN: string;
  begin { UpdateCurrentRecord }
    with fTempFamilyTable do
      begin
        OldAFN := fldAFN.AsString;
        if IsPureNumeric(OldAFN) then
          if Length(OldAFN) < NrDigits then
            begin
              NewAFN := RZero(OldAFN, NrDigits);

              if not FamilyTableLookup.Locate('AFN', NewAFN, []) then  // a record with this AFN does not already exist
                begin
                  Edit;
                  fldAFN.AsString := NewAFN;

                  p := StrAlloc(Length(NewAFN)+1);
                  StrCopy(p, pchar(NewAFN));
                  ChangedAFNList.AddObject(OldAFN, TObject(p));  // make a list of the old, new AFNs

                  if not Simulated then
                    Post
                  else
                    Cancel;

                  ChangedAFNList.AddObject(OldAFN, TObject(pchar(NewAFN)));
                end
              else
                begin
                  WriteLn(fOutFile, OldAFN:NrDigits,  ' =/=> ', NewAFN:NrDigits, ': record already exists');
                  inc(ErrorCount);
                end;
              Inc(UpdateCount);
            end;
      end;
  end;  { UpdateCurrentRecord }

  procedure UpdateField(Field: TField);
  var
    Idx: integer;
    NewAFN: string;
  begin { UpdateField }
    with fTempFamilyTable do
      begin
        idx := ChangedAFNList.IndexOf(Field.AsString);
        if Idx >= 0 then  // a reference to the old AFN which must be updated
          begin
            NewAFN := pchar(ChangedAFNList.Objects[Idx]);
            Edit;
            Field.AsString := NewAFN;
            Inc(RefCount);
          end;
      end;
  end;  { UpdateField }

begin { TfrmIndividual.EnlargeAFNs1Click }
  Valid := false;
  repeat
    if GetString( 'Resize AFN strings', 'New String Size (must be larger)', aResult) then
      if IsPureNumeric(aResult) then
        begin
          NrDigits := StrToInt(aResult);
          Valid := (NrDigits <= FamilyTable.fldAFN.Size) and (NrDigits > 5);
        end
      else
    else
      Exit;
  until Valid;

  AssignFile(fOutFile, fLogPathFileName);
  ReWrite(fOutFile);
  ErrorCount := 0; Pass1Count := 0; Pass2Count := 0; RefCount := 0; UpdateCount := 0;

  FreeAndNil(fTempFamilyTable);  // re-create it w/o indexing
  TempFamilyTable  := TFamilyTable.Create( self,
                                           gPrivateSettings.FamilyTreeDataBaseFileName,
                                           cFAMILY,
                                           [optUseClient]);
  FamilyTableLookup := TFamilyTable.Create( self,
                                            gPrivateSettings.FamilyTreeDataBaseFileName,
                                            cFAMILY,
                                            [optUseClient]);
  FamilyTableLookup.IndexFieldNames := 'AFN';
  FamilyTableLookup.Active          := true;
  TempFamilyTable.Active := true;

  if GetSelectivityInfo then   // get selectivity options here.
    begin
      if CANDO_SIMULATED then
        Simulated := Yes('Simulated update only?')
      else
        Simulated := false;

      Saved_Cursor  := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      ChangedAFNList := TStringList.Create;
      ChangedAFNList.Sorted := true;

      try
        if FamilyTable.State in [dsEdit, dsInsert] then  // make sure that current record is posted
          FamilyTable.Post;

        with TempFamilyTable do
          begin
            // update the record's AFNs, when necessary
            First;
            while not Eof do
              begin
                try
                  Saved_RecNo := RecNo;
                  UpdateCurrentRecord;

                  if RecNo = Saved_RecNo then  // current record was not removed by the selectivity
                    Next;

                  Inc(Pass1Count);
                  if (Pass1Count mod 100) = 0 then
                    ShowStatus(Format('%d records processed (pass 1).', [Pass1Count]), false);

                except
                  on e:Exception do
                    begin
                      WriteLn(fOutFile, e.message);
                      inc(ErrorCount);
                    end;
                end;
              end;

            // We must turn off filtering and reprocess the entire table to update records referencing the changed records
            Filtered := false;
            OnFilterRecord := FilterFamilyRecords;
            First;
            while not Eof do
              begin
                UpdateField(fldFather_AFN);
                UpdateField(fldMother_AFN);
                UpdateField(fldSpouse_AFN);
                if State = dsEdit then
                  begin
                    if not Simulated then
                      Post
                    else
                      Cancel;
                    inc(UpdateCount);
                  end;
                Next;
                Inc(Pass2Count);
                if (Pass2Count mod 100) = 0 then
                  ShowStatus(Format('%d records processed (Pass 2).', [Pass2Count]), false);
              end;
          end;
      finally
        temp := Format('Errors=%d, AFNs Updated=%d, References Updated=%d.',
                       [ErrorCount, UpdateCount, RefCount]);
        Message(temp+' See LogFile.txt for details.');
        WriteLn(fOutFile);
        WriteLn(fOutFile);
        WriteLn(temp);
        WriteLn(fOutFile);
        WriteLn(fOutFile, 'CHANGED AFNS:');
        for i := 0 to ChangedAFNList.Count - 1 do
          WriteLn(fOutFile, ChangedAFNList[i]:NrDigits, ' --> ', pchar(ChangedAFNList.Objects[i]):NrDigits);
        CloseFile(fOutFile);
        temp := Format('Notepad.exe %s', [fLogPathFileName]);
        FileExecute(temp, false);

        TempFamilyTable.Close;
        FreeAndNil(fTempFamilyTable);
        FreeAndNil(FamilyTableLookup);
        for i := 0 to ChangedAFNList.Count-1 do
          begin
            p := Pchar(ChangedAFNList.Objects[i]);
            StrDispose(p);
          end;
        FreeAndNil(ChangedAFNList);
        Screen.Cursor := Saved_Cursor;
      end;
    end;
end;  { TfrmIndividual.EnlargeAFNs1Click }

procedure TfrmIndividual.CalendarArithmetic1Click(Sender: TObject);
begin
  frmCalendarArithmetic.Show;
end;

procedure TfrmIndividual.CalendarArithmetic2Click(Sender: TObject);
begin
  frmCalendarArithmetic.meDate.Text := FamilyTable.fldBirthDate.AsString;
  frmCalendarArithmetic.Show;
end;

procedure TfrmIndividual.DeathDateCalendarArithmetic1Click(
  Sender: TObject);
begin
  frmCalendarArithmetic.meDate.Text := FamilyTable.fldDeathDate.AsString;
  frmCalendarArithmetic.Show;
end;

procedure TfrmIndividual.EditPhoto1Click(Sender: TObject);
var
  Temp: string;
  FileName: string;
begin
  if not Empty(gPrivateSettings.PhotoEditorPathName) then
    begin
      FileName := gPhotoPath + FamilyTable.fldImage.AsString;
      temp     := Format('"%s" "%s"', [gPrivateSettings.PhotoEditorPathName, FileName]);
      if not FileExecute(temp, false) then
        AlertFmt('Unable to execute %s' + CRLF, [temp]);
    end
  else
    Message('Path to Photo Editor has not been set in options')
end;

procedure TfrmIndividual.btnEditPhotoClick(Sender: TObject);
var
  Temp: string;
begin
  with FamilyTable do
    begin
      Temp := gPhotoPath + fldImage.AsString;
      if ExecAndWait(temp, '') then
        ShowPerson(fldAFN.AsString)
      else
        AlertFmt('Could not edit "%s"', [temp]);
    end;
end;

initialization
finalization
end.
