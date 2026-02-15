#!/bin/bash

# Script to run all tests and generate coverage report

echo "Running 3ASH - Gym Trainer App tests..."
echo "=================================="

# Run all tests
echo "1. Running all tests..."
flutter test --coverage

# Check if tests passed
if [ $? -ne 0 ]; then
    echo "Error: Tests failed"
    exit 1
fi

echo "2. Generating coverage report..."
genhtml coverage/lcov.info -o coverage/html

# Verify coverage file exists
if [ -f "coverage/lcov.info" ]; then
    echo "✅ Coverage report generated successfully"
    echo "   - Coverage file: coverage/lcov.info"
    echo "   - HTML report: coverage/html/index.html"
else
    echo "❌ Coverage report not generated"
    exit 1
fi

echo "=================================="
echo "✅ All tests passed and coverage report generated"
echo "✅ Coverage report available at coverage/html/index.html"
