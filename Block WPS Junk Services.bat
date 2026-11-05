@echo off
chcp 65001 >nul
title Cong cu chan dich vu ngam, Auto-Update va Quang cao WPS Office

:: ============================================================================
:: Kiem tra quyen Administrator (Tu dong yeu cau quyen Admin neu chua co)
:: ============================================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Dang yeu cau quyen Administrator de thuc thi...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================================
echo        CHAN DICH VU NGAM, AUTO-UPDATE VA QUANG CAO WPS OFFICE
echo ============================================================================
echo.

:: 1. Tat cac tien trinh WPS dang chay ngam
echo [1/5] Dang tat cac tien trinh WPS chay ngam...
for %%p in (wps.exe et.exe wpp.exe wpspdf.exe wpscloudsvr.exe wpsupdate.exe wpscenter.exe wpsnotify.exe ksolaunch.exe) do (
    taskkill /f /im "%%p" >nul 2>&1
)
echo       - Da dung cac tien trinh.

:: 2. Vo hieu hoa Services cua WPS
echo [2/5] Dang vo hieu hoa cac dich vu (Services) cua WPS...
for %%s in ("wpscloudsvr" "WPS Office Cloud Service" "WPS Office Update Service" "Kingsoft Office Update Service") do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo       - Da vo hieu hoa Services.

:: 3. Xoa cac tac vu tu dong cap nhat trong Task Scheduler
echo [3/5] Dang xoa cac tac vu ngam trong Task Scheduler...
schtasks /query /fo LIST | findstr /i "WPS Kingsoft" > "%temp%\wps_tasks.txt"
for /f "tokens=2 delims=:" %%a in ('findstr /i "TaskName" "%temp%\wps_tasks.txt" 2^>nul') do (
    set "taskname=%%a"
    call :DeleteTask
)
del /f /q "%temp%\wps_tasks.txt" >nul 2>&1
:: Xoa truc tiep cac ten task pho bien
for %%t in ("WPS Office Update Task" "WpsUpdateTask" "WpsExternal" "Kingsoft Update Task") do (
    schtasks /delete /tn %%t /f >nul 2>&1
)
echo       - Da don dep Task Scheduler.

:: 4. Go bo khoi dong cung Windows (Startup Registry)
echo [4/5] Dang xoa WPS khoi danh sach khoi dong cung Windows (Startup)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WPS Office" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "wpscloudsvr" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "WPS Office" /f >nul 2>&1
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /v "WPS Office" /f >nul 2>&1
echo       - Da go khoi Startup.

:: 5. Tao quy tac tuong lua (Firewall) chan ket noi cua cac file chay ngam/quang cao
echo [5/5] Dang thiet lap Windows Firewall chan ket noi ngam va quang cao...
:: Xoa rule cu neu co de tranh trung lap
netsh advfirewall firewall delete rule name="Block_WPS_Background_Telemetry" >nul 2>&1

:: Quet thu muc Kingsoft trong AppData va Program Files de chan cac file rac
for %%d in ("%localappdata%\Kingsoft\WPS Office" "%programfiles%\Kingsoft\WPS Office" "%programfiles(x86)%\Kingsoft\WPS Office") do (
    if exist "%%~d" (
        for %%f in (wpscloudsvr.exe wpsupdate.exe wpscenter.exe wpsnotify.exe upgrader.exe wpsinst.exe) do (
            for /f "delims=" %%p in ('dir /s /b "%%~d\%%f" 2^>nul') do (
                netsh advfirewall firewall add rule name="Block_WPS_Background_Telemetry" dir=out action=block program="%%p" enable=yes >nul 2>&1
                echo       + Da chan ket noi: %%p
                
                :: Doi ten file doc hai/quang cao de ngan tu kich hoat lai (tuy chon an toan cho wpsnotify va wpsupdate)
                if /i "%%f"=="wpsnotify.exe" (
                    icacls "%%p" /inheritance:r /deny "*S-1-1-0:(RX)" >nul 2>&1
                )
                if /i "%%f"=="wpsupdate.exe" (
                    icacls "%%p" /inheritance:r /deny "*S-1-1-0:(RX)" >nul 2>&1
                )
                if /i "%%f"=="wpscloudsvr.exe" (
                    icacls "%%p" /inheritance:r /deny "*S-1-1-0:(RX)" >nul 2>&1
                )
            )
        )
    )
)

echo.
echo ============================================================================
echo [HOAN TAT] Da chan toan bo dich vu ngam, tu dong cap nhat va quang cao WPS!
echo Ban van co the su dung Word, Excel, PowerPoint, PDF cua WPS binh thuong.
echo ============================================================================
pause
exit /b

:DeleteTask
:: Loai bo khoang trang dau dong
for /f "tokens=* delims= " %%x in ("%taskname%") do set "clean_task=%%x"
if not "%clean_task%"=="" (
    schtasks /delete /tn "%clean_task%" /f >nul 2>&1
)
goto :eof
