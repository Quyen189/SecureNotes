@echo off
setlocal
cd /d "%~dp0"
echo ===============================================
echo   IT43 - Secure Notes - SQL Server
echo ===============================================
echo.
echo Connection string: appsettings.json
echo.
dotnet restore
if errorlevel 1 (
    echo.
    echo [ERROR] dotnet restore failed.
    pause
    exit /b 1
)

dotnet run --launch-profile http
pause
