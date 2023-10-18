unit FamilyTree_Utils;

interface

uses
  FamilyTree_Decl;

const
  BAD_ROMAN = '??'; // unconvertable roman numeral


function CanonicalDateToGenealogyDate(CanonicalDate: string): string;
function ConvertRomanToDigits(Roman: string): string;
function IsPrefix(var aWord: string): boolean;
function IsSuffix(var aWord: string): boolean;
function OffsetToPhrase(const Text: string; AllowablePhraseKinds: TPhraseKindSet; RequireBlanks: boolean = true): integer;
function ParentsString(const Sex: string; FatherInfo, MotherInfo: TPersonInfo): string;
procedure ParseDateAndPlace(const DateAndPlace: string; var Date, Place: string);
function ParseName(const Value: string; var Prefix, FirstName, MiddleName, LastName, Suffix, NickName: string): boolean;
function UnknownName(const aName: string): boolean;

implementation

uses
  StStrL, MyUtils, SysUtils, PdbUtils;

type
  TSuffixWord = record
                  Variation: string;
                  Normal: string;
                end;

  TSuffixes = (sfxJr, sfxMD, sfxPHD, sfxDDS, sfxRN);
  TPrefixes = (pfxRev, pfxDR, pfxRN, pfxJudge);

  TSuffixArray = array[TSuffixes] of TSuffixWord;
  TPrefixArray = array[TPrefixes] of TSuffixWord;

var
  SuffixArray: TSuffixArray = (
                 (Variation: 'Jr';   Normal: 'Jr.'),
                 (Variation: 'MD';   Normal: 'M.D.'),
                 (Variation: 'PhD';  Normal: 'Ph.D'),
                 (Variation: 'DDS';  Normal: 'DDS'),
                 (Variation: 'RN';   Normal: 'R.N.')
               );

  PrefixArray: TPrefixArray = (
                 (Variation: 'Rev';  Normal: 'Rev.'),
                 (Variation: 'Dr';   Normal: 'Dr.'),
                 (Variation: 'RN';   Normal: 'R.N.'),
                 (Variation: 'Judge';Normal: 'Judge')
               );



function  CanonicalDateToGenealogyDate(CanonicalDate: string): string;
var
  MonthStr, DayStr: string;
  Month: integer;
begin
  CanonicalDate := Trim(CanonicalDate);
  result        := CanonicalDate;
  if (Length(CanonicalDate) >= 4) and IsPureNumeric(CanonicalDate) then
    begin
      result := Copy(CanonicalDate, 1, 4);
      if Length(CanonicalDate) >= 6 then
        begin
          MonthStr := Copy(CanonicalDate, 5, 2);
          Month    := StrToInt(MonthStr);
          if (Month >= 1) and (Month <= 12) then
            begin
              MonthStr := ProperCase(Copy(Months, ((Month-1)*4) + 1, 3));
              result   := MonthStr + ' ' + result;
              if Length(CanonicalDate) >= 8 then
                begin
                  DayStr := Copy(CanonicalDate, 7, 2);
                  result := DayStr + ' ' + Result;
                end;
            end
          else
            AlertFmt('Invalid month in %s', [CanonicalDate]);
        end;
    end;
end;

function ConvertRomanToDigits(Roman: string): string;
begin
  if SameText(Roman, 'I') then
    result := '01' else
  if SameText(Roman, 'II') then
    result := '02' else
  if SameText(Roman, 'III') then
    result := '03' else
  if SameText(Roman, 'IV') then
    result := '04' else
  if SameText(Roman, 'V') then
    result := '05' else
  if SameText(Roman, 'VI') then
    result := '06' else
  if SameText(Roman, 'VII') then
    result := '07' else
  if SameText(Roman, 'VIII') then
    result := '08' else
  if SameText(Roman, 'IX') then
    result := '09' else
  if SameText(Roman, 'X') then
    result := '10' else
  if SameText(Roman, 'XI') then
    result := '11' else
  if SameText(Roman, 'XII') then
    result := '12' else
  if SameText(Roman, 'XIII') then
    result := '13' else
  if SameText(Roman, 'XIV') then
    result := '14' else
  if SameText(Roman, 'XV') then
    result := '15' else
  if SameText(Roman, 'XVI') then
    result := '16' else
  if SameText(Roman, 'XVII') then
    result := '17' else
  if SameText(Roman, 'XVIII') then
    result := '18'
  else
    result := BAD_ROMAN;
end;

function IsSuffix(var aWord: string): boolean;
var
  sfx: TSuffixes;
begin
  aWord := RemoveBadChars(aWord, ['.']);
  for sfx := Low(SuffixArray) to High(SuffixArray) do
    with SuffixArray[sfx] do
      begin
        result := SameText(aWord, Variation);
        if result then
         begin
           aWord := Normal;
           break;
         end;
      end;
  if not result then
    if ConvertRomanToDigits(aWord) <> BAD_ROMAN then // if it can be converted, then return the word in uppercase
      begin
        result := true;  // and say that it IS a suffix
        aWord  := UpperCase(aWord);
      end;
end;

function IsPrefix(var aWord: string): boolean;
var
  pfx: TPrefixes;
begin
  aWord := RemoveBadChars(aWord, ['.']);
  for pfx := Low(PrefixArray) to High(PrefixArray) do
    with PrefixArray[pfx] do
      begin
        result := SameText(aWord, Variation);
        if result then
         begin
           aWord := Normal;
           Exit;
         end;
      end;
end;

function OffsetToPhrase(
           const Text: string;
           AllowablePhraseKinds: TPhraseKindSet;
           RequireBlanks: boolean = true): integer;
var
  N: integer;
  OffSet: integer;
  Buf, P, p0, p1: pchar;
  dk: TPhraseKind;
  FoundMatch: boolean;
begin
  OffSet  := MAXINT;
  p0      := pchar(Text);
  Buf     := p0;
  p1      := nil;  // will point to character after phrase
  for dk := Succ(Low(TPhraseKind)) to High(TPhraseKind) do
   if dk in AllowablePhraseKinds then
    begin
      p := MyStrPos(Buf, pchar(PhraseInfoArray[dk].Key), Length(Text)-1, true);
      if p <> nil then
        begin
          FoundMatch := true;
          if RequireBlanks then
            begin
              if not ((p-1)^ in [' ', '.']) then // we require a preceding blank or period
                FoundMatch := false
              else
                begin
                  p1 := p + Length(PhraseInfoArray[dk].Key);
                  if not (p1^ in [' ', '.']) then  // and a trailing blank (or period)
                    FoundMatch := false;
                end;
            end;

          if FoundMatch then
            begin
              N := P - Buf + 1;     // distance from where we started the search
              if N < OffSet then
                OffSet     := N;  // shortest distance from where we started the search
            end;
        end;
    end;

  if OffSet <> MAXINT then   // found a match
    result     := OffSet
  else
    result := -1;
end;

function ParentsString(const Sex: string; FatherInfo, MotherInfo: TPersonInfo): string;
var
  FathersName, MothersName, FathersBirthDate, MothersBirthDate: string;
begin
  FathersBirthDate := '';
  MothersBirthDate := '';
  with FatherInfo do
    if not Empty(AFN) then
      begin
        FathersName := FullName(Prefix, FirstName, MiddleName, LastName, Suffix, NickName);
        if not Empty(BirthDate) then
          FathersBirthDate := '(born ' + BirthDate + ')';
      end
    else
      FathersName := UNKNOWNP;

  with MotherInfo do
    if not Empty(AFN) then
      begin
        MothersName := FullName(Prefix, FirstName, MiddleName, LastName, Suffix, NickName);
        if not Empty(BirthDate) then
          MothersBirthDate := '(born ' + BirthDate + ')';
      end
    else
      MothersName := UNKNOWNP;

  result := SexPronoun(Sex) + ' was the ' + GenderRelation(Sex) + ' of ' + FathersName + ' and ' + MothersName + '. ';
end;

procedure ParseDateAndPlace(const DateAndPlace: string; var Date, Place: string);
const
  DELIMS = ' .';
var
  wc, i, BreakWord: integer;
  aWord: string;
begin
  wc := WordCountL(DateAndPlace, DELIMS);
  BreakWord := -1;
  for i := 1 to wc do
    begin
      aWord := ExtractWordL(i, DateAndPlace, DELIMS);
      if SameText(aWord, 'in') then
        begin
          BreakWord := i;
          break;
        end;
    end;

  if BreakWord > 0 then
    begin
      Date := '';
      for i := 1 to BreakWord-1 do
        Date := Date + ' ' + ExtractWordL(i, DateAndPlace, DELIMS);
      Date := Trim(Date);

      Place := '';
      for i := BreakWord+1 to wc do
        Place := Place + ' ' + ExtractWordL(i, DateAndPlace, DELIMS);
      Place := Trim(Place);
    end
  else
    AlertFmt('"in" not found in text "%s"', [DateAndPlace]);
end;

function ParseName(const Value: string; var Prefix, FirstName, MiddleName, LastName, Suffix, NickName: string): boolean;
var
  wc, i, lb, rb: integer;
  Line, Tempv, Temp, FirstWord, LastWord: string;
begin
  tempv             := TrimTrailing(Value, [' ', ',']);
  lb := Pos('(', TempV);
  rb := Pos(')', TempV);
  if (lb > 0) and (rb > 0) then
    begin
      Temp      := Copy(TempV, lb+1, rb-lb-1);
      if not ContainsAny(Temp, DIGITS) then  // its not an indicator of marriage number, i.e. "(1)"
        NickName  := ProperCase(Temp);
      TempV     := ProperCase(Copy(TempV, 1, lb-1) + Copy(TempV, rb+1, Length(TempV)-rb));
    end;
  wc := WordCountL(TempV, ' ');
  result := wc >= 1;
  if result then
    begin
      FirstWord := ExtractWordL(1, TempV, ' ');
      if IsPrefix(FirstWord) then
        begin
          Prefix := FirstWord;
          wc     := wc - 1;
          TempV  := Copy(TempV, Length(Prefix)+1, Length(TempV)-Length(Prefix));
        end;

      LastWord := ExtractWordL(wc, TempV, ' ');
      if IsSuffix(LastWord) then
        begin
          Suffix := LastWord;
          wc     := wc - 1;
        end;

      case wc of
        1: LastName := TrimTrailing(TempV, [' ', ',']);
        2: begin
             FirstName := ExtractWordL(1, TempV, ' ');
             LastName  := ProperCase(TrimTrailing(ExtractWordL(2, TempV, ' '), [' ', ',', '.']));
           end;
        3: begin
             FirstName  := ExtractWordL(1, TempV, ' ');
             MiddleName := ExtractWordL(2, TempV, ' ');
             LastName   := ProperCase(TrimTrailing(ExtractWordL(3, TempV, ' '), [' ', ',', '.']));
           end;
        else
          begin
            FirstName := ProperCase(ExtractWordL(1, TempV, ' '));
            Line      := '';
            for i := 2 to wc-1 do
              begin
                if i > 2 then
                  Line := Line + ' ' + ExtractWordL(i, TempV, ' ')
                else
                  Line := ExtractWordL(i, TempV, ' ');
              end;
            MiddleName := Line;
            LastName   := ProperCase(TrimTrailing(ExtractWordL(wc, TempV, ' '), [' ', ',', '.']));
          end;
      end;
    end;

end;

function UnknownName(const aName: string): boolean;
begin
  result := SameText(aName, UNKNOWN) or SameText(aName, UNKNOWNP);
end;

end.
