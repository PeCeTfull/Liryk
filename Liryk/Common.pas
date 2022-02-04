unit Common;

interface

const
  WCHAR_CAP_AOGONEK = WideString(#$0104);
  WCHAR_SML_AOGONEK = WideString(#$0105);
  WCHAR_CAP_CACUTE = WideString(#$0106);
  WCHAR_SML_CACUTE = WideString(#$0107);
  WCHAR_CAP_EOGONEK = WideString(#$0118);
  WCHAR_SML_EOGONEK = WideString(#$0119);
  WCHAR_CAP_LSLASH = WideString(#$0141);
  WCHAR_SML_LSLASH = WideString(#$0142);
  WCHAR_CAP_NACUTE = WideString(#$0143);
  WCHAR_SML_NACUTE = WideString(#$0144);
  WCHAR_CAP_OACUTE = WideString(#$00D3);
  WCHAR_SML_OACUTE = WideString(#$00F3);
  WCHAR_CAP_SACUTE = WideString(#$015A);
  WCHAR_SML_SACUTE = WideString(#$015B);
  WCHAR_CAP_ZACUTE = WideString(#$0179);
  WCHAR_SML_ZACUTE = WideString(#$017A);
  WCHAR_CAP_ZDOTACCENT = WideString(#$017B);
  WCHAR_SML_ZDOTACCENT = WideString(#$017C);

  LOCSTR_ERROR = WideString('B' + Common.WCHAR_SML_LSLASH + Common.WCHAR_SML_AOGONEK + 'd');
  LOCSTR_MESSAGE = 'Komunikat';
  LOCSTR_WARNING = WideString('Ostrze' + Common.WCHAR_SML_ZDOTACCENT + 'enie');

implementation

end.
 