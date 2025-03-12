## Test Coverage Guide

# Flutter

# Generate `coverage/lcov.info` file
Navigate to the frondend directories 
cd ewc_frontend/
flutter test --coverage
# Generate HTML report
# Note: on macOS you need to have lcov installed on your system (`brew install lcov`) to use this:
genhtml coverage/lcov.info -o coverage/html
# Open the report
open coverage/html/index.html