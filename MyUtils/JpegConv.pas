unit JpegConv;

interface

uses Windows, Graphics, SysUtils, Classes;

procedure CreateThumbnail(InStream, OutStream: TStream;
  Width, Height: Integer; FillColor: TColor=clWhite); overload;
procedure CreateThumbnail(const InFileName, OutFileName: string;
  Width, Height: Integer; FillColor: TColor=clWhite); overload;

implementation

uses Jpeg;

procedure CreateThumbnail(InStream, OutStream: TStream;
  Width, Height: Integer; FillColor: TColor=clWhite);
var
  JpegImage: TJpegImage;
  Bitmap: TBitmap;
  Ratio: Double;
  ARect: TRect;
  AHeight{, AHeightOffset}: Integer;
  AWidth{, AWidthOffset}: Integer;
begin
//  Check for invalid parameters
  if Width<1 then
    raise Exception.Create('Invalid Width');
  if Height<1 then
    raise Exception.Create('Invalid Height');
  JpegImage := TJpegImage.Create;
  try
//  Load the image
    JpegImage.LoadFromStream(InStream);
// Create bitmap, and calculate parameters
    Bitmap := TBitmap.Create;
    try
      Ratio := JpegImage.Width/JpegImage.Height;
      if Ratio > 1 then
        begin
          AHeight       := Round(Width/Ratio);
          AWidth        := Width;
        end
      else
        begin
          AWidth        :=Round(Height*Ratio);
          AHeight       :=Height;
        end;
      Bitmap.Width  := AWidth;
      Bitmap.Height := AHeight;
      Bitmap.Canvas.Brush.Color := FillColor;
      Bitmap.Canvas.FillRect(Rect(0, 0, AWidth, AHeight));
      ARect := Rect(0 {AWidthOffset},
                    0 {AHeightOffset},
                    AWidth{+AWidthOffset},
                    AHeight{+AHeightOffset});
      Bitmap.Canvas.StretchDraw(ARect,JpegImage);
// Assign back to the Jpeg, and save to the file
      JpegImage.Assign(Bitmap);
      JpegImage.SaveToStream(OutStream);
    finally
      Bitmap.Free;
    end;
  finally
    JpegImage.Free;
  end;
end;

procedure CreateThumbnail(const InFileName, OutFileName: string;
  Width, Height: Integer; FillColor: TColor=clWhite); overload;
var
  InStream, OutStream: TFileStream;
begin
  InStream:=TFileStream.Create(InFileName,fmOpenRead);
  try
    OutStream:=TFileStream.Create(OutFileName,fmOpenWrite or fmCreate);
    try
      CreateThumbnail(InStream,OutStream,Width,Height,FillColor);
    finally
      OutStream.Free;
    end;
  finally
    InStream.Free;
  end;
end;

end.
