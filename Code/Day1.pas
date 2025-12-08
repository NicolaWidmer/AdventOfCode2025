{$mode objfpc}

program Day1;

uses SysUtils;

var
  F: TextFile;
  Line: string;
  Dir: Char;
  Value: Integer;
  Ans: Integer;
  Ans2: Integer;
  Cur: Integer;
begin
  AssignFile(F, '../Input/Day1.in');
  Reset(F);

  Cur := 50;
  Ans := 0;
  Ans2 := 0;

  while not Eof(F) do
  begin
    ReadLn(F, Line);
    Line := Trim(Line);

    if Line <> '' then
    begin

      Dir := Line[1];                     
      Value := StrToInt(Copy(Line, 2));

      Ans2 := Ans2 + (Value div 100);

      if Dir = 'R' then
      begin
        if (Cur + (Value mod 100) > 100)  then
        begin
            Ans2 := Ans2 + 1;
        end;
        Cur := (Cur + Value) mod 100;

        end
      else
      begin
        if (Cur - (Value mod 100) < 0) and (Cur <> 0) then
        begin
            Ans2 := Ans2 + 1;
        end;
        Cur := (Cur - Value + 10000) mod 100;
      end;

      if Cur = 0 then
      begin
        Ans := Ans + 1;
        Ans2 := Ans2 + 1;
      end;

    end;
  end;

  CloseFile(F);
  WriteLn(Ans);
  WriteLn(Ans2);
end.