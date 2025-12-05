@echo off

:: Check for empty arguments
if [%1]==[] (
  echo Usage: ./sim.bat module_name
  echo Use ./sim.bat h for more information
  exit /b 1
)
:: Documentation
if "%1"=="h" (
  echo sim.bat: Tool for compiling and simulating SystemVerilog code in DT
  echo.
  echo Usage: ./sim.bat module_name
  echo.
  echo This script supports the following modes:
  echo - Default mode: ./sim.bat module_name
  echo     Replace module_name by the name of the module you want to test ^(not the testbench, but the module itself, e.g., xyz.sv^).
  echo     This will run your code with all the required files, i.e., xyz.sv, xyz_tb.sv and any potentially also required files.
  echo - Solution mode: ./sim.bat module_name sol
  echo     If you downloaded the solution xyz_sol.sv and added it to the folder, run this to try out the solution
  echo     The only difference to the default mode is that here, xyz_sol.sv is used instead of xyz.sv
  echo - Grading mode ^(only for tutors^): ./sim.bat module_name grd
  echo     Like the default mode, but uses xyz_tb_full.sv instead of xyz_tb.sv to do the more extensive testing
  echo - Grading solution mode ^(only for testing^): ./sim.bat module_name grdsol
  echo     This combines the solution mode and the grading mode by using xyz_sol.sv and xyz_tb_full.sv which can be used for internal testing
  echo - Custom mode: ./sim.bat module_name custom
  echo     If further arguments are provided, these are used as list of files to import.
  echo     Otherwise, the list of files to import is taken from the 5th line of the corresponding runconfig if it exists.
  echo - Alternative grading mode ^(only for tutors^): ./sim.bat module_name altgrd
  echo     This requires an alternative runconfig to run grading mode on, e.g., different testbenches, submodules or similar
  echo     It is also possible to append an index of a specific alternative runconfig as additional argument if there are multiple
  echo - Alternative grading solution mode ^(only for testing^): ./sim.bat module_name altgrdsol
  echo     This requires an alternative runconfig to run grading mode on, e.g., different testbenches, submodules or similar
  echo     It is also possible to append an index of a specific alternative runconfig as additional argument if there are multiple
  echo.
  echo.
  echo Runconfigs:
  echo By default, we assume that there are at most four files for a module xyz that can be imported by this script:
  echo  - xyz.sv: This contains the ^(empty^) module code itself
  echo  - xyz_tb.sv: This contains the default testbench
  echo  - xyz_sol.sv: This is xyz.sv filled with one possible solution implementation ^(will only be available for students when an exercise's/homework's solution is published^)
  echo  - xyz_tb_full.sv: This contains a more extensive testbench to be used by tutors when grading homework ^(will never be available for students^)
  echo.
  echo In some cases, more files might be required, e.g., if another sub-module needs to be imported from another file.
  echo For this case, a file xyz.runconfig is included which exactly follows this formatting:
  echo  - 1. line: List of files required for default mode, separated by whitespaces
  echo  - 2. line: List of files required for solution mode, separated by whitespaces
  echo  - 3. line: List of files required for grading mode, separated by whitespaces
  echo  - 4. line: List of files required for grading solution mode, separated by whitespaces
  echo  - 5. line: Empty or list of files for custom mode, separated by whitespaces
  echo  - 6. line: Empty
  echo.
  echo If a runconfig for a module is provided, it will be used ^(except for custom mode if a list of files is provided manually^). Otherwise, the default naming scheme will be assumed.
  echo.
  echo There might also be an alternative runconfig xyz_alternative.runconfig for grading and solution grading mode in alternative configurations
  echo If an alternative configuration with a specific index i is used, the relevant runconfig is xyz_alternative_i.runconfig
  exit /b 0
)
:: Otherwise, first arg has to be module name
set module=%1
set files=

:: Check for differend modes
:: First: Make Windows not be completely useless:
setlocal enabledelayedexpansion
if [%2]==[] (
  :: no further args => default mode
  if exist %module%.runconfig (
    :: specific runconfig exists in first line of runconfig
    for /F "delims=" %%i in (%module%.runconfig) do if not defined files set "files=%%i"
  ) else (
    :: default for no runconfig
    set "files=!module!.sv !module!_tb.sv"
  )
) else ( if "%2"=="sol" (
  :: => solution mode
  if exist %module%.runconfig (
    :: specific runconfig exists in second line of runconfig
    for /F "skip=1 delims=" %%i in (%module%.runconfig) do if not defined files set "files=%%i"
  ) else (
    :: default for no runconfig
    set "files=!module!_sol.sv !module!_tb.sv"
  )
) else ( if "%2"=="grd" (
  :: => grading mode
  if exist %module%.runconfig (
    :: specific runconfig exists in third line of runconfig
    for /F "skip=2 delims=" %%i in (%module%.runconfig) do if not defined files set "files=%%i"
  ) else (
    :: default for no runconfig
    set "files=!module!.sv !module!_tb_full.sv"
  )
) else ( if "%2"=="grdsol" (
  :: => grading on solution mode (testing purposes)
  if exist %module%.runconfig (
    :: specific runconfig exists in fourth line of runconfig
    for /F "skip=3 delims=" %%i in (%module%.runconfig) do if not defined files set "files=%%i"
  ) else (
    :: default for no runconfig
    set "files=!module!_sol.sv !module!_tb_full.sv"
  )
) else ( if "%2"=="custom" (
  :: => custom file imports
  if [%3]==[] (
    :: no list of files passed => search for custom runconfig
    if exist %module%.runconfig (
      :: specific runconfig exists in fifth line of runconfig
      for /F "skip=4 delims=" %%i in (%module%.runconfig) do if not defined files set "files=%%i"
    ) else (
      echo Please add list of required files as arguments or in fifth line of runconfig
      exit /b 1
    )
  ) else (
    for /f "tokens=2,* delims= " %%a in ("%*") do set files=%%b
  )
) else ( if "%2"=="altgrd" (
  :: => alternative grading mode
  if [%3]==[] (
    set suffix=
  ) else (
    set "suffix=_%3"
  )
  if exist %module%_alternative!suffix!.runconfig (
    :: specific runconfig exists in third line of runconfig
    for /F "skip=2 delims=" %%i in (%module%_alternative!suffix!.runconfig) do if not defined files set "files=%%i"
  ) else (
    echo No alternative runconfig provided.
    exit /b 1
  )
) else ( if "%2"=="altgrdsol" (
  :: => alternative grading on solution mode (testing purposes)
  if [%3]==[] (
    set suffix=
  ) else (
    set "suffix=_%3"
  )
  if exist %module%_alternative!suffix!.runconfig (
    :: specific runconfig exists in fourth line of runconfig
    for /F "skip=3 delims=" %%i in (%module%_alternative!suffix!.runconfig) do if not defined files set "files=%%i"
  ) else (
    echo No alternative runconfig provided.
    exit /b 1
  )
) else (
  echo Unsupported flag %2, allowed ones are none, sol, grd, grdsol, and custom.
  echo Use ./sim.bat h for more information
  exit /b 1
)))))))

echo Importing files %files%
echo.
echo Running command iverilog -o %module%_tb.out -g 2005-sv -s %module%_tb %files%
echo.
iverilog -o %module%_tb.out -g 2005-sv -s %module%_tb %files%
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
echo Running command vvp %module%_tb.out
echo.
vvp %module%_tb.out
exit /b 0
