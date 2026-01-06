@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "COMPOSE_FILE=%SCRIPT_DIR%docker-compose.yml"

set "CLEAN_VOLUMES=0"

:parseArgs
if "%~1"=="" goto afterParse

if /I "%~1"=="-v" (
  set "CLEAN_VOLUMES=1"
  shift
  goto parseArgs
)

if /I "%~1"=="--volumes" (
  set "CLEAN_VOLUMES=1"
  shift
  goto parseArgs
)

if /I "%~1"=="--clean" (
  set "CLEAN_VOLUMES=1"
  shift
  goto parseArgs
)

if /I "%~1"=="-h" goto help
if /I "%~1"=="--help" goto help

echo Unknown argument: %~1
goto helpError

:afterParse
if "%CLEAN_VOLUMES%"=="1" (
  docker compose -f "%COMPOSE_FILE%" down -v
) else (
  docker compose -f "%COMPOSE_FILE%" down
)

exit /b %ERRORLEVEL%

:help
echo Usage: down.bat [--clean^|--volumes^|-v]
echo.
echo   --clean / --volumes / -v   Remove volumes (deletes Postgres data)
exit /b 0

:helpError
echo Usage: down.bat [--clean^|--volumes^|-v]
exit /b 1
