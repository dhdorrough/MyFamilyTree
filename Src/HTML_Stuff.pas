unit HTML_Stuff;

interface

const
  FAMILYTREEFOLDER = 'FamilyTree/';
  PHOTODBROOT      = 'http://RuthAndDan.net/';
  IMAGESFOLDER     = 'http://RuthAndDan.net/Images/';
type
  THTMLTags = (ht_HTML, ht_BODY, ht_HEAD, ht_TITLE, ht_STRONG, ht_BR,
               ht_TR,   ht_TD,   ht_P,    ht_DIV,   ht_FONT,   ht_TABLE,
               ht_FORM, ht_INPUT,ht_A,    ht_META,  ht_LINK,   ht_IMG);

  THTMLTagInfo = record
    Name: string;
  end;

var
  HTMLTagInfoArray: array[THTMLTags] of THTMLTagInfo = (
    ( { ht_HTML }   Name: 'html'),
    ( { ht_BODY }   Name: 'body'),
    ( { ht_HEAD }   Name: 'head'),
    ( { ht_TITLE }  Name: 'title'),
    ( { ht_STRONG } Name: 'strong'),
    ( { ht_BR }     Name: 'br'),
    ( { ht_TR }     Name: 'tr'),
    ( { ht_TD }     Name: 'td'),
    ( { ht_P }      Name: 'p'),
    ( { ht_DIV }    Name: 'div'),
    ( { ht_FONT }   Name: 'font'),
    ( { ht_TABLE }  Name: 'table'),
    ( { ht_FORM }   Name: 'form'),
    ( { ht_INPUT }  Name: 'input'),
    ( { ht_A }      Name: 'a'),
    ( { ht_META }   Name: 'meta'),
    ( { ht_LINK }   Name: 'link'),
    ( { ht_IMG }    Name: 'img')
  );

function CloseTag(ht: THTMLTags; const params: string = ''): string;
function OpenTag(ht: THTMLTags; const params: string = ''): string;
function SelfCloseTag(ht: THTMLTags; const params: string = ''): string;

implementation

uses
  SysUtils;

function OpenTag(ht: THTMLTags; const params: string = ''): string;
begin
  result := Format('<%s %s>', [HTMLTagInfoArray[ht].Name, Params]);
end;

function CloseTag(ht: THTMLTags; const params: string = ''): string;
begin
  result := Format('</%s %s>', [HTMLTagInfoArray[ht].Name, Params]);
end;

function SelfCloseTag(ht: THTMLTags; const params: string = ''): string;
begin
  result := Format('<%s %s/>', [HTMLTagInfoArray[ht].Name, params]);
end;

end.
