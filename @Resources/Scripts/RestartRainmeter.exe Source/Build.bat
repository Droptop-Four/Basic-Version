@echo off
setlocal EnableDelayedExpansion

:: Usage: build.bat MyZipFile.zip
set OUTPUT_FILE=%1
if "%OUTPUT_FILE%" == "" set OUTPUT_FILE=RestartRainmeter.zip

if exist ".\.build\" rd /q /s ".\.build" > nul 2>&1
if exist "%OUTPUT_FILE%" del "%OUTPUT_FILE%" > nul

:: Visual Studio no longer creates the |%VSxxxCOMNTOOLS%| environment variable during install, so link
:: directly to the default location of "vcvarsall.bat" (Visual Studio 2019 Communnity)
set VCVARSALL=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat
if not exist "%VCVARSALL%" set VCVARSALL=%VCVARSALL:Community\=Enterprise\%
if not exist "%VCVARSALL%" echo ERROR: vcvarsall.bat not found & exit /b 1

echo RestartRainmeter Build
echo ----------------------------------------------
echo.

call "%VCVARSALL%" x86 > nul

set MSBUILD="msbuild.exe" /nologo^
	/p:ExcludeTests=true^
	/p:TrackFileAccess=false^
	/p:Configuration=Release

if exist "Certificate.bat" call "Certificate.bat" > nul
set SIGNTOOL_SHA1="signtool.exe" sign /t http://timestamp.comodoca.com /f "%CERTFILE%" /p "%CERTKEY%"
set SIGNTOOL_SHA2="signtool.exe" sign /fd sha256 /tr http://timestamp.comodoca.com/?td=sha256 /td sha256 /f "%CERTFILE%" /p "%CERTKEY%"

:: Set vcbuild environment variables and begin build
for /F "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
	set /A "BUILD_BEGIN_TIMESTAMP=(((%%a * 60) + 1%%b %% 100)* 60 + 1%%c %% 100) * 100 + 1%%d %% 100"
)

:: Build Library
echo * Building 32-bit project
%MSBUILD% /t:rebuild /p:Platform=x86 /v:q /m RestartRainmeter.sln || (echo   ERROR %ERRORLEVEL%: Build failed & exit /b 1)

echo * Building 64-bit project
%MSBUILD% /t:rebuild /p:Platform=x64 /v:q /m RestartRainmeter.sln || (echo   ERROR %ERRORLEVEL%: Build failed & exit /b 1)

:: Sign binaries
if not "%CERTFILE%" == "" (
	echo * Signing binaries
	%SIGNTOOL_SHA2% x32-Release\RestartRainmeter.exe || (echo   ERROR %ERRORLEVEL%: Signing x32-Release\RestartRainmeter.exe failed & exit /b 1)
	%SIGNTOOL_SHA2% x64-Release\RestartRainmeter.exe || (echo   ERROR %ERRORLEVEL%: Signing x64-Release\RestartRainmeter.exe failed & exit /b 1)
)

echo * Archiving binaries
md ".\.build\x32" > nul
md ".\.build\x64" > nul
xcopy /Q /Y ".\x32-Release\RestartRainmeter.exe" ".\.build\x32\" > nul
xcopy /Q /Y ".\x64-Release\RestartRainmeter.exe" ".\.build\x64\" > nul
tar -caf "%OUTPUT_FILE%" -C ".\.build" "*" > nul

echo * Cleaning up
if exist ".\.build\" rd /q /s ".\.build" > nul 2>&1

:DONE
for /F "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
	set /A "BUILD_END_TIMESTAMP=(((%%a * 60) + 1%%b %% 100)* 60 + %%c %% 100) * 100 + 1%%d %% 100"
)
set /A "BUILD_ELAPSED_TIME=(%BUILD_END_TIMESTAMP% - %BUILD_BEGIN_TIMESTAMP%) / 100"
echo * Build complete. Elapsed time: %BUILD_ELAPSED_TIME% sec

echo.
pause
