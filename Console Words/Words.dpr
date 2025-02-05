program Words;

uses SysUtils;

const
  DictSize = 1532629;

var
  S, Source: string;
  PlayerCount, WordCount, Max: integer;
  Score, CurrScore: array [1 .. 4] of integer;
  Dictionary, UsedWords: array of string;
  Code: byte;

const
  alphabet =
    '�����������娸����������������������������������������������������-';

procedure GetDictionary(var Dictionary: array of string; Name: string);
var
  Txt: TextFile;
  i: integer;
begin
  AssignFile(Txt, Name);
  Reset(Txt);
  i := 0;
  while not EOF(Txt) do
  begin
    Readln(Txt, Dictionary[i]);
    Inc(i);
  end;
end;

function ChangeRegister(S: string): string;
begin
  for var i := 1 to Length(S) do
  begin
    if (S[i] >= '�') and (S[i] <= '�') then
      S[i] := Chr(Ord(S[i]) + 32)
    else if (S[i] = '�') or (S[i] = '�') then
      S[i] := '�';

  end;
  result := S;
end;

function CheckRussWord(s: string):boolean;
var numright: integer;
begin
  numright := 0;
  for var i := 1 to length(s) do
    if pos(s[i], alphabet) > 0 then
      inc(numright);
  if numright = length(s) then
    result := true
  else
    result := false;
end;

function CheckWord(const Dictionary: array of string; Word: string): boolean;
var
  Place, Step: integer;
  DebugWord: string;
begin
  result := false;
  Step := Length(Dictionary) div 2;
  Place := Step;
  repeat
    if ChangeRegister(Dictionary[Place]) = Word then
      result := true
    else
    begin
      Step := (Step div 2) + 1;
      if ChangeRegister(Dictionary[Place]) > Word then
        Place := Place - Step
      else
        Place := Place + Step;
      DebugWord := Dictionary[Place];
    end;
  until result or (Step = 2);
  if not result then
  begin
    Step := 1;
    if ChangeRegister(Dictionary[Place]) = Word then
      result := true
    else
    begin
      if ChangeRegister(Dictionary[Place]) > Word then
        Place := Place - Step
      else
        Place := Place + Step;
    end;
    if Dictionary[Place] = Word then
      result := true
  end
end;

function GetRandomWord(const Dictionary: array of string;
  MinLength: integer): string;
var
  Number, i: integer;
begin
  if MinLength < 30 then
  begin
    Number := Random(Length(Dictionary));
    if Number > Length(Dictionary) then
      i := -1
    else
      i := 1;
    while Length(Dictionary[Number]) < MinLength do
      Number := Number + i;
    result := Dictionary[Number];
  end
  else
    result := '���-�����-�������-����-��������';
end;

function GetScore(var S: string; Source: string; var UsedWords: array of string;
  // ����: 0 - �� ��, 1 - ������ ������, 2 - ����� �� ����������, 3 - ��������, 4 - �����������, 5 - �� �� �����
  var WordCount: integer; var Code: byte): integer;
var
  Flag: boolean;
  i: integer;
begin
  Flag := true;
  if (S = '') or not CheckRussWord(s) then
  begin
    result := 0;
    Code := 1;
  end
  else
  begin
    i := 1;
    if UsedWords[0] = S then
    begin
      Flag := false;
      Code := 4;
    end
    else
      while Flag and (i <= WordCount) do
      begin
        if UsedWords[i] = S then
        begin
          Flag := false;
          Code := 3;
        end;
        Inc(i);
      end;
    if Flag and CheckWord(Dictionary, S) then
    begin
      result := 0;
      for i := 1 to Length(S) do
        if Pos(S[i], Source) <> 0 then
        begin
          Delete(Source, Pos(S[i], Source), 1);
          S[i] := Chr(Ord(S[i]) - 32);
        end
        else
        begin
          Dec(result);
          Code := 5;
        end;
      if result = 0 then
      begin
        result := Length(S);
        UsedWords[WordCount] := ChangeRegister(S);
        Inc(WordCount);
      end;
    end
    else
    begin
      result := -Length(S);
      if Flag then
        Code := 2;
    end;
  end;
end;

begin
  var
    i, j: integer;
  PlayerCount := 0;
  repeat
    Write('������� ���������� ������� (2-4): ');
    try
      Readln(PlayerCount);
    except
    end
  until PlayerCount in [2 .. 4];
  SetLength(Dictionary, DictSize);
  GetDictionary(Dictionary, 'Dictionary.txt');
  Randomize;
  Source := GetRandomWord(Dictionary, 10);
  Writeln('���� �������� �����: ', Source);
  Source := ChangeRegister(Source);
  SetLength(UsedWords, PlayerCount * Length(Source));
  UsedWords[0] := Source;
  WordCount := 1;
  for i := 1 to PlayerCount do
    CurrScore[i] := 1;
  repeat
    i := 1;
    while (i <= PlayerCount) and not((CurrScore[1] = 0) and (CurrScore[2] = 0)
      and (CurrScore[3] = 0) and (CurrScore[4] = 0)) do
    begin
      Write('����� ������ ', i, ': ');
      Readln(S);
      S := Trim(S);
      S := ChangeRegister(S);
      Code := 0;
      CurrScore[i] := GetScore(S, Source, UsedWords, WordCount, Code);
      Score[i] := Score[i] + CurrScore[i];
      case Code of
        0:
          Writeln('����� ', i, ' �������� ', CurrScore[i], ' �����');
          // ����: 0 - �� ��, 1 - ������ ������, 2 - ����� �� ����������, 3 - ��������, 4 - �����������, 5 - �� �� �����
        1:
          Writeln('����� ', i, ' ���������� ���');
        2:
          Writeln('����� ', i, ' ������ ', -CurrScore[i],
            ' �����: ������ ����� �� ����������');
        3:
          Writeln('����� ', i, ' ������ ', -CurrScore[i],
            ' �����: ��� ����� ��� ��������������');
        4:
          Writeln('����� ', i, ' ������ ', -CurrScore[i],
            ' �����: ��� ����������� �����');
        5:
          Writeln('����� ', i, ' ������ ', -CurrScore[i],
            ' �����: ����� �������� ������������ �����: ', S);
      end;
      if i < PlayerCount then
        Inc(i)
      else
      begin
        i := 1;
        Write('����: ');
        for j := 1 to PlayerCount do
          Write(Score[j], ' ');
        Writeln;
      end
    end;
  until (CurrScore[1] = 0) and (CurrScore[2] = 0) and (CurrScore[3] = 0) and
    (CurrScore[4] = 0);
  Max := 0;
  for i := 1 to PlayerCount do
    if Score[i] > Max then
      Max := Score[i];
  for i := 1 to PlayerCount do
    if Score[i] = Max then
      Writeln('����� ', i, ' �������!');
  Readln;

end.
