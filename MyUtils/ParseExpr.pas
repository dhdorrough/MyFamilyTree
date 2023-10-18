unit ParseExpr;

//    dhd 12/21/2010 Implement the FilePaths() function
// 14 dhd 08/05/2010 Wasn't changing internal field pointers when referencing a different dataset
//        06/28/2010 Make use of IsNull when evaluating Empty()

interface

  uses Classes, DB, DBTables, SysUtils, Types, Variants;

  const
    MAX_FUNCTION_ARGS = 4; { Max function arguments }
    BAD_DATE          = -1;
    LEFTDISPLAYNAMEDEL       = '[';
    RIGHTDISPLAYNAMEDEL      = ']';

  type
    ESyntaxError = class(exception);
    ERecordNotFound = class(Exception);

    TType_of_Symbol = ( symUnknown,
                        symStrRef,
                        symIntRef,
                        symFloatRef,
                        symBoolRef,
                        symDateRef,
                        symVariantRef,
                        symLeftParen,
                        symRightParen,
                        symNot,
                        symTimes,
                        symDividedBy,
                        symAnd,
                        symPlus,
                        symMinus,
                        symOr,
                        symLt,
                        symLe,
                        symGt,
                        symGe,
                        symEq,
                        symNe,
                        symIncludes,
                        symExcludes,
                        symSoundsLike,
                        symFunction,
                        symEmpty,
                        symNotEmpty,
                        symUnsNum,
                        symCharStr,
                        symDate,
                        symBooleanConst,
                        symNegate,
                        symNoop,
                        symComma,
                        symEOS);


  TAvailable_Function_Calls = (funcBad, funcEmpty, funcChar, funcWord,
                               funcConsonants, funcNumeric, funcSoundex,
                               funcLeft, funcRight, funcSubStr, funcUpper,
                               funcLower, funcLength, funcPadr, funcYearOf,
                               funcMonthOf, funcDayOf, funcAbs, funcPos,
                               funcTimeOfDay, funcApproxEqual,
                               funcExtra, funcExtractFilePath, funcExtractFileName,
                               funcExtractFileBase, funcFileExists, funcFileAge, 
                               funcTrunc, funcToday, funcIsNumeric, funcContainsAny,
                               funcContainsAnyPunct, funcTrim,
                               funcEncodeDate, funcDaysInMonth, funcIncMonth,
                               funcFileModifiedDateTime, funcIncludesAnyOf, funcRecNo,
                               funcFileCreatedDateTime, funcRandom, funcChrTran, funcChangeStringCase);

  TTypes_List   = array[TFieldType] of string;

  TParser = class;
  TEval_Tree = class;

  TRectangle = record
                 Left, Top, Right, Bottom: double;
               end;

  TEval_Func = procedure {name}(Eval_Tree: TEval_Tree) of object;

  TAvailable_Function = class;

  TCallBackFunction = procedure {name}(fp: TAvailable_Function) of object;

  TAvailable_Function = class
                          fn   : string;         { function_name }
                          rt   : TFieldType;     { result type }
                          ac   : shortint;       { Arg count }
                          at   : array[1..MAX_FUNCTION_ARGS] of
                                   TType_of_Symbol;{ Arg type }
                          LLink: TAvailable_Function;
                          RLink: TAvailable_Function;
                          FuncCode: TAvailable_Function_Calls;
                          ExtraFunc: TEval_Func;
                          ProtoType: string;
                          fFunction: TAvailable_Function;
                        Destructor Destroy; override;
                        procedure TraverseSubTree(CallBackFunction: TCallBackFunction);
                        end;

  TCharSet = set of char;

(*
const

    Type_Strings: TTypes_List = ( 'Unknown',
                                  'String',
                                  'Smallint',
                                  'Integer',
                                  'Word',
                                  'Boolean',
                                  'Float',
                                  'Currency',
                                  'BCD',
                                  'Date',
                                  'Time',
                                  'DateTime',
                                  'Bytes',
                                  'VarBytes',
                                  'AutoInc',
                                  'Blob',
                                  'Memo',
                                  'Graphic',
                                  'FmtMemo',
                                  'ParadoxOle',
                                  'DBaseOle',
                                  'TypedBinary',
                                  'Cursor',
                                  'FixedChar',
                                  'WideString',
                                  'Largeint',
                                  'ADT',
                                  'Array',
                                  'Reference',
                                  'DataSet',
                                  'OraBlob',
                                  'OraClob',
                                  'Variant',
                                  'Interface',
                                  'IDispatch',
                                  'Guid',
                                  'TimeStamp',
                                  'FMTBcd');

type
*)
  TEval_Tree = class
  private
    fField    : TField;
    fParser   : TParser;
    fLastChars: string;
    fCharSet  : TCharSet;
    fHasLocation: boolean;

    function GetField: TField;
    function GetAsBoolean: Boolean;
    function GetAsDateTime: TDateTime;
    function GetAsFloat: Double;
    function GetAsInteger: Longint;
    function GetAsString: string;
    function GetAsVariant: variant;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsFloat(const Value: Double);
    procedure SetAsInteger(const Value: Longint);
    procedure SetAsString(const Value: string);
    procedure SetAsVariant(const Value: variant);
    procedure RaiseConversionError(const DesiredResultType: string);
    function GetTable: TDataSet;
    function GetAsTime: TDateTime;
    procedure SetAsTime(const Value: TDateTime);
    function GetCase_Sensitive: boolean;
    procedure SetHasLocation(const Value: boolean);
  public
    Left_Expr        : TEval_Tree;
    right_expr       : TEval_Tree;
    Arg              : array[1..MAX_FUNCTION_ARGS] of TEval_Tree;
    Arg_Count        : integer;
    Operator         : TType_of_Symbol;
    Func_Code        : TAvailable_Function_Calls;
    Node_Type        : TFieldType;
    fBool_Val        : Boolean;
    fFieldName       : string;
    fDate_Val        : TDateTime;
    fFloat_Val       : Double;
    fInt_Val         : Longint;
    fVariant_Val     : Variant;
    fStringValue     : string;
    IsNull           : boolean;
    fLat             : double;
    fLon             : double;
    fAbbrev          : string;
    fFunction        : TAvailable_function;
    LastLocationID   : integer;

    constructor Create(aParser: TParser);
    destructor Destroy; override;

    procedure Evaluate(aTable: TDataSet; case_sensitive: boolean{; aPad_Fields: boolean});
    procedure EvaluateTree;
    property Case_Sensitive: boolean
             read GetCase_Sensitive;
    property Field         : TField
               read GetField
               write fField;
    property AsBoolean     : Boolean
               read GetAsBoolean
               write SetAsBoolean;
    property AsDateTime    : TDateTime
               read GetAsDateTime
               write SetAsDateTime;
    property AsInteger     : Longint
               read GetAsInteger
               write SetAsInteger;
    property AsFloat       : Double
               read GetAsFloat
               write SetAsFloat;
    property AsString      : string
               read GetAsString
               write SetAsString;
    property AsTime        : TDateTime
               read GetAsTime
               Write SetAsTime;
    property AsVariant: variant
               read GetAsVariant
               write SetAsVariant;
    property Table: TDataSet
             read GetTable;
    property HasLocation      : boolean
               read fHasLocation
               write SetHasLocation;
  end;

  Symbol_Type = record
    Type_of_Symbol : TType_of_Symbol;
    StringVal      : string;
    IntVal         : longint;
    DateVal        : TDateTime;
    FloatVal       : Double;
    BoolVal        : boolean;
  end;

  TFunc_Call_Data = Array of
                      TAvailable_Function;

  TParser = class
  private
    fCase_Sensitive: boolean;
    ch         : char;
//  fFunction  : TAvailable_Function;
    fIdx       : Integer;
    fRootNode  : TAvailable_Function;
    fSymbol    : Symbol_Type;
    fTable     : TDataSet;
    fText      : string;
    fFunction_Count: integer;

    function Parse_Expression(var Symbol: Symbol_Type): TEval_Tree;
    function Parse_Simple_Expression(var Symbol: Symbol_Type): TEval_Tree;
    function Parse_Term(var Symbol: Symbol_Type): TEval_Tree;
    function Parse_Factor(var Symbol: Symbol_Type): TEval_Tree;
    procedure InSymbol(var Symbol: Symbol_type);
    function Variable_Reference( name: string): TType_of_Symbol;
    procedure Skip_Blanks;
    procedure NextCh;
    function ReadString(CharSet: TCharSet): string;
    procedure ReadQuotedString;
    function Categorize(var aWord : string): TType_of_Symbol;
    function Parse_Function_Call(var Symbol: Symbol_Type): TEval_Tree;
    function GetFunctionData(function_Name: string): TAvailable_Function;
    procedure InsertFuncNode(var RootNode: TAvailable_Function; aNode: TAvailable_Function);
    procedure FreeFuncNodes;
    procedure ReadDisplayName;
    procedure RaiseError(const Msg: string);
    procedure RaiseErrorFmt(const Msg: string; Args: array of const);
    function ReadDateTimeString: string;
  protected
    procedure AddOptionalFunctionsToParser; virtual;
  public
    property  Case_Sensitive: boolean
              read fCase_Sensitive
              write fCase_Sensitive;
    property Condition: string read fText;
    function GenFunctionPrototype(func: TAvailable_Function): string;
    function GetFunctionPrototype(func: TAvailable_Function): string;
    procedure InitFunc( aFuncCode: TAvailable_Function_Calls;
                        FuncName: string; result_type: TFieldType; Min_Args, Max_Args: byte;
                        arg1_type, arg2_type, arg3_type, arg4_type: TType_of_Symbol;
                        const aProtoType: string = '';
                        Eval_Func: TEval_Func = nil);
    property RootNode: TAvailable_Function
             read fRootNode;
  published
    Eval_Tree  : TEval_Tree;
    constructor Create;
    destructor Destroy; override;
    function Valid_Expr(     theExpr : string;
                             aTable  : TDataSet;
                         var ErrorMsg : string): boolean;
    procedure Clear;
    property Table: TDataSet
             read fTable
             write fTable;
    property Function_Count: integer
             read fFunction_Count
             write fFunction_Count;
  end;

  EConversionError   = class(Exception);

const
  SymSet_FieldRef        = [symStrRef, symIntRef,  symFloatRef, symBoolRef,
                            symDateRef, symVariantRef];
  NUMERIC_TYPES       = [ftAutoInc, ftFloat, ftBCD, ftInteger, ftWord, ftSmallint, ftLargeint, ftVariant];

    Type_Strings: TTypes_List = ( 'Unknown',
                                  'String',
                                  'Smallint',
                                  'Integer',
                                  'Word',
                                  'Boolean',
                                  'Float',
                                  'Currency',
                                  'BCD',
                                  'Date',
                                  'Time',
                                  'DateTime',
                                  'Bytes',
                                  'VarBytes',
                                  'AutoInc',
                                  'Blob',
                                  'Memo',
                                  'Graphic',
                                  'FmtMemo',
                                  'ParadoxOle',
                                  'DBaseOle',
                                  'TypedBinary',
                                  'Cursor',
                                  'FixedChar',
                                  'WideString',
                                  'Largeint',
                                  'ADT',
                                  'Array',
                                  'Reference',
                                  'DataSet',
                                  'OraBlob',
                                  'OraClob',
                                  'Variant',
                                  'Interface',
                                  'IDispatch',
                                  'Guid',
                                  'TimeStamp',
                                  'FMTBcd');

implementation

  uses
    StStrL, MyUtils, DateUtils, Math;

  const
    alpha     = ['A'..'Z', 'a'..'z'];
    numeric   = ['0'..'9'];
    quotes    = ['''', '"'];
    signs     = ['+', '-'];
    EOS       = #0;
    SNoSuchField = 'No such field: %s';
    UNEXPECTED_NODE_TYPE_CHANGE = 'Unexpected Node_Type change';

    SInvalidConversionTo     = 'Invalid Conversion %s to %s';

type

  EMissingExpression = class(ESyntaxError);
  ENonCompatible = class(ESyntaxError);
  ENoSuchField = class(ESyntaxError);

function ExpressionTypeName(tos: TType_of_Symbol): string;
begin
  if tos in [symStrRef] then
    result := 'Str' else
  if tos in [symDateRef] then
    result := 'Date' else
  if tos in [symFloatRef] then
    result := 'Float' else 
  if tos in [symIntRef] then
    result := 'Int' else
  if tos in [symVariantRef] then
    result := 'Variant'
  else
    result := 'Unknown';
end;

destructor TParser.Destroy;
begin
  Clear;
  FreeFuncNodes;
  inherited Destroy;
end;

procedure TParser.Clear;
begin
  Eval_Tree.Free;
  Eval_Tree := nil;
  fText     := '';
end;

procedure TParser.FreeFuncNodes;
begin
  fRootNode.Free;
end;

function TParser.GetFunctionPrototype(func: TAvailable_Function): string;
begin
  result := func.Prototype;
end;

function TParser.GenFunctionPrototype(func: TAvailable_Function): string;
var
  an: integer;
begin
  with func do
    begin
      result := Format('%s(', [fn]);
      for an := 1 to ac do
        begin
          if at[an] <> symUnknown then
            result := Format('%s[%s]', [result, ExpressionTypeName(at[an])]);
          if an < ac then
            result := result + ', ';
        end;
      result := result + ')';
    end;
end;

{*****************************************************************************
{   Function Name     : InitFunc
{   Useage            :
{   Function Purpose  : Init the TFunc_Call_Data array
{*******************************************************************************}

  procedure TParser.InitFunc ( aFuncCode  : TAvailable_Function_Calls;
                               FuncName   : string;
                               result_type: TFieldType;  { result type }
                               Min_Args   : byte;
                               Max_Args   : byte;
                               arg1_type  : TType_of_Symbol;
                               arg2_type  : TType_of_Symbol;
                               arg3_type  : TType_of_Symbol;
                               arg4_type  : TType_of_Symbol;
                         const aProtoType: string = '';
                               Eval_Func  : TEval_Func = nil);
  var
    Func: TAvailable_Function;
  begin { InitFunc }
//  Assert(Min_Args = Max_Args, 'System error'); // must be true for now - variable number of arguments not handled yet
    Assert(Max_Args <= 4, 'System error'); // must be true for now - cannot handle moe than 4 arguments

    Function_Count   := Function_Count + 1;
    Func := TAvailable_Function.Create;
    with Func do
      begin
        fn          := FuncName;
        rt          := Result_Type;
        ac          := Max_Args;
        at[1]       := arg1_type;
        at[2]       := arg2_type;
        at[3]       := arg3_type;
        at[4]       := arg4_type;
        ExtraFunc   := Eval_Func;
        FuncCode    := aFuncCode;
        if not Empty(aProtoType) then
          ProtoType := aProtoType
        else
          ProtoType   := GenFunctionPrototype(Func);
      end;
    InsertFuncNode(fRootNode, Func);
  end;  { InitFunc }

procedure TParser.InsertFuncNode(var RootNode: TAvailable_Function; aNode: TAvailable_Function);
  var
    n: integer;
begin
  if not Assigned(RootNode) then
    RootNode := aNode
  else
    begin
      n := CompareText(aNode.fn, RootNode.Fn);
      if n > 0 then
        InsertFuncNode(RootNode.Rlink, aNode) else
      if n < 0 then
        InsertFuncNode(RootNode.LLink, aNode)
      else
        raise Exception.CreateFmt('System error in InsertFuncNode [%s] (two function nodes with same name)',
                                  [aNode.Fn]); // we should never be inserting two nodes with the same name
    end;
end;

  procedure TParser.NextCh;
  begin { TParser.NextCh }
    if fIdx <= length(fText) then
      begin
        ch := fText[fIdx];
        inc(fIdx);
      end
    else
      ch := EOS;
  end;  { TParser.NextCh }

  procedure TParser.Skip_Blanks;
  begin { TParser.Skip_Blanks }
    while Ch in [' ', #9, #13, #10] do
      NextCh;
  end;  { TParser.Skip_Blanks }

  function TParser.ReadString(CharSet: TCharSet): string;
  begin { TParser.ReadString }
    result := '';
    repeat
      result := result + ch;
      NextCh;
    until not (ch in CharSet);
  end;  { TParser.ReadString }

  function TParser.ReadDateTimeString: string;
  begin
    result := '';
    repeat
      result := result + ch;
      NextCh;
    until (ch = '}') or (ch = EOS);
  end;

  procedure TParser.ReadQuotedString;
    var
      OpenQuote : char;
  begin { TParser.ReadQuotedString }
    OpenQuote := ch;
    NextCh;
    while not (ch in [OpenQuote, EOS]) do
      begin
        fSymbol.StringVal := fSymbol.StringVal + ch;
        NextCh;
      end;
    NextCh;
  end;  { TParser.ReadQuotedString }

  procedure TParser.ReadDisplayName;
  var
    DisplayName : string;
  begin
    DisplayName := '';
    NextCh;
    while (not (Ch in [RIGHTDISPLAYNAMEDEL, EOS])) do
      begin
        DisplayName := DisplayName + Ch;
        NextCh;
      end;
    DisplayName := TrimRight(DisplayName);  // trailing blanks not permitted
    if (Ch <> RIGHTDISPLAYNAMEDEL) then
      RaiseError(RIGHTDISPLAYNAMEDEL + ' expected.');

    if Assigned(fTable) {and (not NoRaiseNoField)} then
      begin
        fSymbol.StringVal := DisplayName;

        fSymbol.Type_Of_Symbol := Variable_Reference(fSymbol.StringVal);
        if (fSymbol.type_of_Symbol = symUnknown) then
          raise ENoSuchField.CreateFmt(SNoSuchField, [fSymbol.StringVal]);
      end;

    NextCh;
  end;

  function TParser.Categorize(var aWord : string): TType_of_Symbol;
  begin { TParser.Categorize }
    aWord := Uppercase(aWord);
    if aWord = 'AND' then
      Categorize := symAnd else
    if aWord = 'OR' then
      Categorize := symOr else
    if aWord = 'NOT' then
      Categorize := symNot else
    if aWord = 'INCLUDES' then
      Categorize := symIncludes else
    if aWord = 'EXCLUDES' then
      Categorize := symExcludes else
    if aWord = 'SOUNDS_LIKE' then
      Categorize := symSoundsLike else
    if (aWord = 'TRUE') or (aWord = 'FALSE') then
      Categorize := symBooleanConst else
    if (Assigned(GetFunctionData(aWord))) and (ch = '(') then
      Categorize := symFunction
    else
      Categorize := Variable_Reference(aWord);
  end;  { TParser.Categorize }

  procedure TParser.InSymbol(var Symbol: Symbol_type);

    procedure ReadNumber;
      var
        Sign: integer;
        SignStr, ExpStr: string;
        Exp: integer;
    begin { ReadNumber }
      with Symbol do
        begin
          StringVal      := ReadString(NUMERIC + ['.']);
          Type_of_Symbol := symUnsNum;
          try
            FloatVal := StrToFloat(StringVal);
            try
              IntVal := Trunc(FloatVal);
            except
              on ERangeError do
                IntVal := StrToInt(StringVal);
            else
              raise;
            end;
            Skip_Blanks;
            if Ch in ['E', 'e'] then
              begin
                NextCh;
                Skip_Blanks;
                if Ch in NUMERIC + ['+', '-'] then
                  begin
                    Sign    := +1;
                    SignStr := '';
                    if Ch in ['+', '-'] then
                      begin
                        SignStr := Ch;
                        Sign    := IIF(Ch='+', +1, -1);
                        NextCh;
                        Skip_Blanks;
                      end;
                    ExpStr    := ReadString(NUMERIC);
                    Exp       := StrToInt(ExpStr);
                    StringVal := Format('%sE%s%s',
                                        [StringVal, SignStr, ExpStr]);
                    FloatVal  := FloatVal * IntPower(10, Sign*Exp);
                  end;
              end;
          except
            raise ESyntaxError.CreateFmt('Invalid floating point number: %s',
                                         [StringVal]);
          end;
        end;
    end;  { ReadNumber }

  begin { TParser.InSymbol }
    with Symbol do
      begin
        StringVal   := '';
        IntVal      := 0;
        Type_of_Symbol := symUnknown;
        Skip_Blanks;
        if ch = EOS then
          Type_of_Symbol := symEOS else
        if ch in Alpha then
          begin
            StringVal := ReadString(alpha+numeric+['_']);
            Type_of_Symbol := Categorize(StringVal);
            if Type_of_Symbol = symBooleanConst then
              begin
                if StringVal = 'TRUE' then
                  Boolval := TRUE else
                if StringVal = 'FALSE' then
                  BoolVal := FALSE
                else
                  raise ESyntaxError.Create('System error: '+StringVal);
              end
          end else
        if ch in Numeric then
          ReadNumber else
        if ch in Quotes then
          begin
            ReadQuotedString;
            Type_of_Symbol := symCharStr;
          end else
        if ch = '(' then
          begin
            StringVal := '(';
            Type_of_Symbol := symLeftParen;
            NextCh;
          end else
        if ch = ')' then
          begin
            StringVal := ')';
            Type_of_Symbol := symRightParen;
            NextCh;
          end else
        if Ch = LEFTDISPLAYNAMEDEL then {'['}
          begin
            ReadDisplayName;
          end else
        if ch in Signs then
          begin
            if ch = '+' then
              Type_of_Symbol := symPlus else
            if ch = '-' then
              Type_of_Symbol := symMinus;
            StringVal := ch;
            NextCh;
          end else
        if ch = '=' then
          begin
            Type_of_Symbol := symEq;
            StringVal := '=';
            NextCh;
          end else
        if ch = '<' then
          begin
            Type_of_Symbol := symLt;
            NextCh;
            if ch = '=' then
              begin
                Type_of_Symbol := symLe;
                StringVal := '<=';
                NextCh;
              end else
            if ch = '>' then
              begin
                Type_of_Symbol := symNe;
                StringVal := '<>';
                NextCh;
              end;
          end else
        if ch = '>' then
          begin
            Type_of_Symbol := symGt;
            NextCh;
            if ch = '=' then
              begin
                Type_of_Symbol := symGe;
                StringVal := '>=';
                NextCh;
              end else
          end else
        if ch = '*' then
          begin
            Type_Of_Symbol := symTimes;
            StringVal := '*';
            NextCh;
          end else
        if ch = '/' then
          begin
            Type_Of_Symbol := symDividedBy;
            StringVal := '/';
            NextCh;
          end else
        if ch = ',' then
          begin
            Type_Of_Symbol := symComma;
            StringVal := ',';
            NextCh;
          end else
        if ch = '{' then
          begin
            NextCh;
//          StringVal := ReadString(numeric + [DateSeparator]);
            StringVal := ReadDateTimeString;
            Type_of_Symbol := symDate;
            if ch <> '}' then
              RaiseError('Unexpected character <'+ch+'>');
            NextCh;
            Symbol.DateVal := StrToDateTime(Symbol.StringVal);
          end
        else
          RaiseError('Unexpected character <'+ch+'>');
      end;
  end;  { TParser.InSymbol }

  function TParser.Variable_Reference( name: string): TType_of_Symbol;
    var
      aField : TField;
  begin { TParser.Variable_Reference }
    result := symUnknown;
    try
      aField := fTable.FieldByName(name);
      case aField.DataType of
        ftString, ftWideString, ftMemo:
          result := symStrRef;
        ftInteger, ftSmallint, ftWord, ftAutoInc:
          result := symIntRef;
        ftBoolean:
          result := symBoolRef;
        ftDate, ftDateTime:
          result := symDateRef;
        ftFloat, ftBCD, ftCurrency:
          result := symFloatRef;
        ftVariant:
          result := symVariantRef;
      end;

    except
      raise ENoSuchField.CreateFmt(SNoSuchField, [fSymbol.StringVal]);
    end;
  end;  { TParser.Variable_Reference }

  function TParser.Parse_Factor(var Symbol: Symbol_type): TEval_Tree;
  begin { TParser.Factor }
    result := nil;
    try
      if Symbol.type_of_Symbol = symUnsNum then
        begin
          result          := TEval_Tree.Create(self);
          with result do
            begin
              Operator  := symUnsNum;
              if Symbol.IntVal = Symbol.FloatVal then
                AsInteger := Symbol.IntVal
              else
                AsFloat   := Symbol.FloatVal;
            end;
          InSymbol(Symbol);
        end else
      if Symbol.Type_of_Symbol = symCharStr then
        begin
          result          := TEval_Tree.Create(self);
          with result do
            begin
              Operator    := symCharStr;
              AsString    := Symbol.StringVal;
              Node_Type   := ftString;
            end;
          InSymbol(Symbol);
        end else
      if Symbol.Type_of_Symbol = symDate then
        begin
          result          := TEval_Tree.Create(self);
          with result do
            begin
              Operator    := symDate;
              AsDateTime  := Symbol.DateVal;
              Node_Type   := ftDateTime;
            end;
          InSymbol(Symbol);
        end else
      if Symbol.Type_of_Symbol = symBooleanConst then
        begin
          result           := TEval_Tree.Create(self);
          with result do
            begin
              operator   := symBooleanConst;
              AsBoolean  := Symbol.BoolVal;
              Node_Type  := ftBoolean;
            end;
          InSymbol(Symbol);
        end else
      if Symbol.Type_of_Symbol in [symStrRef, symIntRef, symBoolRef, symDateRef,
                                   symFloatRef, symVariantRef] then
        begin
          result          := TEval_Tree.Create(self);
          with result do
            begin
              Operator := Symbol.Type_of_Symbol;
              fFieldName := Symbol.StringVal;
              case Symbol.Type_of_Symbol of
                symStrRef:
                  Node_Type := ftString;
                symIntRef:
                  Node_Type := ftInteger;
                symBoolRef:
                  Node_Type := ftBoolean;
                symDateRef:
                  Node_Type := ftDateTime;
                symFloatRef:
                  Node_Type := ftFloat;
                symVariantRef:
                  Node_Type := ftVariant;
              end;
            end;
          InSymbol(Symbol);
        end else
      if Symbol.Type_of_Symbol = symLeftParen then
        begin
          InSymbol(Symbol);
          result := Parse_Expression(Symbol);
          if Symbol.type_of_Symbol = symRightParen then
            InSymbol(Symbol)
          else
            RaiseError(') expected');
        end else
      if Symbol.type_of_Symbol in [symMinus, symPlus] then
        begin
          result := TEval_Tree.Create(self);
          with result do
            begin
              if Symbol.type_of_Symbol = symMinus then
                operator := symNegate
              else
                operator := symNoop;
              Node_Type := ftInteger;
              InSymbol(Symbol);
              Left_Expr := parse_factor(Symbol);
            end;
        end else
      if Symbol.type_of_Symbol = symNot then
        begin
          InSymbol(Symbol);
          result := TEval_Tree.Create(self);
          with result do
            begin
              Operator  := symNot;
              Node_Type := ftBoolean;
              Left_Expr := parse_factor({Left_Expr,} Symbol);
            end;
        end else
      if Symbol.type_of_symbol = symFunction then
        result := Parse_Function_Call(Symbol)
      else
        begin
          if Assigned(result) then
            FreeAndNil(result);
          RaiseErrorFmt('Unexpected Symbol "%s"', [Symbol.StringVal]);
        end;
    except
      on e:Exception do
        begin
          if Assigned(result) then
            FreeAndNil(result);
          RaiseError('Invalid factor');
        end;
    end;
  end;  { TParser.Factor }

  function TParser.GetFunctionData(Function_Name: string): TAvailable_Function;
    var
      mode        : TSearch_Type;
      ptr         : TAvailable_Function;
      n           : integer;
  begin { TParser.GetFunctionData }
    ptr  := fRootNode;
    mode := SEARCHING;
    repeat
      if ptr = nil then     // can't find it
        mode := NOT_FOUND
      else
        begin
          n   := CompareText(Function_Name, ptr.fn);
          if n = 0 then         // this is it
            mode := SEARCH_FOUND else
          if n > 0 then         // descend the right branch
            ptr := ptr.Rlink
          else { n < 0 }        // descend the left branch
            ptr := ptr.LLink;
        end;
    until mode <> SEARCHING;

    if (mode = SEARCH_FOUND) {and FunctionAvailable(ptr.FuncCode)} then
      result := ptr
    else
      result := nil;
  end;  { TParser.GetFunctionData }


  function TParser.Parse_Function_Call(var Symbol: Symbol_Type): TEval_Tree;
  var
    TempFp: TAvailable_Function;
    FuncName: string;
  begin { TParser.Parse_Function_Call }
    result   := nil;
    try
      FuncName := Symbol.StringVal;
      TempFP   := GetFunctionData(FuncName);
      if Assigned(TempFP) then
        begin
          InSymbol(Symbol);
          if Symbol.Type_Of_Symbol = symLeftParen then
            begin
              InSymbol(Symbol);
              result := TEval_Tree.Create(self);
              with result do
                begin
                  fFunction := TempFP;
                  Arg_Count := 0;
                  Operator  := symFunction;
                  Node_Type := fFunction.rt;
                  Func_Code := fFunction.FuncCode;
                  if fFunction.ac > 0 then { has at least one argument }
                    repeat
                      Arg[Arg_Count+1] := Parse_Expression(Symbol);
                      inc(Arg_Count);
                      if Arg_Count < fFunction.ac then
                        if Symbol.type_of_symbol = symComma then
                          InSymbol(Symbol)
                        else
                          RaiseErrorFmt('Comma expected in function %s', [FuncName]);
                    until (Arg_Count = fFunction.ac) or (Symbol.type_of_Symbol = symRightParen);
                end;
              if Symbol.type_of_Symbol = symRightParen then
                InSymbol(Symbol)
              else
                RaiseErrorFmt(') expected in function %s', [FuncName]);
            end
          else
            RaiseErrorFmt('Left Paren Expected in function %s', [FuncName]);
        end
      else
        RaiseError('Unknown function: '+Symbol.StringVal);
    except
      if Assigned(result) then
        FreeAndNil(result);
      RaiseError('Invalid function call');
    end;
  end;  { TParser.Parse_Function_Call }

  function TParser.Parse_Term(Var Symbol: Symbol_Type): TEval_Tree;
    var
      temp_node : TEval_Tree;
  begin { TParser.Parse_Term }
    result := parse_factor(Symbol);
    try
      while (Symbol.type_of_Symbol in [symTimes, symDividedBy, symAnd]) do
        begin
          temp_node := TEval_Tree.Create(self);

          with temp_node do
            begin
              Operator  := Symbol.type_of_Symbol;
              Left_Expr := result;
              if Symbol.type_of_Symbol in [symTimes, symDividedBy] then
                Node_Type := ftInteger else
              if Symbol.type_of_symbol = symAnd then
                Node_Type := ftBoolean;
            end;

          result := temp_node;

          InSymbol(Symbol);
          result.Right_Expr := parse_factor(Symbol);
        end;
    except
      if Assigned(result) then
        FreeAndNil(result);
      RaiseError('Invalid term');
    end;
  end;  { TParser.Parse_Term }

  function TParser.Parse_Simple_Expression(var Symbol: Symbol_Type): TEval_Tree;
    var
      temp_node : TEval_Tree;
  begin { TParser.Parse_Simple_Expression }
    result := Parse_Term(Symbol);
    try
      while (Symbol.Type_Of_Symbol in [symPlus, symMinus, symOr]) do
        begin
          temp_node := TEval_Tree.Create(self);

          with temp_node do
            begin
              Operator := Symbol.Type_of_Symbol;
              Left_Expr := result;
              if Operator in [symPlus, symMinus] then
                Node_Type := ftInteger { this may get updated at evaluation time } else
              if Operator = symOr then
                Node_Type := ftBoolean;
            end;

          result := temp_node;

          InSymbol(Symbol);
          result.Right_Expr := Parse_Term(Symbol);
        end;
    except
      if Assigned(result) then
        FreeAndNil(result);
      RaiseError('Invalid simple expression');
    end;
  end;  { TParser.Parse_Simple_Expression }

  function TParser.Parse_Expression(var Symbol: Symbol_Type): TEval_Tree;
    var
      temp_node: TEval_Tree;
  begin { TParser.Parse_Expression }
    result := Parse_Simple_Expression(Symbol);
    try
      if Symbol.Type_of_Symbol in [ symLt, symLe, symGt, symGe, symEq, symNe,
                                    symIncludes, symExcludes,
                                    symSoundsLike] then
        begin
          temp_node := TEval_Tree.Create(self);
          with temp_node do
            begin
              Operator := Symbol.Type_of_Symbol;
              Left_Expr := result {Exp};
              Node_Type := ftBoolean;
            end;
          result := {Exp :=} temp_node;

          InSymbol(Symbol);
          result.Right_Expr := Parse_Simple_Expression(Symbol);
        end;
    except
      if Assigned(result) then
        FreeAndNil(result);
      RaiseError('Invalid expression');
    end;
  end;  { TParser.Parse_Expression }

  function TParser.Valid_Expr( theExpr : string;
                               aTable: TDataSet;
                               var ErrorMsg: string): boolean;
  begin { TParser.Valid_Expr }
    ErrorMsg      := '';
    fTable        := aTable;
    try
      try
        FreeAndNil(Eval_Tree);

        fText     := theExpr;
        fIdx      := 1;
        NextCh;
        InSymbol(fSymbol);
        if (fSymbol.Type_of_Symbol <> symEOS) then
          Eval_Tree := Parse_Expression(fSymbol)
        else
          Eval_Tree := TEval_Tree.Create(self);  // return an empty tree
        Result    :=  fSymbol.Type_of_Symbol = symEOS;
        if not Result then
          RaiseErrorFmt('Unexpected symbol: %s', [fSymbol.StringVal]);
      except
        on E : EDatabaseError do
          raise ESyntaxError.Create(E.Message);
        on E : Exception do
          raise ESyntaxError.Create(E.Message);
        on E : ESyntaxError do
          raise;
      end;
    except
      on E: ESyntaxError do
        begin
          E.Message := 'Syntax error: ' + E.Message;
          ErrorMsg  := E.Message;
          Result    := false;
        end;
      on E: Exception do
        begin
          ErrorMsg  := E.Message;
          Result    := false;
        end;
    end;
    if (not result) and Assigned(Eval_Tree) then { not a valid expression }
      FreeAndNil(Eval_Tree);
  end;  { TParser.Valid_Expr }

(*
  procedure TParser.show_node(Indent: Integer; side: string; Eval_Tree: TEval_Tree);
  begin { TParser.show_node }
    if eval_tree <> nil then
      with Eval_Tree do
        begin
          writeln(outfile, ' ':indent, side, ': ', '(', Op_Strings[Operator], ') ',
                           ' Node_Type=', Type_Strings[Node_Type]);
          case Node_Type of
            ftString:
              begin
                if Operator = symStrRef then
                  writeln(outfile, ' ':indent, fFieldName)
                else
                  writeln(outfile, ' ':indent, '"', AsString, '"')
              end;

            ftInteger:
              writeln(outfile, ' ':indent, AsInteger);

            ftFloat:
              writeln(outfile, ' ':indent, AsFloat);

            ftBoolean:
              if AsBoolean then
                writeln(outfile, ' ':indent, 'TRUE')
              else
                writeln(outfile, ' ':indent, 'FALSE');

            ftDateTime:
              writeln(outfile, ' ':indent, DateToStr(AsDateTime));
          end;
          show_node(Indent + 2, 'LEFT', Left_Expr);
          show_node(InDent + 2, 'RIGHT', Right_Expr);
        end;
  end;  { TParser.show_node }

  procedure TParser.Show_Tree;
  begin { TParser.Show_Tree }
    assignfile(outfile, 'c:\projects\bcc\bccdev\src\junk.txt');
    rewrite(outfile);
    show_node(2, 'none', Eval_Tree);
    closefile(outfile);
  end;  { TParser.Show_Tree }

  function TEval_Tree.AsString: string;
  begin { TEval_Tree.AsString }
    case Node_Type of
      ftString:  result := AsString;
      ftInteger: result := IntToStr(AsInteger);
      ftDate:    result := DateToStr(AsDateTime);
      ftBoolean:
        if AsBoolean then
          result := 'TRUE'
        else
          result := 'FALSE';
      else
        result := 'Can''t handle :'+Type_Strings[Node_Type];
    end;
  end;  { TEval_Tree.AsString }
*)

  procedure TEval_Tree.Evaluate(aTable: TDataSet; case_sensitive: boolean);
  begin
    if Assigned(fParser) then
      begin
        with fParser do
          begin
            Table           := aTable;
            fCase_Sensitive := Case_Sensitive;
          end;
        EvaluateTree;
      end;
  end;

  procedure TEval_Tree.EvaluateTree;

    procedure Evaluate_Operands(Left_Expr, Right_Expr: TEval_Tree);
    var
      MustEvaluateRightOperand: boolean;
    begin { Evaluate_Operands }
      if (Left_Expr <> nil) and (Right_Expr <> nil) then
        begin
          Left_Expr.EvaluateTree;
          case Operator of
            symAnd:
              MustEvaluateRightOperand := Left_Expr.AsBoolean;
            symOr:
              MustEvaluateRightOperand := not Left_Expr.AsBoolean;
            else
              MustEvaluateRightOperand := true;
          end;

          if MustEvaluateRightOperand then
            Right_Expr.EvaluateTree
          else
            exit;

          if Left_Expr.Node_Type <> Right_Expr.Node_Type then
            begin
              if (Left_Expr.Node_Type = ftInteger) and
                 (Right_Expr.Node_Type = ftFloat) then
                Left_Expr.AsFloat := Left_Expr.AsInteger else
              if (Left_Expr.Node_Type = ftFloat) and
                 (Right_Expr.Node_Type = ftInteger) then
                Right_Expr.AsFloat := Right_Expr.AsInteger else
              if (Left_Expr.Node_Type in [ftDate, ftDateTime]) and
                 (Right_Expr.Node_Type in [ftDate, ftDateTime]) then
                begin
                  Left_Expr.Node_Type  := ftDateTime;
                  Right_Expr.Node_Type := ftDateTime;
                end else
              if (Left_Expr.Node_Type in [ftDate, ftDateTime]) and
                 (Right_Expr.Node_Type in [ftInteger, ftFloat]) then
                Left_Expr.Node_Type  := ftDateTime else
              if (Left_Expr.Node_Type in [ftInteger, ftFloat]) and
                 (Right_Expr.Node_Type in [ftDate, ftDateTime]) then
                Left_Expr.AsDateTime := Left_Expr.AsFloat else
              if (Left_Expr.Node_Type in [ftInteger, ftFloat]) and (Right_Expr.Node_Type = ftString) then
                Right_Expr.AsFloat := MyStrToInt(Right_Expr.AsString) else
              if (Left_Expr.Node_Type = ftString) and (Right_Expr.Node_Type in [ftSmallint, ftInteger, ftWord, ftFloat]) then
                Right_Expr.AsString   := FloatToStr(Right_Expr.AsFloat) else
              if (Left_Expr.Node_Type = ftDate) and (Right_Expr.Node_Type = ftString) then
                Right_Expr.AsDateTime := StrToDate(Right_Expr.AsString) else
              if (Left_Expr.Node_Type = ftDateTime) and (Right_Expr.Node_Type = ftString) then
                Left_Expr.AsString := Left_Expr.AsString else // force the left side to be a string
              if (Left_Expr.Node_Type = ftTime) and (Right_Expr.Node_Type = ftString) then
                Right_Expr.AsTime     := MyStrToTime(Right_Expr.AsString) else
              if (Left_Expr.Node_Type = ftString) and (Right_Expr.Node_Type in [ftDate, ftDateTime, ftTime]) then
                Right_Expr.AsString := DateTimeToStr(Right_Expr.AsDateTime) 
              else
                raise ENonCompatible.CreateFmt('Incompatible expressions: %s %s',
                      [Type_Strings[Left_Expr.Node_Type],
                       Type_Strings[Right_Expr.Node_Type]]);
            end
        end
      else
        raise EMissingExpression.Create('Expression missing ? ');
    end;  { Evaluate_Operands }

    function CompareString( sl, sr: string;
                            operator: TType_of_Symbol{;
                            case_sensitive: boolean}): boolean;

      function wild_match(sl, sr: string): boolean;
        var
          ra, rq: integer;
          i: integer;
          mode: (SCANNING, MATCH, MIS_MATCH);
      begin { wild_match }
        ra := pos('*', sr);
        rq := pos('?', sr);
        i  := 1;
        if (ra>0) or (rq>0)then
          begin
            mode := SCANNING;
            REPEAT
              if (i > length(sl)) and (i > length(sr)) then { passed then end
                                      of both strings without a mis-match }
                mode := MATCH else
              if (i > length(sl)) or (i > length(sr)) then { passed the end
                                     of one string but not the other }
                mode := MIS_MATCH else
              if sr[i] = '*' then
                mode := match else
              if sr[i] = '?' then
                inc(i) else
              if sl[i] <> sr[i] then
                mode := MIS_MATCH
              else
                inc(i);
            UNTIL mode <> SCANNING;
            wild_match := mode = MATCH;
          end
        else
          wild_match := sl = sr;
      end;  { wild_match }

      procedure CheckForWild (var s1,s2 : string);
      var
        i,
        wildPos:integer;
      begin
        wildPos:=pos('*',s2);
        if wildPos>0 then begin
          s1:=copy (s1,1,wildPos-1)+'*';
        end;
        if pos('?',s2)>0 then begin
          for i:=1 to length (s2) do begin
            if s2[i]='?' then begin
              if length(s1)<i then
                setLength (s1,i);
              s1[i]:='?';
            end;
          end;
        end;
      end;

    begin { CompareString }
      if not case_sensitive then
        begin
          sl := UpperCase(sl);
          sr := UpperCase(sr);
        end;
      CheckForWild (sl, sr);

      result := false;
      case operator of
        symLt:
          Result := sl < sr;
        symLe:
          Result := sl <= sr;
        symGt:
          Result := sl > sr;
        symGe:
          Result := sl >= sr;
        symEq:
          Result := sl=sr ; //wild_match(sl, sr);
        symNe:
          Result := sl <> sr;
        symIncludes:
          Result := ContainsWords(sr, sl, true, true);
        symExcludes:
          Result := not ContainsWords(sr, sl, true, true);
        symSoundsLike:
          Result := Soundex(sl) = Soundex(sr);
      end;
    end;  { CompareString }

    function CompareInteger(il, ir: integer; operator: TType_of_Symbol): boolean;
    begin { CompareInteger }
      result := false;
      case operator of
        symLt:
          Result := il < ir;
        symLe:
          Result := il <= ir;
        symGt:
          Result := il > ir;
        symGe:
          Result := il >= ir;
        symEq:
          Result := il = ir;
        symNe:
          Result := il <> ir;
      end;
    end;  { CompareInteger }

    function CompareFloat(fl, fr: Double; operator: TType_of_Symbol): boolean;
    begin { CompareInteger }
      result := false;
      case operator of
        symLt:
          Result := fl < fr;
        symLe:
          Result := fl <= fr;
        symGt:
          Result := fl > fr;
        symGe:
          Result := fl >= fr;
        symEq:
          Result := fl = fr;
        symNe:
          Result := fl <> fr;
      end;
    end;  { CompareInteger }

    function CompareDate(dl, dr: TDateTime; operator: TType_of_Symbol): boolean;
    begin { CompareDate }
      result := false;
      case operator of
        symLt:
          Result := dl < dr;
        symLe:
          Result := dl <= dr;
        symGt:
          Result := dl > dr;
        symGe:
          Result := dl >= dr;
        symEq:
          Result := dl = dr;
        symNe:
          Result := dl <> dr;
      end;
    end;  { CompareDate }

    function MyCompareTime(tl, tr: TDateTime; operator: TType_Of_Symbol): boolean;
    begin { MyCompareTime }
      Case Operator of
        symLt: result := Frac(tl) < Frac(tr);
        symLe: result := (Frac(tl) < Frac(tr)) or MyCompareTime(tl, tr, symEq);
        symEq: result := Abs(Frac(tl) - Frac(tr)) < OneMillisecond;
        symGt: result := Frac(tl) > Frac(tr);
        symGe: result := (Frac(tl) > Frac(tr)) or MyCompareTime(tl, tr, symEq);
        symNe: result := not MyCompareTime(tl, tr, symEq);
        else
          raise Exception.Create('Invalid time comparison');
      end;
    end;  { MyCompareTime }

    procedure Evaluate_Function;
      var
        an: integer;
        wn : integer;
//      mu: TMeasurementUnits;
        Chars: string;
        i: integer;
        creationTime, lastAccessTime, lastModificationTime: TDateTime;
    begin { Evaluate_Function }
      for an := 1 to fFunction.ac do
        Arg[an].EvaluateTree;

      case Func_Code of
        funcEmpty:
          begin
            if Arg[1].Operator in SymSet_FieldRef then
              AsBoolean    := (Arg[1].IsNull) or Empty(Arg[1].AsString)
            else
              AsBoolean    := Empty(Arg[1].AsString);
          end;

        funcChar:
          begin
            Chars    := Arg[1].AsString;
            i        := Arg[2].AsInteger;
            if (I > 0) and (i <= Length(Chars)) then
              AsString := Chars[I]
            else
              AsString := '';
          end;

        funcWord:
          begin
            wn    := Arg[2].AsInteger;
            AsString := ExtractWordL(wn, Arg[1].AsString, ',. ');
          end;

        funcConsonants:
          AsString := CleanUpString(Arg[1].AsString,
              ['B'..'D', 'F'..'H', 'J'..'N', 'P'..'T', 'V'..'Z',
               'b'..'d', 'f'..'h', 'j'..'n', 'p'..'t', 'v'..'z']);

        funcNumeric:
          AsString := CleanUpString(Arg[1].AsString, ['0'..'9']);

        funcSoundex:
          AsString := Soundex(Arg[1].AsString);

        funcLeft:
          AsString := MyUtils.Left( Arg[1].AsString,
                                       Arg[2].AsInteger);
        funcRight:
          AsString := MyUtils.Right(Arg[1].AsString,
                                       Arg[2].AsInteger);
        funcSubstr:
          AsString := Copy(Arg[1].AsString,
                              Arg[2].AsInteger,
                              Arg[3].AsInteger);
        funcPos:
          AsInteger := Pos(Arg[1].AsString, Arg[2].AsString);

        funcUpper:
          AsString := UpperCase(Arg[1].AsString);

        funcLower:
          AsString := LowerCase(Arg[1].AsString);

        funcLength:
          AsInteger     := Length(Arg[1].AsString);

        funcPadr:
          AsString := Padr( Arg[1].AsString,
                            Arg[2].AsInteger);

        funcYearOf:
          AsInteger := YearOf(Arg[1].AsDateTime);

        funcMonthOf:
          AsInteger := MonthOf(Arg[1].AsDateTime);

        funcDayOf:
          AsInteger := DayOf(Arg[1].AsDateTime);

        funcAbs:
          AsFloat := Abs(Arg[1].AsFloat);

        funcTimeOfDay:
            begin
              if Arg[1].Node_Type in [ftTime, ftDateTime, ftFloat] then
                AsTime := Arg[1].AsTime else
              if Arg[1].Node_Type in [ftString] then
                AsTime := StrToDateTime(Arg[1].AsString)
              else
                AsTime := BAD_DATE;
            end;

          funcApproxEqual:
            AsBoolean := ApproxEqual(Arg[1].AsFloat, Arg[2].AsFloat, Arg[3].AsFloat);

{
          funcDistance:
            begin
              if Arg_Count = 4 then
                mu := muFeet   // allow possibility of other units when there are more than 4 arguments
              else
                raise ESyntaxError.CreateFmt('Distance(): unexpected number of arguments (%d)', [Arg_Count]);
              if (Arg[1].AsFloat <> 0.0) and (Arg[2].AsFloat <> 0.0) and (Arg[3].AsFloat <> 0.0) and (Arg[4].AsFloat <> 0.0) then
                AsFloat := Distance(Arg[1].AsFloat, Arg[2].AsFloat, Arg[3].AsFloat, Arg[4].AsFloat, mu)
              else
                AsFloat := MaxLongint;    // A VERY LARGE NUMBER
            end;
}
          funcExtractFilePath:
            AsString := ExtractFilePath(Arg[1].AsString);

          funcExtractFileName:
            AsString := ExtractFileName(Arg[1].AsString);

          funcFileExists:
            AsBoolean := FileExists(Arg[1].AsString);

          funcFileAge:
            AsInteger := FileAge(Arg[1].AsString);

          funcTrunc:
            AsInteger := Trunc(Arg[1].AsFloat);

          funcToday:
            AsDateTime := Today;

          funcIsNumeric:
            AsBoolean  := (not Empty(Arg[1].AsString)) and IsPureNumeric(Arg[1].AsString);

          funcContainsAny:
            begin
              Chars := Arg[2].AsString;
              if Chars <> fLastChars then
                begin
                  fCharSet := [];
                  for i := 1 to Length(Chars) do
                    Include(fCharSet, Chars[i]);
                  fLastChars := Chars;
                end;
              AsBoolean := ContainsAny(Arg[1].AsString, fCharSet);
            end;

          funcContainsAnyPunct:
            AsBoolean := ContainsAnyPunct(Arg[1].AsString);

          funcExtractFileBase:
            AsString := ExtractFileBase(Arg[1].AsString);

          funcTrim:
            AsString := Trim(Arg[1].AsString);

          funcEncodeDate:
            AsDateTime := EncodeDate(Arg[1].AsInteger, Arg[2].AsInteger, Arg[3].AsInteger);

          funcDaysInMonth:
            AsInteger  := DaysInMonth(Arg[1].AsDateTime);

          funcIncMonth:
            AsDateTime  := IncMonth(Arg[1].AsDateTime, Arg[2].AsInteger);

          funcFileModifiedDateTime:
            begin
              if GetFileTimes(Arg[1].AsString, creationTime, lastAccessTime, lastModificationTime) then
                AsDateTime := lastModificationTime;
            end;

          funcFileCreatedDateTime:
            begin
              if GetFileTimes(Arg[1].AsString, creationTime, lastAccessTime, lastModificationTime) then
                AsDateTime := creationTime;
            end;

          funcRandom:
            begin
              AsInteger := Random(Arg[1].AsInteger);
            end;

          funcChrTran:
            AsString := ChrTran(Arg[1].AsString, Arg[2].AsString, Arg[3].AsString);

          funcChangeStringCase:
            AsString := ChangeStringCase(TCaseChange(Arg[1].AsInteger) { ccToLower=1, ccToUpper=2, ccToProper=3, ccToSentence=4 },
                                         Arg[2].AsString);
          funcIncludesAnyOf:
            begin
              AsBoolean := ContainsWords(Arg[1].AsString, Arg[2].AsString, true, false);
            end;

          funcRecNo:
            AsInteger := Table.RecNo;
            
          funcExtra:
            if Assigned(fFunction) then
              fFunction.ExtraFunc(self)
            else
              raise Exception.Create('System error: Function execution code not specified');
      end;
    end;  { Evaluate_Function }

  begin { TEval_Tree.EvaluateTree }
    case operator of
      symStrRef:
        begin
          AsString := Field.AsString;
          IsNull   := Field.IsNull;
        end;

      symIntRef:
        begin
          AsInteger     := Field.AsInteger;
          IsNull        := Field.IsNull;
        end;

      symFloatRef:
        begin
          AsFloat       := Field.AsFloat;
          IsNull        := Field.IsNull;
        end;

      symBoolRef:
        begin
          AsBoolean    := Field.AsBoolean;
          IsNull       := Field.IsNull;
        end;

      symDateRef:
        begin
          AsDateTime    := Field.AsDateTime;
          IsNull        := Field.IsNull;
        end;

      symVariantRef:
        begin
          AsVariant     := Field.AsVariant;
          IsNull        := Field.IsNull;
        end;

      symNot:
        begin
          Left_Expr.EvaluateTree;
          AsBoolean := not Left_Expr.AsBoolean;
        end;

      symNoop:
        begin
          Left_Expr.EvaluateTree;
          AsInteger   := Left_Expr.AsInteger;  // I don't think this actually does anything- dhd 3/20/2017
          AsFloat     := Left_Expr.AsFloat;
        end;

      symNegate:
        begin
          Left_Expr.EvaluateTree;
          AsInteger   := - Left_Expr.AsInteger;
          AsFloat     := - Left_Expr.AsFloat;
        end;

      symFunction:
        Evaluate_Function;

      symTimes,
      symPlus,
      symMinus,
      symDividedBy,
      symOr,
      symAnd,
      symLt,
      symLe,
      symGt,
      symGe,
      symEq,
      symNe,
      symIncludes,
      symExcludes,
      symSoundsLike:
        begin
          Evaluate_Operands(Left_Expr, Right_Expr);

          { assert that sub-tree node types must not only be compatible here
            but that they must also be the same (forced by evaluate_subtree) }       

          case operator of
            symTimes:
              if (Left_Expr.Node_Type = ftInteger) then
                AsInteger := Left_Expr.AsInteger * Right_Expr.AsInteger else
              if (Left_Expr.Node_Type = ftFloat) then
                begin
                  AsFloat := Left_Expr.AsFloat * Right_Expr.AsFloat;
                  Node_Type := ftFloat;
                end;

            symPlus:
              if (Left_Expr.Node_Type = ftString) then
                begin
                  AsString := Left_Expr.AsString + Right_Expr.AsString;
                  Node_Type   := ftString;
                end else
              if (Left_Expr.Node_Type = ftInteger) then
                begin
                  AsInteger    := Left_Expr.AsInteger + Right_Expr.AsInteger;
                  Node_Type := ftInteger;
                end else
              if (Left_Expr.Node_Type = ftFloat) then
                begin
                  AsFloat    := Left_Expr.AsFloat + Right_Expr.AsFloat;
                  Node_Type := ftFloat;
                end else
              if (Left_Expr.Node_Type in [ftDate, ftDateTime]) and
                 (Right_Expr.Node_Type in [ftFloat, ftInteger]) then
                AsDateTime   := Left_Expr.AsDateTime + Right_Expr.AsFloat;

            symMinus:
              if (Left_Expr.Node_Type = ftInteger) then
                AsInteger := Left_Expr.AsInteger - Right_Expr.AsInteger else
              if (Left_Expr.Node_Type = ftFloat) then
                AsFloat := Left_Expr.AsFloat - Right_Expr.AsFloat else
              if (Left_Expr.Node_Type in [ftDate, ftDateTime]) and
                 (Right_Expr.Node_Type in [ftFloat, ftInteger]) then
                AsDateTime   := Left_Expr.AsDateTime - Right_Expr.AsFloat;

            symDividedBy:
              try
                if Right_Expr.AsFloat <> 0.0 then
                  AsFloat := Left_Expr.AsFloat / Right_Expr.AsFloat
                else
                  AsFloat := Infinity;
              except
                AsFloat := 0.0; // don't want to abort for single bad record
              end;
(*
              if (Left_Expr.Node_Type = ftFloat) or (Right_Expr.Node_Type = ftFloat) then
                try
                  AsFloat := Left_Expr.AsFloat / Right_Expr.AsFloat;
                except
                  AsFloat := 0.0;
                end else
              if (Left_Expr.Node_Type = ftInteger) then
                try
                  if Right_Expr.AsInteger > 0 then
                    AsInteger := Left_Expr.AsInteger div Right_Expr.AsInteger
                  else
                    AsInteger := 0;
                except
                  AsInteger := 0;  // don't want to abort for single bad record
                end;
*)
            symOr:
              AsBoolean := Left_Expr.AsBoolean or Right_Expr.AsBoolean;

            symAnd:
              AsBoolean := Left_Expr.AsBoolean and Right_Expr.AsBoolean;

            symLt,
            symLe,
            symGt,
            symGe,
            symEq,
            symNe,
            symIncludes,
            symExcludes,
            symSoundsLike:
              begin
                if (Left_Expr.Node_Type = ftString) then
                  AsBoolean := CompareString( Left_Expr.AsString,
                                              Right_Expr.AsString,
                                              operator) else
                if (Left_Expr.Node_Type = ftInteger) then
                  AsBoolean := CompareInteger( Left_Expr.AsInteger,
                                               Right_Expr.AsInteger,
                                               Operator) else
                if (Left_Expr.Node_Type = ftDateTime) then
                  AsBoolean := CompareDate( Left_Expr.AsDateTime,
                                            Right_Expr.AsDateTime,
                                            Operator) else
                if (Left_Expr.Node_Type = ftTime) then
                  AsBoolean := MyCompareTime( Left_Expr.AsTime,
                                            Right_Expr.AsTime,
                                            Operator) else
                if (Left_Expr.Node_Type = ftFloat) then
                  AsBoolean := CompareFloat( Left_Expr.AsFloat,
                                             Right_Expr.AsFloat,
                                             Operator)
                else
                  raise ENonCompatible.CreateFmt( 'Incompatible operands: %s %s',
                                        [Left_Expr.AsString, Right_Expr.AsString]);
              end;
          end;
        end;
    end;
  end;  { TEval_Tree.EvaluateTree }

  Constructor TEval_Tree.Create(aParser: TParser);
  begin
    inherited Create;
    fParser    := aParser;
    Left_Expr  := nil;
    Right_Expr := nil;
    IsNull     := false;
    Operator   := symUnknown;
    AsString   := '';
    fFieldName := '';
    AsInteger  := 0;
  end;

  Destructor TEval_Tree.Destroy;
    var
      i : integer;
  begin
    FreeAndNil(Left_Expr);
    FreeAndNil(Right_Expr);
    for i := 1 to MAX_FUNCTION_ARGS do
      FreeAndNil(Arg[i]);
    inherited destroy;
  end;

function  TEVal_Tree.GetCase_Sensitive: boolean;
begin
  result := fParser.Case_Sensitive;
end;

function TEval_Tree.GetField: TField;
var
  aTable: TDataSet;
begin
  if (not Assigned(fField)) or (fField.DataSet <> fParser.fTable) or (not SameText(fField.FieldName, fFieldName)) then
    begin
      aTable := fParser.fTable;
      if Operator in (SymSet_FieldRef) then
        fField := aTable.FieldByName(fFieldName)
    end;
  Result := fField;
end;

function TEval_Tree.GetAsBoolean: Boolean;
begin
  result := false;
  case Node_Type of
    ftInteger: result := Boolean(fInt_Val);
    ftString:  begin
                 if Length(fStringValue) >= 1 then
                   result := fStringValue[1] in ['T', 't', 'Y', 'y']
                 else
                   result := FALSE;
               end;
    ftFloat:
      begin
        fInt_Val := trunc(fFloat_Val);
        result   := Boolean(fInt_Val);
      end;
    ftBoolean: result := fBool_Val;
    ftUnknown: // treat unknown nodes as boolean false
      begin
        Node_Type := ftBoolean;
        result    := false;
      end;
    else
      RaiseConversionError('Boolean');
  end;
end;

function TEval_Tree.GetAsDateTime: TDateTime;
begin
  result := BAD_DATE;
  case Node_Type of
    ftDate,
    ftDateTime,
    ftTime:     result := fDate_Val;
    ftString:   result := StrToDateTime(fStringValue);
    ftInteger:  result := fInt_Val;
    ftFloat:    result := fFloat_Val;
    else
      RaiseConversionError('DateTime');
  end;
end;

function TEval_Tree.GetAsFloat: Double;
begin
  result := 0.0;
  case Node_Type of
    ftInteger: result := fInt_Val;
    ftFloat:   result := fFloat_Val;
    ftString:
      begin
        try
          result := StrToFloat(fStringValue);
        except
          result := 0.0;
        end
      end;
    ftDate, ftDateTime:
      result := fDate_Val;
    ftBoolean:
      result := Ord(fBool_Val);
    else
      RaiseConversionError('Float');
  end;
end;

function TEval_Tree.GetAsInteger: Longint;
begin
  result := 0;
  case Node_Type of
    ftInteger: result := fInt_Val;
    ftString:
    try
      Result:= VarAsType(fStringValue, varInteger);
    except
      on EVariantError do
        Result:= StrToInt(fStringValue);
    else
      raise;
    end;
    ftFloat:
    try
      Result:= Trunc(fFloat_Val);
    except
      on ERangeError do
        Result:= StrToInt(IntToStr(Trunc(fFloat_Val)));
    else
      raise;
    end;
    ftBoolean: result := ord(fBool_Val);
    else
      RaiseConversionError('Integer');
  end;
end;

function TEval_Tree.GetAsString: string;
begin
  case Node_Type of
    ftUnknown:   result := '';
    ftString:    result := fStringValue;
    ftInteger:   result := IntToStr(fInt_Val);
    ftFloat:     result := FloatToStr(fFloat_Val);
    ftBoolean:   if fBool_Val then
                   result := 'TRUE'
                 else
                   result := 'FALSE';
    ftDate:      if fDate_Val <> BAD_DATE then
                   result := DateToStr(fDate_Val)
                 else
                   result := '';
    ftDateTime:  if fDate_Val <> BAD_DATE then
                   result := DateTimeToStr(fDate_Val)
                 else
                   result := '';
    ftTime:      if fDate_Val <> BAD_DATE then
                   result := TimeToStr(fDate_Val)
                 else
                   result := '';
    else
      RaiseConversionError('String');
  end;
end;

function TEval_TRee.GetAsVariant: variant;
begin
  case Node_Type of
    ftUnknown:   result := '';
    ftString:    result := fStringValue;
    ftInteger:   result := fInt_Val;
    ftFloat:     result := fFloat_Val;
    ftBoolean:   result := fBool_Val;
    ftDate:      result := fDate_Val;
    ftDateTime:  result := Trunc(fDate_Val);
    ftTime:      result := Frac(fDate_Val);
    ftVariant:   result := fVariant_Val;
    else
      RaiseConversionError('Variant');
  end;
end;

procedure TEval_Tree.SetAsBoolean(const Value: Boolean);
begin
  fBool_Val := value;
  Assert(Node_Type in [ftUnknown, ftString, ftInteger, ftFloat, ftBoolean, ftDate],
         UNEXPECTED_NODE_TYPE_CHANGE);
  Node_Type := ftBoolean;
end;

procedure TEval_Tree.SetAsDateTime(const Value: TDateTime);
begin
  fDate_Val := value;
  Assert(Node_Type in [ftUnknown, ftString, ftInteger, ftFloat, ftBoolean, ftDate,
                       ftDateTime],
         UNEXPECTED_NODE_TYPE_CHANGE);
  Node_Type := ftDateTime;
end;

procedure TEval_Tree.SetAsFloat(const Value: Double);
begin
  fFloat_Val := Value;
  Assert(Node_Type in [ftUnknown, ftString, ftInteger, ftFloat, ftBoolean, ftDate, ftDateTime],
         UNEXPECTED_NODE_TYPE_CHANGE);
  Node_Type  := ftFloat;
end;

procedure TEval_Tree.SetAsInteger(const Value: Longint);
begin
  fInt_Val  := Value;
  Assert(Node_Type in [ftUnknown, ftString, ftInteger, ftFloat, ftBoolean, ftDate, ftDateTime],
         UNEXPECTED_NODE_TYPE_CHANGE);
  Node_Type := ftInteger;
end;

procedure TEval_Tree.SetAsString(const Value: string);
begin
  fStringValue := Value;
  Assert(Node_Type in ([ftUnknown, ftString, ftBoolean, ftDate, ftDateTime, ftMemo]+NUMERIC_TYPES),
         UNEXPECTED_NODE_TYPE_CHANGE);
  Node_Type    := ftString;
end;

procedure TEval_Tree.SetAsVariant(const Value: variant);
begin
  fVariant_Val := Value;
  Assert(Node_Type in ([ftUnknown, ftString, ftBoolean, ftDate, ftDateTime, ftMemo]+NUMERIC_TYPES),
         UNEXPECTED_NODE_TYPE_CHANGE);
  Node_Type    := ftVariant;
end;

procedure TEval_Tree.RaiseConversionError(const DesiredResultType: string);
begin
  raise EConversionError.CreateFmt( SInvalidConversionTo,
                                    [Type_Strings[Node_Type], DesiredResultType]);
end;

function TEval_Tree.GetTable: TDataSet;
begin
  result := fParser.Table;
end;

function TEval_Tree.GetAsTime: TDateTime;
begin
  result := Frac(AsDateTime);
end;

procedure TEval_Tree.SetAsTime(const Value: TDateTime);
begin
  fDate_Val  := Frac(Value);
  Node_Type  := ftTime;
end;

{ TAvailable_Function }

destructor TAvailable_Function.Destroy;
begin
  FreeAndNil(LLink);
  FreeAndNil(Rlink);
  inherited;
end;

procedure TAvailable_Function.TraverseSubTree(CallBackFunction: TCallBackFunction);
begin
  if Assigned(LLink) then
    LLink.TraverseSubTree(CallBackFunction);
  if FuncCode <> funcBad then
    CallBackFunction(self);
  if Assigned(RLink) then
    Rlink.TraverseSubTree(CallBackFunction);
end;

procedure TParser.RaiseErrorFmt(const Msg: string; Args: array of const);
begin
  RaiseError(Format(Msg, Args));
end;

procedure TParser.RaiseError(const Msg: string);
begin
  raise ESyntaxError.CreateFmt('%s @ character # %d'+#13#10+'%s', [Msg, fIdx, Copy(fText, 1, fIdx)]);
end;

procedure TParser.AddOptionalFunctionsToParser;
begin

end;

constructor TParser.Create;
begin
  inherited Create;

  InitFunc(funcEmpty,      'Empty',           ftBoolean, 1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcChar,       'Char',            ftString,  2, 2,  symStrRef,   symIntRef,  symUnknown, symUnknown);
  InitFunc(funcWord,       'Word',            ftString,  2, 2,  symStrRef,   symIntRef,  symUnknown, symUnknown);
  InitFunc(funcConsonants, 'Consonants',      ftString,  1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcNumeric,    'Numeric',         ftString,  1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcSoundex,    'Soundex',         ftString,  1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcLeft,       'Left',            ftString,  2, 2,  symStrRef,   symIntRef,  symUnknown, symUnknown);
  InitFunc(funcRight,      'Right',           ftString,  2, 2,  symStrRef,   symIntRef,  symUnknown, symUnknown);
  InitFunc(funcSubStr,     'Substr',          ftString,  3, 3,  symStrRef,   symIntRef,  symIntRef,  symUnknown);
  InitFunc(funcUpper,      'Upper',           ftString,  1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcLower,      'Lower',           ftString,  1, 1,  symStrRef,   symUnknown, symunknown, symUnknown);
  InitFunc(funcLength,     'Length',          ftInteger, 1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcPadr,       'Padr',            ftString,  2, 2,  symStrRef,   symIntRef,  symUnknown, symUnknown);
  InitFunc(funcYearOf,     'YearOf',          ftInteger, 1, 1,  symDateRef,  symUnknown, symUnknown, symUnknown);
  InitFunc(funcMonthOf,    'MonthOf',         ftInteger, 1, 1,  symDateRef,  symUnknown, symUnknown, symUnknown);
  InitFunc(funcDayOf,      'DayOf',           ftInteger, 1, 1,  symDateRef,  symUnknown, symUnknown, symUnknown);
  InitFunc(funcAbs,        'Abs',             ftFloat,   1, 1,  symFloatRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcPos,        'Pos',             ftInteger, 2, 2,  symStrRef,   symStrRef,  symUnknown, symUnknown);
  InitFunc(funcTimeOfDay,  'TimeOfDay',       ftTime,    1, 1,  symStrRef,   symUnknown, symUnknown, symUnknown);
  InitFunc(funcApproxEqual,'ApproxEqual',     ftBoolean, 3, 3,  symFloatRef, symFloatRef, symFloatRef, symUnknown);
  InitFunc(funcExtractFilePath, 'ExtractFilePath', ftString,  1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcExtractFileName, 'ExtractFileName', ftString,  1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcExtractFileBase, 'ExtractFileBase', ftString,  1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcFileExists,      'FileExists',      ftBoolean, 1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcFileAge,         'FileAge',         ftInteger, 1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcTrunc,           'Trunc',           ftInteger, 1, 1, symFloatRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcToday,           'Today',           ftDateTime, 0, 0, symUnknown, symUnknown, symUnknown, symUnknown);
  InitFunc(funcIsNumeric,       'IsNumeric',       ftBoolean,  1, 1, symStrRef,  symUnknown, symUnknown, symUnknown);
  InitFunc(funcContainsAny,     'ContainsAny',     ftBoolean, 2, 2, symStrRef,   symStrRef,  symUnknown, symUnknown);
  InitFunc(funcContainsAnyPunct, 'ContainsAnyPunct', ftBoolean, 1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcTrim,             'Trim',             ftString,  1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcEncodeDate,       'EncodeDate',     ftDateTime,  3, 3, symIntRef, symIntRef,  symIntRef,  symUnknown);
  InitFunc(funcDaysInMonth,     'DaysInMonth',     ftInteger,   1, 1, symDateRef, symIntRef, symUnknown, symUnknown);
  InitFunc(funcIncMonth,        'IncMonth',        ftDateTime,  2, 2, symDateRef, symIntRef,  symUnknown, symUnknown);
  InitFunc(funcFileModifiedDateTime,'FileModifiedDateTime', ftDateTime, 1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcFileCreatedDateTime,'FileCreatedDateTime', ftDateTime, 1, 1, symStrRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcIncludesAnyOf,   'IncludesAnyOf',    ftBoolean,  2, 2, symStrRef, symStrRef, symUnknown, symUnknown);
  InitFunc(funcRecNo,           'RecNo',            ftInteger,  0, 0, symIntRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcRandom,          'Random',           ftInteger,  1, 1, symIntRef, symUnknown, symUnknown, symUnknown);
  InitFunc(funcChrTran,         'ChrTran',          ftString,   3, 3, symStrRef, symStrRef,  symStrRef,  symUnknown);
  InitFunc(funcChangeStringCase, 'ChangeStringCase',ftString,   2, 2, symIntRef, symStrRef,  symUnknown, symUnknown);
end;

procedure TEval_Tree.SetHasLocation(const Value: boolean);
begin
  fHasLocation := Value;
end;

initialization
finalization
end.


