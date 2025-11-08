unit Main.View;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.DateTimeCtrls,
  FMX.Platform.Win,
  Winapi.Windows,
  Winapi.Messages,
  Winapi.CommCtrl,
  System.Messaging,
  FMX.Platform;

type
  TMainView = class(TForm)
    Label1: TLabel;
    Btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
  private
    FOldWndProc: Pointer;
    FDateTimePicker: HWND;
    class function HookProc(aHWnd: HWND; aUMsg: UINT; aWParam: WPARAM; aLParam: LPARAM): LRESULT; stdcall; static;
  end;

var
  MainView: TMainView;

implementation
uses
  Vcl.Themes, Winapi.UxTheme;

{$R *.fmx}

procedure TMainView.Btn1Click(Sender: TObject);
var
  LNewInstance: TMainView;
begin
  LNewInstance := TMainView.Create(Self);
  LNewInstance.Caption := 'Sub form';
  LNewInstance.Show;
end;

procedure TMainView.FormCreate(Sender: TObject);
var
  LhWnd: HWND;
begin
  LhWnd := Formtohwnd(Self);

  FDateTimePicker := CreateWindowEx(0, DATETIMEPICK_CLASS, nil,
    WS_CHILD or WS_VISIBLE or WS_TABSTOP or DTS_SHORTDATEFORMAT,
    50, 80, 307, 25,
    LhWnd, 0, HInstance, nil);

  SetWindowTheme(FDateTimePicker, 'Explorer', nil);

  // subclass FMX window
  FOldWndProc := Pointer(SetWindowLongPtr(LhWnd, GWLP_WNDPROC, LONG_PTR(@HookProc)));
  SetWindowLongPtr(LhWnd, GWLP_USERDATA, LONG_PTR(Self));
end;

class function TMainView.HookProc(
  aHWnd: HWND;
  aUMsg: UINT;
  aWParam: WPARAM;
  aLParam: LPARAM): LRESULT;
var
  LPNMHDR: PNMHDR;
  LPNMDATETIMECHANGE: PNMDATETIMECHANGE;
  sysTime: TSystemTime;
  LDateTime: TDateTime;
  LSelfRef: TMainView;
begin
  LSelfRef := TMainView(GetWindowLongPtr(aHWnd, GWLP_USERDATA));

  if (aUMsg = WM_NOTIFY) and (LSelfRef <> nil) then
  begin
    LPNMHDR := PNMHDR(aLParam);
    if (LPNMHDR.hwndFrom = LSelfRef.FDateTimePicker) and (LPNMHDR.code = DTN_DATETIMECHANGE) then
    begin
      LPNMDATETIMECHANGE := PNMDATETIMECHANGE(aLParam);
      sysTime := LPNMDATETIMECHANGE.st;
      LDateTime := SystemTimeToDateTime(sysTime);
      LSelfRef.Label1.Text := 'Selected date: ' + DateToStr(LDateTime);
    end;
  end;

  // Call original window proc
  Result := CallWindowProc(LSelfRef.FOldWndProc, aHWnd, aUMsg, aWParam, aLParam);
end;

end.
