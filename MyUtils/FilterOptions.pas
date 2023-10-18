unit FilterOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, DBCtrls, Mask, ExtCtrls, ParseExpr, Expression;

type
  TfrmFilterOptions = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    leHighDate: TLabeledEdit;
    leLowDate: TLabeledEdit;
    leFilter: TLabeledEdit;
    btnExpression: TButton;
    btnClearAll: TButton;
    procedure btnClearAllClick(Sender: TObject);
    procedure btnExpressionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fFilterExpression: string;
    fForm_Expression: TfrmExpression;
    fDBFilePathName: string;
    fFilterName: string;
    function GetFilterExpression: string;
    procedure SetFilterExpression(const Value: string);
  protected
    fDataSet: TDataSet;
    procedure ClearFilterOptions; virtual;
    procedure Enable_Buttons; virtual;
  public
    { Public declarations }
    Constructor Create(aOwner: TComponent; DataSet: TDataSet); reintroduce; virtual;
    Destructor Destroy; override;
    function AnyFilters: boolean; virtual;
    property DataSet: TDataSet
             read fDataSet;
    property FilterExpression: string
             read GetFilterExpression
             write SetFilterExpression;
    property FilterName: string
             read fFilterName
             write fFilterName;
  end;

implementation

{$R *.dfm}

uses
  MyUtils, MyTables;

{ TfrmHikingLog }

function TfrmFilterOptions.AnyFilters: boolean;
begin
  result := (leFilter.Text <> '') or (fFilterExpression <> '');
end;

procedure TfrmFilterOptions.btnClearAllClick(Sender: TObject);
begin
  FilterExpression := '';
  ClearFilterOptions;
end;

procedure TfrmFilterOptions.btnExpressionClick(Sender: TObject);
var
  ErrorMsg: string;
begin
  if not Assigned(fForm_Expression) then
    fForm_Expression := TFrmExpression.Create(self, fDBFilePathName, fDataSet, (fDataSet as TMyTable).SelectivityParser);

  fForm_Expression.Expression := fFilterExpression;
  if fForm_Expression.ShowModal = mrOk then
    begin
      fFilterExpression := fForm_Expression.Expression;
      fFilterName       := fForm_Expression.LookupName;
      if not Empty(fFilterExpression) then
        if not (DataSet as TMyTable).SelectivityParser.Valid_Expr(fFilterExpression, fDataSet, ErrorMsg) then
          AlertFmt('Invalid expression: %s [%s]', [fFilterExpression, ErrorMsg])
        else
          btnExpression.Hint := fFilterExpression
      else
        begin
          FreeAndNil(fForm_Expression);
        end;
    end;
  Enable_Buttons;
end;

procedure TfrmFilterOptions.Enable_Buttons;
begin
  if not Empty(FilterExpression) then
    begin
      btnExpression.Font.Style := btnExpression.Font.Style + [fsBold];
      btnExpression.Hint := FilterExpression;
      btnExpression.ShowHint := true;
    end
  else
    begin
      btnExpression.Font.Style := btnExpression.Font.Style - [fsBold];
      btnExpression.ShowHint := false;
    end;
end;


procedure TfrmFilterOptions.ClearFilterOptions;
begin
  leFilter.Text := '';
  btnExpression.Hint := '';
end;

constructor TfrmFilterOptions.Create(aOwner: TComponent; DataSet: TDataSet);
begin
  inherited Create(aOwner);
  fDataSet := DataSet;
  if Dataset is TMyTable then
    with DataSet as TMyTable do
      fDBFilePathName := DBFilePathName;
end;

destructor TfrmFilterOptions.Destroy;
begin
  inherited;
end;

function TfrmFilterOptions.GetFilterExpression: string;
begin
  result := fFilterExpression;
end;

procedure TfrmFilterOptions.SetFilterExpression(const Value: string);
begin
  fFilterExpression := Value;
  Enable_Buttons;
end;

procedure TfrmFilterOptions.FormShow(Sender: TObject);
begin
  with Dataset do
    begin
      leLowDate.Visible := Assigned(FindField('DateTime'));
      leHighDate.Visible := Assigned(FindField('DateTime'));
    end;
end;

initialization
finalization
end.
