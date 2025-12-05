#!/bin/sh

# Check for empty arguments
if [ $# -eq 0 ]; then
  echo Usage: ./sim.sh module_name
  echo Use ./sim.sh h for more information
  exit 1
fi
# Documentation
if [ "$1" = "h" ]; then
  echo sim.sh: Tool for compiling and simulating SystemVerilog code in DT
  echo
  echo Usage: ./sim.sh module_name
  echo You might need to run the following command to make this file executable: chmod +x sim.sh
  echo
  echo This script supports the following modes:
  echo - Default mode: ./sim.sh module_name
  echo "    Replace module_name by the name of the module you want to test (not the testbench, but the module itself, e.g., xyz.sv)."
  echo "    This will run your code with all the required files, i.e., xyz.sv, xyz_tb.sv and any potentially also required files."
  echo - Solution mode: ./sim.sh module_name sol
  echo "    If you downloaded the solution xyz_sol.sv and added it to the folder, run this to try out the solution"
  echo "    The only difference to the default mode is that here, xyz_sol.sv is used instead of xyz.sv"
  echo "- Grading mode (only for tutors)": ./sim.sh module_name grd
  echo "    Like the default mode, but uses xyz_tb_full.sv instead of xyz_tb.sv to do the more extensive testing"
  echo "- Grading solution mode (only for testing)": ./sim.sh module_name grdsol
  echo "    This combines the solution mode and the grading mode by using xyz_sol.sv and xyz_tb_full.sv which can be used for internal testing"
  echo "- Custom mode: ./sim.sh module_name custom"
  echo "    If further arguments are provided, these are used as list of files to import."
  echo "    Otherwise, the list of files to import is taken from the 5th line of the corresponding runconfig if it exists."
  echo "- Alternative grading mode (only for tutors)": ./sim.sh module_name altgrd
  echo "    This requires an alternative runconfig to run grading mode on, e.g., different testbenches, submodules or similar"
  echo "    It is also possible to append an index of a specific alternative runconfig as additional argument if there are multiple"
  echo "- Alternative grading solution mode (only for testing)": ./sim.sh module_name altgrdsol
  echo "    This requires an alternative runconfig to run grading mode on, e.g., different testbenches, submodules or similar"
  echo "    It is also possible to append an index of a specific alternative runconfig as additional argument if there are multiple"
  echo
  echo
  echo Runconfigs:
  echo By default, we assume that there are at most four files for a module xyz that can be imported by this script:
  echo " - xyz.sv: This contains the (empty) module code itself"
  echo " - xyz_tb.sv: This contains the default testbench"
  echo " - xyz_sol.sv: This is xyz.sv filled with one possible solution implementation (will only be available for students when an exercise's/homework's solution is published)"
  echo " - xyz_tb_full.sv: This contains a more extensive testbench to be used by tutors when grading homework (will neer be available for students)"
  echo
  echo In some cases, more files might be required, e.g., if another sub-module needs to be imported from another file.
  echo For this case, a file xyz.runconfig is included which exactly follows this formatting:
  echo " - 1. line: List of files required for default mode, separated by whitespaces"
  echo " - 2. line: List of files required for solution mode, separated by whitespaces"
  echo " - 3. line: List of files required for grading mode, separated by whitespaces"
  echo " - 4. line: List of files required for grading solution mode, separated by whitespaces"
  echo " - 5. line: Empty or list of files for custom mode, separated by whitespaces"
  echo " - 6. line: Empty"
  echo
  echo "If a runconfig for a module is provided, it will be used (except for custom mode if a list of files is provided manually). Otherwise, the default naming scheme will be assumed."
  echo
  echo "There might also be an alternative runconfig xyz_alternative.runconfig for grading and solution grading mode in alternative configurations"
  echo "If an alternative configuration with a specific index i is used, the relevant runconfig is xyz_alternative_i.runconfig"
  exit 0
fi
# Otherwise, first arg has to be module name
module=$1

# Check for different modes
if [ $# -eq 1 ]; then # no further args => default mode
  if test -f "${module}.runconfig"; then # test if specific runconfig exists
    files=`cat ${module}.runconfig | head -n 1 | tail -n 1` # use first line of runconfig
  else
    files="${module}.sv ${module}_tb.sv" # default to this is no runconfig
  fi
elif [ "$2" = "sol" ]; then # => solution mode
  if test -f "${module}.runconfig"; then # test if specific runconfig exists
    files=`cat ${module}.runconfig | head -n 2 | tail -n 1` # use second line of runconfig
  else
    files="${module}_sol.sv ${module}_tb.sv" # default to this is no runconfig
  fi
elif [ "$2" = "grd" ]; then # => grading mode
  if test -f "${module}.runconfig"; then # test if specific runconfig exists
    files=`cat ${module}.runconfig | head -n 3 | tail -n 1` # use third line of runconfig
  else
    files="${module}.sv ${module}_tb_full.sv" # default to this is no runconfig
  fi
elif [ "$2" = "grdsol" ]; then # => grading on solution mode (testing purposes)
  if test -f "${module}.runconfig"; then # test if specific runconfig exists
    files=`cat ${module}.runconfig | head -n 4 | tail -n 1` # use fourth line of runconfig
  else
    files="${module}_sol.sv ${module}_tb_full.sv" # default to this is no runconfig
  fi
elif [ "$2" = "custom" ]; then # => custom file imports
  if [ $# -eq 2 ]; then # no list of files passed => search for custom runconfig
    if test -f "${module}.runconfig"; then # test if specific runconfig exists
      files=`cat ${module}.runconfig | head -n 5 | tail -n 1` # use fifth line of runconfig
    else
      echo Please add list of required files as arguments or in fifth line of runconfig
      exit 1
    fi
  else
    shift
    shift
    files="$@"
    # files="${@:3}"
  fi
elif [ "$2" = "altgrd" ]; then # => alternative grading mode
  if [ $# -eq 2 ]; then
    suffix=""
  else
    suffix="_$3"
  fi
  if test -f "${module}_alternative${suffix}.runconfig"; then # test if specific alternative runconfig exists
    files=`cat ${module}_alternative${suffix}.runconfig | head -n 3 | tail -n 1` # use third line of runconfig
  else
    echo No alternative runconfig provided.
    exit 1
  fi
elif [ "$2" = "altgrdsol" ]; then # => alternative grading on solution mode (testing purposes)
  if [ $# -eq 2 ]; then
    suffix=""
  else
    suffix="_$3"
  fi
  if test -f "${module}_alternative${suffix}.runconfig"; then # test if specific runconfig exists
    files=`cat ${module}_alternative${suffix}.runconfig | head -n 4 | tail -n 1` # use fourth line of runconfig
  else
    echo No alternative runconfig provided.
    exit 1
  fi
else
  echo Unsupported flag $2, allowed ones are none, sol, grd, grdsol, and custom.
  echo Use ./sim.sh h for more information
  exit 1
fi

echo Importing files $files
echo
echo Running command iverilog -o "${module}_tb.out" -g 2005-sv -s "${module}_tb" $files
echo
iverilog -o "${module}_tb.out" -g 2005-sv -s "${module}_tb" $files
if [ $? -ne 0 ]; then exit $?; fi
echo
echo Running command vvp "${module}_tb.out"
echo
vvp "${module}_tb.out"
