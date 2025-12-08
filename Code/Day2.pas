{$mode delphi}

program Day2;

uses
  SysUtils;

function checkOne2(s: string): Int64;
var
    ans: Int64;
    n,i,j,k: Int64;
    pos: Boolean;
begin
  n := Length(s);

  ans := 0;

  for i := 1 to (n div 2) do
  begin
   pos := True;
   if (n mod i) <> 0 then
   begin
    pos := False;
   end;
   for j := 0 to (i-1) do
   begin
    for k := 1 to ((n div i) - 1) do
    begin
     if s[j+1] <> s[k*i + j + 1] then
      pos := False;
    end;
   end;
   if pos then
    ans := StrToInt64(s);
 end;
  checkOne2 := ans; 
end;

function checkRange2(a, b: Int64): Int64;
var
    i: Int64;
    ans: Int64;
begin

    ans := 0;
    for i := a to b do
    begin
        ans := ans + checkOne2(IntToStr(i));
    end;

    checkRange2 := ans;
end;

function checkOne(s: string): Int64;
var
    ans: Int64;
    n,i: Int64;
begin
  n := Length(s);
  ans := StrToInt64(s);
  if (n mod 2) = 1 then
    ans := 0;

  for i := 1 to (n div 2) do
  begin
    if s[i] <> s[i + (n div 2)] then
     ans := 0;
  end;
  checkOne := ans;
end;

function checkRange(a, b: Int64): Int64;
var
    i: Int64;
    ans: Int64;
begin

    ans := 0;
    for i := a to b do
    begin
        ans := ans + checkOne(IntToStr(i));
    end;

    checkRange := ans;
end;

var
  F: TextFile;
  Line: string;
  Parts, RangeParts: TStringArray;
  i: Int64;
  a, b: Int64;
  ans1,ans2: Int64;

begin
  AssignFile(F, '../Input/Day2.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;

  while not Eof(F) do
  begin
    ReadLn(F, Line);
    Line := Trim(Line);

    Parts := Line.Split([',']);

    for i := 0 to High(Parts) do
    begin
       RangeParts := Parts[i].Split(['-']);

       a := StrToInt64(RangeParts[0]);
       b := StrToInt64(RangeParts[1]);
       ans1 := ans1 + checkRange(a,b);
       ans2 := ans2 + checkRange2(a,b);
    end;
  end;
  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.