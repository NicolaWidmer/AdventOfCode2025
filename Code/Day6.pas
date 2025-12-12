{$mode delphi}

program Day6;

uses
  SysUtils;


function getNumber(col:Int64; allLines: array of string): Int64;
var
  i,ans:Int64;
begin
  ans := 0;
  for i := 0 to (High(allLines)-1) do
  begin
    if allLines[i][col] <> ' ' then
      ans := ans*10 + (ord(allLines[i][col]) - ord('0'));
  end;
  Result := ans;
end;


var
  F: TextFile;
  Line: string;
  Parts: TStringArray;
  s: string;
  Lines: array of TStringArray;
  allLines: array of string;
  n,i,j,cur,cur_num: Int64;
  ans1,ans2: Int64;
  cur_op: char;

begin
  AssignFile(F, '../Input/Day6.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;
  n := 0;

  while not Eof(F) do
  begin
    ReadLn(F, Line);

    SetLength(Lines, n + 1);
    SetLength(allLines, n + 1);

    allLines[n] := Line;
    Parts := Line.Split([' ']);
  
    for s in Parts do
    begin
      if Length(S) > 0 then
      begin
        SetLength(Lines[n], Length(Lines[n]) + 1);
        Lines[n][High(Lines[n])] := s;
      end;
    end;

    Inc(n);
  end;

  for i := 0 to (Length(Lines[n-1]) - 1) do
  begin
    cur := StrToInt64(Lines[0][i]);
    for j := 1 to (High(Lines) - 1) do
    begin
      if Lines[n-1][i] = '*' then
        cur := cur * StrToInt64(Lines[j][i])
      else
        cur := cur + StrToInt64(Lines[j][i]);
    end;
    ans1 := ans1 + cur;
  end;

  cur := 0;
  cur_op := ' ';

  for i := 1 to High(allLines[0]) do
  begin
    cur_num := getNumber(i,allLines);
    if allLines[n - 1][i] <> ' ' then
    begin
      cur_op :=  allLines[n - 1][i];
      ans2 := ans2 + cur;
      cur := cur_num;
    end
    else if cur_num <> 0 then
    begin
      if cur_op = '*' then
      begin
        cur := cur * getNumber(i,allLines);
      end
      else
        cur := cur + getNumber(i,allLines);
    end;
  end;

  ans2 := ans2 + cur;
  

  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.