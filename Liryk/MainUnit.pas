unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ToolWin, Grids, Calendar, Buttons, Menus, Common,
  DateUtils, ClipBrd, CalendarUnit, AboutUnit, HTTPGet, uLkJSON, ImgList,
  AppEvnts;

type
  TfrmMain = class(TForm)
    { Components }
    aevAppEvents: TApplicationEvents;
    btnDate: TButton;
    cmbRadio: TComboBox;
    cmbTime: TComboBox;
    htgGetPlaylist: THTTPGet;
    htgGetRadiolst: THTTPGet;
    imlMenuIcons: TImageList;
    lsbTrackList: TListBox;
    mmnAppMenu: TMainMenu;
    mniAbout: TMenuItem;
    mniCopy: TMenuItem;
    mniCut: TMenuItem;
    mniDelete: TMenuItem;
    mniEdit: TMenuItem;
    mniExit: TMenuItem;
    mniFile: TMenuItem;
    mniHelp: TMenuItem;
    mniPaste: TMenuItem;
    mniRegion: TMenuItem;
    mniSearch: TMenuItem;
    mniSelectAll: TMenuItem;
    mniSeparator1: TMenuItem;
    mniSeparator2: TMenuItem;
    mniSwitchToCurrentDateAndTime: TMenuItem;
    mniUpdateRadioStationList: TMenuItem;
    sbtSearch: TSpeedButton;
    stbAppStatusBar: TStatusBar;
    tlbAppToolBar: TToolBar;
    { Event handlers }
    procedure aevAppEventsHint(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure cmbRadioEnter(Sender: TObject);
    procedure cmbRadioExit(Sender: TObject);
    procedure cmbRadioKeyPress(Sender: TObject; var Key: Char);
    procedure cmbTimeEnter(Sender: TObject);
    procedure cmbTimeExit(Sender: TObject);
    procedure cmbTimeKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure htgGetPlaylistDoneString(Sender: TObject; Result: String);
    procedure htgGetPlaylistError(Sender: TObject);
    procedure htgGetRadiolstDoneString(Sender: TObject; Result: String);
    procedure htgGetRadiolstError(Sender: TObject);
    procedure lsbTrackListEnter(Sender: TObject);
    procedure lsbTrackListExit(Sender: TObject);
    procedure mniAboutClick(Sender: TObject);
    procedure mniCopyClick(Sender: TObject);
    procedure mniCutClick(Sender: TObject);
    procedure mniDeleteClick(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure mniPasteClick(Sender: TObject);
    procedure mniSearchClick(Sender: TObject);
    procedure mniSelectAllClick(Sender: TObject);
    procedure mniSwitchToCurrentDateAndTimeClick(Sender: TObject);
    procedure mniUpdateRadioStationListClick(Sender: TObject);
    procedure sbtSearchClick(Sender: TObject);
  private
    { Private declarations }
    { Private subsidiary functions and procedures }
    procedure AddStationsItemToRadioList(JsonStationsItem: TlkJSONobject);
    procedure AddSummaryItemToTrackList(JsonSummaryItem: TlkJSONobject; ItemId: integer);
    procedure AddTimePeriods;
    procedure DisableAllCommonEditMenuItems;
    procedure DisableCopyEditMenuItem;
    procedure DisableHTTPOptions;
    procedure EnableAllCommonEditMenuItems;
    procedure EnableCopyEditMenuItem;
    procedure EnableHTTPOptions;
    procedure HandleSearchOption;
    procedure HandleSearchEnter(Key: Char);
    function ParseReason(ErrorSummary: string):WideString;
    procedure PrintRadioStatus(JsonResult: TlkJSONobject);
    procedure ReadRadioList;
    procedure ShowGetRadioListErrorMessage(JsonResult: TlkJSONobject);
    procedure ShowGetTrackListErrorMessage(JsonResult: TlkJSONobject);
    procedure ShowNetworkErrorMessage;
    procedure SwitchToCurrentDateAndTime;
    procedure WriteRadioList;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  dtSelectedDate: TDateTime;
  wstrActualStatus: WideString;

const
  DATFILE_POLAND = 'POL.dat';

implementation

{$R *.dfm}

{ Event handlers }

procedure TfrmMain.aevAppEventsHint(Sender: TObject);
begin
  if length(Application.Hint) <> 0 then
    stbAppStatusBar.SimpleText := Application.Hint
  else
    stbAppStatusBar.SimpleText := wstrActualStatus;
end;

procedure TfrmMain.btnDateClick(Sender: TObject);
var
  frmCalendar: TfrmCalendar;
begin
  frmCalendar := TfrmCalendar.Create(Application, dtSelectedDate);
  frmCalendar.Visible := false;
  frmCalendar.ShowModal;
  
  dtSelectedDate := frmCalendar.GetSelectedDate;
  btnDate.Caption := DateToStr(dtSelectedDate);

  frmCalendar.Destroy;
end;

procedure TfrmMain.cmbRadioEnter(Sender: TObject);
begin
  EnableAllCommonEditMenuItems;
end;

procedure TfrmMain.cmbRadioExit(Sender: TObject);
begin
  DisableAllCommonEditMenuItems;
end;

procedure TfrmMain.cmbRadioKeyPress(Sender: TObject; var Key: Char);
begin
  HandleSearchEnter(Key);
end;

procedure TfrmMain.cmbTimeEnter(Sender: TObject);
begin
  EnableAllCommonEditMenuItems;
end;

procedure TfrmMain.cmbTimeExit(Sender: TObject);
begin
  DisableAllCommonEditMenuItems;
end;

procedure TfrmMain.cmbTimeKeyPress(Sender: TObject; var Key: Char);
begin
  HandleSearchEnter(Key);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  wstrActualStatus := stbAppStatusBar.SimpleText;

  ReadRadioList;

  AddTimePeriods;

  SwitchToCurrentDateAndTime;
end;

procedure TfrmMain.htgGetPlaylistDoneString(Sender: TObject; Result: String);
var
  jsonobjResult: TlkJSONobject;
  jsonboolSuccess: TlkJSONboolean;
  jsonlstSummary: TlkJSONlist;
  boolSuccess: boolean;

  i: integer;
begin
  jsonobjResult := TlkJson.ParseText(Result) as TlkJSONobject;
  if Assigned(jsonobjResult) then
  begin
    try
      jsonboolSuccess := jsonobjResult.Field['success'] as TlkJSONboolean;
      if Assigned(jsonboolSuccess) then
      begin
        boolSuccess := jsonboolSuccess.Value;
        if boolSuccess then
        begin
          lsbTrackList.Clear;

          jsonlstSummary := jsonobjResult.Field['summary'] as TlkJSONlist;
          if Assigned(jsonlstSummary) then
          begin
            PrintRadioStatus(jsonobjResult);

            i := 0;
            while Assigned(jsonlstSummary.Child[i]) do
            begin
              AddSummaryItemToTrackList(jsonlstSummary.Child[i] as TlkJSONobject, i);

              i := i + 1;
            end;
          end;
        end
        else
          ShowGetTrackListErrorMessage(jsonobjResult);
      end;
    finally
      jsonobjResult.Free
    end;
  end;

  EnableHTTPOptions;
end;

procedure TfrmMain.htgGetPlaylistError(Sender: TObject);
begin
  ShowNetworkErrorMessage;

  EnableHTTPOptions;
end;

procedure TfrmMain.htgGetRadiolstDoneString(Sender: TObject;
  Result: String);
var
  jsonobjResult: TlkJSONobject;
  jsonboolSuccess: TlkJSONboolean;
  jsonlstSummary: TlkJSONlist;
  jsonobjSummaryItem: TlkJSONobject;
  jsonlstStations: TlkJSONlist;
  boolSuccess: boolean;

  i: integer;
  j: integer;
begin
  jsonobjResult := TlkJson.ParseText(Result) as TlkJSONobject;
  if Assigned(jsonobjResult) then
  begin
    try
      jsonboolSuccess := jsonobjResult.Field['success'] as TlkJSONboolean;
      if Assigned(jsonboolSuccess) then
      begin
        boolSuccess := jsonboolSuccess.Value;
        if boolSuccess then
        begin
          cmbRadio.Clear;

          jsonlstSummary := jsonobjResult.Field['summary'] as TlkJSONlist;
          if Assigned(jsonlstSummary) then
          begin
            i := 0;
            while Assigned(jsonlstSummary.Child[i]) do
            begin
              jsonobjSummaryItem := jsonlstSummary.Child[i] as TlkJSONobject;
              jsonlstStations := jsonobjSummaryItem.Field['stations'] as TlkJSONlist;
              if Assigned(jsonlstStations) then
              begin
                j := 0;
                while Assigned(jsonlstStations.Child[j]) do
                begin
                  AddStationsItemToRadioList(jsonlstStations.Child[j] as TlkJSONobject);

                  j := j + 1;
                end;
              end;

              i := i + 1;
            end;
          end;
        end
        else
          ShowGetRadioListErrorMessage(jsonobjResult);
      end;
    finally
      jsonobjResult.Free
    end;
  end;

  EnableHTTPOptions;
  WriteRadioList;
end;

procedure TfrmMain.htgGetRadiolstError(Sender: TObject);
begin
  ShowNetworkErrorMessage;

  EnableHTTPOptions;
end;

procedure TfrmMain.lsbTrackListEnter(Sender: TObject);
begin
  EnableCopyEditMenuItem;
end;

procedure TfrmMain.lsbTrackListExit(Sender: TObject);
begin
  DisableCopyEditMenuItem;
end;

procedure TfrmMain.mniAboutClick(Sender: TObject);
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(Application);
  frmAbout.Visible := false;
  frmAbout.ShowModal;

  frmAbout.Destroy;
end;

procedure TfrmMain.mniCopyClick(Sender: TObject);
var
  lsbActiveListBox: TListBox;
begin
  if Screen.ActiveControl is TListBox then
    begin
      lsbActiveListBox := Screen.ActiveControl as TListBox;
      if lsbActiveListBox.ItemIndex <> -1 then
        Clipboard.AsText := lsbActiveListBox.Items[lsbActiveListBox.ItemIndex];
    end
  else
    with Screen.ActiveControl do
      if HandleAllocated then SendMessage(Handle, WM_COPY, 0, 0);
end;

procedure TfrmMain.mniCutClick(Sender: TObject);
begin
  with Screen.ActiveControl do
    if HandleAllocated then SendMessage(Handle, WM_CUT, 0, 0);
end;

procedure TfrmMain.mniDeleteClick(Sender: TObject);
begin
  with Screen.ActiveControl do
    if HandleAllocated then SendMessage(Handle, WM_CLEAR, 0, 0);
end;

procedure TfrmMain.mniExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mniPasteClick(Sender: TObject);
begin
  with Screen.ActiveControl do
    if HandleAllocated then SendMessage(Handle, WM_PASTE, 0, 0);
end;

procedure TfrmMain.mniSearchClick(Sender: TObject);
begin
  HandleSearchOption;
end;

procedure TfrmMain.mniSelectAllClick(Sender: TObject);
begin
  if Screen.ActiveControl is TComboBox then
    (Screen.ActiveControl as TComboBox).SelectAll;
end;

procedure TfrmMain.mniSwitchToCurrentDateAndTimeClick(Sender: TObject);
begin
  SwitchToCurrentDateAndTime;
end;

procedure TfrmMain.mniUpdateRadioStationListClick(Sender: TObject);
begin
  DisableHTTPOptions;

  htgGetRadiolst.URL := 'http://ods.lynx.re/radiolst.php';
  htgGetRadiolst.GetString;
end;

procedure TfrmMain.sbtSearchClick(Sender: TObject);
begin
  HandleSearchOption;
end;

{ Private subsidiary functions and procedures }

procedure TfrmMain.AddStationsItemToRadioList(JsonStationsItem: TlkJSONobject);
var
  jsonintId: TlkJSONnumber;
  jsonstrName: TlkJSONstring;
begin
  jsonintId := JsonStationsItem.Field['id'] as TlkJSONnumber;
  jsonstrName := JsonStationsItem.Field['name'] as TlkJSONstring;

  cmbRadio.AddItem(jsonstrName.Value, TObject(Integer(jsonintId.Value)));
end;

procedure TfrmMain.AddSummaryItemToTrackList(JsonSummaryItem: TlkJSONobject; ItemId: integer);
var
  jsonstrTime: TlkJSONstring;
  jsonstrTitle: TlkJSONstring;
begin
  jsonstrTime := JsonSummaryItem.Field['time'] as TlkJSONstring;
  jsonstrTitle := JsonSummaryItem.Field['title'] as TlkJSONstring;

  lsbTrackList.AddItem(jsonstrTime.Value + ' | ' + jsonstrTitle.Value, TObject(ItemId));
end;

procedure TfrmMain.AddTimePeriods;
begin
  cmbTime.AddItem('0:00-2:00', TObject(0));
  cmbTime.AddItem('2:00-4:00', TObject(2));
  cmbTime.AddItem('4:00-6:00', TObject(4));
  cmbTime.AddItem('6:00-8:00', TObject(6));
  cmbTime.AddItem('8:00-10:00', TObject(8));
  cmbTime.AddItem('10:00-12:00', TObject(10));
  cmbTime.AddItem('12:00-14:00', TObject(12));
  cmbTime.AddItem('14:00-16:00', TObject(14));
  cmbTime.AddItem('16:00-18:00', TObject(16));
  cmbTime.AddItem('18:00-20:00', TObject(18));
  cmbTime.AddItem('20:00-22:00', TObject(20));
  cmbTime.AddItem('22:00-0:00', TObject(22));
end;

procedure TfrmMain.DisableAllCommonEditMenuItems;
begin
  mniCut.Enabled := false;
  mniCopy.Enabled := false;
  mniPaste.Enabled := false;
  mniDelete.Enabled := false;
  mniSelectAll.Enabled := false;
end;

procedure TfrmMain.DisableCopyEditMenuItem;
begin
  mniCopy.Enabled := false;
end;

procedure TfrmMain.DisableHTTPOptions;
begin
  mniSearch.Enabled := false;
  sbtSearch.Enabled := false;
  mniUpdateRadioStationList.Enabled := false;
end;

procedure TfrmMain.EnableAllCommonEditMenuItems;
begin
  mniCut.Enabled := true;
  mniCopy.Enabled := true;
  mniPaste.Enabled := true;
  mniDelete.Enabled := true;
  mniSelectAll.Enabled := true;
end;

procedure TfrmMain.EnableCopyEditMenuItem;
begin
  mniCopy.Enabled := true;
end;

procedure TfrmMain.EnableHTTPOptions;
begin
  mniSearch.Enabled := true;
  sbtSearch.Enabled := true;
  mniUpdateRadioStationList.Enabled := true;
end;

procedure TfrmMain.HandleSearchOption;                           
  var intSelectedRadioId: integer;
  var intSelectedTimeFrom: integer;

  var strInputRadioId: string;
  var strInputTimeFrom: string;
  var strInputTimeTo: string;
begin
  if cmbRadio.ItemIndex = -1 then
  begin
    MessageBoxW(Handle, 'Prosz' + Common.WCHAR_SML_EOGONEK + ' wybra' + Common.WCHAR_SML_CACUTE + ' stacj' + Common.WCHAR_SML_EOGONEK + ' radiow' + Common.WCHAR_SML_AOGONEK + '.', Common.LOCSTR_WARNING, MB_ICONEXCLAMATION or MB_OK);
    cmbRadio.SetFocus;
  end
  else if cmbTime.ItemIndex = -1 then
  begin
    MessageBoxW(Handle, 'Prosz' + Common.WCHAR_SML_EOGONEK + ' wybra' + Common.WCHAR_SML_CACUTE + ' przedzia' + Common.WCHAR_SML_LSLASH + ' czasowy.', Common.LOCSTR_WARNING, MB_ICONEXCLAMATION or MB_OK);
    cmbTime.SetFocus;
  end
  else
  begin
    DisableHTTPOptions;

    intSelectedRadioId := Integer(cmbRadio.Items.Objects[cmbRadio.ItemIndex]);
    intSelectedTimeFrom := Integer(cmbTime.Items.Objects[cmbTime.ItemIndex]);

    strInputRadioId := IntToStr(intSelectedRadioId);
    strInputTimeFrom := IntToStr(intSelectedTimeFrom);
    if intSelectedTimeFrom = 22 then
      strInputTimeTo := '0'
    else
      strInputTimeTo := IntToStr(intSelectedTimeFrom + 2);

    htgGetPlaylist.URL := 'http://ods.lynx.re/playlist.php?r=' + strInputRadioId + '&date=' + FormatDateTime('dd-mm-yyyy', dtSelectedDate)+ '&time_from=' + strInputTimeFrom + '&time_to=' + strInputTimeTo;
    htgGetPlaylist.GetString;
  end;
end;

procedure TfrmMain.HandleSearchEnter(Key: Char);
begin
  if (ord(Key) = VK_RETURN) and sbtSearch.Enabled then
  begin
    Key := #0; // prevent beeping
    HandleSearchOption;
  end
end;

function TfrmMain.ParseReason(ErrorSummary: string):WideString;
begin
  if ErrorSummary = 'Radio ID unspecified.' then
    ParseReason := 'Nie wybrano stacji radiowej.'
  else if ErrorSummary = 'Service unavailable.' then
    ParseReason := 'Us' + Common.WCHAR_SML_LSLASH + 'uga niedost' + Common.WCHAR_SML_EOGONEK + 'pna.'
  else if ErrorSummary = 'Radio with the specified ID unavailable.' then
    ParseReason := 'Stacja radiowa nie istnieje lub witryna ' + Common.WCHAR_SML_ZACUTE + 'r' + Common.WCHAR_SML_OACUTE + 'd' + Common.WCHAR_SML_LSLASH + 'owa przechodzi obecnie konserwacj' + Common.WCHAR_SML_EOGONEK + '.'
  else if ErrorSummary = 'Unknown error while retrieving radio station list.' then
    ParseReason := 'Nieznany bùàd podczas pozyskiwania listy stacji radiowych.'
  else
    ParseReason := 'Pow' + Common.WCHAR_SML_OACUTE + 'd nieudokumentowany.';
end;

procedure TfrmMain.PrintRadioStatus(JsonResult: TlkJSONobject);
var
  jsonstrName: TlkJSONstring;
  jsonstrDate: TlkJSONstring;
  jsonstrTimeFrom: TlkJSONstring;
begin
  jsonstrName := JsonResult.Field['name'] as TlkJSONstring;
  jsonstrDate := JsonResult.Field['date'] as TlkJSONstring;
  jsonstrTimeFrom := JsonResult.Field['timeFrom'] as TlkJSONstring;

  wstrActualStatus := jsonstrName.Value + ' - dane od: ' + jsonstrDate.Value + ', ' + jsonstrTimeFrom.Value + ':00';
  stbAppStatusBar.SimpleText := wstrActualStatus;
end;

procedure TfrmMain.ReadRadioList;
var
  txtFile: TextFile;
  strLine: string;
  intTabPos: integer;
  strRadioId: string;
  strRadioName: string;
begin
  if FileExists(DATFILE_POLAND) then
  begin
    AssignFile(txtFile, DATFILE_POLAND);
    begin
      Reset(txtFile);
      
      while not Eof(txtFile) do
      begin
        Readln(txtFile, strLine);
        intTabPos := Pos(Chr(9), strLine);
        if intTabPos > 0 then
        begin
          strRadioId := Copy(strLine, 0, intTabPos - 1);
          strRadioName := Copy(strLine, intTabPos + 1, Length(strLine));
          
          try
            cmbRadio.AddItem(strRadioName, TObject(StrToInt(strRadioId)));
          except
          end;
        end;
      end;

      CloseFile(txtFile);
    end;
  end;
end;

procedure TfrmMain.ShowGetRadioListErrorMessage(JsonResult: TlkJSONobject);
var
  jsonstrErrorSummary: TlkJSONstring;
  wstrErrorMessage: WideString;
begin
  jsonstrErrorSummary := JsonResult.Field['summary'] as TlkJSONstring;
  if Assigned(jsonstrErrorSummary) then
    wstrErrorMessage := 'Nie uda' + Common.WCHAR_SML_LSLASH + 'o si' + Common.WCHAR_SML_EOGONEK + ' pomy' + Common.WCHAR_SML_SACUTE + 'lnie pobra' + Common.WCHAR_SML_CACUTE + ' listy stacji radiowych z nast' + Common.WCHAR_SML_EOGONEK + 'puj' + Common.WCHAR_SML_AOGONEK + 'cego powodu: ' + ParseReason(jsonstrErrorSummary.Value)
  else
    wstrErrorMessage := 'Nie uda' + Common.WCHAR_SML_LSLASH + 'o si' + Common.WCHAR_SML_EOGONEK + ' pomy' + Common.WCHAR_SML_SACUTE + 'lnie pobra' + Common.WCHAR_SML_CACUTE + ' listy stacji radiowych.';

  MessageBoxW(Handle, PWideChar(wstrErrorMessage), Common.LOCSTR_ERROR, MB_ICONHAND or MB_OK);
end;

procedure TfrmMain.ShowGetTrackListErrorMessage(JsonResult: TlkJSONobject);
var
  jsonstrErrorSummary: TlkJSONstring;
  wstrErrorMessage: WideString;
begin
  jsonstrErrorSummary := JsonResult.Field['summary'] as TlkJSONstring;
  if Assigned(jsonstrErrorSummary) then
    wstrErrorMessage := 'Nie uda' + Common.WCHAR_SML_LSLASH + 'o si' + Common.WCHAR_SML_EOGONEK + ' pomy' + Common.WCHAR_SML_SACUTE + 'lnie pobra' + Common.WCHAR_SML_CACUTE + ' spisu utwor' + Common.WCHAR_SML_OACUTE + 'w z nast' + Common.WCHAR_SML_EOGONEK + 'puj' + Common.WCHAR_SML_AOGONEK + 'cego powodu: ' + ParseReason(jsonstrErrorSummary.Value)
  else
    wstrErrorMessage := 'Nie uda' + Common.WCHAR_SML_LSLASH + 'o si' + Common.WCHAR_SML_EOGONEK + ' pomy' + Common.WCHAR_SML_SACUTE + 'lnie pobra' + Common.WCHAR_SML_CACUTE + ' spisu utwor' + Common.WCHAR_SML_OACUTE + 'w.';

  MessageBoxW(Handle, PWideChar(wstrErrorMessage), Common.LOCSTR_ERROR, MB_ICONHAND or MB_OK);
end;

procedure TfrmMain.ShowNetworkErrorMessage;
begin
  MessageBoxW(Handle, 'Wyst' + Common.WCHAR_SML_AOGONEK + 'pi' + Common.WCHAR_SML_LSLASH + ' b' + Common.WCHAR_SML_LSLASH + Common.WCHAR_SML_AOGONEK + 'd sieciowy. Prosz' + Common.WCHAR_SML_EOGONEK + ' sprawdzi' + Common.WCHAR_SML_CACUTE + ' po' + Common.WCHAR_SML_LSLASH + Common.WCHAR_SML_AOGONEK + 'czenie internetowe i spr' + Common.WCHAR_SML_OACUTE + 'bowa' + Common.WCHAR_SML_CACUTE + ' ponownie.', Common.LOCSTR_ERROR, MB_ICONHAND or MB_OK);
end;

procedure TfrmMain.SwitchToCurrentDateAndTime;
begin
  dtSelectedDate := Now;
  btnDate.Caption := DateToStr(dtSelectedDate);

  if HourOf(dtSelectedDate) < 2 then
    cmbTime.ItemIndex := 0
  else if HourOf(dtSelectedDate) < 4 then
    cmbTime.ItemIndex := 1
  else if HourOf(dtSelectedDate) < 6 then
    cmbTime.ItemIndex := 2
  else if HourOf(dtSelectedDate) < 8 then
    cmbTime.ItemIndex := 3
  else if HourOf(dtSelectedDate) < 10 then
    cmbTime.ItemIndex := 4
  else if HourOf(dtSelectedDate) < 12 then
    cmbTime.ItemIndex := 5
  else if HourOf(dtSelectedDate) < 14 then
    cmbTime.ItemIndex := 6
  else if HourOf(dtSelectedDate) < 16 then
    cmbTime.ItemIndex := 7
  else if HourOf(dtSelectedDate) < 18 then
    cmbTime.ItemIndex := 8
  else if HourOf(dtSelectedDate) < 20 then
    cmbTime.ItemIndex := 9
  else if HourOf(dtSelectedDate) < 22 then
    cmbTime.ItemIndex := 10
  else if HourOf(dtSelectedDate) < 24 then
    cmbTime.ItemIndex := 11;
end;

procedure TfrmMain.WriteRadioList;
var
  slstRadioStations: TStringList;

  i: integer;
begin
  slstRadioStations := TStringList.Create;

  for i := 0 to cmbRadio.Items.Count - 1 do
    slstRadioStations.Add(IntToStr(Integer(cmbRadio.Items.Objects[i])) + Chr(9) + cmbRadio.Items[i]);

  try
    try
      slstRadioStations.SaveToFile(DATFILE_POLAND)
    except
      MessageBoxW(Handle, 'Wyst' + Common.WCHAR_SML_AOGONEK + 'pi' + Common.WCHAR_SML_LSLASH + ' b' + Common.WCHAR_SML_LSLASH + Common.WCHAR_SML_AOGONEK + 'd przy pr' + Common.WCHAR_SML_OACUTE + 'bie zapisu aktualnej listy stacji radiowych do pliku. Upewnij si' + Common.WCHAR_SML_EOGONEK + ', ' + Common.WCHAR_SML_ZDOTACCENT + 'e plik nie jest chroniony przed zapisem i spr' + Common.WCHAR_SML_OACUTE + 'buj ponownie.', Common.LOCSTR_ERROR, MB_ICONHAND or MB_OK)
    end;
  finally
    slstRadioStations.Free
  end;
end;

end.
