{$mode delphi}

program Day6;

uses
  SysUtils;


var
  F: TextFile;
  Line: string;
  Parts: TStringArray;
  Ranges,mergedRanges: array of TRange;
  n,num,i,j,n2: Int64;
  ans1,ans2: Int64;
  inRange,found: Boolean;

begin
  AssignFile(F, '../Input/Day5.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;
  n := 0;

  ReadLn(F, Line);
  Line := Trim(Line);

  while Line <> '' do
  begin
    Parts := Line.Split(['-']);

    SetLength(Ranges, n + 1);
    Ranges[n].lo := StrToInt64(Parts[0]);
    Ranges[n].hi := StrToInt64(Parts[1]);

    Inc(n);

    ReadLn(F, Line);
    Line := Trim(Line);
  end;

  while not Eof(F) do
  begin
    ReadLn(F, Line);
    Line := Trim(Line);

    num := StrToInt64(Line);

    inRange := False;

    for i:= 0 to (n-1) do
    begin
        if (num >= Ranges[i].lo) and (num <= Ranges[i].hi) then
            inRange := True;
    end;


    if inRange then
        Inc(ans1);

  end;

  n2 := 0;

  for i := 0 to (n-1) do
  begin
    found := False;

    for j := (i+1) to (n-1) do
    begin
        if (Ranges[i].lo <= Ranges[j].hi) and (Ranges[j].lo <= Ranges[i].hi) then
        begin
            Ranges[j].hi := Max64(Ranges[j].hi,Ranges[i].hi);
            Ranges[j].lo := Min64(Ranges[j].lo,Ranges[i].lo);
            found := True;
            continue;
        end;
    end;

    if not found then
    begin
        SetLength(mergedRanges, n2 + 1);
        mergedRanges[n2].lo := Ranges[i].lo;
        mergedRanges[n2].hi := Ranges[i].hi;
        Inc(n2);
    end;
  end;

  for i:= 0 to (n2-1) do
  begin
    ans2 := ans2 + (mergedRanges[i].hi - mergedRanges[i].lo + 1)
  end;

  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.