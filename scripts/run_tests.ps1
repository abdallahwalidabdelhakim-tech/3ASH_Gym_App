<#
.SYNOPSIS
    Runs all tests and generates coverage report for 3ASH - Gym Trainer App.
.DESCRIPTION
    This script runs all Flutter tests, generates coverage information,
    and creates an HTML coverage report.
#>

Write-Host "Running 3ASH - Gym Trainer App tests..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

try {
    # Run all tests with coverage
    Write-Host "1. Running all tests..." -ForegroundColor Yellow
    flutter test --coverage
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Tests failed"
        exit 1
    }
    
    # Generate coverage report
    Write-Host "2. Generating coverage report..." -ForegroundColor Yellow
    genhtml coverage/lcov.info -o coverage/html
    
    if (Test-Path "coverage/lcov.info") {
        Write-Host "✅ Coverage report generated successfully" -ForegroundColor Green
        Write-Host "   - Coverage file: coverage/lcov.info" -ForegroundColor White
        Write-Host "   - HTML report: coverage/html/index.html" -ForegroundColor White
    } else {
        Write-Error "❌ Coverage report not generated"
        exit 1
    }
    
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "✅ All tests passed and coverage report generated" -ForegroundColor Green
    Write-Host "✅ Coverage report available at coverage/html/index.html" -ForegroundColor Green
}
catch {
    Write-Error "Error running tests: $_"
    exit 1
}
