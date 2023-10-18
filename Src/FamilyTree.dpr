program FamilyTree;

uses
//ExceptionLog,
  Forms,
  uIndividual in 'uIndividual.pas' {frmIndividual},
  uLookupIndividual in 'uLookupIndividual.pas' {frmLookupIndividual},
  PersonalEvents in 'PersonalEvents.pas' {frmPersonalEvents},
  FamilyTreePrivateSettings in 'FamilyTreePrivateSettings.pas',
  SetFilter in 'SetFilter.pas' {frmSetFilter},
  FamilyTreePrivateSettingsDialog in 'FamilyTreePrivateSettingsDialog.pas' {frmGetPrivateSettingsFromUser},
  About in 'About.pas' {AboutBox},
  FamilyTree_Decl in 'FamilyTree_Decl.pas',
  dEXIF in '..\dEXIF\dEXIF.pas',
  dIPTC in '..\dEXIF\dIPTC.pas',
  AdvancedSearch in 'AdvancedSearch.pas' {frmAdvancedSearch},
  ShortCuts in 'ShortCuts.pas' {frmShortcuts},
  AddInfoFromDescendantsOfAbnerBDorrough in 'AddInfoFromDescendantsOfAbnerBDorrough.pas' {frmAddInfoFromDescendantsOfAbnerBDorrough},
  ChangeAFNs in 'ChangeAFNs.pas' {frmChangeAFNs},
  FamilyTree_Utils in 'FamilyTree_Utils.pas',
  HTML_Stuff in 'HTML_Stuff.pas',
  CalendarArithmetic in 'CalendarArithmetic.pas' {frmCalendarArithmetic},
  PDB_Decl in '..\..\Photo DB\Src\PDB_Decl.pas',
  MyUtils in '..\..\MyUtils\MyUtils.pas',
  FamilyTables in '..\..\MyUtils\FamilyTables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmIndividual, frmIndividual);
  Application.CreateForm(TfrmShortcuts, frmShortcuts);
  Application.CreateForm(TfrmCalendarArithmetic, frmCalendarArithmetic);
  Application.Run;
end.
