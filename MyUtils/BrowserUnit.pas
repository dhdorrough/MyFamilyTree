unit BrowserUnit;                              

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, DB, Menus, {PDBTables,}
  ComCtrls, MyUtils, FilterOptions, ParseExpr;

type
  TfrmDataSetBrowser = class(TForm)
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    btnClose: TButton;
    MainMenu1: TMainMenu;
    Navigate1: TMenuItem;
    ReplaceDialog1: TReplaceDialog;
    FindDialog1: TFindDialog;
    SaveDialog1: TSaveDialog;
    File1: TMenuItem;
    Print1: TMenuItem;
    Exit1: TMenuItem;
    FilterOptions1: TMenuItem;
    ClearFilterOptions1: TMenuItem;
    lblStatus: TLabel;
    Edit1: TMenuItem;
    Find1: TMenuItem;
    FindAgain1: TMenuItem;
    procedure ReplaceStrings1Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure FilterOptions1Click(Sender: TObject);
    procedure ClearFilterOptions1Click(Sender: TObject);
    procedure FindAgain1Click(Sender: TObject);
  private
    { Private declarations }
    fBrowseMemoList: TList;
    fGenericStringFilter: string;
    fExpression: string;
    fLastField: integer;
    fOnDoubleClick: TNotifyEvent;
    function GetBrowseMemoList: TList;
    procedure SetExpression(const Value: string);
  protected
    fDataSource: TDataSource;
    fDataSet: TDataSet;
    ffrmFilterOptions: TfrmFilterOptions;
    fSavedFilter: TFilterRecordEvent;
    fWasFiltering: boolean;
    procedure AddClause(var result: string; Caption: string; Value: string = '');
    function AllowFiltering: boolean; virtual;
    function CalcDescriptionString: string; virtual;
    function frmFilterOptions: TfrmFilterOptions; virtual;
    procedure ClearFilterOptions; virtual;
    procedure SaveFilterParams; virtual;
    procedure CloseMemos;
//   procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ResetFilter;
  public
    { Public declarations }
    property BrowseMemoList: TList
             read GetBrowseMemoList;
    Constructor Create(aOwner: TComponent; DataSet: TDataSet; DataSetName: string = ''); reintroduce; virtual;
    Destructor Destroy; override;

    property Expression: string
             read fExpression
             write SetExpression;
    procedure FilterRecord(Dataset: TDataSet; var Accept: boolean); virtual;
    property OnDoubleClick: TNotifyEvent
             read fOnDoubleClick
             write fOnDoubleClick;
    property DataSet: TDataset
             read fDataSet
             write fDataSet;
  end;

implementation

{$R *.DFM}

uses StStrL, PDB_Decl, PDBUtils, uBrowseMemo, ColumnSelector,
  MyTables;

{ TfrmBrowseFilePaths }

constructor TfrmDataSetBrowser.Create(aOwner: TComponent; DataSet: TDataSet; DataSetName: string = '');
begin
  inherited Create(aOwner);
  if not Empty(DataSetName) then
    Caption                 := DataSetName
  else
    if DataSet is TMyTable then
      with DataSet as TMyTable do
        Caption := TableName;
  fDataset                := DataSet;
  fDataSource             := TDataSource.Create(self);
  fDataSource.DataSet     := fDataset;
  DBGrid1.DataSource      := fDataSource;
  DBNavigator1.DataSource := fDataSource;
  lblStatus.Caption       := '';
  lblStatus.Color         := clBtnFace;
end;

procedure TfrmDataSetBrowser.ReplaceStrings1Click(Sender: TObject);
begin
  with ReplaceDialog1 do
    begin
      if Execute then
        begin
          Assert(false, 'Replace strings not implemented');
        end;
    end;
end;

procedure TfrmDataSetBrowser.CloseMemos;
var
  i: integer;
begin
  if Assigned(fBrowseMemoList) then
    begin
      for i := BrowseMemoList.Count-1 downto 0 do
        TForm(BrowseMemoList[i]).Free;
      FreeAndNil(fBrowseMemoList);
    end;
end;

destructor TfrmDataSetBrowser.Destroy;
begin                                      
  CloseMemos;
  FreeAndNil(ffrmFilterOptions);
  FreeAndNil(fDataSource);
  inherited;
end;

procedure TfrmDataSetBrowser.btnCloseClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOK;
end;

procedure TfrmDataSetBrowser.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDataSetBrowser.Find1Click(Sender: TObject);
begin
  FindDialog1.Execute;
end;

procedure TfrmDataSetBrowser.FindDialog1Find(Sender: TObject);
var
  modeR, modeF: TSearch_Type; // (SEARCHING, SEARCH_FOUND, NOT_FOUND);
  fn, i: integer;
  BookMark, TempBookMark: TBookMark;
  ReachedStart: boolean;
  Saved_Cursor: TCursor;
  FindTextUC: string;
  FieldsShowing: set of 0..255;
begin
  // Make a list of the fields that are showing in the browser
  FieldsShowing := [];
  for i := 0 to DBGrid1.FieldCount-1 do
    if Assigned(DBGrid1.Fields[i]) then
      begin
        fn := DBGrid1.Fields[i].Index;
        FieldsShowing := FieldsShowing + [fn];
      end;

  fn := fLastField + 1;
  ReachedStart := false;
  fDataSet.DisableControls;
  BookMark := fDataSet.GetBookmark;
  Saved_Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  FindTextUC := UpperCase(FindDialog1.FindText);
  try
    modeR := SEARCHING;
    repeat
      if not ReachedStart then
        begin
          if (frDown in FindDialog1.Options) and fDataSet.Eof then
            begin
              if Yes('Reached the bottom of the file. Restart from the top?') then
                begin
                  fDataSet.First;
                  ReachedStart := true;
                end
              else
                modeR := NOT_FOUND;
            end else
          if (not (frDown in FindDialog1.Options)) and fDataSet.bof then
            begin
              if Yes('Reached the top of the file. Restart from the bottom?') then
                begin
                  fDataSet.Last;
                  ReachedStart := true;
                end
              else
                modeR := NOT_FOUND;
            end
        end
      else  // have already reached the starting record
        begin
          TempBookMark := fDataSet.GetBookmark;
          try
            if fDataSet.CompareBookmarks(TempBookMark, BookMark) = 0 then  // we're back to where we started from
              modeR := NOT_FOUND else
            if (frDown in FindDialog1.Options) and fDataSet.Eof then
              modeR := NOT_FOUND else
            if (not (frDown in FindDialog1.Options)) and fDataSet.bof then
              modeR := NOT_FOUND;
          finally
            fDataSet.FreeBookmark(TempBookMark);
          end;
        end;

      if modeR <> NOT_FOUND then
        begin
          modeF := SEARCHING;
          repeat
            if fn >= fDataSet.FieldCount then
              modeF := NOT_FOUND
            else
              if fn in FieldsShowing then
                begin
                  if frWholeWord in FindDialog1.Options then
                    if frMatchCase in FindDialog1.Options then
                      begin
                        if fDataSet.Fields[fn].AsString = FindDialog1.FindText then
                          modeF := SEARCH_FOUND
                        else
                          inc(fn);
                      end
                    else
                      begin
                        if SameText(fDataSet.Fields[fn].AsString, FindDialog1.FindText) then
                          modeF := SEARCH_FOUND
                        else
                          inc(fn);
                      end
                  else
                    begin
                      if frMatchCase in FindDialog1.Options then
                        begin
                          if Pos(FindDialog1.FindText, fDataSet.Fields[fn].AsString) > 0 then
                            modeF := SEARCH_FOUND
                          else
                            inc(fn);
                        end
                      else
                        begin
                          if Pos(FindTextUC, UpperCase(fDataSet.Fields[fn].AsString)) > 0 then
                            modeF := SEARCH_FOUND
                          else
                            inc(fn);
                        end
                    end;
                end
              else
                begin
                  inc(fn);
                  if fn >= fDataSet.Fields.Count then
                    modeF := NOT_FOUND;
                end;
          until modeF <> SEARCHING;
          if modeF = SEARCH_FOUND then
            modeR := SEARCH_FOUND
          else
            begin
              fn := 0;
              if frDown in FindDialog1.Options then
                fDataSet.Next
              else
                fDataSet.Prior;
            end;
        end;
    until modeR <> SEARCHING;
    if modeR <> SEARCH_FOUND then
      begin
        Alert('Not found');
        fDataSet.GotoBookmark(BookMark);
      end
    else
      begin
        fLastField := fn;
        DBGrid1.SelectedField := fDataSet.Fields[fn];
      end;
  finally
    Screen.Cursor := Saved_Cursor;
    fDataSet.EnableControls;
    fDataSet.FreeBookmark(BookMark);
  end;
end;

procedure TfrmDataSetBrowser.FilterRecord(Dataset: TDataSet;
  var Accept: boolean);

  function CheckAll: boolean;
  var
    i: integer;
  begin { CheckAll }
    result := false;
    with DataSet do
      for i := 0 to Fields.Count - 1 do
        if Pos(fGenericStringFilter, UpperCase(Fields[i].AsString)) > 0 then
          begin
            result := true;
            break;
          end;
  end; { CheckAll }

begin { TfrmDataSetBrowser.FilterRecord }
  Accept := true;
  if not Empty(fGenericStringFilter) then
    Accept := CheckAll;
  if DataSet is TMyTable then
    with DataSet as TMyTable do
      begin
        if Accept and (not Empty(Expression)) then
          begin
            SelectivityParser.Eval_Tree.Evaluate(DataSet, false);
            Accept := SelectivityParser.Eval_Tree.AsBoolean;
          end;
      end else
  if DataSet is TMyQuery then
    with DataSet as TMyQuery do
      begin
        if Accept and (not Empty(Expression)) then
          begin
            Parser.Eval_Tree.Evaluate(DataSet, false);
            Accept := Parser.Eval_Tree.AsBoolean;
          end;
      end;
end;  { TfrmDataSetBrowser.FilterRecord }

procedure TfrmDataSetBrowser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{$IfDef debugging}
  fDataSet.Filtered       := false;          // 10/25/2017- removed because the Expressions Browser
  if Assigned(fSavedFilter) then             // (which uses the Lookups table) was crashing. This removal could cause
    fDataset.OnFilterRecord := fSavedFilter  //          problems with nested filtering ?
  else
    fDataSet.OnFilterRecord := nil;

  fDataSet.Filtered       := fWasFiltering;
  CloseMemos;
{$EndIf}
end;

procedure TfrmDataSetBrowser.FormShow(Sender: TObject);
begin
{$IfDef debugging}
  if Assigned(fDataset.OnFilterRecord) then    // 10/25/2017- removed because the Expressions Browser
    fSavedFilter  := fDataset.OnFilterRecord;  // (which uses the Lookups table) was crashing. This removal could cause
  fWasFiltering := fDataSet.Filtered;          //          problems with nested filtering ?
  fDataset.OnFilterRecord := FilterRecord;
{$EndIf}
end;

function TfrmDataSetBrowser.AllowFiltering: boolean;
begin
  result := (not Empty(fGenericStringFilter)) or (not Empty(fExpression));
end;

procedure TfrmDataSetBrowser.DBGrid1DblClick(Sender: TObject);
var
  aBrowseMemo: TForm;
begin
  if Assigned(self.fOnDoubleClick) then
    fOnDoubleClick(self)
  else
    begin
      aBrowseMemo := TfrmBrowseMemo.Create(self, fDataSource, DBGrid1.SelectedField, bhAsText);
      BrowseMemoList.Add(aBrowseMemo);
      aBrowseMemo.Show;
    end;
end;

function TfrmDataSetBrowser.GetBrowseMemoList: TList;
begin
  if not Assigned(fBrowseMemoList) then
    fBrowseMemoList := TList.Create;
  result := fBrowseMemoList;
end;

procedure TfrmDataSetBrowser.Print1Click(Sender: TObject);
var
  i: integer;
  frmColumnSelector: TfrmColumnSelector;
  SelectedItems: TStringList;

  procedure PrintReport(DataSet: TDataSet; SelectedItems: TStringList);
  var
    OutFile: TextFile;
    i: integer;
    Field: TField;
    Value: string;
    Width: integer;
    MaxWidths: array of integer;
    temp: string;
    GOODCHARS: TSetOfChar;

    procedure GetFieldValueWidth(Field: TField; var Value: string; var Width: integer; PadIt: boolean);
    begin { GetFieldValueWidth }
      if Field.DataType in [ftString, ftWideString] then
        Value := Field.AsString else
      if Field.DataType in [ftDate, ftDateTime] then
        begin
          if Field.AsDateTime <> 0 then
            Value := YYYYMMDD(Field.AsDateTime)
          else
            Value := '';
        end else
      if Field.DataType in [ftSmallint, ftInteger, ftWord] then
        Value := Format('%0d', [Field.AsInteger]) else
      if Field.DataType in [ftFloat, ftCurrency] then
        Value := Format('%0.4f', [Field.AsFloat]) else
      if Field.DataType = ftMemo then
        Value := CleanUpString(Field.AsString, GOODCHARS, ' ')
      else
        Value := Field.AsString;

      if PadIt and (Field.DataType in [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency]) then
        Value := LeftPadL(Value, MaxWidths[i]);

      Width := Length(Value);
    end;  { GetFieldValueWidth }

    procedure WriteField(i: integer; const Value: string);
    var
      NrBlanks: integer;
    begin { WriteField }
      NrBlanks := MaxWidths[i]-Length(Value);
      if NrBlanks > 0 then
        Write(OutFile, Value, ' ':NrBlanks, ' ')
      else                         // width = 0 not handled properly
        Write(OutFile, Value, ' ');
    end;  { WriteField }

  begin { PrintReport }
    GoodChars := ALPHA_UPPER + ALPHA_LOWER + DIGITS + ['.'];
    SaveDialog1.FileName := TempPath + 'Report.txt';
    if SaveDialog1.Execute then
      begin
        AssignFile(OutFile, SaveDialog1.FileName);
        ReWrite(OutFile);
        try
          // Calculate maximum field widths
          SetLength(MaxWidths, SelectedItems.Count);
          for i := 0 to SelectedItems.Count-1 do
            begin
              Field := TField(SelectedItems.Objects[i]);
              MaxWidths[i] := Length(Field.FieldName);  // default the width to the length of the field name
            end;

          with DataSet do
            begin
              First;
              while not eof do
                begin
                  for i := 0 to SelectedItems.Count-1 do
                    begin
                      Field := TField(SelectedItems.Objects[i]);
                      GetFieldValueWidth(Field, Value, Width, false);
                      if Width > MaxWidths[i] then
                        MaxWidths[i] := width;
                    end;
                  Next;
                end;

              // write the header line
              for i := 0 to SelectedItems.Count-1 do
                begin
                  Field := TField(SelectedItems.Objects[i]);
                  Value := UpperCase(Field.FieldName);
                  WriteField(i, Value);
                end;
              WriteLn(OutFile);

              // write the seperator line
              for i := 0 to SelectedItems.Count-1 do
                begin
                  Value := PadR('', MaxWidths[i], '-');
                  WriteField(i, Value);
                end;
              WriteLn(OutFile);

              // now actually write the data
              First;
              While not Eof do
                begin
                  for i := 0 to SelectedItems.Count-1 do
                    begin
                      Field := TField(SelectedItems.Objects[i]);
                      GetFieldValueWidth(Field, Value, Width, true);
                      WriteField(i, Value);
                    end;
                  WriteLn(OutFile);
                  Next;
                end;
            end;
        finally
          CloseFile(OutFile);
        end;
      end;
    temp := Format('Notepad.exe "%s"', [SaveDialog1.FileName]);
    FileExecute(temp, false);
  end;  { PrintReport }

begin
  frmColumnSelector := TfrmColumnSelector.Create(self);
  try
    DataSet.DisableControls;
    with DBGrid1 do
      begin
        for i := 0 to Columns.Count-1 do
          begin
            frmColumnSelector.ListBox1.Items.AddObject(Columns[i].FieldName, nil);
            frmColumnSelector.ListBox1.Selected[i] := Columns[i].Field.DataType in [ftString, ftWideString, ftSmallint, ftInteger, ftWord,
              ftBoolean, ftFloat, ftCurrency, ftDate, ftTime, ftDateTime];
          end;
        if frmColumnSelector.ShowModal = mrOk then
          begin
            // create a list of the selected items
            SelectedItems := TStringList.Create;
            for i := 0 to Columns.Count - 1 do
              begin
                if frmColumnSelector.ListBox1.Selected[i] then
                  SelectedItems.AddObject(frmColumnSelector.ListBox1.Items[i], Columns[i].Field);
              end;
            PrintReport(DataSet, SelectedItems);
          end;
      end;
  finally
    DataSet.EnableControls;
    FreeAndNil(SelectedItems);
    FreeAndNil(frmColumnSelector);
  end;
end;

procedure TfrmDataSetBrowser.ResetFilter;
var
  SavedCursor: TCursor;
begin
  fDataSet.Filtered       := false;
  fDataSet.OnFilterRecord := nil;
  SaveFilterParams;
  SavedCursor := Screen.Cursor;
  try
    Screen.Cursor := crSQLWait;
    Application.ProcessMessages;
    fDataSet.OnFilterRecord := FilterRecord;
    fDataSet.Filtered       := fWasFiltering or AllowFiltering;
  finally
    Screen.Cursor := SavedCursor;
  end;
end;


procedure TfrmDataSetBrowser.FilterOptions1Click(Sender: TObject);
begin
  if frmFilterOptions.ShowModal = mrOk then
    ResetFilter;
end;

procedure TfrmDataSetBrowser.SaveFilterParams;
var
  ErrorMsg: string;
begin
  fGenericStringFilter := UpperCase(frmFilterOptions.leFilter.Text);
  fExpression          := frmFilterOptions.FilterExpression;
  if DataSet is TMyTable then
    with DataSet as TMyTable do
      begin
        if not Empty(fExpression) then
          if (not SelectivityParser.Valid_Expr(fExpression, DataSet, ErrorMsg)) then
            raise Exception.CreateFmt('Invalid expression for this DataSet: %s', [fExpression]);
      end else
  if DataSet is TMyQuery then
    with DataSet as TMyQuery do
      begin
        if not Empty(fExpression) then
          if (not Parser.Valid_Expr(fExpression, DataSet, ErrorMsg)) then
            raise Exception.CreateFmt('Invalid expression for this DataSet: %s', [fExpression]);
      end;
  DataSet.OnFilterRecord := FilterRecord;
  lblStatus.Caption := CalcDescriptionString;
  if not Empty(lblStatus.Caption) then
    lblStatus.Color := clYellow;
end;


function TfrmDataSetBrowser.frmFilterOptions: TfrmFilterOptions;
begin
  if not Assigned(ffrmFilterOptions) then
    ffrmFilterOptions := TfrmFilterOptions.Create(self, DataSet);
  result := ffrmFilterOptions;
end;

procedure TfrmDataSetBrowser.ClearFilterOptions1Click(Sender: TObject);
begin
  ClearFilterOptions;
end;

procedure TfrmDataSetBrowser.ClearFilterOptions;
begin
  fGenericStringFilter := '';
  fExpression          := '';
  DataSet.Filtered     := false;
  DataSet.Filtered     := AllowFiltering;  // should this always evaluate to false
  lblStatus.Caption    := '';
  lblStatus.Color      := clBtnFace;
end;

(*
function TfrmDataSetBrowser.GetParser: TParser;
begin
  if not Assigned(fParser) then
    fParser := TParser.Create;
  result := fParser;
end;
*)

function TfrmDataSetBrowser.CalcDescriptionString: string;
begin
  result := '';
  if not Empty(fGenericStringFilter) then
    AddClause(result, 'Filter', fGenericStringFilter);
  if not Empty(fExpression) then
    AddClause(result, 'Expression', fExpression);
end;

procedure TfrmDataSetBrowser.AddClause(var result: string; Caption: string; Value: string = '');
var
  Phrase: string;
begin { AddClause }
  Phrase := Format('%s="%s"', [Caption, Value]);
  if result = '' then
    result := Phrase
  else
    result := result + ', ' + Phrase;
end;  { AddClause }

procedure TfrmDataSetBrowser.SetExpression(const Value: string);
begin
  fExpression := Value;            
end;

procedure TfrmDataSetBrowser.FindAgain1Click(Sender: TObject);
begin
  FindDialog1Find(nil);
end;

end.

