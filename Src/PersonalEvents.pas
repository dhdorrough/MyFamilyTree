unit PersonalEvents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids;

type
  TfrmPersonalEvents = class(TForm)
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    btnClose: TButton;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    btnCancel: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    fAFN: string;
    fMiddleName: string;
    fFirstName: string;
    fLastName: string;
    fNickName: string;
    fPrefix: string;
    procedure SetAFN(const Value: string);
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetMiddleName(const Value: string);
    procedure DoAfterInsert(DataSet: TDataSet);
    procedure SetPrefix(const Value: string);
    procedure SetNickName(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    Constructor Create(aOwner: TComponent); override;
    property AFN: string
             read fAFN
             write SetAFN;
    property FirstName: string
             read fFirstName
             write SetFirstName;
    property MiddleName: string
             read fMiddleName
             write SetMiddleName;
    property LastName: string
             read fLastName
             write SetLastName;
    property NickName: string
             read fNickName
             write SetNickName;
    property Prefix: string
             read fPrefix
             write SetPrefix;
  end;

var
  frmPersonalEvents: TfrmPersonalEvents;

implementation

uses uIndividual, MyUtils, FamilyTreePrivateSettings;

{$R *.dfm}

procedure TfrmPersonalEvents.btnCloseClick(Sender: TObject);
begin
  if ADOQuery1.State in [dsEdit, dsInsert] then
    ADOQuery1.Post;
  Close;
end;

constructor TfrmPersonalEvents.Create(aOwner: TComponent);
begin
  inherited;
  ADOQuery1.ConnectionString := Format(c_CnStr, [gPrivateSettings.FamilyTreeDataBaseFileName]);
  ADOQuery1.AfterInsert := DoAfterInsert;
end;

procedure TfrmPersonalEvents.DoAfterInsert(DataSet: TDataSet);
begin
  ADOQuery1.FieldByName('AFN').AsString := fAFN;
  ADOQuery1.FieldByName('Person').AsString   := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
  ADOQuery1.FieldByName('KeyWords').AsString := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
end;

procedure TfrmPersonalEvents.SetAFN(const Value: string);
begin
  fAFN := Value;
  ADOQuery1.Active := false;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add(Format('SELECT * FROM FamilyEvents WHERE AFN = "%s"',
                           [Value]));
  ADOQuery1.ExecSQL;
  ADOQuery1.Active := true;
end;

procedure TfrmPersonalEvents.SetFirstName(const Value: string);
begin
  fFirstName := Value;
  Caption := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
end;

procedure TfrmPersonalEvents.SetLastName(const Value: string);
begin
  fLastName := Value;
  Caption := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
end;

procedure TfrmPersonalEvents.SetMiddleName(const Value: string);
begin
  fMiddleName := Value;
  Caption := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
end;

procedure TfrmPersonalEvents.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPersonalEvents.SetPrefix(const Value: string);
begin
  fPrefix := Value;
  Caption := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
end;

procedure TfrmPersonalEvents.SetNickName(const Value: string);
begin
  fNickName := Value;
  Caption := FullName(fPrefix, fFirstName, fMiddleName, fLastName, fNickName);
end;

end.
