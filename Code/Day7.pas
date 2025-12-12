{$mode delphi}

program Day7;

uses
  SysUtils;


  procedure initRays(var rays: array of Int64);
  var
    i:Int64;
  begin
    for i := 0 to High(rays) do
        rays[i] := 0;
  end;


var
  F: TextFile;
  Line: string;
  allLines: array of string;
  n,m,i,j: Int64;
  ans1,ans2: Int64;
  rays,next_rays: array of Int64;

begin
  AssignFile(F, '../Input/Day7.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;
  n := 0;

  while not Eof(F) do
  begin
    ReadLn(F, Line);

    SetLength(allLines, n + 1);

    allLines[n] := Line;

    Inc(n);
  end;

  m :=  Length(allLines[0]);
  WriteLn(m);

  SetLength(rays,m);
  SetLength(next_rays,m);

  initRays(rays);

  for i := 0 to (m-1) do
    if allLines[0][i] = 'S' then
        rays[i] := 1;

  for i := 0 to (m-1) do
    Write(rays[i],' ');
  WriteLn();

  for i := 0 to (n-1) do
  begin
    initRays(next_rays);
    for j := 0 to (m-1) do
    begin
        if (rays[j] <> 0) and (allLines[i][j] = '^') then
        begin
            next_rays[j-1] :=  rays[j] + next_rays[j-1];
            next_rays[j+1] :=  rays[j] + next_rays[j+1];
            ans1 := ans1 + 1;
        end
        else if rays[j] <> 0 then
            next_rays[j] := rays[j] + next_rays[j];

    end;
    for j := 0 to (m-1) do
        rays[j] := next_rays[j]; 
  end;

  for j := 0 to (m-1) do
    ans2 := ans2 + rays[j]; 
  Inc(ans2);

  

  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.