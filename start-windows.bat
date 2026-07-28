@echo off
setlocal
cd /d "%~dp0"

echo.
echo ========================================
echo   Petalora - Next.js App Router

echo   URL: http://localhost:3000
echo ========================================
echo.

if not exist package.json (
  echo ERROR: package.json is not in this folder.
  echo Open or extract the folder that contains package.json.
  pause
  exit /b 1
)

if not exist .env.local (
  copy /Y .env.example .env.local >nul
  echo Created .env.local from .env.example
)

if not exist node_modules (
  echo Installing packages. This may take a few minutes...
  call npm install
  if errorlevel 1 (
    echo npm install failed. Check Node.js and internet access.
    pause
    exit /b 1
  )
)

echo Starting Petalora...
call npm run dev
endlocal
