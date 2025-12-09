{$mode delphi}

program Day9;

uses
  SysUtils;

type
  TPoint = record
    x, y: Int64;
end;

function Max64(a, b: Int64): Int64;
begin
  if a > b then Result := a else Result := b;
end;

function Min64(a, b: Int64): Int64;
begin
  if a < b then Result := a else Result := b;
end;

function Abs64(a: Int64): Int64;
begin
  if a > 0 then Result := a else Result := -a;
end;

function doOverlap(p1,p2,p3,p4: TPoint): Boolean;
var 
 pTopLeft,pBotomRight: TPoint;
 lineTopLeft,lineBotomRight: TPoint;
begin
  pTopLeft.x := Min64(p1.x,p2.x);
  pTopLeft.y := Min64(p1.y,p2.y);
  pBotomRight.x := Max64(p1.x,p2.x);
  pBotomRight.y := Max64(p1.y,p2.y);
  lineTopLeft.x := Min64(p3.x,p4.x);
  lineTopLeft.y := Min64(p3.y,p4.y);
  lineBotomRight.x := Max64(p3.x,p4.x);
  lineBotomRight.y := Max64(p3.y,p4.y);

  Result := (pTopLeft.x < lineBotomRight.x) and (pTopLeft.y < lineBotomRight.y) and (pBotomRight.x > lineTopLeft.x) and (pBotomRight.y > lineTopLeft.y);
end;


var
  F: TextFile;
  Line: string;
  Parts: TStringArray;
  Points: array of TPoint;
  n,i,j,k,cur: Int64;
  ans1,ans2: Int64;

begin
  AssignFile(F, '../Input/Day9.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;
  n := 0;


  while not Eof(F) do
  begin

    ReadLn(F, Line);
    Line := Trim(Line);
    Parts := Line.Split([',']);

    SetLength(Points, n + 1);
    Points[n].x := StrToInt64(Parts[0]);
    Points[n].y := StrToInt64(Parts[1]);

    Inc(n);
  end;

  for i := 0 to (n-1) do
  begin
    for j := 0 to (n-1) do
    begin
      cur :=  (Abs64(Points[i].x - Points[j].x) + 1) * (Abs64(Points[i].y - Points[j].y) + 1);
      ans1 := Max64(ans1,cur);

      for k := 0 to (n-1) do
      begin
        if doOverlap(Points[i],Points[j],Points[k],Points[(k+1) mod n]) then
        begin 
          cur := 0;
          break;
        end
      end;

      ans2 := Max64(ans2,cur);
    end;
  
  end;

  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.