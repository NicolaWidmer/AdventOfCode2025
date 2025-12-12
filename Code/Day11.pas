{$mode delphi}

program Day9;

uses
  SysUtils;

type
  Graph = array of array of Int64;

function Max64(a, b: Int64): Int64;
begin
  if a > b then Result := a else Result := b;
end;


function stringToIndex(s:String): Int64;
begin
    Result := (ord(s[1])-ord('a'))*26*26+((ord(s[2])-ord('a'))*26)+(ord(s[3])-ord('a'));
end;


procedure resetPaths(var paths: array of Int64);
var 
 i: Int64;
begin 
  for i := 0 to 26*26*26 do
  begin
    paths[i] := -1;
  end;
end;

function dfs(u: Int64; g: Graph; var paths: array of Int64; target: Int64): Int64;
var
    n,ans,i: Int64;
begin
    if u = target then
        Result := 1
    else if paths[u] <> -1 then
        Result := paths[u]
    else
    begin
        ans := 0;
        n := length(g[u]);
        for i := 0 to (n - 1) do
        begin
            ans := ans + dfs(g[u][i],g,paths,target);
        end;
        paths[u] := ans;
        Result := ans;
    end;
end;

function dfs2(u: Int64; g: Graph; var paths: array of Int64; target: Int64): Int64;
begin
    resetPaths(paths);
    Result := dfs(u,g,paths,target);
end;


var
  F: TextFile;
  Line: string;
  Parts: TStringArray;
  source: String;
  source_num: Int64;
  ans1,ans2: Int64;
  n,i,node,n2: Int64;
  g: Graph;
  paths: array of Int64;

begin
  AssignFile(F, '../Input/Day11.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;
  n := 0;
  SetLength(g,26*26*26);
  SetLength(paths,26*26*26);


  while not Eof(F) do
  begin

    ReadLn(F, Line);
    Line := Trim(Line);
    Parts := Line.Split([':']);


    source := Parts[0];
    Parts := Parts[1].Split([' ']);

    n2 := length(Parts);
    source_num := stringToIndex(source);

    SetLength(g[source_num],n2 - 1);

    for i := 1 to (n2-1) do
    begin
        g[source_num][i-1] := stringToIndex(Parts[i]);
    end;

    Inc(n);
  end;

  ans1 := dfs2(stringToIndex('you'),g,paths,stringToIndex('out'));

  ans2 := Max64(
    dfs2(stringToIndex('svr'),g,paths,stringToIndex('dac')) * dfs2(stringToIndex('dac'),g,paths,stringToIndex('fft')) * dfs2(stringToIndex('fft'),g,paths,stringToIndex('out')),
    dfs2(stringToIndex('svr'),g,paths,stringToIndex('fft')) * dfs2(stringToIndex('fft'),g,paths,stringToIndex('dac')) * dfs2(stringToIndex('dac'),g,paths,stringToIndex('out'))
  );

  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.