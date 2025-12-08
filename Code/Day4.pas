
{$mode delphi}

program Day4;

uses
  SysUtils, Classes;

type
  TCharGrid = array of array of Char;


function CloneGrid(const src: TCharGrid): TCharGrid;
var
  i, j: Integer;
  ans: TCharGrid;
begin
  SetLength(ans, Length(src));
  for i := 0 to High(src) do
  begin
    SetLength(ans[i], Length(src[i]));
    for j := 0 to High(src[i]) do
      ans[i][j] := src[i][j];
  end;
  CloneGrid := ans;
end;




var
  Lines: TStringList;
  CharMap,NextCharMap: TCharGrid;
  NextLines: TStringList;
  ans1,ans2: Int64;
  n,m: Int64;
  x,y,dy,dx: Int64;
  removed: Int64;
  row,col: Int64;
  count: Int64;

begin

  ans1 := 0;
  ans2 := 0;

  Lines := TStringList.Create;
  try
    Lines.LoadFromFile('../Input/Day4.in');

    n := Lines.Count;
    m := Length(Lines[1]);

    SetLength(CharMap, n, m);

    for row := 0 to n-1 do
      for col := 1 to m do
        CharMap[row][col-1] := Lines[row][col];

      NextCharMap := CloneGrid(CharMap);

    removed := -1;

    while removed <> 0 do
    begin
    removed := 0;

    for x := 0 to (n-1) do 
    begin
      for y := 0 to (m-1) do
      begin
        count := 0;
        for dx := -1 to 1 do
        begin
          for dy := -1 to 1 do
          begin
            if ((x+dx) >= 0) and ((x+dx) < n) and ((y+dy) >= 0) and ((y+dy) < m) and (CharMap[x+dx][y+dy] = '@') then
              count := count + 1;
          end;
        end;

        if (count < 5) and (CharMap[x][y] = '@') then
        begin
          removed := removed + 1;
          NextCharMap[x][y] := '.';
        end;

      end;
    end;

    if ans1 = 0 then
      ans1 := removed;

    ans2 := ans2 + removed;

    CharMap := CloneGrid(NextCharMap);

    end;



  finally
    Lines.Free;
  end;

  WriteLn(ans1);
  WriteLn(ans2);
end.