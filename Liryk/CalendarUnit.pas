unit CalendarUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, Calendar, StdCtrls, DateUtils;

type
  TfrmCalendar = class(TForm)
    { Components }
    btnOK: TButton;
    btnPrevMonth: TButton;
    btnNextMonth: TButton;
    btnPrevYear: TButton;
    btnNextYear: TButton;
    cldDate: TCalendar;
    lblSelectedDate: TLabel;
    { Constructors }
    constructor Create(AOwner: TComponent; var SelectedDate: TDateTime);
    { Event handlers }
    procedure btnNextMonthClick(Sender: TObject);
    procedure btnNextYearClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPrevMonthClick(Sender: TObject);
    procedure btnPrevYearClick(Sender: TObject);
    procedure cldDateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    { Private subsidiary functions and procedures }
    procedure RefreshDate(SelectedDateLabel: TLabel; SelectedYear: Word; SelectedMonth: Word; SelectedDay: Word);
  public
    { Public declarations }
    { Public subsidiary functions and procedures }
    function GetSelectedDate:TDateTime;
  end;

var
  frmCalendar: TfrmCalendar;
  dtSelectedDate: TDateTime;

implementation

{$R *.dfm}

{ Constructors }

constructor TfrmCalendar.Create(AOwner: TComponent; var SelectedDate: TDateTime);
begin
  inherited Create(AOwner);
  dtSelectedDate := SelectedDate;
end;

{ Event handlers }

procedure TfrmCalendar.btnNextMonthClick(Sender: TObject);
begin
  cldDate.NextMonth;
  RefreshDate(lblSelectedDate, cldDate.Year, cldDate.Month, cldDate.Day);
end;

procedure TfrmCalendar.btnNextYearClick(Sender: TObject);
begin
  cldDate.NextYear;
  RefreshDate(lblSelectedDate, cldDate.Year, cldDate.Month, cldDate.Day);
end;

procedure TfrmCalendar.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCalendar.btnPrevMonthClick(Sender: TObject);
begin
  cldDate.PrevMonth;
  RefreshDate(lblSelectedDate, cldDate.Year, cldDate.Month, cldDate.Day);
end;

procedure TfrmCalendar.btnPrevYearClick(Sender: TObject);
begin
  cldDate.PrevYear;
  RefreshDate(lblSelectedDate, cldDate.Year, cldDate.Month, cldDate.Day);
end;

procedure TfrmCalendar.cldDateChange(Sender: TObject);
begin
  RefreshDate(lblSelectedDate, cldDate.Year, cldDate.Month, cldDate.Day);
end;

procedure TfrmCalendar.FormCreate(Sender: TObject);
  var intSelectedYear: integer;
  var intSelectedMonth: integer;
  var intSelectedDay: integer;
begin
  intSelectedYear := YearOf(dtSelectedDate);
  intSelectedMonth := MonthOf(dtSelectedDate);
  intSelectedDay := DayOf(dtSelectedDate);

  cldDate.Year := intSelectedYear;
  cldDate.Month := intSelectedMonth;
  cldDate.Day := intSelectedDay;
  lblSelectedDate.Caption := FormatDateTime(LongDateFormat, dtSelectedDate);
end;

{ Private subsidiary functions and procedures }

procedure TfrmCalendar.RefreshDate(SelectedDateLabel: TLabel; SelectedYear: Word; SelectedMonth: Word; SelectedDay: Word);
begin
  dtSelectedDate := EncodeDate(SelectedYear, SelectedMonth, SelectedDay);
  SelectedDateLabel.Caption := FormatDateTime(LongDateFormat, dtSelectedDate);
end;

{ Public subsidiary functions and procedures }

function TfrmCalendar.GetSelectedDate:TDateTime;
begin
  GetSelectedDate := dtSelectedDate;
end;

end.
