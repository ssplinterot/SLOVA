program SLOVA;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {Form1},
  GameMenu in 'GameMenu.pas' {Frame2: TFrame},
  Help in 'Help.pas' {Frame3: TFrame},
  PlayersSelector in 'PlayersSelector.pas' {PlayersFrame: TFrame},
  startGame in 'startGame.pas' {GameFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
