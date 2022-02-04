program Liryk;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Liryk';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
