@echo off

:: module name must be provided
if [%1]==[] (
  echo Usage: synth module_name [source_files]
  exit /b 1
)
set module=%1
set files=


:: collect given or all source files (without testbenches containing $dumpfile) in current directory
setlocal enabledelayedexpansion
if [%2]==[] (
  for %%a in (*.sv) do (
    findstr "\$dumpfile" %%a > NUL
    if !errorlevel! neq 0 call set files=%%files%% %%~na.sv
  )
) else (
  for /f "tokens=1,* delims= " %%a in ("%*") do set files=%%b 
)

:: synthesize selected module to module.dot
:: frontend option mem2reg used as workaround for not recognized memory
yosys -qq -f "verilog -sv -mem2reg"                                    ^
          -p "hierarchy -check -top %module%"                          ^
          -p proc    -p opt                                            ^
          -p fsm     -p opt                                            ^
          -p memory  -p opt                                            ^
          -p flatten -p opt                                            ^
          -p "opt_clean -purge"                                        ^
          -p techmap -p opt                                            ^
          -p "show -notitle -prefix %module% -format dot -viewer echo" ^
          %files%
if %errorlevel% neq 0 exit /b %errorlevel%

:: convert graph to pdf
dot %module%.dot -Tpdf -Gmargin=0 > %module%.pdf
if %errorlevel% neq 0 exit /b %errorlevel%

:: report
echo '%module%.pdf'
