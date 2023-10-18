unit LocationUtils;

interface

uses
  SysUtils;

const
  InchesPerFoot            =   12;
  InchesPerYard            =   36;
  FeetPerYard              =    3;
  YardsPerMile             = 1760;
  FEETPERMILE              = 5280;
  CentimetersPerInch       =    2.54;
  NauticalMile             =    1.852; {km}
  EarthRadius              = 6366.7070194937075; {km}
  DEFAULT_MAXDEVIATION     = 115;

  FP_Tolerance             = 0.00000001;

type
  EInvalidLocation         = class(Exception);

  TMeasurementUnits = (muInches, muFeet, muYards, muMiles, muMillimeters,
                       muCentimeters, muMeters, muKilometers, muNauticalMiles);
  TLatLonCode = (llLat, llLon);
  TLocation = record
              Lat: Double;
              Lon: Double;
            end;
  TPosNeg = (pnPos, pnNeg);

  TBoundingRectangle = record
    BRTop         : double;
    BRLeft        : double;
    BRBottom      : double;
    BRRight       : double;
  end;

  EConversionError = class(Exception);

  TDirection = (td_Unknown, td_W_to_E, td_E_to_W, td_S_to_N, td_N_to_S);

  function AzimuthCode(Angle: double): string;
  function CalcLocationString(Latitude, Longitude: double): string;
  function CalcLocationStringLong(Latitude, Longitude: double): string;
  function DecimalDegreesToDegMin(Deg: double; ll: TLatLonCode): string;
  function DegMinToDecimalDegrees(DegMin: string): double;
  function Distance(Latitude1, Longitude1, Latitude2, Longitude2 : Double; Units : TMeasurementUnits) : Double;
  function DistanceHaversine(Latitude1, Longitude1, Latitude2, Longitude2 : Double; Units : TMeasurementUnits) : Double;
  function GetDecimalDegrees(const Ref, LongDesc: string): double;
  function InArc(Azimuth, DesiredAzimuth: double; MaxDeviation: double = DEFAULT_MAXDEVIATION): boolean;
  function InBoundingRectangle(Location: TLocation; BoundingRectangle: TBoundingRectangle): boolean;
  function LatLonLetter(PosNeg: TPosNeg; LatLon: TLatLonCode): string;
  function LatLonToCode(x: double; Direction: TDirection): string;
  function ParseDistance(const DistanceStr: string; var Distance: double; var MeasurementUnits: TMeasurementUnits): boolean;
  function ParseLatOrLon(LatOrLon: string): double;
  function ParseLatitudeLongitude(LatLong: string; var Latitude, Longitude: double): boolean;
  function RhumbDistance(    llat1, llon1, llat2, llon2: double;
                             units: TMeasurementUnits;
                         var Azimuth:double): double;

var
  MeasurementUnitsArray: array[TMeasurementUnits] of string =
    ({muInches}       'Inch,Inches',
     {muFeet}         'Foot,Feet,Ft',
     {muYards}        'Yard,Yards,Yd',
     {muMiles}        'Mile,Miles',
     {muMillimeters}  'Mm',
     {muCentimeters}  'Cm',
     {muMeters}       'M,Mt',
     {muKilometers}   'Km',
     {muNauticalMiles} 'Nautical Miles'
    );

implementation

uses
  MyUtils, StStrL, Math, DateUtils;

function GetDecimalDegrees(const Ref, LongDesc: string): double;
const
  DELIMS = ' °"''';
type
  TWordType = (wt_Deg, wt_Min, wt_Sec);
var
  Deg, Min, I: integer;
  Sec: Single;
  W: string;
  wt: TWordType;
begin
  result := 0; Deg := 0; Min := 0; Sec := 0.0;
  if not Empty(LongDesc) then
    begin
      wt := wt_Deg;
      for i := 1 to 6 do
        begin
          W := ExtractWordL(i, LongDesc, DELIMS);
          if IsFloat(W) then
            case wt of
              wt_Deg:
                begin
                  Deg := StrToInt(w);
                  inc(wt);
                end;
              wt_Min:
                begin
                  Min := StrToInt(w);
                  inc(wt);
                end;
              wt_Sec:
                Sec := (Min * 60) + StrToFloat(w);
            end
          else
            if Length(w) > 0 then
              if not (SameText(w, 'Degrees') or SameText(w, 'Minutes') or SameText(w, 'Seconds')) then
                raise Exception.CreateFmt('Unexpected word (%s) when converting Lat/Lon: %s', [W, LongDesc]);
        end;

      result := Deg + (Sec / 3600);
      if SameText(Ref, 'W') or SameText(Ref, 'S') then
        result := - result;
    end;
end;

function CalcLocationString(Latitude, Longitude: double): string;
var
  EW, NS: string;
begin
  if Latitude >= 0 then
    EW := 'N'
  else
    begin
      EW := 'S';
      Latitude := - Latitude;
    end;

  if Longitude >= 0 then
    NS := 'E'
  else
    begin
      NS := 'W';
      Longitude := - Longitude;
    end;

  result := Format('%1s%5.2f,%1s%5.2f', [EW, Latitude, NS, Longitude]);
end;

function CalcLocationStringLong(Latitude, Longitude: double): string;
var
  EW, NS: string;
begin
  if Latitude >= 0 then
    EW := 'N'
  else
    begin
      EW := 'S';
      Latitude := - Latitude;
    end;

  if Longitude >= 0 then
    NS := 'E'
  else
    begin
      NS := 'W';
      Longitude := - Longitude;
    end;

  result := Format('%1s%8.5f %1s%8.5f', [EW, Latitude, NS, Longitude]);
end;

function DecimalDegreesToDegMin(Deg: double; ll: TLatLonCode): string;
var
  f: double;
  pn: TPosNeg;
begin
  if Deg >= 0 then
    pn := pnPos
  else
    pn := pnNeg;
    
  f := Abs(Frac(Deg));
  result := Format('%s%d° %8.5f''', [LatLonLetter(pn, ll), Trunc(Abs(Deg)), f * 60.0])
end;


function DegMinToDecimalDegrees(DegMin: string): double;
var
  qp: integer;
  DegStr, MinStr: string;
  Deg: double;
  Min: double;
  IsNeg: boolean;
begin
  result := 0;
  DegMin := UpperCase(trim(DegMin));
  IsNeg  := false;
  if Length(DegMin) > 0 then
    begin
      if DegMin[1] in ['W', 'S'] then
        begin
          IsNeg := true;
          DegMin := Copy(DegMin, 2, Length(DegMin)-1);
        end else
      if DegMin[1] in ['N', 'E'] then
        DegMin := Copy(DegMin, 2, Length(DegMin)-1);

      try
        qp := Pos('°', DegMin);
        if qp = 0 then
          qp := Pos(' ', DegMin);
        if qp = 0 then
          qp := Length(DegMin)+1;
        DegStr := Trim(Copy(DegMin, 1, qp-1));
        Deg := StrToFloat(DegStr);
        MinStr := Copy(DegMin, qp+1, Length(DegMin)-qp);
        qp := Pos('''', MinStr);
        if qp = 0 then
          qp := Length(MinStr) + 1;
        MinStr := Trim(Copy(MinStr, 1, qp-1));
        Min    := 0.0;
        if Length(MinStr) > 0 then
          try
            Min    := StrToFloat(MinStr) / 60
          except
            Min    := 0.0;
          end;
        result := Deg + Min;
        if IsNeg then
          result := - result;
      except
        raise EInvalidLocation.CreateFmt('Unexpected format [%s]. Should be: dd° mm.mmmm''',
                                  [DegMin]);
      end;
    end;
end;

function Distance(Latitude1, Longitude1, Latitude2, Longitude2 : Double; Units : TMeasurementUnits) : Double;
begin
  Result := DistanceHaversine(Latitude1, Longitude1, Latitude2, Longitude2, Units);
end;

function ConvertEarthRadius(Units : TMeasurementUnits) : Double;
begin
// A nautical mile is one minute of arc of a great circle of the earth.
// The internationally accepted (SI) value for the length of a nautical
// mile is by definition, exactly, 1.852 km or 1.852/1.609344 international
// miles. That is, approximately 1.15078 miles (international or U.S.
// statute). Therefore, the official circumference of the earth is
// 360 degrees * 60 minutes/degree * 1.852 km/minute = 40003.2 km.
  Result                                  := EarthRadius; {km}
  case Units of
    muInches,
    muFeet,
    muYards,
    muMiles       : begin
                      Result := Result * 100000 / 30.48; {km to ft - 1 km * (100000 cm / 1 km) * (1 in / 2.54 cm) * (1 ft / 12 in)}
                      case Units of
                        muInches : Result := Result * InchesPerFoot;
                        muFeet   : ;
                        muYards  : Result := Result / FeetPerYard;
                        muMiles  : Result := Result / FEETPERMILE;
                        else       Result := 0.0;
                      end;
                    end;
    muMillimeters : Result                := Result * 1000000;
    muCentimeters : Result                := Result * 100000;
    muMeters      : Result                := Result * 1000;
    muKilometers  : ;
    muNauticalMiles: raise Exception.Create('Convert Earth radius- Nautical miles not implemented');
    else            Result                := 0.0;
  end;
end;

function DistanceHaversine(Latitude1, Longitude1, Latitude2, Longitude2 : Double; Units : TMeasurementUnits) : Double;
var
  dLon : Double;
  dLat : Double;
  a    : Double;
  c    : Double;
begin
  dLon   := DegToRad(Longitude2 - Longitude1);
  dLat   := DegToRad(Latitude2 - Latitude1);
  a      := IntPower(Sin(dLat / 2), 2) + (Cos(DegToRad(Latitude1)) * Cos(DegToRad(Latitude2)) * IntPower(Sin(dLon / 2), 2));
  c      := 2 * ArcTan2(SqRt(a), SqRt(1 - a)); {great circle distance in radians}
  Result := c * ConvertEarthRadius(Units); {great circle distance}
end;

function InBoundingRectangle(Location: TLocation; BoundingRectangle: TBoundingRectangle): boolean;
begin
  with Location, BoundingRectangle do
    result := (Lat <= BRTop) and
              (Lat >= BRBottom) and
              (Lon >= BRLeft) and
              (Lon <= BRRight);
end;

function LatLonLetter(PosNeg: TPosNeg; LatLon: TLatLonCode): string;
begin
  case PosNeg of
    pnPos:
      case LatLon of
        llLat:
          result := 'N';
        llLon:
          result := 'E';
      end;
    pnNeg:
      case LatLon of
        llLat:
          result := 'S';
        llLon:
          result := 'W';
      end;
  end;
end;

//*****************************************************************************
//   Function Name     : LatLonToCode
//   Useage            : LatLonToCode(x, Direction)
//   Function Purpose  : W_to_E: Convert a Lon from -180 to +180 --> 0 to 360
//                       E_to_W:           Lon from -180 to +180 --> 360 to 0
//                       N_to_S:           Lat from 90 to -90 --> 0 to 180
//                       S_to_N:           Lat from 90 to -90 --> 180 to 0
//   Parameters        : x is a latitude or a longitude
//                       direction is the direction for ascending codes to be generated
//   Return Value      : a code string which can be sorted in ascending order
//                       to give results in the desired direction
//*******************************************************************************}

function LatLonToCode(x: double; Direction: TDirection): string;
var
  Hrs, Dec: integer;
begin
  case Direction of
    td_W_to_E:
      x := x + 180.0;

    td_E_to_W:
      x := 180.0 - x;

    td_N_to_S:
      x := 90.0 - x;

    td_S_to_N:
      x := x + 90.0
  end;
  Hrs := trunc(x);
  Dec := Trunc(frac(x) * 10000);
  result := Rzero(Hrs, 3) + RZero(Dec, 4);
end;

function ParseDistance(const DistanceStr: string; var Distance: double; var MeasurementUnits: TMeasurementUnits): boolean;
var
  mu: TMeasurementUnits;
  Possibilities, aWord, temp: string;
  MaxWords: integer;
  mode1, mode2: TSearch_Type; // (SEARCHING, SEARCH_FOUND, NOT_FOUND);
  UnitStr: string;
  NonNumericIndex, i: integer;
begin
  Temp     := LeadingNumericString(DistanceStr, NonNumericIndex);
  if IsAllNumeric(temp) then
    Distance := StrToFloat(temp)
  else
    Distance := 0;

  UnitStr  := Trim(Copy(DistanceStr, NonNumericIndex, Length(DistanceStr) - NonNumericIndex + 1));
  if not Empty(UnitStr) then
    begin
      mode1 := SEARCHING;
      mu    := Low(TMeasurementUnits);
      repeat
        Possibilities := MeasurementUnitsArray[mu];
        MaxWords      := WordCountL(Possibilities, ',');
        mode2 := SEARCHING;
        I     := 1;
        repeat
          if i > MaxWords then
            mode2 := NOT_FOUND
          else
            begin
              aWord := ExtractWordL(i, Possibilities, ',');
              if SameText(UnitStr, aWord) then
                mode2 := SEARCH_FOUND
              else
                inc(i);
            end;
        until mode2 <> SEARCHING;
        if mode2 = SEARCH_FOUND then
          mode1 := SEARCH_FOUND
        else
          if mu = High(TMeasurementUnits) then
            mode1 := NOT_FOUND
          else
            inc(mu);
      until mode1 <> SEARCHING;

      result := mode2 = SEARCH_FOUND;
      if result then
        MeasurementUnits := mu;
    end
  else
    begin
      result := (Distance > 0);
      MeasurementUnits := muMiles;  // default to miles
    end;
end;

function ParseLatOrLon(LatOrLon: string): double;
var
  LastCh: char;
  Sign, Idx: integer;
  NumStr, Tail: string;

  procedure RaiseError;
  begin
    raise EConversionError.CreateFmt('Location "%s" cannot be parsed', [LatOrLon]);
  end;

begin { ParseLatOrLon }
  result    := MAXINT;              // just to keep the compiler happy
  LatOrLon  := Trim(LatOrLon);
  NumStr    := LeadingNumericString(LatOrLon, idx);
  Tail      := Copy(LatOrLon, idx, Length(LatOrLon) - idx);
  if Length(Tail) > 0 then
    begin
      LastCh    := ToUpper(LatOrLon[Length(LatOrLon)]);
      Sign      := 0;
      if LastCh in ['W', 'S'] then
        Sign := -1 else
      if LastCh in ['N', 'E'] then
        Sign := + 1
      else
        RaiseError;

      try
        result := sign * StrToFloat(NumStr);
      except
        RaiseError;
      end
    end
  else
    RaiseError;
end; { ParseLatOrLon }


function ParseLatitudeLongitude(LatLong: string; var Latitude, Longitude: double): boolean;
var
  LatStr, LongStr: string;
  cp: integer;
begin
  LatLong := Trim(LatLong);
  cp := Pos(',', LatLong);
  result := cp > 0;
  if not result then
    begin
      cp := Pos(' ', LatLong);
      result := cp > 0;
    end;
  if result then
    begin
      try
        LatStr    := Copy(LatLong, 1, cp-1);
        Latitude  := DegMinToDecimalDegrees(LatStr);
        LongStr   := Copy(LatLong, cp+1, Length(LatLong) - cp);
        Longitude := DegMinToDecimalDegrees(LongStr);
      except
        result := false;
      end;
    end;
end;

function RhumbDistance(     llat1,llon1,llat2,llon2: double;
                            units: TMeasurementUnits;
                        var Azimuth:double): double;
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles
  TMeasurementUnits = (muInches, muFeet, muYards, muMiles, muMillimeters, muCentimeters, muMeters, muKilometers);
}
(*
    Azimuth

    A rhumb line is a straight line on a Mercator projection, with an angle on the projection equal to the compass Azimuth.

    Formula:  ?? = ln( tan(p/4 + f2/2) / tan(p/4 + f1/2) ) (‘projected’ latitude difference)
     ? = atan2(??, ??)
    where f is latitude, ? is longitude, ?? is taking shortest route (<180°), R is the earth’s radius, ln is natural log
    JavaScript:
    (all angles in radians)
    var ?? = Math.log(Math.tan(Math.PI/4+f2/2)/Math.tan(Math.PI/4+f1/2));

    // if dLon over 180° take shorter rhumb line across the anti-meridian:
    if (Math.abs(??) > Math.PI) ?? = ??>0 ? -(2*Math.PI-??) : (2*Math.PI+??);

    var brng = Math.atan2(??, ??).toDegrees();
*)

  var
    lat1,lat2,lon1,lon2,dist: double;
    DLon, DLat, ProjDLat: double;
    Q,R: double;
  Begin
   (*
   case Units of  {convert distance to meters}
      muMiles:{miles}                  dist := dist * 1609.344;
      muKilometers:{kilometers}        dist := dist * 1000;
      muNauticalMiles:{nautical miles} dist := dist * 1852;
   end;
   *)
   R    := EarthRadius * 1000;  {earth radius in meter}
   lat1 := DegToRad(llat1);
   lon1 := DegToRad(llon1);
   lat2 := DegToRad(llat2);
   lon2 := DegToRad(llon2);
   DLat := Lat2-Lat1;
   Dlon := Lon2-Lon1;
   ProjDLat := Ln(tan(Pi/4+Lat2/2)/tan(Pi/4+Lat1/2));

   If abs(ProjDlat) > 1e-12 then
     Q := DLat/ProjDLat
   else
     Q := cos(Lat1);

   if abs(DLon) > Pi/2 then
     if DLon>0 then
       Dlon := -(2*Pi-Dlon)
     else
       DLon := Dlon+2*Pi;
   dist    := sqrt(sqr(Dlat)+sqr(q*DLon))*R;
   Azimuth := (arctan2(DLon,ProjDLat))/Pi*180;      {in degrees}
   if Azimuth < 0 then
     Azimuth := Azimuth + 360;    // 0 to 360: 0=N, 90=E, 180=S, 270=W

   case units of {convert result to desired units}
     muMiles:           result := dist * 0.00062137;
     muKilometers:      result := dist * 0.001;
     muNauticalMiles:   result := dist * 0.00053996;
     else
       raise Exception.Create('System error: RhumbDistance unknown units');
   end;
end;

// Azimuth code in degrees- N = 0, E = 90; S = 180; W = 270
function AzimuthCode(Angle: double): string;
const
  ONE_SIXTEENTH = 360 / 16;
  Azimuth = 'N  NNENE ENEE  ESESE SSES  SSWSW WSWW  WNWNW NNWN  ';
  //         000   002   004   006   008   010   012   014   016
  //            001   003   005   007   009   011   013   015
var
  AngleI: integer;
begin
  AngleI := Round(Angle);

  if AngleI < 0 then
    AngleI := AngleI + 360 else
  if AngleI > 360 then
    AngleI := AngleI mod 360;

  AngleI      := Round(AngleI / ONE_SIXTEENTH);

  result := Copy(Azimuth, (AngleI*3)+1, 3);
end;

function InArc(Azimuth, DesiredAzimuth: double; MaxDeviation: double = DEFAULT_MAXDEVIATION): boolean;
var
  Angle: integer;
begin
  Angle  := Trunc(Abs(Azimuth - DesiredAzimuth));
  if Angle >= 180.0 then
    Angle := 360 - Angle;
  result := Angle < MaxDeviation;
end;
(*
    var
      D: Double;
      MinP, MaxP, AzP: double;
      D       := - MinAzimuth;
      MinP    := MinAzimuth + D;
      MaxP    := MaxAzimuth + D;
      Azp     := Azimuth + D;
      result := (MinP <= AzP) and
                (AzP  <= MaxP);
*)
(*
      if MaxAzimuth > 360 then
        begin
          result := Azimuth <= (MaxAzimuth - 360)
        end else
      if MinAzimuth < 0 then
        begin
          result := ((AzimuthMin + 360) <= (Azimuth + 360)) and
                    ((Azimuth + 360)    <= (AzimuthMax + 360));
        end
      else
        result := (AzimuthMin <= Azimuth) and
                  (Azimuth    <= AzimuthMax);
*)
(*
          result := (Azimuth <= (MaxAzimuth - 360));
          if result then
            result := (Azimuth > (MinAzimuth - 360));
*)


end.
