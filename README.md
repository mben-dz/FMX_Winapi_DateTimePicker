# ✅ Embed WinAPI TDateTimePicker Inside FMX (FireMonkey) Form  
Hybrid FMX + WinAPI Control Integration in Delphi

This repository demonstrates how to embed the native **WinAPI TDateTimePicker** (the same control used by VCL) inside a **FireMonkey (FMX)** form using `CreateWindowEx` and window subclassing.

FMX does not provide the Vista+ animated date picker UI, so this project shows how to integrate the real Windows picker directly inside your FMX application.

---  

## 🚀 Features

- Create a **native WinAPI DateTimePicker** inside an FMX form  
- Works on **Windows 7 → Windows 11**  
- Full animated dropdown calendar  
- Receive `DTN_DATETIMECHANGE` notifications  
- Sync with FMX labels or controls  
- Support for **multiple FMX forms / dynamic instances**  
- Pure Delphi — no external .dll, no VCL forms used  

---

## 📸 Screenshot

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/12cc6a7c-254d-4a54-9d4a-f5de93482108" />  

## 🎥 Video Test

[▶️ Watch the YouTube Tutorial](https://www.youtube.com/watch?v=tkq_gTw8DlY)  

Shows FMX form with native Windows date picker embedded inside.

---

## 📦 Requirements

- Windows target platform  
- FMX framework  
- `Winapi.CommCtrl` for DateTimePicker API  

---

## 🧩 How It Works

We use 3 key steps:

### **1. Create the WinAPI DateTimePicker**
```delphi
procedure TMainView.FormCreate(Sender: TObject);
var
  LhWnd: HWND;
begin
  LhWnd := Formtohwnd(Self);

  FDateTimePicker := CreateWindowEx(0, DATETIMEPICK_CLASS, nil,
    WS_CHILD or WS_VISIBLE or WS_TABSTOP or DTS_SHORTDATEFORMAT,
    50, 80, 307, 25,
    LhWnd, 0, HInstance, nil);
```
### **2. Subclass the FMX window  

We replace the main window procedure with our own to capture WM_NOTIFY:  
```delphi
  // subclass FMX window
  FOldWndProc := Pointer(SetWindowLongPtr(LhWnd, GWLP_WNDPROC, LONG_PTR(@HookProc)));
  SetWindowLongPtr(LhWnd, GWLP_USERDATA, LONG_PTR(Self));
```
### **3. Handle date changes  

Receive the Windows notification:  
```delphi
  if (aUMsg = WM_NOTIFY) and (LSelfRef <> nil) then
  begin
    LPNMHDR := PNMHDR(aLParam);
    if (LPNMHDR.hwndFrom = LSelfRef.FDateTimePicker) and (LPNMHDR.code = DTN_DATETIMECHANGE) then
    begin
      LPNMDATETIMECHANGE := PNMDATETIMECHANGE(aLParam);
      LSysTime := LPNMDATETIMECHANGE.st;
      LDateTime := SystemTimeToDateTime(LSysTime);
      LSelfRef.Label1.Text := 'Selected date: ' + DateToStr(LDateTime);
    end;
  end;
```  
the full WndProc :  
```delphi  
class function TMainView.HookProc(
  aHWnd: HWND;
  aUMsg: UINT;
  aWParam: WPARAM;
  aLParam: LPARAM): LRESULT;
var
  LPNMHDR: PNMHDR;
  LPNMDATETIMECHANGE: PNMDATETIMECHANGE;
  LSysTime: TSystemTime;
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
      LSysTime := LPNMDATETIMECHANGE.st;
      LDateTime := SystemTimeToDateTime(LSysTime);
      LSelfRef.Label1.Text := 'Selected date: ' + DateToStr(LDateTime);
    end;
  end;

  // Call original window proc
  Result := CallWindowProc(LSelfRef.FOldWndProc, aHWnd, aUMsg, aWParam, aLParam);
end;
```

### 📁 Project Structure:
```css
/FMX_Winapi_DateTimePicker
   ├── Main.View.pas
   ├── Main.View.fmx
   ├── README.md
   └── FMX_Winapi_DateTimePicker.dpr
```
### 💡 Why Do This?

FMX’s built-in TDateEdit uses custom FMX rendering — no Vista/Win10 animations, no Win11 calendar style.

Using WinAPI you get:

- Native Windows UI  

- Hardware-accelerated animation  

- User-familiar experience  

- Better accessibility  

### 🧪 Tested On

  - Delphi 12 Athens  

  - Windows 10  

  - Both 32-bit and 64-bit builds

### 📝 Notes:  
  
  This approach uses classic WinAPI controls.  
If you need WinUI or WinRT composition, that's a different API set.  

### 📜 License:  

  MIT License — free to use, modify, and distribute.  

### ⭐ Support:  

  If this repository helped you, please star the repo ⭐  
and subscribe to the [YouTube channel](https://www.youtube.com/@MBen_Delphi) for more Delphi / FMX tricks!  

