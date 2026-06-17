@echo off
cd /d "%~dp0"
python -m http.server 4173 --bind 0.0.0.0
