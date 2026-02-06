@echo off
setlocal
set ROOT=%~dp0
cd /d "%ROOT%"
echo Serving from %CD%
python -m http.server 8000
