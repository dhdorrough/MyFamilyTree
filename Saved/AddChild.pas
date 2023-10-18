unit AddChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls;

type
  TfrmAddChild = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    dbFirstName: TDBEdit;
    dbMiddleName: TDBEdit;
    dbLastName: TDBEdit;
    dbBirthDate: TDBEdit;
    dbDeathDate: TDBEdit;
    dbSex: TDBEdit;
    dbBirthPlace: TDBEdit;
    dbSearch: TDBEdit;
    dbSuffix: TDBEdit;
    dbDeathPlace: TDBEdit;
    DBEdit1: TDBEdit;
    Label19: TLabel;
    dbCanonBirth: TDBEdit;
    lblCanonDeath: TLabel;
    dbCanonDeath: TDBEdit;
    btnCancel: TButton;
    btnOK: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    Constructor Create(AuxFamilyTable: TFamilyTable; AuxFamilyDataSource: TDataSource); reintroduce;
  end;

var
  frmAddChild: TfrmAddChild;

implementation

{$R *.dfm}

end.
