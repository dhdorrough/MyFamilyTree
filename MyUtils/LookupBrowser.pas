unit LookupBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BrowserUnit, Menus, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids,
  DB, LookupsTableUnit;

type
  TfrmLookupBrowser = class(TfrmDataSetBrowser)
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    fLookupCategory: TLookupCategory;
  protected
    function AllowFiltering: boolean; override;
    function CalcDescriptionString: string; override;
  public
    { Public declarations }
    Constructor Create(aOwner: TComponent; DataSet: TDataSet; DataSetName: string; LookupCategory: TLookupCategory); reintroduce;
    Destructor Destroy; override;
    procedure FilterRecord(Dataset: TDataSet; var Accept: boolean); override;
  end;

implementation  

{$R *.dfm}

{ TfrmLookupBrowser }

function TfrmLookupBrowser.AllowFiltering: boolean;
begin
  result := true;
end;

function TfrmLookupBrowser.CalcDescriptionString: string;
begin
  result := Format('LookupCategory="%s"', [LookupInfoArray[fLookupCategory].Cat]);
end;

constructor TfrmLookupBrowser.Create(aOwner: TComponent; DataSet: TDataSet;
  DataSetName: string; LookupCategory: TLookupCategory);
begin
  fLookupCategory := LookupCategory;
  inherited Create(aOwner, DataSet, DataSetName);
  Caption := Format('Browsing %s', [LookupInfoArray[fLookupCategory].Desc]);
end;

procedure TfrmLookupBrowser.FilterRecord(Dataset: TDataSet;
  var Accept: boolean);
begin
  inherited FilterRecord(DataSet, Accept);
  if Accept then
    begin
      with DataSet as TLookupsTable do
        if fLookupCategory = lc_All then
          Accept := true
        else
          Accept := SameText(fldLookupCategory.AsString, LookupInfoArray[fLookupCategory].Cat);
    end;
end;

procedure TfrmLookupBrowser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  inherited;  // skip the inherited stuff which will mis-position the dataset
  CloseMemos;
end;

procedure TfrmLookupBrowser.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

destructor TfrmLookupBrowser.Destroy;
begin

  inherited;
end;

end.
