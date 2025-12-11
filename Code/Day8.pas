{$mode delphi}

program Day9;

uses
  SysUtils,AnySort;

type
  TPoint = record
    x, y, z: Int64;
end;

type
  TIndexPair = record
    i, j: Int64;
    p1, p2: TPoint;
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

function dist(p1,p2: TPoint): Int64;
var
  dx, dy, dz: Int64;
begin
  dx := p1.x - p2.x;
  dy := p1.y - p2.y;
  dz := p1.z - p2.z;
  Result := (dx * dx) + (dy * dy) + (dz * dz);
end;

function CompareIndexPairs(const a,b:TIndexPair): Integer;
begin
    if (dist(a.p1,a.p2) - dist(b.p1,b.p2) < 0) then
     Result := -1
    else if (dist(a.p1,a.p2) - dist(b.p1,b.p2) > 0) then
     Result := 1
    else
     Result := 0;
end;


// sorts implemented by AI

procedure BubbleSort(var A: array of Integer);
var
  i, j, Temp: Integer;
  Swapped: Boolean;
begin
  // Outer loop controls the number of passes
  for i := Low(A) to High(A) - 1 do
  begin
    Swapped := False; // Assume the array is sorted in this pass
    
    // Inner loop performs the comparisons and swaps
    // We only need to check up to High(A) - i because the last i elements 
    // are already in their correct (sorted) position.
    for j := Low(A) to High(A) - 1 - i do
    begin
      // Compare adjacent elements
      if A[j] > A[j + 1] then
      begin
        // Swap if they are in the wrong order
        Temp := A[j];
        A[j] := A[j + 1];
        A[j + 1] := Temp;
        Swapped := True; // A swap occurred, so the array is not sorted yet
      end;
    end;
    
    // Optimization: If no two elements were swapped by inner loop, then the array is sorted
    if not Swapped then
      Break;
  end;
end;

function Partition(var A: array of TIndexPair; L, R: Integer): Integer;
var
  i, j: Integer;
  Pivot,Temp: TIndexPair;

begin
  Pivot := A[R]; // Choose the rightmost element as the pivot
  i := L - 1;    // Index of smaller element

  for j := L to R - 1 do
  begin
    // If current element is smaller than or equal to the pivot
    if CompareIndexPairs(A[j],Pivot) <= 0 then
    begin
      Inc(i); // Increment index of smaller element
      
      // Swap A[i] and A[j]
      Temp := A[i];
      A[i] := A[j];
      A[j] := Temp;
    end;
  end;
  // Swap the pivot element (A[R]) with the element at A[i + 1]
  Temp := A[i + 1];
  A[i + 1] := A[R];
  A[R] := Temp;

  // Return the new partition index
  Result := i + 1;
end;

procedure QuickSort(var A: array of TIndexPair; L, R: Integer);
var
  PartitionIndex: Integer;
begin
  // Base case: Only proceed if the subarray has 2 or more elements
  if L < R then
  begin
    // Partition the array, getting the final pivot position
    PartitionIndex := Partition(A, L, R);

    // Recursively sort the elements before the partition index
    QuickSort(A, L, PartitionIndex - 1);

    // Recursively sort the elements after the partition index
    QuickSort(A, PartitionIndex + 1, R);
  end;
end;


function find(var parents: array of Integer; i: Integer): Integer;
var
 par: Int64;
begin
  if i = parents[i] then
    Result := i
  else
  begin
    par := find(parents,parents[i]);
    parents[i] := par;
    Result := par;
  end;
end;

function computeans1(n: Int64;var parents: array of Integer): Integer;
var
    i,j: Int64;
    componentsizes: array of Integer;
begin

  SetLength(componentsizes, n);
  for i := 0 to (n-1) do
  begin
     componentsizes[i] := 0;
  end;

  for i := 0 to (n-1) do
  begin
    j := find(parents,i);
    Inc(componentsizes[j]);
  end;

  BubbleSort(componentsizes);

  Result := componentsizes[n-1] * componentsizes[n-2] * componentsizes[n-3];
end; 


var
  F: TextFile;
  Line: string;
  Parts: TStringArray;
  Points: array of TPoint;
  PointPairs: array of TIndexPair;
  n,n2,i,j,rounds: Int64;
  ans1,ans2: Int64;
  parents: array of Integer;
  indpair: TIndexPair;
  pari,parj: Int64;
  components: Int64;

begin
  AssignFile(F, '../Input/Day8.in');
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
    Points[n].z := StrToInt64(Parts[2]);

    Inc(n);
  end;

  SetLength(parents, n);

  for i := 0 to (n-1) do
  begin
     parents[i] := i;
  end;

  SetLength(PointPairs,((n-1)*n) div 2);

  n2 := 0;

  begin;
  for i := 0 to (n-1) do
    begin
        for j := (i+1) to (n-1) do
        begin 
            PointPairs[n2].i := i;
            PointPairs[n2].j := j;
            PointPairs[n2].p1 := Points[i];
            PointPairs[n2].p2 := Points[j];
            Inc(n2);
        end;
  end;
  end;

  QuickSort(PointPairs, Low(PointPairs), High(PointPairs));

  i := 0;
  rounds := 1000;

  for i := 1 to n2 do
  begin
   indpair := PointPairs[i];

   pari := find(parents,indpair.i);
   parj := find(parents,indpair.j);

   if pari <> parj then
   begin
    parents[pari] := parj;
    ans2 := indpair.p1.x * indpair.p2.x;
   end;

   if i = rounds then
   begin
    ans1 := computeans1(n,parents);
   end;
  end;


  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.