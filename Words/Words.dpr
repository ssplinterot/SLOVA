program Words;

uses SysUtils;

var
  S, Source: string;
  PlayerCount, WordCount, Max: integer;
  Score, CurrScore: array [1 .. 4] of integer;
  UsedWords: array of string;

const
  alphabet =
    'АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЬьЫыЭэЮюЯя-';

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

procedure change_registr(var S: string);
begin
  for var i := 1 to Length(S) do
    if S[i] in ['А'..'Я'] then
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
  repeat
    try
      Write('Введите количество игроков: ');
      readLn(PlayerCount);
    except
    end;
  until PlayerCount in [2 .. 4];
  repeat
    Write('Введите исходную строку:                               ');
    readLn(Source);
  until (Source<> '') and (checking_correct(Source));
  change_registr(Source);
  SetLength(UsedWords, PlayerCount * Length(Source));
  UsedWords[0] := Source;
  WordCount := 1;
  repeat
    for i := 1 to PlayerCount do
    begin
      Write('Слово игрока ', i, ': ');
      readLn(S);
      if checking_correct(S) then
      begin
        change_registr(S);
        CurrScore[i] := GetScore(S, Source, UsedWords, WordCount);
        Score[i] := Score[i] + CurrScore[i];
        Writeln('Игрок ', i:3, ' получает ', CurrScore[i], ' очков');
      end;
      Writeln('У     ', i:3, ' игрока   ', Score[i], ' очков');
    end;
  until (CurrScore[1] = 0) and (CurrScore[2] = 0) and (CurrScore[3] = 0) and
    (CurrScore[4] = 0);
  Max := 0;
  for i := 1 to PlayerCount do
    if Score[i] > Max then
      Max := Score[i];
  for i := 1 to PlayerCount do
    if Score[i] = Max then
      Writeln('Игрок ', i, ' победил!');
  readLn;

end.
