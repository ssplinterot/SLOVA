program Words;

uses SysUtils;

var
  S: word;
  PlayerCount: integer;
  Scores: array [1 .. 4] of integer;

begin
  repeat
    try
      Write('Введите количество игроков: ');
      Readln(PlayerCount);
    except
    end;
  until PlayerCount in [2 .. 4];
  repeat
    for var i := 1 to PlayerCount do
    begin

    end;
  until true;
  Readln;
end.
