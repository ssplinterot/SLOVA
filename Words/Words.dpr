program Words;

uses SysUtils;

var
  S, Source: string;
  PlayerCount, WordCount: integer;
  Score, CurrScore: array [1 .. 4] of integer;
  UsedWords: array of string;

const
  alphabet =
    'АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЬьЫыЭэЮюЯя';

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

function checking_correct(S: string): boolean;
var
  counter: integer;
begin
  counter := 0;
  if S = '' then
  begin
    result := false;
  end
  else
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
  repeat
    try
      Write('Введите количество игроков: ');
      readLn(PlayerCount);
    except
    end;
  until PlayerCount in [2 .. 4];
  repeat
    Write('Введите исходную строку: ');
    readLn(Source);
  until (checking_correct(Source));
  SetLength(UsedWords, PlayerCount * Length(Source));
  UsedWords[0] := Source;
  WordCount := 1;
  repeat
    for var i := 1 to PlayerCount do
    begin
      Write('Слово игрока ', i, ': ');
      readLn(S);
      if checking_correct(S) then
      begin
        CurrScore[i] := GetScore(S, Source, UsedWords, WordCount);
        Score[i] := Score[i] + CurrScore[i];
        Writeln('Игрок ', i, ' получает ', CurrScore[i], ' очков');
      end;
      Writeln('У ', i, ' игрока ', Score[i], ' очков');
    end;
  until (CurrScore[1]=0);
  readLn;

// Change
end.
