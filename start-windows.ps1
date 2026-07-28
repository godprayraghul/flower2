$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "Petalora - Next.js App Router" -ForegroundColor Magenta
Write-Host "URL: http://localhost:3000" -ForegroundColor Cyan

if (-not (Test-Path "package.json")) {
  throw "package.json is not in this folder. Open the extracted project root."
}

if (-not (Test-Path ".env.local")) {
  Copy-Item ".env.example" ".env.local"
  Write-Host "Created .env.local from .env.example"
}

if (-not (Test-Path "node_modules")) {
  Write-Host "Installing packages. This may take a few minutes..."
  & npm.cmd install
}

& npm.cmd run dev
