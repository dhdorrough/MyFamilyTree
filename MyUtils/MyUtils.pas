unit MyUtils;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

// 08/19/2010 RemoveTrailingBackslash error when zero length path

interface

uses
{$IFnDEF FPC}
  Windows
{$ELSE}
  LCLIntf, LCLType, LMessages, FileUtil, JwaWinBase, windows, ShellApi, FileProcs
{$ENDIF}
  , Grids, Types, Graphics, Menus;

type
  TSetOfChar = set of char;
  TCompareProc = function(Item1, Item2, Param: Pointer): Integer;
  TChangedRows  = array[0..255] of boolean;


const
  PUNCT: TSetOfChar = [' '..'/', ':'..'@', '['..'`', '{'..'}'];
  BAD_FILENAME_CHARS = [':', '*', '"', '''', '\', '/', '|', '=', '>', '<', '?'];  {'[', ']',}
  DIGITS: TSetOfChar = ['0'..'9'];
  DELIMS = ', -._[];()?:''"@#$%^&*+={}|\<>/~`!'#9#147#146#13#10;  // 12/26/2012 added the "/" to allow split of dates
  ALPHA_UPPER: TSetOfChar = ['A'..'Z'];
  ALPHA_LOWER: TSetOfChar = ['a'..'z'];
  NUMERIC: TSetOfChar = ['0'..'9'];
  VOWELS: TSetOfChar = ['A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'];
  CR = #13;
  LF = #10;
  TAB = #9;
  DLE = #16;
  FF  = #12;
  CRLF = CR+LF;
  
  MY_DOCUMENTS_CONST = '{My Documents}';
  CURRENT_USER_CONST = '{Current User}';
  Months     = 'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC';
  MonthNames = 'JANUARY   FEBRUARY  MARCH     APRIL     MAY       JUNE      JULY      AUGUST    SEPTEMBER OCTOBER   NOVEMBER  DECEMBER  ';
//              X---------X---------X---------X---------X---------X---------X---------X---------X---------X---------X---------X---------
  MAX_DIFF_LEN = 255;
  DayNames   = 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';
//              1   2   3   4   5   6   7
  HexDigits = '0123456789ABCDEF';

type
  TSearch_Type = (SEARCHING, SEARCH_FOUND, NOT_FOUND);
  TUpdateStatusProc = procedure {name}(const Msg: string; LineNo: integer = 0) of object;
  TFixOption = (fo_FixAll, fo_FixAmpersand,fo_FixLT, fo_FixGT, fo_FixCR, fo_FixQuote);
  TFixOptions = set of TFixOption;
  TCaseChange = (ccNone, ccToLower, ccToUpper, ccToProper, ccToSentence);
  THexBytes = packed array[0..MAX_DIFF_LEN] of byte;

var
  DELIM_SET: TSetOfChar;
  ANY_ALPHA: TSetOfChar;
  IDENT_CHARS: TSetOfChar;
  HEX_DIGITS: TSetOfChar;

procedure AdjustColumnWidths(Grid: TStringGrid; ExtraPixels: word = 15);
procedure Alert(const Msg: string);
procedure AlertFmt(const Msg: string; Args: array of const);
function  ApproxEqual(f1, f2: double; Tolerance: double): boolean;
function  BitCount(n: longint): integer;
function  BrowseForFolder(Title: string; var Folder: string): Boolean;
function  BrowseForFile(Caption: string; var FilePath: string; Ext: string; aFilter: string = ''): boolean;
function  BuildFilterString(const Msg, Ext: string): string;
function  Calc_TextWidth(aCanvas : TCanvas; n: integer): integer;
function  ChangeStringCase(cc: TCaseChange; const s: string): string;
function  CharName(BitNr: word): string;
function  ChrTran(const Source, FromChar, ToChar: string): string;
function  CleanUpString( s: string;
                         GoodChars: TSetOfChar;
                         SubstChar: char = #0): string;
function  ComputerName : String;
function  ContainsAny(const aWord: string; aCharSet: TSetOfChar): boolean;
function  ContainsAnyPunct(const aWord: string): boolean;
function  ContainsWords( Target: string;
                         Data: string;
                         MatchWholeWordsOnly: boolean;
                         MustContainAll: boolean;
                         CaseSensitive: boolean = false): boolean;
function  ConvHexStr(hexstr: string; var hexbytes: THexBytes): integer;
procedure CreateLink(ObjectPath: string;   // path of the file/folder to create a shortcut
                     LinkPath: string;     // path of the newly created link/shortcut
                     Description : string);
function  DD_Mon_YYYY(DateTime: TDateTime): string;
procedure DeleteGridRow(yourStringGrid: TStringGrid; ARow: Integer);
procedure DeleteTrailingChar(var s: string; ch: char);
procedure EditTextFile(const FileName: string);
function  ElapsedTimeToStr(aTime : TDateTime) : string;
function  Empty(const s: string): boolean;
procedure Error(const Msg: string);
procedure ErrorFmt(const Msg: string; args: array of const);
function  ExecAndWait(const ExecuteFile, ParamString : string; Wait: boolean = true): boolean;
function  ExtractFileBase(s: string): string;
Function  FileExecute(FileName: String; WaitUntilDone: Boolean): Boolean;
function  FileExists(const FileName: string): boolean;  // standard routine doesn't always work!
function  FileExistsSlow(const FileName: string): boolean;  // standard routine doesn't always work!
function  FileNameByDate(const FileName: string): string;
function  FileSize32(FileName: string): DWORD;
function  FileSize64(FileName: string): Int64;
function  FindAnyOf(const s: string; Cset: TSetOfChar; StartIdx: integer = 1): integer;
function  FindDSTDateForYear(Year, Month, N: word): TDateTime;
function  FixExt(Ext: string): string;
function  FixHTMLChars(const s: string; FixOptions: TFixOptions = [fo_FixAll]): string;
function  FixSpecialChars(const s: string): string;
function  FixTableName(const aTableName: string): string;
function  ForceBackSlash(const Path: string): string;
function  ForceExtension(const FileName, Ext: string; HasPeriod: boolean = false): string;
function  FullName(const Prefix, First, Middle, Last, Suffix: string; NickName: string = ''): string;
function  GetFileCreationTime(FileName: string): TDateTime;
function  GetFileTimes(const fileName: string; var creationTime, lastAccessTime,
                       lastModificationTime: TDateTime): boolean;
function  GetMyDocuments: string;
function  GetUserFolder: string;
procedure GridDrawCell(grid: TStringGrid; const ChangedRows: TChangedRows;
                       ACol, ARow: Integer; Rect: TRect);
function  HashedFileName(const FileName: string; HashLen: integer): string;
function  HexStrToWord(const HexStr: string): longword;
function  HHMMSS(Elapsed: double): string;
function  IIF(cond: boolean; a, b: integer): integer; overload;
function  IIF(cond: boolean; a, b: string): string; overload;
function  IIF(cond: boolean; a, b: TDateTime): TDateTime; overload;
function  IIF(cond: boolean; a, b: boolean): boolean; overload;
function  IIF(cond: boolean; a, b: double): double; overload;
procedure InflateRect(var Rect: TRect; Pixels: integer);
function  InternetOpenShell(const Url: string): Boolean;
function  IsAllAlpha(const aWord: string): boolean;
function  IsAllNumeric(const aWord: string): boolean;
function  IsIdentifier(aWord: string): boolean;
function  IsPureNumeric(const aWord: string): boolean;
function  IsPureHex(const aWord: string): boolean;
function  IsFloat(const aWord: string): boolean;
function  IsDelphiRunning: Boolean;
function  IsPowerOfTwo(n: longint): boolean;

function  IsReadOnlyFile(FileName: string): boolean;
function  IsReadOnlyFolder(FileName: string): boolean;
function  IsValidDate(const DateStr: string): boolean;
function  IsVowel(ch: char): boolean;
function  IsWildName(FilePath: string): boolean;
procedure KillFolder(const FolderName: string);
function  LeadingNumericString(const aWord: string; var NonNumericIndex: integer): string;
function  Left(const s: string; width: integer): string;
function  MakePathGeneric(const Path: string; Enabled: boolean): string;
function  MakePathSpecific(const Path: string; Enabled: boolean): string;
function  MatchesPattern(const aWord, Pattern: string): boolean;
function  Max(a, b: integer): integer;
function  Min(a, b: integer): integer;
procedure Message(const Msg: string);
procedure MessageFmt(const Msg: string; Args: array of const);
function  MonthName(mon: integer; UseShort: boolean = false): string;
function  MonthNumber(mon: string): integer;
function  MyDeleteFile(const lfn: string; ReCycle: boolean = true; Confirm: boolean = true): boolean;
function  MyExtractFileExt(Ext: string): string;
function  MyStrPos( buf: pchar;
                    target: pchar;
                    BufEndOffset: integer;
                    IgnoreCase: boolean = false;
                    IgnoreEOL: boolean = false): pchar; overload;
function  MyStrPos( buf: pchar;
                    target: pchar;
                    bufend : pchar): pchar; overload;
function  MyStrToInt(const aWord: string): integer;
function  MyStrToTime(const aWord: string): TDateTime;
procedure OutputDebugStringFmt(const s: string; const Args: array of const);
function  PadL(const s: string; Count: integer): string; overload;
function  PadL(const n: integer; Count: integer): string; overload;
function  PadR(const s: string; Count: integer): string; overload;
function  PadR(const s: string; Count: integer; ch: char): string; overload;
function  PosCH(chars: string; Target: string): integer;
function  Pretty(s: string): string;
//function  PrintableOnly(s: string): string;  // replace with PrintableOnly2
function  PrintableOnly2(s: string): string;
procedure PrintStringGrid( const Title: string;
                           Grid: TStringGrid;
                           const OutFileName: string;
                           OpenOutputFile: boolean = false;
                           MaxColWidth: integer = 255);
function  ProperCase(const S : string; FirstOnly: boolean = false) : string;
function  Quoted(const s: string): string;
function  Radix26(n: integer; c: char): string;
function  RandomStr(n : Integer) : string;
function  RemoveBadChars( s: string;
                          BadChars: TSetOfChar): string;
function  RemoveRepeatedChar(const s: string; ch: char): string;
function  RemoveLeadingBackSlash(const Path: string): string;
function  RemoveTrailingBackSlash(const Path: string): string;
function  ReplaceAll(const s: string; FromCh, ToCh: char): string;
function  Right(const s: string; width: integer): string;
function  Rounder(f: Extended; n : integer): Extended;
function  RZero(n: integer; w: integer): string; overload;
function  RZero(const n: string; w: integer): string; overload;
function  ScaledSize(n: double): string;
procedure SetFileCreationTime(const FileName: string; const DateTime: TDateTime);
procedure Sortgrid(Grid : TStringGrid; SortCol:integer);
procedure SortGridByDate(Grid : TStringGrid; SortCol:integer);
procedure SortGridNumeric(Grid : TStringGrid; SortCol:integer);
Procedure SortMenuItems(Menu: TMenuItem; FirstRow: integer = 0);
function  Soundex(const aString: string): string;
function  StripDigits(const aWord: string): string;
function  StrToIntSafe(s: string): integer;
function  TabsToSpaces(const Line: string): string;
function  TF(b: boolean): string;
function  TFString(b: boolean): string;
function  TempPath: string;
function  ToLower(ch: char): char;
function  ToUpper(ch: char): char;
function  TrimTrailing(const s: string; BadChars: TSetOfChar): string;
function  UniqueFileName(const FileName: string): string;
function  Wild_Match(strg, pattern: pchar; ASTERISK, QUESTION: char; CaseSensitive: boolean): boolean;
function  Yes(Msg: string): boolean;
function  YesFmt(Msg: string; Args: array of const): boolean;
function  YYMMDD(DateTime: TDateTime): string;
function  YYYYMMDD(DateTime: TDateTime): string;
function  YYYYMMDD_hhmmss_to_DateTime(const DateStr: string): TDateTime;

implementation

uses
{$IFnDEF FPC}
  ShellAPI,
{$ELSE}
{$ENDIF}
  SysUtils, Classes, Dialogs, Controls,
  ActiveX, ComObj, ShlObj, Forms, DateUtils,
  StStrL, Math;

const
  SValidateFailed = 'Cannot find ''%s''. Make sure the path is correct.';
  FILE_WRITE_ATTRIBUTES = $0100;

var
  gShellMalloc: IMalloc;

procedure AdjustColumnWidths(Grid: TStringGrid; ExtraPixels: word = 15);
var
  c, r: integer;
  Wid, Len, NrChanged: integer;
  PixelWidths, CharWidths: array of integer;
begin
  with Grid do
    begin
      SetLength(PixelWidths, ColCount);
      SetLength(CharWidths, ColCount);
      for c := 0 to ColCount-1 do
        begin
          PixelWidths[c] := 0;
          CharWidths[c]  := 0;
        end;

      // find the longest field in each column
      NrChanged := 0;
      for c := 0 to ColCount-1 do
        for r := 0 to RowCount do
          if Length(Cells[c, r]) > CharWidths[c] then
            begin
              Len            := Min(Length(Cells[c, r]), 255);
              CharWidths[c]  := Len;
              PixelWidths[c] := Calc_TextWidth(Grid.Canvas, Len);
              inc(NrChanged);
            end;

      if NrChanged > 0 then
        for c := 0 to ColCount-1 do
          ColWidths[c] := PixelWidths[c] + ExtraPixels;

      Wid := 0;
      for c := 0 to Pred(Pred(ColCount)) do
        Wid := Wid + ColWidths[c];

      ColWidths[Pred(ColCount)] := Width - Wid;  // Widen the rightmost column width
    end;
end;

procedure Alert(const Msg: string);
begin { Alert }
  MessageDlg(msg, mtWarning, [mbOk], 0);
end;  { Alert }

procedure AlertFmt(const Msg: string; Args: array of const);
begin
  Alert(Format(Msg, Args));
end;

function  ApproxEqual(f1, f2: double; Tolerance: double): boolean;
begin
  result := Abs(f1-f2) <= Tolerance;
end;


procedure Error(const Msg: string);
begin
  MessageDlg(msg, mtError, [mbOk], 0);
end;

function ExecAndWait(const ExecuteFile, ParamString : string; Wait: boolean = true): boolean;
{$IfNDef FPC}
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
{$endIF}
begin
{$IfNDef FPC}
  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do
    begin
      fMask  := SEE_MASK_NOCLOSEPROCESS;
      Wnd    := Application.Handle;
      lpFile := PChar(ExecuteFile);
      lpParameters := PChar(ParamString);
      nShow  := SW_SHOWNORMAL; // SW_HIDE;
    end;
  if ShellExecuteEx(@SEInfo) then
    begin
      if Wait then
        repeat
          Application.ProcessMessages;
          GetExitCodeProcess(SEInfo.hProcess, ExitCode);
        until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
      Result:=True;
    end
  else
  Result:=False;
{$Else}
  raise Exception.Create('Unimplemented: ExecAndWait');
{$EndIf}
end;

procedure ErrorFmt(const Msg: string; args: Array of const);
begin
  Error(Format(Msg, Args));
end;

function FindAnyOf(const s: string; Cset: TSetOfChar; StartIdx: integer = 1): integer;
var
  i: integer;
begin
  result := 0;
  for i := StartIdx to Length(s) do
    if s[i] in Cset then
      begin
        result := i;
        exit;
      end;
end;

// Looks for the N'th Sunday of the specified Month/Year
function FindDSTDateForYear(Year, Month, N: word): TDateTime;
var
  mode: TSearch_Type; // (SEARCHING, SEARCH_FOUND, NOT_FOUND);
  Day, N0, DaysInMonth: word;
  dow: integer;
begin
  DaysInMonth := DaysInAMonth(Year, Month);
  mode := SEARCHING;
  day  := 1;
  N0   := 1;
  repeat
    result := EncodeDate(Year, Month, Day);
    dow    := DayOfTheWeek(result);
    if (dow = DaySunday) and (N0 = N) then  // found the right occurrence
      mode := SEARCH_FOUND else
    if Day <= DaysInMonth then
      begin
        if dow = DaySunday then
          inc(N0);
        inc(Day)
      end
    else
      mode := NOT_FOUND;
  until mode <> SEARCHING;
end;

function FixExt(Ext: string): string;
begin
  if (Length(Ext) > 0) and (Ext[1] = '.') then
    Delete(Ext, 1, 1);   // get rid of the '.'
  result := Ext;
end;

function FixHTMLChars(const s: string; FixOptions: TFixOptions = [fo_FixAll]): string;
  var
    i: integer;
begin
  result := '';
  if FixOptions = [fo_FixAll] then
    FixOptions := [Succ(Low(TFixOption)) .. High(TFixOption)];

  for i := 1 to Length(s) do
    begin
      case s[i] of
        '&': if fo_FixAmpersand in FixOptions then
               result := result + '&amp;';
        '<': if fo_FixLT in FixOptions then
               result := result + '&lt;';
        '>': if fo_FixGT in FixOptions then
               result := result + '&gt;';
        '''': if fo_FixQuote in FixOptions then
               result := result + '&#39;';
        CR:  if fo_FixCR in FixOptions then
               result := result + '<br/>' + CR
             else
               result := result + s[i];  
      else
        result := result + s[i];
      end;
    end;
end;

function FixSpecialChars(const s: string): string;
  var
    i: integer;
begin
  result := '';
  for i := 1 to Length(s) do
    begin
      case s[i] of
        ' ': result := result + '&nbsp;';
        '-': result := result + '&nbsp;';
      else
        result := result + s[i];
      end;
    end;
end;

function ContainsAny(const aWord: string; aCharSet: TSetOfChar): boolean;
  var
    i: integer;
begin
  result := false;
  for i := 1 to Length(aWord) do
    if aWord[i] in aCharSet then
      begin
        result := true;
        break;
      end;
end;

function ContainsAnyPunct(const aWord: string): boolean;
begin
  result := ContainsAny(aWord, PUNCT);
end;


function ContainsWords( Target: string;
                        Data: string;
                        MatchWholeWordsOnly: boolean;
                        MustContainAll: boolean;
                        CaseSensitive: boolean = false): boolean;
var
  wcD, wcT, TW, DW: integer;
  aWord: string;
  DataWords: array of string;
  MatchedOne: boolean;

  function DataContainsWord(const aWord: string): boolean;
    var
      DW: integer;
  begin { DataContainsWord }
    result := false;
    for DW := 0 to wcD-1 do
      if aWord = DataWords[DW] then
        begin
          result := true;
          exit;
        end;
  end; { DataContainsWord }

begin { ContainsWords }
  if not CaseSensitive then
    begin
      Target     := UpperCase(Target);
      Data       := UpperCase(Data);
    end;

  MatchedOne := false;
  if MatchWholeWordsOnly then
    begin
      wcD := WordCountL(Data, DELIMS);
      SetLength(DataWords, wcD);
      for DW := 1 to wcD do
        DataWords[DW-1] := ExtractWordL(DW, Data, DELIMS);
      wcT := WordCountL(Target, DELIMS);
      // try to match each word of the target to any word in the data
      for TW := 1 to wcT do
        begin
          aWord := ExtractWordL(TW, Target, DELIMS);
          if not DataContainsWord(aWord) then
            begin
              if MustContainAll then
                begin
                  result := false;
                  exit;
                end;
            end
          else
            MatchedOne := true;
        end;
      result := MatchedOne; // iff required number of matches made
    end
  else
    result := Pos(Target, Data) > 0;
end;  { ContainsWords }

function ConvHexStr(hexstr: string; var hexbytes: THexBytes): integer;
var
  j, Idx: integer;
  temp: string;
  eol: boolean;
  aByte: Byte;

  function skipblanks: boolean;  {  true if eol reached }
  var
    done: boolean;
  begin
    repeat
      done := idx > length(hexstr);
      if not done then
        done := hexstr[idx] <> ' ';
      if not done then
        idx := idx + 1;
    until done;
    skipblanks := idx >= Length(HexStr);
  end;

  function Hex(val: integer; NrBytes: integer): string;
  var  
    nib: Byte;  
    i: integer;    
  begin    
    (* writeLn('Hex: Val: ', Val, ' NrBytes:  ', NrBytes,  ': '); *)  
    {$R-}
    SetLength(result, NrBytes);
    {$R+}    
    for i := 0 to NrBytes-1 do    
      begin    
        nib := val mod 16;      
        val := val div 16;
     (* writeln('i = ', i, ' NrBytes-i = ', NrBytes-i,         
                ' Nib = ', Nib, ' Val = ', Val); *)     
        result[NrBytes-i] := HexDigits[nib+1];                
      end;        
  end;      

  function readhex: longint;
  var    
    ch: char;    
    digit: Byte;      
    done: boolean;
  begin
    result := 0; done := idx > length(hexstr);
    while (not done) do
      begin
        ch := hexstr[idx];
        if ch in ['a'..'f'] then
          digit := ord(ch) - ord('a') + 10 else
        if ch in ['A'..'F'] then
          digit := ord(ch) - ord('A') + 10 else
        if ch in ['0'..'9'] then
          digit := ord(ch) - ord('0')
        else
          begin
            raise EConvertError.CreateFmt('Non hex character in "%s" = "%s"', [ch, hexstr]);
          end;
        result := (result * 16) + digit;
        idx := idx + 1;
        done := (idx > Length(hexstr));
        if not done then
          done := not (hexstr[idx] in ['0'..'9', 'a'..'f','A'..'F']);
      end;
  end;

begin { ConvHexStr }
  idx := 1;  j := 0; eol := false;
  while not eol do
    begin
      eol := skipblanks;
      if not eol then
        begin
          aByte := readhex;
          temp := Hex(aByte, 2);
       (* writeln('hex byte: ', temp); *)
          hexbytes[j] := aByte;
          j := j + 1;
        end;
    end;
  result := j;
end;  { ConvHexStr }

function FixTableName(const aTableName: string): string;
begin
  if ContainsAnyPunct(aTableName) then
    result := Format('[%s]', [aTableName])
  else
    result := aTableName;
end;

function  ForceBackSlash(const Path: string): string;
var
  c: char;
begin
  result := Path;
  if Length(Path) > 0 then
    begin
      c := Path[Length(Path)];
      if c <> '\' then
        result := Path + '\';
    end;
end;

function  BitCount(n: longint): integer;
  var
    i: integer;
  begin
    result := 0;
    for I := 0 to 31 do
      begin
        if odd(n) then
          inc(result);
        n := n shr 1;
      end;
  end;

  function IsPowerOfTwo(n: longint): boolean;
  begin
    result := BitCount(n) = 1;
  end;

function RemoveLeadingBackSlash(const Path: string): string;
begin
  if (Length(Path) > 0) and (Path[1] = '\') then
    result := Copy(Path, 2, Length(Path) - 1)
  else
    result := Path;
end;


//*****************************************************************************
//   Function Name     :  ForceExtension
//   Useage            :  NewName := ForceExtension(OldName, 'BAK')
//   Function Purpose  :  Change only the file name extension
//   Assumptions       :
//   Parameters        :  Filename = original name
//                     :  Ext = the extension to be used
//                     :  HasPeriod = if the extension starts with "."
//   Return Value      :  The changed file name
//*******************************************************************************}

function  ForceExtension(const FileName, Ext: string; HasPeriod: boolean = false): string;
  var
    i: integer;
    mode: TSearch_Type; // SEARCHING, SEARCH_FOUND, NOT_FOUND
    temp: string;
begin
  mode := SEARCHING;
  i    := Length(FileName);

  repeat
    if i = 0 then
      mode := NOT_FOUND
    else
      if FileName[i] = '.' then
        mode := SEARCH_FOUND
      else
        dec(i);
  until mode <> SEARCHING;

  if mode = SEARCH_FOUND then
    temp := Copy(FileName, 1, i-1)
  else
    temp := FileName;

  if HasPeriod then
    result := temp + Ext
  else
    result := temp + '.' + Ext
end;

{*****************************************************************************
{   Function Name     : CleanUpString
{   Useage            :
{   Function Purpose  : Deletes any char not in 'GoodChars'
{   Assumptions       :
{   Parameters        :
{   Return Value      :
{*******************************************************************************}

function CleanUpString( s: string;
                        GoodChars: TSetOfChar;
                        SubstChar: char = #0): string;
  var
    i      : integer;
begin { CleanUpString }

  { delete bad characters }

  i      := 1;
  while i <= Length(S) do
    if not (s[i] in GoodChars) then
      if SubstChar <> #0 then
        begin
          s[i] := SubstChar;
          inc(i);
        end
      else
        delete(s, i, 1)
    else
      inc(i);

  result := s;
end;  { CleanUpString }

procedure EditTextFile(const FileName: string);
begin
  if not ExecAndWait('NOTEPAD.EXE', FileName, false) then
    AlertFmt('Could not edit "%s"', [FileName]);
end;

function ElapsedTimeToStr(aTime : TDateTime) : string;
var
  Seconds : word;
  Minutes : word;
  Hours   : word;
  Mcs     : word;
begin
  DecodeTime(aTime, Hours, Minutes, Seconds, Mcs);
  Result  := Trim(Format('%3.2d:%2.2d:%2.2d', [Hours, Minutes, Seconds]));
end;

function Empty(const s: string): boolean;
begin
  result := Trim(s) = '';
end;

function ExtractFileBase(s: string): string;
  label 10;
  var i: integer;
begin { ExtractFileBase }
  s := ExtractFileName(s);
  { look for the right-most period }
  for i := length(s) downto 1 do
    if s[i] = '.' then
      goto 10;
  i := 0;
  10: if i > 0 then
    s := copy(s, 1, i-1);
  result := s;
end;  { ExtractFileBase }

{$IfDef FPC}
function FileSize32(FileName: string): DWORD;
var
  FindData: TSearchRec;
  Find: integer;
begin
    Result:= 0;
    Find  := FindFirstUTF8(pChar(FileName), 0, FindData);
    if Find<>INVALID_HANDLE_VALUE then
    begin
      FindCloseUTF8(FindData); { *Converted from FindClose* }
      Result:= FindData.Size;
    end;
    FindCloseUTF8(FindData); { *Converted from FindClose* }
end;
{$EndIf}
{$IfNDef FPC}
function FileSize32(FileName: string): DWORD;
var
  Find: THandle;
  FindData: TWin32FindData;
begin
    Result:= 0;
    Find:= FindFirstFile(pChar(FileName), FindData);
    if Find<>INVALID_HANDLE_VALUE then
    begin
      Windows.FindClose(Find);
      Result:= FindData.nFileSizeLow;
    end;
end;
{$EndIf}


{$IfNDef fpc}
function FindDataFileSize64(const FindData: TWin32FindData): Int64;
begin
  LARGE_INTEGER(Result).LowPart        := FindData.nFileSizeLow;
  DWORD(LARGE_INTEGER(Result).HighPart):= FindData.nFileSizeHigh;
end;
{$ENDiF}

{$IfDef FPC}
function FileSize64(FileName: string): Int64;
var
  FindData: TSearchRec;
  Find: integer;
begin
    Result:= 0;
    Find  := FindFirstUTF8(pChar(FileName), 0, FindData);
    if Find<>INVALID_HANDLE_VALUE then
    begin
      FindCloseUTF8(FindData); { *Converted from FindClose* }
      Result:= FindData.Size;
    end;
    FindCloseUTF8(FindData); { *Converted from FindClose* }
end;
{$EndIf}
{$IfNDef FPC}
function FileSize64(FileName: string): Int64;
var
  Find: THandle;
  FindData: TWin32FindData;
begin
  Result:= 0;
  Find:= FindFirstFile(pChar(FileName), FindData);
  if Find<>INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Find);
    Result:= FindDataFileSize64(FindData);
  end;
end;
{$EndIf}

function FullName(const Prefix, First, Middle, Last, Suffix: string; NickName: string = ''): string;
begin
  result := Trim(Last);                                   // Last
  if not Empty(Middle) then
    begin
      if not Empty(NickName) then
        result := Trim(Middle) + ' (' + Trim(NickName) + ') ' + result  // Middle (NickName) Last
      else
        result := Trim(Middle) + ' ' + result;                  // Middle Last
    end else
  if Not Empty(NickName) then
    result := ' (' + Trim(NickName) + ') ' + result;
  if not Empty(First) then
    result := Trim(First) + ' ' + result;                 // First Middle (NickName) Last
  if not Empty(Suffix) then
    result := result + ', ' + Trim(Suffix);                // First Middle (NickName) Last Suffix
  if not Empty(Prefix) then
    result := Trim(Prefix) + ' ' + result;                // Prefix Middle (NickName) Last Suffix
end;

function SNL_FileTime2DateTime(FileTime: TFileTime): TDateTime;
var
   LocalFileTime: TFileTime;
   SystemTime: TSystemTime;
begin
   FileTimeToLocalFileTime(FileTime, LocalFileTime) ;
   FileTimeToSystemTime(LocalFileTime, SystemTime) ;
   Result := SystemTimeToDateTime(SystemTime) ;
end;

function  GetFileTimes(const fileName: string; var creationTime, lastAccessTime,
  lastModificationTime: TDateTime): boolean;
var
  fileHandle            : cardinal;
  fsCreationTime        : TFileTime;
  fsLastAccessTime      : TFileTime;
  fsLastModificationTime: TFileTime;
begin
  Result := false;
  fileHandle := CreateFile(PChar(fileName), GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, 0, 0);
  if fileHandle <> INVALID_HANDLE_VALUE then try
    Result               := GetFileTime(fileHandle, @fsCreationTime, @fsLastAccessTime, @fsLastModificationTime);

    if result then
      begin
        creationTime         := SNL_FileTime2DateTime(fsCreationTime);
        lastAccessTime       := SNL_FileTime2DateTime(fsLastAccessTime);
        lastModificationTime := SNL_FileTime2DateTime(fsLastModificationTime);
      end;
  finally
    CloseHandle(fileHandle);
  end;
end; { DSiGetFileTimes }

function  HashedFileName(const FileName: string; HashLen: integer): string;
const
  EXTMAX = 4;
  EXTMAX2 = EXTMAX DIV 2;
var
  Base, Ext: string;
  ExtLen, BaseLen, BaseLen2, PfxLen, HashLen2: integer;
  HasExt: boolean;
begin
  if Length(FileName) <= HashLen then
    result := FileName
  else
    begin
      Ext     := ExtractFileExt(FileName);
      if (Length(Ext) > 0) and (Ext[1] = '.') then
        Ext := Copy(Ext, 2, 127)
      else
        Ext := '';

      ExtLen  := Length(Ext);
      HasExt  := ExtLen > 0;

      HashLen2:= (HashLen-ExtLen) div 2;
      Base    := ExtractFileBase(FileName);
      BaseLen := Length(Base);
      BaseLen2:= BaseLen div 2;

      if HasExt then
        if (ExtLen < EXTMAX) then
          Ext := Padr(Ext, EXTMAX)
        else
          Ext := Left(Ext, EXTMAX)
      else
        Ext := '';

      PfxLen  := HashLen2;
      if PfxLen < BaseLen2 then
        PfxLen := BaseLen2;
      if PfxLen > HashLen2 then
        PfxLen := HashLen2;

      if HasExt then
        result := Left(Base, PfxLen) + Right(Base, PfxLen) + Left(Ext, EXTMAX2) + Right(Ext, EXTMAX2)
      else
        result := Left(Base, PfxLen) + Right(Base, PfxLen);
    end;
end;

function  HexStrToWord(const HexStr: string): longword;
var
  i: word; ch: char; d: byte;
begin
  result := 0;
  i := 1;
  while I <= Length(Hexstr) do
    begin
      ch := ToUpper(HexStr[i]);
      if ch in ['A'..'F'] then
        d := ord(ch) - ord('A') + 10 else
      if ch in ['0'..'9'] then
        d := ord(ch) - ord('0')
      else
        raise Exception.CreateFmt('Illegal character [%s] in Hex string [%s]',
                                   [ch, HexStr]);
      result := (result * 16) + d;
      inc(i);
    end;
end;

function HHMMSS(Elapsed: double { in ms.} ): string;
begin
  Result:= ElapsedTimeToStr(Elapsed/(1000*60*60*24));
end;

function IIF(cond: boolean; a, b: double): double;
begin
  if Cond then
    result := a
  else
    result := b;
end;

function IIF(cond: boolean; a, b: integer): integer;
begin
  if Cond then
    result := a
  else
    result := b;
end;

function IIF(cond: boolean; a, b: string): string;
begin
  if Cond then
    result := a
  else
    result := b;
end;

function IIF(cond: boolean; a, b: TDateTime): TDateTime;
begin
  if Cond then
    result := a
  else
    result := b;
end;

function  IIF(cond: boolean; a, b: boolean): boolean; overload;
begin
  if Cond then
    result := a
  else
    result := b;
end;

function  Min(a, b: integer): integer;
begin
  if a < b then
    result := a
  else
    result := b;
end;

function Max(a, b: integer): integer;
begin
  if a > b then
    result := a
  else
    result := b;
end;

function MonthName(mon: integer; UseShort: boolean = false): string;
begin
  if UseShort then
    result := ProperCase(Copy(Months, ((mon-1)*4)+1, 3))
  else
    result := ProperCase(Copy(MonthNames, ((mon-1)*10)+1, 10));
end;

function MonthNumber(mon: string): integer;
  var
    idx: integer;
begin
  result := -1;

  if Length(Mon) in [3..9] then
    begin
      Mon := UpperCase(mon);
      idx := Pos(mon, months);
      if idx > 0 then
        begin
          if ((idx - 1) mod 4) = 0 then
            result := ((idx - 1) div 4) + 1
        end
      else
        begin
          idx := Pos(mon, MonthNames);
          if idx > 0 then
            begin
              if ((idx - 1) mod 10) = 0 then
                result := ((idx - 1) div 10) + 1
            end
          else
            if SameText(mon, 'SEPT') then
              result := 9;
        end;
    end;
end;

function MyExtractFileExt(Ext: string): string;
begin
  Ext    := ExtractFileExt(Ext);
  result := UpperCase(Copy(Ext, 2, Length(Ext)-1));
end;

function MyStrPos( buf: pchar;
                   target: pchar;
                   BufEndOffset: integer;
                   IgnoreCase: boolean = false;
                   IgnoreEOL: boolean = false): pchar; overload;
var
  mode : tSEARCH_TYPE;
  len  : integer;
  BufEnd: pchar;
begin
  result := nil;
  BufEnd := Buf + BufEndOffset - 1;
  if Buf < BufEnd then
    begin
      len  := StrLen(Target);
      mode := SEARCHING;
      repeat
        if ((buf + len) > bufend) or ((not IgnoreEOL) and (buf^ = #0)) then
          mode := NOT_FOUND else
        if IgnoreCase then
          begin
            if StrLIComp(buf, target, len) = 0 then
              mode := SEARCH_FOUND
          end
        else // don't ignore case
          begin
            if StrLComp(buf, target, len) = 0 then
              mode := SEARCH_FOUND
          end;
        if mode <> SEARCH_FOUND then
          inc(buf);
      until mode <> SEARCHING;
      if mode = SEARCH_FOUND then
        result := buf
    end
  else if Buf > BufEnd then // beginning of buffer comes after end?
    {raise Exception.Create('System error in MyStrPos')};
end;

function MyStrPos(buf: pchar; target: pchar; bufend : pchar): pchar; overload;
var
  mode : tSEARCH_TYPE;
  len  : integer;
begin
  result := nil;
  if Buf < BufEnd then
    begin
      len  := StrLen(Target);
      mode := SEARCHING;
      repeat
        if (buf + len) >= bufend then
          mode := NOT_FOUND else
        if StrLComp(buf, target, len) = 0 then
          mode := SEARCH_FOUND
        else
          inc(buf);
      until mode <> SEARCHING;
      if mode = SEARCH_FOUND then
        result := buf
    end
  else if Buf > BufEnd then // somethings very wacky here (cr #7715: ignore empty buffer)
    raise Exception.Create('System error in MyStrPos');
end;

function MyStrToInt(const aWord: string): integer;
begin
  if (Length(aWord) > 0) and IsAllNumeric(aWord) then
    result := StrToInt(aWord)
  else
    result := 0;
end;

function IsDelphiRunning: Boolean;
begin
  Result := (FindWindow('TAppBuilder', nil) > 0) and
    (FindWindow('TPropertyInspector', 'Object Inspector') > 0);
end;

function  MyStrToTime(const aWord: string): TDateTime;
begin
  try
    result := StrToTime(aWord);
  except
    if SameText(aWord, 'MidNight') then
      result := 0.0 else
    if SameText(aWord, 'Mid-Night') then
      result := 0.0 else
    if SameText(aWord, 'Noon') then
      result := OneHour * 12.0
    else
      raise Exception.CreateFmt('Invalid time value: %s', [aWord]);
  end;
end;

function  RemoveTrailingBackSlash(const Path: string): string;
begin
  result := Path;
  if (Length(Path) > 0) and (Path[Length(Path)] = '\') then
    result := Copy(Path, 1, Length(Path)-1);
end;

function  ReplaceAll(const s: string; FromCh, ToCh: char): string;
var
  i: integer;
begin
  result := s;
  for i := 1 to Length(s) do
    if result[i] = FromCh then
      result[i] := ToCh;
end;

function Rounder(f: Extended; n : integer): Extended;
  var
    i : integer;
begin { Rounder }
  if n >= 0 then
    begin
      for i := 1 to n do
        f := f * 10;
      f := round(f);
      for i := 1 to n do
        f := f / 10;
    end
  else
    begin
      for i := 1 to -n do
        f := f / 10;
      f := round(f);
      for i := 1 to -n do
        f := f * 10;
    end;
  result := f;
end;  { Rounder }

function  RZero(const n: string; w: integer): string; overload;
begin
  if IsPureNumeric(n) then
    result := Rzero(StrToInt(n), w)
  else
    result := n;
end;

function  RZero(n: integer; w: integer): string;
  var
    temp: string;
begin
  temp := IntToStr(n);
  while Length(temp) < w do
    temp := '0' + temp;
  RZero := temp;
end;

procedure OutputDebugStringFmt(const s: string; const Args: array of const);
  var
    temp: string;
begin
  temp := Format(s, Args);
  OutputDebugString(pchar(temp));
end;

function PadR(const s: string; Count: integer): string;
begin
  result := PadR(s, Count, ' ');
end;

function PadL(const s: string; Count: integer): string;
begin
  result := PadR('', Count-Length(s)) + s;
end;

function  PadL(const n: integer; Count: integer): string;
begin
  Str(n:count, result)
end;

function PadR(const s: string; Count: integer; ch: char): string;
  var
    i: integer;
begin
  if Length(S) > Count then
    result := Copy(s, 1, Count)
  else
    begin
      SetLength(Result, Count);
      for i := 1 to Length(s) do
        result[i] := s[i];
      for i := Length(s)+1 to Count do
        result[i] := ch;
    end;
end;

function Pretty(s: string): string;
  var
    i: integer;
begin { pretty }
  result := s;
  for i := 1 to length(s) do
    if s[i] = '_' then
      result[i] := ' '
    else
      result[i] := s[i];
end;  { pretty }

Procedure SortMenuItems(Menu: TMenuItem; FirstRow: integer = 0);
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Sorted := true;
    for i := FirstRow to Menu.Count - 1 do
    begin
      sl.AddObject(Menu.Items[i].Caption, Menu.Items[i]);
    end;
    for i := FirstRow to sl.Count - 1 do
      TMenuItem(sl.Objects[i]).MenuIndex := i;
  finally
    sl.Free;
  end;
end;

{*****************************************************************************
{   Function Name     : Soundex
{   Function Purpose  : Calculate dBase Soundex
{   Parameters        : string to convert
{   Return Value      : Soundex as dBase would calculate it
{*******************************************************************************}

function Soundex(const aString: string): string; {dhd}
const
  soundextable:packed array['A'..'Z'] of CHAR=
   '.123.12..22455.12623.1.2.2';
var
   SoundString: string;
   I1: integer;      // input
   I2: INTEGER;      // output
   C2: CHAR;
   len: integer;
begin { Soundex }
  len := Length(aString);
  result := '0000';
  if len > 0 then
    begin
      // find first non-blank char
      I1 := 0;
      repeat
        Inc(I1);
        C2 := UPCASE(aString[I1]);
      until (I1 >= len) or (C2 <> ' ');

      // if first non-blank is not alphabetic, result is 0000
      if (C2 < 'A') or (C2 > 'Z') then
        exit;

      // calculate sound value for each remaining character
      Len := Len - I1 + 1;
      SetLength(SoundString, Len);
      Fillchar(SoundString[1], Len, '0');
      SoundString[1] := C2;
      for I2 := I1+1 to Length(astring) do
        begin
          C2 := UpCase(astring[I2]);
          if (C2 < 'A') or (C2 > 'Z') then
            break;
          SoundString[i2-i1+1] := SoundexTable[C2];
        end;

      // if adjacent chars have the same sound value, delete the second
      I1 := 2;
      repeat
        if I1 < Length(SoundString) then
          if SoundString[I1] = SoundString[I1+1] then
            Delete(SoundString, I1+1, 1)
          else
            Inc(I1);
      until I1 >= Length(SoundString);

      // result is 1st char followed by next 3 non-ignored chars padded to
      // right with '0', if necessary
      I1 := 1;
      I2 := 1;
      repeat
        if SoundString[I2] <> '.' then
          begin
            result[I1] := SoundString[I2];
            inc(I1);
          end;
        inc(I2);
      until (I1 > 4) or (I2 > Length(SoundString));
    end;
end;  { Soundex }

function TabsToSpaces(const Line: string): string;
const
  MAXLEN = 255;
  TABWIDTH = 8;
var
  i, col, NrBlanks: integer;
  temp, blanks: string[MAXLEN];
begin
{$R-}
  result := '';
  COL := 0;
  for i := 1 to Length(Line) do
    if Line[i] <> TAB then
      begin
        Inc(Col);
        temp[col] := Line[i];
      end
    else
      begin
        NrBlanks := TABWIDTH - (Col MOD TABWIDTH);
        Blanks   := Padr('', NrBlanks);
        Move(Blanks[1], Temp[Col+1], NrBlanks);
        Inc(Col, NrBlanks);
      end;
  SetLength(temp, Col);
  result := Copy(temp, 1, col);
{$R+}
end;

function StripDigits(const aWord: string): string;
  var
    i: integer;
begin
  result := '';
  for i := 1 to Length(aWord) do
    if not (aWord[i] in ['0'..'9']) then
      result := result + aWord[i];
end;

// avoid raising an exception
function  StrToIntSafe(s: string): integer;
begin
  s := trim(s);
  if IsPureNumeric(s) then
    result := StrToInt(s)
  else
    result := 0;
end;

function  TFString(b: boolean): string;
begin
  if b then
    result := 'true'
  else
    result := 'false';
end;

function TF(b: boolean): string;
begin
  if b then
    result := 'T'
  else
    result := 'F';
end;

function  TempPath: string;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

function IsFloat(const aWord: string): boolean;
begin
  try
    StrToFloat(aWord);
    result := true;
  except
    result := false;
  end;
end;

function  IsAllAlpha(const aWord: string): boolean;
var
  i: integer;
  ch: char;
begin
  for i := 1 to Length(aWord) do
    begin
      ch := ToLower(aWord[i]);
      if not (ch in ALPHA_LOWER) THEN
        begin
          result := false;
          exit;
        end;
    end;
  result := true;
end;

function IsAllNumeric(const aWord: string): boolean;
  var
    p: pchar;
begin
  result := false;
  p := pchar(aWord);
  while p^ <> #0 do
    begin
      if not (p^ in ['0'..'9', '-', '+']) then // Removed '_' because its not numeric
        exit
      else
        inc(p);
    end;
  result := true;
end;

function  IsIdentifier(aWord: string): boolean;
var
  i: integer;
begin
  result := true;
  aWord  := UpperCase(aWord);
  if Length(aWord) > 0 then
    begin
      if aWord[1] in ALPHA_UPPER then
        if (Length(aWord) > 1) then
          begin
            for i := 2 to Length(aWord) do
              if not (aWord[i] in IDENT_CHARS) then
                begin
                  result := false;
                  exit;
                end;
          end
        else
      else
        result := false;
    end
  else
    result := false;
end;

function IsPureNumeric(const aWord: string): boolean;
var
  p: pchar;
begin
  result := false;
  p      := pchar(aWord);
  if StrLen(p) > 0 then
    begin
      while p^ <> #0 do
        begin
          if not (p^ in NUMERIC) then
            exit
          else
            inc(p);
        end;
      result := true;
    end;
end;

function IsPureHex(const aWord: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 1 to Length(aWord) do
    if not (aWord[i] in ['A'..'F', 'a'..'f', '0'..'9']) then
      exit;
  result := true;
end;

function IsReadOnlyFile(FileName: string): boolean;
var
  SearchRec: TSearchRec;
  Err: integer;
begin
  result   := false;
  FileName := RemoveTrailingBackSlash(FileName);

  try
{$IfDef FPC}
    Err := FindFirstUTF8(FileName,0,SearchRec); { *Converted from FindFirst* }
{$Else}
    Err := FindFirst(FileName,0,SearchRec);
{$EndIF}
    if Err = 0 then  // ignore non-existant
      if not result then
        result := (SearchRec.Attr and faReadOnly) <> 0;
  finally
{$IfDef FPC}
    FindCloseUTF8(SearchRec); { *Converted from FindClose* }
{$Else}
    FindClose(SearchRec);
{$EndIF}
  end;
end;

function IsReadOnlyFolder(FileName: string): boolean;
var
  SearchRec: TSearchRec;
  Err, I1, I2: integer;
  TempFile: file of integer;
  TempFileName: string;
begin
  result   := false;
  FileName := RemoveTrailingBackSlash(FileName);
  OutputDebugStringFmt('Entering IsReadOnlyFolder, FileName=%s', [FileName]);

  try
{$IfDef FPC}
    Err := FindFirstUTF8(FileName,faDirectory,SearchRec); { *Converted from FindFirst* }
{$Else}
    Err := FindFirst(FileName,faDirectory,SearchRec);
{$EndIF}
    if Err = 0 then  // ignore non-existant
      if not result then
        begin
          result := (SearchRec.Attr and faReadOnly) <> 0;
          if not result then // try to actually write a file
            begin
              TempFileName := FileName + '\_junk.tmp';
              try
                AssignFile(TempFile, TempFileName);
                try
                  Rewrite(TempFile);
                  I1 := Random(MAXINT);
                  Write(TempFile, I1);
                  CloseFile(TempFile);
                  Reset(TempFile);
                  Read(TempFile, I2);
                  if I2 <> I1 then
                    raise Exception.CreateFmt('System error: File written to folder %s could not be correctly read', [ExtractFilePath(FileName)]);
                except
                  result := true; // if we can't write the temporary file
                end;
              finally
                if not result then    // file should have been opened
                  CloseFile(TempFile);
                if not MyDeleteFile(TempFileName, false, false) then
                  result := true;
              end;
            end;
        end;
  finally
{$IfDef FPC}
    FindCloseUTF8(SearchRec); { *Converted from FindClose* }
{$Else}
    FindClose(SearchRec);
{$EndIF}
  end;
end;

function  IsValidDate(const DateStr: string): boolean;
begin
  result := true;
  try
    StrToDateTime(DateStr);
  except
    result := false;
  end;
end;

function  IsVowel(ch: char): boolean;
begin
  result := ch in VOWELS;
end;

function  IsWildName(FilePath: string): boolean;
var
  FileName: string;
begin
  FileName := ExtractFileName(FilePath);
  result   := (Pos('*', FileName) > 0) or (Pos('?', FileName) > 0);
end;

procedure KillFolder(const FolderName: string);
var
  FOS: TSHFileOpStruct;
begin
  with FOS do
    begin
      wFunc := FO_DELETE;
      pFrom := PChar(FolderName + #0); { Just in case add extra null }
      pTo   := nil;
      fFlags := FOF_NOCONFIRMATION or FOF_SILENT;
    end;
  SHFileOperation(FOS);
end;


function  LeadingNumericString(const aWord: string; var NonNumericIndex: integer): string;
var
  i: integer;
  done: boolean;
begin
  i := 1;
  result := '';
  done := false;
  NonNumericIndex := 0;
  repeat
    if i > Length(aWord) then
      done := true else
    if aWord[i] in ['0'..'9', '.', '+', '-'] then
      begin
        result := result + aWord[i];
        inc(i)
      end
    else
      begin
        done := true;
        NonNumericIndex := i;
      end;
  until done;
//if result = '' then  // 8/25/2023 commented out because returning '0'
                       // when there is no leading numeric string causes problems in ParseDistance
//  result := '0';
end;

function Left(const s: string; width: integer): string;
begin { right }
  if width < Length(S) then
    result := copy(s, 1, width)
  else
    result := s;
end;  { right }

function  MakePathGeneric(const Path: string; Enabled: boolean): string;
var
  MyDocuments, DocumentsPart: string;
  CurrentUser, UserPart: string;
  Len: integer;
begin
  if Enabled then
    begin
      MyDocuments   := GetMyDocuments;
      Len           := Length(MyDocuments);
      DocumentsPart := Copy(Path, 1, Len);

      if SameText(DocumentsPart, MyDocuments) then
        result := MY_DOCUMENTS_CONST + Copy(Path, Len+1, Length(Path)-Len)
      else
        begin
          CurrentUser   := GetUserFolder;
          Len           := Length(CurrentUser);
          UserPart      := Copy(Path, 1, Len);
          if SameText(UserPart, CurrentUser) then
            result := CURRENT_USER_CONST + Copy(Path, Len+1, Length(Path)-Len)
          else
            result := Path;
        end;
    end
  else
    result := Path;
end;

function MakePathSpecific(const Path: string; Enabled: boolean): string;
var
  DocumentsPart, CurrentUserPart: string;
  Len: integer;
begin
  if Enabled then
    begin
      Len           := Length(MY_DOCUMENTS_CONST);
      DocumentsPart := Copy(Path, 1, Length(MY_DOCUMENTS_CONST));
      if SameText(DocumentsPart, MY_DOCUMENTS_CONST) then
        result := GetMyDocuments + Copy(Path, Len+1, Length(Path)-Len)
      else
        begin
          Len             := Length(CURRENT_USER_CONST);
          CurrentUserPart := Copy(Path, 1, Length(CURRENT_USER_CONST));
          if SameText(CurrentUserPart, CURRENT_USER_CONST) then
            result := GetUserFolder + Copy(Path, Len+1, Length(Path)-Len)
          else
            result := Path;
        end
    end
  else
    result := Path;
end;

function  MatchesPattern(const aWord, Pattern: string): boolean;
var
  i: integer;
  mode: TSearch_Type;  // SEARCHING, SEARCH_FOUND, NOT_FOUND

begin
  i    := 0;
  mode := SEARCHING;
  repeat
    inc(i);
    if (i > Length(Pattern)) then
      mode := SEARCH_FOUND
    else
      if Pattern[i] = '?' then
        { consider it to be a match }
        else
      if Pattern[i] = '9' then
        begin
          if not (aWord[i] in ['0'..'9']) then
            mode := NOT_FOUND
        end
      else
        begin
          if aWord[i] <> Pattern[i] then
            mode := NOT_FOUND;
        end;
  until mode <> SEARCHING;

  result := mode = SEARCH_FOUND;
end;

procedure Message(const Msg: string);
begin
  MessageDlg(msg, mtInformation, [mbOk], 0);
end;

procedure MessageFmt(const Msg: string; Args: array of const);
begin
  Message(Format(Msg, Args));
end;

function Yes(msg: string): boolean;
begin
  Result := MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0)=mrYes;
end;

function YesFmt(Msg: string; Args: array of const): boolean;
begin
  result := Yes(Format(Msg, Args));
end;

function YYYYMMDD(DateTime: TDateTime): string;
var
  YYYY, MM, DD: word;
begin
  DecodeDate(DateTime, YYYY, MM, DD);
  result := RZero(YYYY, 4) + RZero(MM, 2) + RZero(DD, 2);
end;

function  YYYYMMDD_hhmmss_to_DateTime(const DateStr: string): TDateTime;
const
  BAD_DATE = -1;
// Converts a date string which has the format "20230808-075000..." to a TDateTime
var
  sYYYY: string[4];
  sMon:  string[2];
  sDD:   string[2];
  sHH:   string[2];
  sMin:  string[2];
  sSS:   string[2];

  Year   : integer;
  Month  : integer;
  Day    : integer;
  Hour   : integer;
  Min    : integer;
  Sec    : integer;
begin
  result := BAD_DATE;
  if Length(DateStr) >= 15 then
    begin
      sYYYY := Copy(DateStr, 1, 4);
      sMon  := Copy(DateStr, 5, 2);
      sDD   := Copy(DateStr, 7, 2);
      sHH   := Copy(DateStr, 10, 2);
      sMin  := Copy(Datestr, 12, 2);
      sSS   := Copy(DateStr, 14, 2);

      Year   := StrToIntSafe(sYYYY);
      Month  := StrToIntSafe(sMon);
      Day    := StrToIntSafe(sDD);

      Hour   := StrToIntSafe(sHH);
      Min    := StrToIntSafe(sMin);
      Sec    := StrToIntSafe(sSS);

      if IsValidDateTime(Year, Month, Day, Hour, Min, Sec, 0) then
        result := EncodeDateTime(Year, Month, Day, Hour, Min, Sec, 0);
    end;
end;

function DD_Mon_YYYY(DateTime: TDateTime): string;
var
  YYYY, MM, DD: word;
begin
  DecodeDate(DateTime, YYYY, MM, DD);
  result := RZero(DD, 2) + '-' + MonthName(MM, true)  + '-' + RZero(YYYY, 4);
end;

function  YYMMDD(DateTime: TDAteTime): string;
var
  YYYY, MM, DD: word;
begin
  DecodeDate(DateTime, YYYY, MM, DD);
  result := RZero(YYYY-2000, 2) + RZero(MM, 2) + RZero(DD, 2);
end;

Function FileExecute(FileName: String; WaitUntilDone: Boolean): Boolean;
var
  zAppName: array[0..512] of char;
  zCurDir:  array[0..255] of char;
  WorkDir:  String;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  ProcessResult : LongWord ;
begin
  StrPCopy(zAppName,FileName);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);


  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOW;
  Result := CreateProcess(nil,
    zAppName,                      { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) ;                 { pointer to PROCESS_INF }

  If Result And WaitUntilDone Then
    Begin
      WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
      GetExitCodeProcess(ProcessInfo.hProcess, ProcessResult);
    End;
end;

(*
function PrintableOnly(s: string): string;
  var
    i: integer; ch: char;
begin
  for i := Length(s) downto 1 do
    begin
      ch := UpCase(s[i]);
      if not (ch in ['A'..'Z', '0'..'9']) then
        Delete(s, i, 1);
    end;
  result := s;
end;
*)

function PrintableOnly2(s: string): string;
  var
    i: integer; 
begin
  for i := Length(s) downto 1 do
    begin
      if (s[i] < ' ') or (s[i] > '}') then
        Delete(s, i, 1);
    end;
  result := s;
end;


  function Calc_TextWidth(aCanvas : TCanvas; n: integer): integer;
  begin
    Result := aCanvas.TextWidth('0') * n;
  end;

function ChangeStringCase(cc: TCaseChange; const s: string): string;
begin
  case cc of
    ccToLower: { Lower }
      result := LowerCase(s);
    ccToUpper: { Upper }
      result := UpperCase(s);
    ccToProper: { Proper }
      result := ProperCase(s);
    ccToSentence: { Sentence Case }
      result := ProperCase(s, true);
  end;
end;

function CharName(BitNr: word): string;
begin { CharName }
  if (BitNr >= ord(' ')) and
     (BitNr < 127) then
    result := '''' + chr(BitNr) + ''''
  else
    result := '#' + IntToStr(BitNr);
end;  { CharName }

function  ChrTran(const Source, FromChar, ToChar: string): string;
var
  i, idx: integer; ch: char;
begin
  result := '';
  for i := 1 to Length(Source) do
    begin
      ch  := Source[i];
      idx := Pos(ch, FromChar);
      if idx <= 0 then
        result := result + ch   { not in FromChar - just copy it }
      else
        if idx <= Length(ToChar) then { if it is in ToChar, then substitute it }
          result := result + ToChar[Idx]
        else
          { beyond length of ToChar, just delete it };
    end;
end;

//  FUNCTION: PosCh
//  Input:
//        chars:  a string of characters- find the index of ANY ONE of these in the target
//        Target: string to search
//  Output:
//         result: the index of the first matching character that was found
//         (not necessarily the first of any possible match

function PosCH(chars: string; Target: string): integer;
var
  Done: boolean;
  ch: char; idx: integer;
begin
  idx  := 1; result := -1;
  done := (idx > Length(chars)) or (Length(Target) = 0);
  while not done do
    begin
      ch := chars[idx];
      inc(idx);
      result := Pos(ch, Target);
      if result > 0 then
        break;
      done := idx > Length(chars);
    end;
end;

procedure PrintStringGrid(const Title: string;
                           Grid: TStringGrid;
                           const OutFileName: string;
                           OpenOutputFile: boolean = false;
                           MaxColWidth: integer = 255);
var
  c, r: integer;
  MaxWidths: array of integer;
  OutFile: TextFile;
  aCell: string;
begin
  with Grid do
    begin
      // initialize max column widths
      SetLength(MaxWidths, ColCount);
      for c := 0 to ColCount-1 do
        MaxWidths[c] := 0;

      // scan for the max length of each column
      for c := 0 to ColCount-1 do
        for r := 0 to RowCount do
          if Length(Cells[c, r]) > MaxWidths[c] then
            MaxWidths[c] := Length(Cells[c, r]);

      // print the grid using the column widths previously determined
      AssignFile(OutFile, OutFileName);
      ReWrite(OutFile);
      WriteLn(OutFile, Title, ' Report. Generated on ', DateTimeToStr(Now));
      WriteLn(OutFile);
      try
        for r := 0 to RowCount-1 do
          begin
            for c := 0 to ColCount-1 do
              begin
                aCell := Padr(Cells[c, r], Min(MaxWidths[c], MaxColWidth));
                Write(OutFile, aCell, ' ');
              end;
            WriteLn(OutFile);
          end;
      finally
        CloseFile(OutFile);
        if OpenOutputFile then
          EditTextFile(OutFileName);
      end;
    end;
end;

function ProperCase(const S : string; FirstOnly: boolean = false) : string;
const
  WhiteSpace = [Char(0)..Char(32)];
type
  TStatus    = (atBegin, inWord, inNum, inAlphaNum, inWhiteSp, inDQuote, inApos,
                inPunct, afterSentence);
var
  LenStr     : Integer;
  ForceUpper : Boolean;
  I          : Integer;
  Status     : TStatus;
begin
  Result     := UpperCase(S);
  LenStr     := Length(S);
  ForceUpper := false;
  Status     := atBegin;
  try
    for I := 1 to LenStr do
      case S[I] of
        'A'..'Z',
        'a'..'z' : case Status of
                     afterSentence
                                 : Status := inWord;
                     atBegin,
                     inWhiteSp   : begin
                                     if FirstOnly and (Status <> atBegin) then
                                       result[i] := ToLower(result[i]);
                                     Status        := inWord;
                                   end;
                     inWord      : Result[I]     := ToLower(Result[I]);
                     inNum       : Status        := inAlphaNum;
                     inAlphaNum  : if ((not ForceUpper) and ((I = LenStr) or ((Result[I - 2] in DIGITS) and (Result[I + 1] in WhiteSpace)))) then
                                     begin
                                       Result[I - 1] := ToLower(Result[I - 1]);
                                       Result[I] := ToLower(Result[I]);
                                     end
                                   else
                                     ForceUpper  := true;
                     inApos      : begin
                                     if ((I > 2) and (Result[I - 2] in (ALPHA_UPPER - ['I']))) then
                                       begin
                                         // leave it uppercase
                                       end
                                     else
                                       Result[I] := ToLower(Result[I]);
                                     Status      := inWord;
                                   end;
                     inDQuote    : Status        := inWord;
                     inPunct     : Status        := inWord; // before it was, leave it uppercase
                   end;
        '.', '?', '!':   // sentence delimiters
                   begin
                     if FirstOnly then
                       Status    := afterSentence
                     else
                       Status    := inPunct;
                   end;
        '0'..'9' : case Status of
                     inWhiteSp,
                     atBegin     : begin
                                     Status      := inNum;
                                     ForceUpper  := false;
                                   end;
                     inWord      : begin
                                     Status      := inAlphaNum;
                                     ForceUpper  := true;
                                   end;
                     inApos      : Status        := inPunct;
                     inDQuote    : Status        := inNum;
                     inPunct,
                     inNum,
                     inAlphaNum  : // no change in mode
                   end;
        ''''     : case Status of
                     inWhiteSp,
                     atBegin,
                     inWord,
                     inDQuote    : Status       := inApos;
                     inApos,
                     inNum       : begin
                                     Status     := inAlphaNum;
                                     Forceupper := true;
                                   end;
                     inAlphaNum  : ForceUpper   := true;
                     inPunct     : // no change in mode
                   end;
        '"'      : case Status of
                     inWhiteSp,
                     atBegin     : Status := inDQuote;
                     inPunct,
                     inWord,
                     inNum,
                     inAlphaNum,
                     inApos,
                     inDQuote    : Status := inPunct;
                   end;
        #0..#32  : case Status of
                     inWhiteSp,
                     atBegin,
                     inPunct,
                     inWord,
                     inNum,
                     inAlphaNum,
                     inApos,
                     inDQuote    : begin
                                     Status     := inWhiteSp;
                                     ForceUpper := false;
                                   end;
                   end;
        #35..#38,
        #40..#45,
        #47,
        #58..#62,#64,
        #94..#96 : case Status of
                     inWhiteSp,
                     atBegin,
                     inPunct,
                     inWord,
                     inNum,
                     inAlphaNum,
                     inApos,
                     inDQuote    : begin
                                     Status     := inPunct;
                                     ForceUpper := false;
                                   end;
                   end;
      end;
//  Result := CheckPrefix(Result, LenStr);  // Converted "Mcdonald" to "McDonald"
  except
    Result := S;
  end;
end;

function  Quoted(const s: string): string;
begin
  if ContainsAny(s, [',', '''', ' ', '/', ':']) then
    result := '"' + s + '"'
  else
    result := s;
end;

function Radix26(n: integer; c: char): string;
var
  d: integer; ch: char;
begin
  result := '';
  repeat
    d := (n-1) mod 26;
    n := (n-1) div 26;
    ch := chr(d + ord(c));

    result := ch + result;
  until n = 0;
end;

function RandomStr(n : Integer) : string;
var
  s : string[100];
  i : Integer;
begin
  if (n <= 100) then
    begin
      s      := '';
      for i  := 1 to n do
        s    := s + Chr(Random(10) + Ord('0'));
      Result := s;
    end;
end;

function Right(const s: string; width: integer): string;
var
  LenStr : Integer;
begin { Right }
  LenStr := Length(S);
  if width < LenStr then
    result := copy(s, LenStr-width+1, width)
  else
    result := s;
end;  { Right }

function ToLower(ch: char): char;
begin { ToLower }
  if ch in ALPHA_UPPER then
    result := chr(ord(ch) - ord('A') + ord('a'))
  else
    result := CH;
end;  { ToLower }

function  ToUpper(ch: char): char;
begin
  if ch in ALPHA_LOWER then
    result := chr(ord(ch) - ord('a') + ord('A'))
  else
    result := CH;
end;

function TrimTrailing(const s: string; BadChars: TSetOfChar): string;
begin { TrimTrailing }
  result := s;
  while (length(result) > 0) and (result[Length(result)] in BadChars) do
    Delete(result, Length(result), 1);
end;  { TrimTrailing }

function UniqueFileName(const FileName: string): string;
var
  LoopCount: integer;
  TempFileName, FilePath, FileBase, FileExt: string;
begin { UniqueFileName }
  if not FileExists(FileName) then
    result := filename
  else
    begin
      LoopCount := 0;
      FilePath  := ExtractFilePath(FileName);
      FileBase  := ExtractFileBase(FileName);
      FileExt   := ExtractFileExt(FileName);
      repeat
        Inc(LoopCount);
        TempFileName := Format('%s%s (%d)%s', [FilePath, FileBase, LoopCount, FileExt]);
      until not FileExists(TempFileName);
      result := TempFileName;
    end;
end;  { UniqueFileName }

function FileNameByDate(const FileName: string): string;
var
  DOW, Idx: integer;
  FilePath, FileBase, FileExt, FileDayStr: string;
begin
  DOW        := DayOfTheWeek(Now);
  Idx        := ((DOW - 1)*4) + 1;
  FilePath   := ExtractFilePath(FileName);
  FileBase   := ExtractFileBase(FileName);
  FileExt    := ExtractFileExt(FileName);
  FileDayStr := Format(' (%s)', [Copy(DayNames, Idx, 3)]);
  result     := FilePath + FileBase + FileDayStr + FileExt;
end;


//*****************************************************************************
//   Function Name     : Wild_Match
//   Useage            : if Wild_Match(Strg, 'mp_*.pas', '*', '?') then...
//   Function Purpose  : Compare the string to the pattern
//   Parameters        : Strg = String to compare
//                       Pattern = Pattern to match it to
//                       ASTERISK = match any string character
//                       QUESTION = match any single characters
//   Return Value      : Returns TRUE iff string matches pattern
//*******************************************************************************}

function Wild_Match( strg, pattern: pchar;
                     ASTERISK, QUESTION: char;
                     CaseSensitive: boolean): boolean;
  const
    EOS = #0;
  var
    ch: char; Ok: boolean;
begin { Wild_Match }
  result := FALSE;
  if Pattern^ = '9' then
    result := strg^ in ['0'..'9'] else
  if pattern^ = ASTERISK then
    begin
       inc(pattern);
       repeat
         result := Wild_Match(strg, pattern, ASTERISK, QUESTION, CaseSensitive);
         ch     := strg^;
         inc(strg);
       until (result) or (ch = EOS); // bump strg
    end else
  if pattern^ = QUESTION then
    begin
     if strg^ <> EOS then
       result := Wild_Match(strg+1, pattern+1, ASTERISK, QUESTION, CaseSensitive);
    end else
  if pattern^ = EOS then
    begin
      if strg^ = EOS then
        result := TRUE;
    end
  else
    begin
      if CaseSensitive then
        Ok := Strg^ = Pattern^
      else
        Ok := UpCase(Strg^) = UpCase(Pattern^);
      if Ok then
        result := Wild_Match(strg+1, pattern+1, ASTERISK, QUESTION, CaseSensitive)
      else
        result := false;
    end;
end;  { Wild_Match }

function ShellMalloc: IMalloc;
begin
  if not Assigned(gShellMalloc) then
    OleCheck(SHGetMalloc(gShellMalloc));
  Result:= gShellMalloc;
end;

function AllocFileSystemPIDL(Path: string; var pidl: pItemIDList): HRESULT;
var
  ShellFolder: IShellFolder;
  Eaten: ULONG;
  Attributes: DWORD;
begin
  Result:= SHGetDesktopFolder(ShellFolder);
  if Succeeded(Result) then
    Result:= ShellFolder.ParseDisplayName(0, nil, pWideChar(WideString(Path)), Eaten, pidl, Attributes);
end;

function BrowseCallback(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
var
  pidlSelected: pItemIDList;
begin
  Result:= 0;
  try
    case uMsg of
      BFFM_INITIALIZED:
      begin
        if (pString(lpData)^<>'') and Succeeded(AllocFileSystemPIDL(pString(lpData)^, pidlSelected)) then
        try
          SendMessage(Wnd, BFFM_SETSELECTION, 0, Longint(pidlSelected));
        finally
          ShellMalloc.Free(pidlSelected);
        end;
      end;
{$ifNdef FPC}
BFFM_VALIDATEFAILED:
{$else}
BFFM_VALIDATEFAILEDA,
BFFM_VALIDATEFAILEDW:
{$endif}
begin
        Result:= 1;
        raise Exception.CreateFmt(SValidateFailed, [pChar(lParam)]);
      end;
    end;
  except
    Application.HandleException(nil);
  end;
end;

//*****************************************************************************
//   Function Name     : BrowseForFile
//   Useage            : if BrowseForFile('Specify file', FilePath, 'mdb'
//   Function Purpose  :
//   Assumptions       : Ext should not contain the period
//   Parameters        :
//   Return Value      : True if not cancelled. False otherwise
//*******************************************************************************}

function  BrowseForFile(Caption: string; var FilePath: string; Ext: string; aFilter: string = ''): boolean;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    with OpenDialog do
      begin
        Title      := Caption;
        DefaultExt := Ext;
        InitialDir := ExtractFilePath(FilePath);

        if aFilter = '' then
          Filter     := Format('File (*.%s)|*.%s', [Ext, Ext])
        else
          Filter     := aFilter;

        FileName   := FilePath;
        Options    := Options + [{ofNoValidate,} ofPathMustExist{, ofFileMustExist}];
        result     := Execute;
        if result then
          FilePath := FileName;
      end;
  finally
    OpenDialog.Free;
  end;
end;

function BrowseForFolderEx(Title: string; var Folder: string;
  pidlRoot: pItemIDList; Flags: UINT): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Path: array[0..MAX_PATH] of Char;
  pidlSelected: pItemIDList;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), 0);
  if Assigned(Screen.ActiveForm) then
    BrowseInfo.hwndOwner:= Screen.ActiveForm.Handle;
  BrowseInfo.pidlRoot:= pidlRoot;
  BrowseInfo.pszDisplayName:= @Path;
  BrowseInfo.lpszTitle:= pChar(Title);
  BrowseInfo.ulFlags:= Flags;
  BrowseInfo.lpfn:= BrowseCallback;
  BrowseInfo.lParam:= LPARAM(pString(@Folder));
  pidlSelected:= SHBrowseForFolder(BrowseInfo);
  Result:= pidlSelected<>nil;
  if Result then
  begin
    if SHGetPathFromIDList(pidlSelected, @Path) then
    begin
      Folder:= Path;
      if (Flags and BIF_RETURNONLYFSDIRS)<>0 then
        Folder:= IncludeTrailingBackslash(Folder);
    end;
    ShellMalloc.Free(pidlSelected);
  end;
end;

function BrowseForFolder(Title: string; var Folder: string): Boolean;
var
  pidlRoot: pItemIDList;
begin
  pidlRoot:= nil;
  if Folder='' then
    SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, pidlRoot);
  try
    Result:= BrowseForFolderEx(Title, Folder, pidlRoot, BIF_RETURNONLYFSDIRS or BIF_VALIDATE or $0050 {BIF_USENEWUI});
  finally
    if Assigned(pidlRoot) then
      ShellMalloc.Free(pidlRoot);
  end;
end;

function BuildFilterString(const Msg, Ext: string): string;
begin
  result := Format('%s (*.%s)|*.%s', [Msg, Ext, Ext]);
end;

function ComputerName : String;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

{*****************************************************************************
{   Function Name     : RemoveBadChars
{   Function Purpose  : Deletes any char in 'BadChars'
{*******************************************************************************}

function RemoveBadChars( s: string;
                         BadChars: TSetOfChar): string;
  var
    i      : integer;
begin { RemoveBadChars }

  { delete bad characters }

  i      := 1;
  while i <= Length(S) do
    if (s[i] in BadChars) then
      delete(s, i, 1)
    else
      inc(i);

  result := s;
end;  { RemoveBadChars }

function  RemoveRepeatedChar(const s: string; ch: char): string;
var
  i, Len: integer;
begin   // there is undoubtably a better algorithm than this
  result := s;    // default
  if Length(s) >= 2 then
    begin
      i := 1; Len := 0;
      repeat
        Inc(Len);
        Result[Len] := s[i];
        Inc(i);
        while (i <= Length(s)-1) and (s[i] = ch) and (s[i+1] = ch) do
          Inc(i);
      until i > Length(s);
      SetLength(result, len);
    end;
end;

function GetMyDocuments: string;
var
  Res: Bool;
  Path: array[0..Max_Path] of Char;
begin
  Res := ShGetSpecialFolderPath(0, Path, csidl_Personal, False);
  if not Res then
    raise Exception.Create('Could not determine My Documents path');
  Result := Path;
end;

function GetUserFolder: string;
var
  Res: Bool;
  PathC: array[0..Max_Path] of Char;
  Path: string;
begin
  Res := ShGetSpecialFolderPath(0, PathC, csidl_Personal, False);
  if Res then
    begin
      Path   := PathC;
      result := RemoveTrailingBackslash(ExtractFilePath(Path));
    end
  else
    raise Exception.Create('Could not determine USER path');
end;

procedure InflateRect(var Rect: TRect; Pixels: integer);
begin
  with Rect do
    begin
      Dec(Left, Pixels);
      Dec(Top,  Pixels);
      Inc(Right, Pixels);
      Inc(Bottom, Pixels);
    end;
end;

function InternetOpenShell(const Url: string): Boolean;
var
  ShellExecuteInfo: TShellExecuteInfo;
begin
{$ifNdef FPC}
  FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
  ShellExecuteInfo.cbSize:= SizeOf(ShellExecuteInfo);
  ShellExecuteInfo.lpVerb:= 'open';
  ShellExecuteInfo.lpFile:= pChar(Url);
  ShellExecuteInfo.nShow:= SW_NORMAL;
  Result:= ShellExecuteEx(@ShellExecuteInfo);
{$else}
  raise Exception.Create('Not implemented: InternetOpenShell');
{$endif}
end;

procedure CreateShortCut(ShortCut, Application, Parameters, WorkDir: string;
                         SW_State: Integer; IconFile: string; IconIndex: Byte);
var
  SCObject: IUnknown;
  SCSLink: IShellLink;
  SCPFile: IPersistFile;
  WFName: WideString;
begin
  SCObject := CreateComObject(CLSID_ShellLink);
  SCSLink := SCObject as IShellLink;
  SCPFile := SCObject as IPersistFile;
  SCSLink.SetPath(PChar(Application));
  SCSLink.SetArguments(PChar(Parameters));
  SCSLink.SetWorkingDirectory(PChar(WorkDir));
  SCSLink.SetShowCmd(SW_State);
  SCSLink.SetIconLocation(PChar(IconFile), IconIndex);
  WFName := ShortCut;
  SCPFile.Save(PWChar(WFName), False);
end;

procedure CreateLink(ObjectPath: string;   // path of the file/folder to create a shortcut
                     LinkPath: string;     // path of the newly created link/shortcut
                     Description : string);
begin
  CreateShortCut( LinkPath,
                  ObjectPath,
                  '',        { no parameters }
                  '',        { no working directory }
                  0,         { state }
                  ''         { IconFile },
                  0);        { Icon Index }
end;


function MyDeleteFile(const lfn: string; ReCycle: boolean = true; Confirm: boolean = true): boolean;
var
  SH: TSHFILEOPSTRUCT;
  P1: array [Byte] of Char;
begin
  result := false;
  if ReCycle then
    begin
      FillChar(SH, SizeOf(SH), 0);
      FillChar(P1, sizeof(P1),0);
      StrPCopy(P1, ExpandFileName(Lfn)+#0#0);
      with SH do
      begin
        Wnd    := Application.Handle;
        wFunc  := FO_DELETE;
        pFrom  := P1;
//      pTo    := nil;
        if ((Copy(Lfn, 1, 2) = '\\') and Confirm) then
          fFlags := FOF_FILESONLY or FOF_SILENT or FOF_ALLOWUNDO  // network drives cannot recycle-- warn the user
        else
          fFlags := FOF_FILESONLY or FOF_SILENT or FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
      end;
      Result := SHFileOperation(SH) = 0;
      if not result then
        ErrorFmt('Could not send the file "%s" to the recycle bin', [Lfn]);
    end
  else
    if (not Confirm) then
      result := SysUtils.DeleteFile(Lfn)
    else
      if YesFmt('Are you sure that you want to permanently delete the file "%s"', [lfn]) then
        result := SysUtils.DeleteFile(Lfn)
end;

function GetFileCreationTime(FileName: string): TDateTime;
var
   MyRec: TSearchRec;
begin
   Result := Now;

   if (FindFirst(FileName,faAnyFile,MyRec) = 0) then
   begin
      Result := SNL_FileTime2DateTime(MyRec.FindData.ftCreationTime);
      FindClose(MyRec); { *Converted from FindClose* }
   end;
end;

function  ScaledSize(n: double): string;
begin
  if n < 1024 then
    result := Format('%0.0n bytes', [n * 1.0]) else
  if n < (1024 * 1024) then
    result := Format('%0.2n Kb', [n / 1024]) else
  if n < (1024 * 1024 * 1024) then
    result := Format('%0.2n Mb', [n / (1024 * 1024)])
  else
    result := Format('%0.2n Gb', [n / (1024 * 1024 * 1024)]);
end;

procedure SetFileCreationTime(const FileName: string; const DateTime: TDateTime);
var
  Handle: THandle;
  SystemTime: TSystemTime;
  FileTime: TFileTime;
begin
  Handle := FileCreate(PChar(FileName)); { *Converted from CreateFile* }
  if Handle=INVALID_HANDLE_VALUE then
    RaiseLastOSError;
  try
    DateTimeToSystemTime(DateTime, SystemTime);
    if not SystemTimeToFileTime(SystemTime, FileTime) then
      RaiseLastOSError;
    if not SetFileTime(Handle, @FileTime, nil, nil) then
      RaiseLastOSError;
  finally
    FileClose(Handle); { *Converted from CloseHandle* }
  end;
end;

function FileExists(const FileName: string): boolean;  // standard routine doesn't always work!
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Result := SysUtils.FileExists(FileName);
  if not result then
    begin
      Handle := Windows.FindFirstFile(PChar(FileName), FindData);
      if Handle <> INVALID_HANDLE_VALUE then
        begin
          Windows.FindClose(Handle);
          result := true;
        end
    end
end;

function FileExistsSlow(const FileName: string): boolean;  // standard routine doesn't always work!
var
  F: file;
begin
  Result := SysUtils.FileExists(FileName);
  if not result then
    begin
      {$I-}
      AssignFile(F, FileName);
      Reset(F);
      CloseFile(F);
      {$I+}
      result := (IOResult = 0) and (FileName <> '');
    end
end;

procedure GridDrawCell(grid: TStringGrid; const ChangedRows: TChangedRows;
  ACol, ARow: Integer; Rect: TRect);
begin
  with Grid.Canvas do
    begin
      Font.Color := clBlack;  // Default color
      Brush.Color := clWhite;
      if ((ACol = 0) or (ARow = 0)) then   // First check if Fixed row or column
        Brush.Color := clBtnFace
      else
        if (ARow <= grid.RowCount) then  // Avoid empty row
          if Grid.Row = aRow then
            begin
              if ChangedRows[aRow] then
                begin
                  Font.Color  := clBlue;
                  Brush.Color := clYellow;
                end
              else
                begin
                  Font.Color  := clWhite;
                  Brush.Color := clBlue;
                end;
            end else
          if ChangedRows[aRow] then
            begin        // Will only color selected rows
              Font.Color  := clBlack;
              Brush.Color := clYellow;
            end;
      FillRect(Rect);
      TextOut(Rect.Left, Rect.Top, grid.Cells[ACol, ARow]);
    end;
end;

procedure SortGrid(Grid : TStringGrid; SortCol:integer);
{A simple exchange sort of grid rows}
var
   i,j : integer;
   temp: TStringList;
begin
  temp := tstringlist.create;
  with Grid do
    for i := FixedRows to RowCount - 2 do  {because last row has no next row}
      for j:= i+1 to rowcount-1 do {from next row to end}
        if AnsiCompareText(Cells[SortCol, i], Cells[SortCol, j]) > 0 then
          begin
            temp.Assign(rows[j]);
            rows[j].Assign(rows[i]);
            rows[i].Assign(temp);
          end;
  temp.free;
end;

procedure DeleteGridRow(yourStringGrid: TStringGrid; ARow: Integer);
var i: Integer;
begin
  with yourStringGrid do
  begin
    for i := ARow to RowCount-2 do
      Rows[i].Assign(Rows[i+1]);
    RowCount := RowCount - 1
  end;
end;

procedure DeleteTrailingChar(var s: string; ch: char);
begin
  if Length(s) > 0 then
    if s[Length(s)] = ch then
{      Delete(s, Length(s), 1); }
      SetLength(s, Length(s)-1);
end;

procedure SortGridNumeric(Grid : TStringGrid; SortCol:integer);
var
   i,j : integer;
   temp:tstringlist;
begin
  temp := tstringlist.create;
  with Grid do
    for i := FixedRows to RowCount - 2 do  {because last row has no next row}
      for j := i+1 to rowcount-1 do {from next row to end}
        try
          if StrToFloat(Cells[SortCol, i]) > StrToFloat(Cells[SortCol,j]) then
            begin
              temp.assign(rows[j]);
              rows[j].assign(rows[i]);
              rows[i].assign(temp);
            end;
        except
          { ignore it }
        end;
  temp.free;
end;

procedure SortGridByDate(Grid : TStringGrid; SortCol:integer);
var
   i,j : integer;
   temp:tstringlist;
begin
  temp := tstringlist.create;
  with Grid do
    for i := FixedRows to RowCount - 2 do  {because last row has no next row}
      for j := i+1 to rowcount-1 do {from next row to end}
        try
          if StrToDateTime(Cells[SortCol, i]) > StrToDateTime(Cells[SortCol,j]) then
            begin
              temp.assign(rows[j]);
              rows[j].assign(rows[i]);
              rows[i].assign(temp);
            end;
        except
          { ignore it }
        end;
  temp.free;
end;

var
  i: integer;

initialization
  DELIM_SET := [];
  for i := 1 to Length(DELIMS) do
    DELIM_SET := DELIM_SET + [DELIMS[I]];
  ANY_ALPHA   := ALPHA_UPPER + ALPHA_LOWER;
  IDENT_CHARS := ANY_ALPHA + DIGITS + ['_'];
  HEX_DIGITS  := NUMERIC + ['A'..'F', 'a'..'f'];
end.

