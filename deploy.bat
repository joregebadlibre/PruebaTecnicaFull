@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "COMPOSE_FILE=%SCRIPT_DIR%docker-compose.yml"

set "SHOW_LOGS=0"
set "DO_DOWN=0"
set "CLEAN_VOLUMES=0"

:parseArgs
if "%~1"=="" goto afterParse

if /I "%~1"=="--logs" (
  set "SHOW_LOGS=1"
  shift
  goto parseArgs
)

if /I "%~1"=="--down" (
  set "DO_DOWN=1"
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
if "%DO_DOWN%"=="1" (
  if "%CLEAN_VOLUMES%"=="1" (
    docker compose -f "%COMPOSE_FILE%" down -v
  ) else (
    docker compose -f "%COMPOSE_FILE%" down
  )
  exit /b %ERRORLEVEL%
)

docker compose -f "%COMPOSE_FILE%" build
if errorlevel 1 exit /b %ERRORLEVEL%

docker compose -f "%COMPOSE_FILE%" up -d
if errorlevel 1 exit /b %ERRORLEVEL%

echo.
echo Servicios levantados:
docker compose -f "%COMPOSE_FILE%" ps

echo.
echo URLs:
echo - API:   http://localhost:8080
echo - Front: http://localhost:4000

if "%SHOW_LOGS%"=="1" (
  docker compose -f "%COMPOSE_FILE%" logs -f
)

exit /b 0

:help
echo Usage: deploy.bat [--logs] [--down] [--clean]
echo.
echo   --logs   Follow logs after starting
echo   --down   Stop services
echo   --clean  With --down, remove volumes (deletes Postgres data)
exit /b 0

:helpError
echo Usage: deploy.bat [--logs] [--down] [--clean]
exit /b 1
