unit FamilyTreePrivateSettingsDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmGetPrivateSettingsFromUser = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    Label1: TLabel;
    leDatabaseName: TLabeledEdit;
    leDataFolder: TLabeledEdit;
    btnBrowseForDataFolder: TButton;
    OpenDialog1: TOpenDialog;
    leNextAFN: TLabeledEdit;
    leLastAFN: TLabeledEdit;
    leLastOrderFields: TLabeledEdit;
    leFakeDABDNr: TLabeledEdit;
    leHTMLOutputFolder: TLabeledEdit;
    btnBrowseHTMLOutputFolder: TButton;
    lblStatus: TLabel;
    lePhotoEditorPathName: TLabeledEdit;
    btnBrowseForEditor: TButton;
    btnBrowseForACCDB: TButton;
    procedure btnBrowseForACCDBClick(Sender: TObject);
    procedure btnBrowseForDataFolderClick(Sender: TObject);
    procedure btnBrowseHTMLOutputFolderClick(Sender: TObject);
    procedure leDatabaseNameChange(Sender: TObject);
    procedure leDataFolderChange(Sender: TObject);
    procedure leHTMLOutputFolderChange(Sender: TObject);
    procedure btnBrowseForEditorClick(Sender: TObject);
  private
    procedure Enable_Buttons;
    { Private declarations }
  public
    { Public declarations }
    Constructor Create(aOwner: TComponent); override;
  end;

var
  frmGetPrivateSettingsFromUser: TfrmGetPrivateSettingsFromUser;

implementation

{$R *.dfm}

uses
  MyUtils, HTML_Stuff;

procedure TfrmGetPrivateSettingsFromUser.btnBrowseForACCDBClick(
  Sender: TObject);
var
  FileName: string;
begin
  FileName := leDatabaseName.Text;
  if BrowseForFile('Locate FamilyTree.ACCDB', FileName, 'ACCDB') then
    leDatabaseName.Text := FileName;
end;

procedure TfrmGetPrivateSettingsFromUser.btnBrowseForDataFolderClick(
  Sender: TObject);
var
  Path: string;
begin
  Path := leDataFolder.Text;
  if BrowseForFolder('Browse for folder containing "Images\" and "Docs\"',
                     Path) then
    begin
      leDataFolder.Text := Path;
    end;
end;

procedure TfrmGetPrivateSettingsFromUser.btnBrowseHTMLOutputFolderClick(
  Sender: TObject);
var
  Path: string;
begin
  Path := leHTMLOutputFolder.Text;
  if BrowseForFolder(Format('Browse for folder containing "%s\"', [FAMILYTREEFOLDER]),
                     Path) then
    begin
      leHTMLOutputFolder.Text := Path;
    end;
end;

procedure TfrmGetPrivateSettingsFromUser.leDatabaseNameChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmGetPrivateSettingsFromUser.leDataFolderChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmGetPrivateSettingsFromUser.leHTMLOutputFolderChange(
  Sender: TObject);
begin
  Enable_Buttons;
end;

procedure TfrmGetPrivateSettingsFromUser.Enable_Buttons;
begin
  btnOk.Enabled := not (Empty(leDatabaseName.Text) or Empty(leDataFolder.Text) or Empty(leHTMLOutputFolder.Text));
  if not btnOk.Enabled then
    begin
      lblStatus.Caption := 'Field may not be blank';
      lblStatus.Visible := true;
    end
  else
    begin
      lblStatus.Caption := '';
      lblStatus.Visible := false;
    end;
end;


constructor TfrmGetPrivateSettingsFromUser.Create(aOwner: TComponent);
begin
  inherited;
  Enable_Buttons;
end;

procedure TfrmGetPrivateSettingsFromUser.btnBrowseForEditorClick(Sender: TObject);
var
  FileName: string;
begin
  FileName := lePhotoEditorPathName.Text;
  if BrowseForFile('Locate Photo Editor', FileName, 'exe') then
    lePhotoEditorPathName.Text := FileName;
end;

end.
