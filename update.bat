@echo off
setlocal enabledelayedexpansion

REM ====== CONFIG ======
set "THREAD_ID=1350634528338874429"
set "EXPORTER=DiscordChatExporter.Cli.exe"
set "OUT_THREAD=thread.html"
set "OUT_INDEX=index.html"
REM =====================

cd /d "%~dp0"

REM Token must be set as an environment variable: DCE_TOKEN
if "%DCE_TOKEN%"=="" (
  echo DCE_TOKEN is not set. Set it in Windows Environment Variables first.
  exit /b 1
)

REM 1) Export to thread.html
"%EXPORTER%" export -t "%DCE_TOKEN%" -c "%THREAD_ID%" -f HtmlDark --include-threads -o "%OUT_THREAD%"
if errorlevel 1 (
  echo Export failed.
  exit /b 1
)

REM 2) Delete previous index.html (if it exists)
if exist "%OUT_INDEX%" del /f /q "%OUT_INDEX%"

REM 3) Rename thread.html -> index.html
ren "%OUT_THREAD%" "%OUT_INDEX%"

REM 4) Push to GitHub Pages repo
git add "%OUT_INDEX%"
git commit -m "Update archive" || echo No changes to commit
git push

endlocal
