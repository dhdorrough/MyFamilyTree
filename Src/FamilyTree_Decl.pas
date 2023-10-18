unit FamilyTree_Decl;

// 10/06/2010 dhd 1.00 fixed it up to be able to send to Sandy Bowes

interface

uses
  DB;

const
  Version      = '1.01';
  Version_Date = '11/15/2017';
  Copyright    = 'Copyright (c) %s - R && D Systems';
  Contact      = 'Dan Dorrough';
  CRLF         = #13#10;
  UNKNOWN      = 'unknown';
  UNKNOWNP     = '(unknown)';

type
  TPersonInfo = record
    AFN        : string;
    Prefix     : string;
    FirstName  : string;
    MiddleName : string;
    LastName   : string;
    NickName   : string;
    DocFile    : string;
    DocDescription: string;
    Suffix     : string;
    BirthDate  : string;
    BirthOrder : string;
    DeathDate  : string;
    CanonBirth : string;
    CanonDeath : string;
    Spouse_AFN : string;
    Father_AFN : string;
    Mother_AFN : string;
    Image      : string;
    BirthPlace : string;
    DeathPlace : string;
    Sex        : string;
    DateAdded  : TDateTime;
    DateUpdated: TDateTime;
    DateAddedLow   : TDateTime;
    DateUpdatedLow : TDateTime;
    DateAddedHigh  : TDateTime;
    DateUpdatedHigh: TDateTime;
    Comments   : string;
    DataSet    : TDataSet;  // this really doesn't belong here !
    Expr       : string;
    SourceID1  : integer;
    SourceID2  : integer;
    Ref        : string;
  end;

  PFamilyInfo = ^TPersonInfo;

  TPhraseKind = (dkUnknown, dkBorn, dkWasBorn, dkHeWasBorn, dkSheWasBorn, dkDied, dkPlace, dkHeMarried, dkSheMarried, dkPersonNameMarried,
                 dkAtTheAgeOf, dkDiedInChildHood, dkDiedInInfancy, dkTheyDivorced, dkIsDeceased, dkHeIsTheSonOf,
                 dkSheIsTheDaughterOf, dkHeWasTheSonOf, dkSheWasTheDaughterOf);

  TPhraseKindSet = set of TPhraseKind;

  TPhraseInfo = record
                  Key: string;
                  NrWords: integer;
                end;

var
  PhraseInfoArray: Array[TPhraseKind] of TPhraseInfo = (
                ({dkUnknown}         Key: '(unknown)';     NrWords: 0),
                ({dkBorn}            Key: 'born';          NrWords: 1),
                ({dkWasBorn}         Key: 'was born';      NrWords: 2),
                ({dkHeWasBorn}       Key: 'he was born';   NrWords: 3),
                ({dkSheWasBorn}      Key: 'she was born';  NrWords: 3),
                ({dkDied}            Key: 'died';          NrWords: 1),
                ({dkPlace}           Key: 'in';            NrWords: 1),
                ({dkHeMarried}       Key: 'he married';    NrWords: 2),
                ({dkSheMarried}      Key: 'she married';   NrWords: 2),
                ({dkPersonNameMarried} Key: '%s married';  NrWords: 2),
                ({dkAtTheAgeOf}      Key: 'at the age of'; NrWords: 4),
                ({dkDiedInChildHood} Key: 'died in childhood'; NrWords: 3),
                ({dkDiedInInfancy}   Key: 'died in infancy';   NrWords: 3),
                ({dkTheyDivorced}    Key: 'they divorced'; NrWords: 2),
                ({dkIsDeceased}      Key: 'is deceased';   NrWords: 2),
                ({dkHeIsTheSonOf}    Key: 'he is the son of'; NrWords: 5),
                ({dkSheIsTheDaughterOf} Key: 'she is the daughter of'; NrWords: 5),
                ({dkHeWasTheSonOf}         Key: 'he was the son of'; NrWords: 5),
                ({dkSheWasTheDaughterOf}   Key: 'she was the daughter of'; NrWords: 5)
//              ({dkBornIn}          Key: 'born in';       NrWords: 2),
//              ({dkDiedIn}          Key: 'died in';       NrWords: 2)
                );

function Opposite(const Sex: string): string;
function OppositeSexPronoun(const Sex: string): string;
function SexPronoun(const Sex: string): string;
function GenderRelation(const Sex: string): string;



implementation

function GenderRelation(const Sex: string): string;
begin
  result := 'child';
  if Length(Sex) >= 1 then
    if Sex[1] in ['M', 'm'] then
      result := 'son' else
    if Sex[1] in ['F', 'f'] then
      result := 'daughter'
end;

function Opposite(const Sex: string): string;
begin
  result := '?';
  if Length(Sex) >= 1 then
    if Sex[1] in ['M', 'm'] then
      result := 'F' else
    if Sex[1] in ['F', 'f'] then
      result := 'M'
end;

function OppositeSexPronoun(const Sex: string): string;
begin
  result := 'He/She';
  if Length(Sex) >= 1 then
    if Sex[1] in ['M', 'm'] then
      result := 'She' else
    if Sex[1] in ['F', 'f'] then
      result := 'He'
end;

function SexPronoun(const Sex: string): string;
begin
  result := 'He/She';
  if Length(Sex) >= 1 then
    if Sex[1] in ['M', 'm'] then
      result := 'He' else
    if Sex[1] in ['F', 'f'] then
      result := 'She'
end;

end.
