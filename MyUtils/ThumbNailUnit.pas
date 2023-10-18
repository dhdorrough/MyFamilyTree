unit ThumbNailUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ShlObj2,
  ActiveX, CommDlg;

function GetThumbnail(AFilePath: widestring; var hBmp: HBITMAP; Width, Height: integer): HRESULT;

implementation

type
  {$EXTERNALSYM SIIGBF}
  SIIGBF = Integer;

  {$EXTERNALSYM IShellItemImageFactory}
  IShellItemImageFactory = interface(IUnknown)
    ['{BCC18B79-BA16-442F-80C4-8A59C30C463B}']
    function GetImage(size: TSize; flags: SIIGBF; out phbm: HBITMAP):
             HRESULT; stdcall;
  end;

const
  SIIGBF_RESIZETOFIT = $00000000;
  SIIGBF_BIGGERSIZEOK = $00000001;
  SIIGBF_MEMORYONLY = $00000002;
  SIIGBF_ICONONLY = $00000004;
  SIIGBF_THUMBNAILONLY = $00000008;
  SIIGBF_INCACHEONLY = $00000010;

function GetThumbnail(AFilePath: widestring; var hBmp: HBITMAP; Width, Height: integer): HRESULT;
var
  fileShellItemImage: IShellItemImageFactory;
  s: TSize;
begin
  Result := CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);
  if Succeeded(Result) then begin
    Result := SHCreateItemFromParsingName(PWideChar(AFilePath), nil, IShellItemImageFactory, fileShellItemImage);
    if Succeeded(Result) then
      begin
        s.cx := Width;
        s.cy := Height;
        Result := fileShellItemImage.GetImage(s, SIIGBF_THUMBNAILONLY+SIIGBF_BIGGERSIZEOK, hBmp);
      end;
    CoUninitialize;
  end;
end;

end.
 