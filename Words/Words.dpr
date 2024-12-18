program Words;

uses SysUtils;

var
  S, Dictionary, Source: string;
  PlayerCount, WordCount, Max: integer;
  Score, CurrScore: array [1 .. 4] of integer;
  UsedWords: array of string;

const
  alphabet =
    '�����������娸����������������������������������������������������-';

function GetScore(S, Source: string; var UsedWords: array of string;
  var WordCount: integer): integer;
var
  Flag: boolean;
  i: integer;
begin
  i := 0;
  Flag := true;
  repeat
    if UsedWords[i] = S then
      Flag := false;
    Inc(i);
  until (not Flag) or (i = WordCount);
  if Flag then
  begin
    result := 0;
    for i := 1 to Length(S) do
      if Pos(S[i], Source) <> 0 then
        Delete(Source, Pos(S[i], Source), 1)
      else
        Dec(result);
    if result = 0 then
    begin
      result := Length(S);
      UsedWords[WordCount] := S;
      Inc(WordCount);
    end;
  end
  else
    result := -Length(S);

end;

procedure GetDictionary(var Dictionary: string; Name: string);
var
  Txt: TextFile;
begin
  AssignFile(Txt, Name);
  Reset(Txt);
  Read(Txt, Dictionary);
  Dictionary := UTF8ToAnsi(Dictionary);
end;

procedure change_registr(var S: string);
begin
  for var i := 1 to Length(S) do
    if (S[i] >= '�') and (S[i] <= '�') then
      S[i] := Chr(Ord(S[i]) + 32)
end;

function checking_correct(S: string): boolean;
var
  counter: integer;
begin
  counter := 0;

  begin
    for var index := 1 to Length(S) do
    begin
      if Pos(S[index], alphabet) > 0 then
        Inc(counter);
    end;
    if counter = Length(S) then
      result := true
    else
    begin
      result := false;
    end;
  end;
end;

begin
  var
    i: integer;
  GetDictionary(Dictionary, 'Dictionary.txt');
  Writeln(Dictionary);
  repeat
    Write('������� ���������� ������� (2-4): ');
    try
      ReadLn(PlayerCount);
    except
    end
  until PlayerCount in [2 .. 4];
  repeat
    Write('������� �������� ������:                               ');
    readLn(Source);
    Source := Trim(Source);
  until (Source <> '') and (checking_correct(Source));
  change_registr(Source);
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
      readLn(S);
      S := Trim(S);
      if checking_correct(S) then
      begin
        change_registr(S);
        CurrScore[i] := GetScore(S, Source, UsedWords, WordCount);
      end
      else
        CurrScore[i] := -Length(S);
      Score[i] := Score[i] + CurrScore[i];
      Writeln('����� ', i:3, ' �������� ', CurrScore[i], ' �����');
      Writeln('�     ', i:3, ' ������   ', Score[i], ' �����');
      if i < PlayerCount then
        Inc(i)
      else
        i := 1;
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
  readLn;

end.
