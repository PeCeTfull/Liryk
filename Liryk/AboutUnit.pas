unit AboutUnit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, Common;

type
  TfrmAbout = class(TForm)
    pnlAbout: TPanel;
    ProgramIcon: TImage;
    lblComments: TLabel; 
    lblCopyright: TLabel;
    lblProductName: TLabel;
    lblVersion: TLabel;
    btnLicence: TButton;
    btnOK: TButton;
    btnWebsite: TButton;
    procedure btnLicenceClick(Sender: TObject);
    procedure btnWebsiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnLicenceClick(Sender: TObject);
begin
  MessageBoxW(Handle, 'Ten program jest publikowany na zasadach MIT+CC, tj. licencji MIT z klauzul'
    + Common.WCHAR_SML_AOGONEK + ' Commons Clause. Wed' + Common.WCHAR_SML_LSLASH
    + 'ug tych zasad oprogramowanie to mo' + Common.WCHAR_SML_ZDOTACCENT + 'e by'
    + Common.WCHAR_SML_CACUTE + ' dowolnie u' + Common.WCHAR_SML_ZDOTACCENT
    + 'ywane, kopiowane, modyfikowane, scalane, publikowane, rozprowadzane oraz podlicencjonowane pod warunkiem zachowania istniej'
    + Common.WCHAR_SML_AOGONEK + 'cych juý praw autorskich. Zabronione jest natomiast pobieranie jakichkolwiek op'
    + Common.WCHAR_SML_LSLASH + 'at za prawa wynikaj' + Common.WCHAR_SML_AOGONEK
    + 'ce z licencji. Wi' + Common.WCHAR_SML_EOGONEK + 'cej informacji moýna uzyska'
    + Common.WCHAR_SML_CACUTE + ' zapoznaj' + Common.WCHAR_SML_AOGONEK + 'c si'
    + Common.WCHAR_SML_EOGONEK + ' z plikiem Licence.txt (dost' + Common.WCHAR_SML_EOGONEK
    + 'pnym w j' + Common.WCHAR_SML_EOGONEK + 'zyku angielskim) do' + Common.WCHAR_SML_LSLASH
    + Common.WCHAR_SML_AOGONEK + 'czonym do aplikacji.', Common.LOCSTR_MESSAGE, MB_ICONINFORMATION or MB_OK);
end;

procedure TfrmAbout.btnWebsiteClick(Sender: TObject);
begin
  ShellExecute(HInstance, 'open', PChar('http://www.pecetfull.pl/pl'), nil, nil, SW_NORMAL);
end;

end.
 
