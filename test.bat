@echo off
java -jar target/text-diff-tool-1.0.0.jar test1.json test2.json
echo Exit code: %errorlevel%
pause
