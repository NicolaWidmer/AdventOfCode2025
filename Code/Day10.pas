program Day10;

{$mode objfpc}{$H+} // Enable modern Object Pascal features and AnsiStrings

uses
  SysUtils, Classes,Math;


//pasrsing done by gemini
type
  // Define a dynamic array of integers
  TIntArray = array of Int64;
  TGroupArray = array of TIntArray;
  TDoubleArray = array of Double;
  TMatrix = array of TDoubleArray;
  
  // Define a structure to hold the parsed line
  TParsedLine = record
    Pattern: string;                // The part in [...]
    Groups: array of TIntArray;     // The parts in (...) (...)
    Values: TIntArray;              // The part in {...}
  end;



function Min64(a, b: Int64): Int64;
begin
  if a > b then Result := b else Result := a;
end;


// Helper: Converts a comma-separated string "1,2,3" into an integer array
function ParseIntList(input: string): TIntArray;
var
  List: TStringList;
  i: Integer;
begin
  Result := nil;
  if input = '' then Exit;
  
  List := TStringList.Create;
  try
    List.CommaText := input; // Handles commas automatically
    SetLength(Result, List.Count);
    for i := 0 to List.Count - 1 do
    begin
      // Trim spaces and convert to Int
      Result[i] := StrToIntDef(Trim(List[i]), 0);
    end;
  finally
    List.Free;
  end;
end;

// Main Parsing Function
function ParseLine(const rawLine: string): TParsedLine;
var
  pStart, pEnd, i: Integer;
  tempStr, groupChunk: string;
  RawGroups: string;
begin
  // 1. Extract Pattern [...]
  pStart := Pos('[', rawLine);
  pEnd := Pos(']', rawLine);
  Result.Pattern := Copy(rawLine, pStart + 1, pEnd - pStart - 1);

  // 2. Extract Values {...}
  pStart := Pos('{', rawLine);
  pEnd := Pos('}', rawLine);
  tempStr := Copy(rawLine, pStart + 1, pEnd - pStart - 1);
  Result.Values := ParseIntList(tempStr);

  // 3. Extract Groups (...) (...)
  // We isolate the middle section between ] and {
  pStart := Pos(']', rawLine);
  pEnd := Pos('{', rawLine);
  RawGroups := Copy(rawLine, pStart + 1, pEnd - pStart - 1);

  // Iterate through RawGroups to find (parentheses)
  SetLength(Result.Groups, 0);
  for i := 1 to Length(RawGroups) do
  begin
    if RawGroups[i] = '(' then
      pStart := i
    else if RawGroups[i] = ')' then
    begin
      // Found a complete group (e.g., "1,3")
      groupChunk := Copy(RawGroups, pStart + 1, i - pStart - 1);
      
      // Resize array and parse the chunk
      SetLength(Result.Groups, Length(Result.Groups) + 1);
      Result.Groups[High(Result.Groups)] := ParseIntList(groupChunk);
    end;
  end;
end;

//from here my code

function rec(input: Int64): TGroupArray;
var 
    prev,ans : array of TIntArray;
    n,m,i,j: Int64;
begin
    if input = 0 then
        Result := [[]]
    else
    begin
        prev := rec(input-1);
        n := Length(prev);
        SetLength(ans,2*n);
        for i := 0 to (n-1) do
        begin
            ans[2*i] := prev[i];
            m := Length(prev[i]);
            SetLength(ans[2*i+1],m+1);
            for j := 0 to (m - 1) do
                ans[2*i+1][j] := prev[i][j];
            ans[2*i+1][m] := input-1;
        end;
        Result := ans;
    end;

end;

function isValid(pressedButtons: array of Int64; buttons: array of TIntArray; pattern: string): Boolean;
var
    createdPattern: array of Boolean;
    but,n,i: Int64;
begin
    n := Length(pattern);
    SetLength(createdPattern,n);

    for i := 0 to n-1 do
        createdPattern[i] := false;

    for but in pressedButtons do
    begin
        for i in buttons[but] do
            createdPattern[i] := not createdPattern[i];
    end;

    Result := true;
    for i := 0 to n-1 do
        if createdPattern[i] <> (pattern[i+1] = '#') then  //fml strings are 1 indexed
            Result := false;
end;

function solve(parsedLine: TParsedLine): Int64;
var
    pattern :string;
    boolPattern: array of Boolean;
    buttons: array of TIntArray;
    pressedButtons: array of Int64;
    pressedButtonsList: TGroupArray;
    n,m,i,ans: Int64;
begin
    pattern := parsedLine.Pattern;
    buttons := parsedLine.Groups;
    n := Length(pattern);
    m := Length(buttons);
    SetLength(boolPattern,n);
    ans := 10000;

    pressedButtonsList := rec(m);

    for pressedButtons in pressedButtonsList do
    begin
        if isValid(pressedButtons,buttons,pattern) then
            ans := Min64(ans,Length(pressedButtons));
    end;
    Result := ans;
end;

procedure PrintVector(const v: TDoubleArray);
var
  i: Integer;
begin
    Write('[');
  for i := 0 to High(v) do
  begin
    Write(round(v[i]));
    if i < High(v) then
      Write(', ');
  end;
  WriteLn(']');
end;

procedure PrintMatrix(const A: TMatrix);
var
  i, j: Integer;
begin
 Write('[');
  for i := 0 to High(A) do
  begin
    Write('[');
    for j := 0 to High(A[i]) do
    begin
      Write(round(A[i][j]));
      if j < High(A[i]) then
        Write(',');
    end;
    if i < High(A) then
      Write('],')
    else
      Write(']');
  end;
  WriteLn(']');
end;


procedure printLP(parsedLine: TParsedLine);
var
    buttons: array of TIntArray;
    target: array of Int64;
    n,m,i,but,ans: Int64;
    cur: Double;
    A: TMatrix;
    b: TDoubleArray;
begin
    target := parsedLine.Values;
    buttons := parsedLine.Groups;
    n := Length(target);
    m := Length(buttons);
    SetLength(A,n,m);
    SetLength(b,n);

    for i := 0 to n-1 do
        for but := 0 to m-1 do
            A[i][but] := 0;

    for i := 0 to (m-1) do
    begin
        for but in buttons[i] do
            A[but][i] := 1;
    end;

    for i := 0 to n-1 do
        b[i] := target[i];

    PrintMatrix(A);
    PrintVector(b);
end;



var
  F: TextFile;
  Line: string;
  ParsedLines: array of TParsedLine;
  n,m,i,j: Int64;
  a: TIntArray;
  ans1,ans2: Int64;
  Parsed: TParsedLine;
begin

  AssignFile(F, '../Input/Day10.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;
  n := 0;

  while not Eof(F) do
  begin
    ReadLn(F, Line);
    Trim(Line);

    SetLength(ParsedLines, n + 1);

    ParsedLines[n] := ParseLine(Line);

    Inc(n);
  end;

  for i := 0 to (n-1) do 
  begin
    ans1 := ans1 + solve(ParsedLines[i]);
    printLP(ParsedLines[i]);
   end;

  Writeln(ans1);
  Writeln(ans2);


end.