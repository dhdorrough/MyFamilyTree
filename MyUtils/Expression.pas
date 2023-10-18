unit Expression;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ParseExpr, LookupsTableUnit, ExtCtrls;

type
  TExpOption = (eo_NonModal);

  TExpOptions = set of TExpOption;
  
  TfrmExpression = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    cbFunctions: TComboBox;
    Label3: TLabel;
    cbFields: TComboBox;
    Memo1: TMemo;
    lblStatus: TLabel;
    btnLoadExpression: TButton;
    btnSave: TButton;
    btnSaveAs: TButton;
    Label1: TLabel;
    lblLookupName: TLabel;
    btnEvaluate: TButton;
    Panel1: TPanel;
    lblResultType: TLabel;
    lblTemplate: TLabel;
    Memo2: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtResult: TEdit;
    procedure cbFieldsClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure cbFunctionsChange(Sender: TObject);
    procedure btnLoadExpressionClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnEvaluateClick(Sender: TObject);
    procedure cbFunctionsClick(Sender: TObject);
  private
    fDataSet: TDataSet;
    fDBFilePathName: string;
    fLookupsTable: TLookupsTable;
    fHelpTable: TLookupsTable;
    fLookupName: string;
    fList: TStringList;
    fParser: TParser;
    function GetExpression: string;
    procedure SetExpression(const Value: string);
    procedure CallBackFunction(fp: TAvailable_Function);
    procedure Enable_Buttons;
    { Private declarations }
  public
    function LookupsTable: TLookupsTable;
    constructor Create( aOwner: TComponent;
                        aDBFilePathName: string;
                        DataSet: TDataSet;
                        Parser: TParser;
                        FormCaption: string = 'Expression';
                        expOptions: TExpOptions = []); reintroduce;
    property Expression: string
             read GetExpression
             write SetExpression;
    property LookupName: string
             read fLookupName;
  end;

implementation

uses MyUtils, uGetString, BrowserUnit, LookupBrowser, MyTables;

{$R *.dfm}

{ TfrmExpression }

procedure TfrmExpression.CallBackFunction(fp: TAvailable_Function);
begin
  fList.AddObject(fp.fn, fp)
end;


constructor TfrmExpression.Create(aOwner: TComponent;
                        aDBFilePathName: string;
                        DataSet: TDataSet;
                        Parser: TParser;
                        FormCaption: string = 'Expression';
                        expOptions: TExpOptions= []);
var
  i: integer;
begin
  inherited Create(aOwner);

  Caption := FormCaption;
  fDataSet := DataSet;
  fDBFilePathName := aDBFilePathName;
  cbFields.Items.Clear;
  for i := 0 to fDataSet.Fields.Count- 1 do
    cbFields.Items.AddObject(fDataSet.Fields[i].FieldName, TObject(i));
  cbFields.Sorted := true;
  cbFields.ItemIndex := 0;
  lblLookupName.Caption := '';
  fParser  := Parser;
  fList    := TStringList.Create;
  try
    Parser.RootNode.TraverseSubTree(CallBackFunction);
    cbFunctions.Items.Assign(fList);
    cbFunctions.ItemIndex := 0;
    Memo1.Text            := '';
    lblTemplate.Caption   := '';
    lblResultType.Caption := '';
    edtResult.Text        := '';
    Memo2.Text            := '';
    try
      fHelpTable            := THelpTable.Create( self,
                                                     (fDataset as TMyTable).DBFilePathName,
                                                     'Help',
                                                     [],
                                                     lc_Help);
      fHelpTable.Active := true;
    except
      FreeAndNil(fHelpTable);
    end;
    if eo_NonModal in expOptions then
      begin
        btnOk.Visible := false;
        btnCancel.Visible := false;
      end;
  finally
    fList.Free;
  end;
end;

function TfrmExpression.GetExpression: string;
begin
  result := Memo1.Text;
end;

procedure TfrmExpression.SetExpression(const Value: string);
begin
  Memo1.Text := Value;
end;

procedure TfrmExpression.cbFieldsClick(Sender: TObject);
var
  Temp: string;
begin
  with cbFields do
    if ItemIndex >= 0 then
      begin
        Temp := cbFields.Items[ItemIndex];
        if Pos(' ', Temp) > 0 then
          Temp := '[' + Temp + ']';
        Memo1.SelText := Temp;
        Memo1.SetFocus;
      end;
end;

procedure TfrmExpression.Memo1Change(Sender: TObject);
var
  ErrorMsg: string;
begin
  if not Assigned(fParser) then
    raise Exception.Create('System error: fParser is nil');
  if Empty(Memo1.Text) then
    lblStatus.Caption := '' else
  if fParser.Valid_Expr(Memo1.Text, fDataSet, ErrorMsg) then
    lblStatus.Caption := ''
  else
    lblStatus.Caption := ErrorMsg;
  Enable_Buttons;
end;

procedure TfrmExpression.cbFunctionsChange(Sender: TObject);
var
  s1, s2: integer;
begin
  with cbFunctions do
    if ItemIndex >= 0 then
      begin
        Memo1.SelText := fParser.GetFunctionPrototype(TAvailable_Function(Items.Objects[ItemIndex]));
        s1 := Pos('[', Memo1.Text);
        s2 := Pos(']', Memo1.Text);
        Memo1.SelStart := s1-1;
        Memo1.SelLength := s2 - s1 + 1;
        Memo1.SetFocus;
      end;
end;

function TfrmExpression.LookupsTable: TLookupsTable;
begin
  if not Assigned(fLookupsTable) then
    begin
      fLookupsTable := TLookupsTable.Create(self, (fDataset as TMyTable).DBFilePathName, 'Lookups', [], lc_Exp);
      fLookupsTable.Active := true;
    end;
  result := fLookupsTable;
end;

procedure TfrmExpression.btnLoadExpressionClick(Sender: TObject);
var
  mr: integer;
  LookupValueBrowser: TfrmLookupBrowser;
begin
  LookupValueBrowser := TfrmLookupBrowser.Create(self, LookupsTable, 'Lookups', lc_Exp);
  try
    mr := LookupValueBrowser.ShowModal;
    if mr = mrOk then
      begin
        Memo1.Text  := LookupsTable.fldLookupValue.AsString;
        fLookupName := LookupsTable.fldLookupName.AsString;
        lblLookupName.Caption := fLookupName;
        Enable_Buttons;
      end;
  finally
    FreeAndNil(LookupValueBrowser);
  end;
end;

procedure TfrmExpression.Enable_Buttons;
begin
  btnSave.Enabled := not Empty(fLookupName);
end;


procedure TfrmExpression.btnSaveClick(Sender: TObject);
begin
  if LookupsTable.Locate('LookupName', fLookupName, []) then
    begin
      with LookupsTable do
        begin
          Edit;
          fldLookupValue.AsString := Memo1.text;
          Post;
        end;
    end
  else
    AlertFmt('Unable to locate Lookup named "%s"', [fLookupName]);
end;

procedure TfrmExpression.btnSaveAsClick(Sender: TObject);
var
  LookupValueName: string; AlreadyExists, OkToOverWrite: boolean;
begin
  if not Empty(fLookupName) then
    LookupValueName := fLookupName
  else
    LookupValueName := Memo1.Text;
    
  if GetString('Save Expression', 'Expression Name', LookupValueName) then
    with LookupsTable do
      begin
        OkToOverWrite := false;
        LookupValueName := Copy(LookupValueName, 1, LookupsTable.fldLookupName.Size);
        AlreadyExists := Locate('LookupName', LookupValueName, []);
        if AlreadyExists then
          OkToOverWrite := YesFmt('A lookup named "%s" already exists. Do you want to overwrite it?', [LookupValueName]);

        if not AlreadyExists then
          Append else
        if OkToOverWrite then
          Edit
        else
          Exit;;

        fldLookupName.AsString  := LookupValueName;
        fldLookupValue.AsString := Memo1.text;
        Post;
        fLookupName := LookupValueName;
        lblLookupName.Caption := fLookupName;
      end;
end;

procedure TfrmExpression.btnEvaluateClick(Sender: TObject);
var
  ErrorMsg: string;
  temp: string;
begin
  if fParser.Valid_Expr(Memo1.Text, fDataSet, ErrorMsg) then
    begin
      fParser.Eval_Tree.EvaluateTree;
      Temp := fParser.Eval_Tree.AsString;
      edtResult.Text := Temp;
    end
  else
    AlertFmt('%s'#13#10' is not a valid expression [%s]',
             [Memo1.Text, ErrorMsg]);
end;

procedure TfrmExpression.cbFunctionsClick(Sender: TObject);
var
  Func: TAvailable_Function;
begin
  with cbFunctions do
    if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
      begin
        Func := TAvailable_Function(Items.Objects[ItemIndex]);
        if Assigned(Func) then
          begin
            lblTemplate.Caption := fParser.GetFunctionPrototype(Func);
            lblResultType.Caption   := Type_Strings[Func.rt];
            edtResult.Text          := '';
            if Assigned(fHelpTable) then
              if fHelpTable.Locate(cLOOKUPNAME, Func.fn, [loCaseInsensitive]) then
                Memo2.Text := fHelpTable.fldLookupValue.AsString
              else
                Memo2.Text := Format('Help missing for function "%s"', [Func.fn])
            else
              Memo2.Text := 'Unable to open Help table';
          end;
      end;
end;

end.
