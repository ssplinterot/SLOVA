program ProjectINTERF;

uses
  System.StartUpCopy,
  FMX.Forms,
  Interface_PROJECT in 'Interface_PROJECT.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
