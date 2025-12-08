{$mode delphi}

program Day3;

uses
  SysUtils;


var
  F: TextFile;
  Line, s: string;
  i,num: Int64;
  ans1,ans2: Int64;
  max,ind,second_max: Int64;
  cur,j,num_bats: Int64;

begin
  AssignFile(F, '../Input/Day3.in');
  Reset(F);

  ans1 := 0;
  ans2 := 0;

  num_bats := 12;

  while not Eof(F) do
  begin
    ReadLn(F, Line);
    Line := Trim(Line);
    //WriteLn(Line);

    s := Line;

    cur := 0;
    ind := 1;

    for j := 1 to num_bats do
    begin

        max := 0;
        for i := ind to (Length(s) - (num_bats - j)) do
        begin
            num := Ord(s[i]) - Ord('0');
            if max < num then
            begin
                max := num;
                ind := i+1;
            end;
        end;
        cur := cur*10 + max;

    end; 
    WriteLn(cur);

    ans2 := ans2 + cur;

    ind := 0;
    max := 0;



    for i := 1 to (Length(s)-1) do
    begin
        num := Ord(s[i]) - Ord('0');
        if max < num then
        begin
          max := num;
          ind := i;
        end;
    end;

    second_max := 0;

    for i := (ind+1) to Length(s) do
    begin
        num := Ord(s[i]) - Ord('0');
        if second_max < num then
        begin
          second_max := num;
        end;
    end; 
       
    ans1 := ans1 + (max*10+second_max);
    //WriteLn(max*10+second_max);
  end;
  WriteLn(ans1);
  WriteLn(ans2);

  CloseFile(F);
end.