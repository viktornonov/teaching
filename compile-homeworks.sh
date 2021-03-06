#!/bin/sh
#should run with bash!!!

CORRECT_OUTPUT="true.txt"
COMPILER_RESULT_FILE="compiler-result.txt"
INPUT_PARAMS_FILE="in.txt"

#prints passed parameter in red
function print_red {
  echo -e "\e[31m$1\e[0m"
}

#prints passed parameter in green
function print_green {
  echo -e "\e[32m$1\e[0m"
}

function print_yellow {
  echo -e "\e[93m$1\e[0m"
}

function print_underlined {
  echo -e "\e[1;4m$1\e[0m"
}

# $1 - the excutable file //$out_file
function check_result {
  #check for segmentation fault
  if [ $? -eq 139 ]; then
    print_red "Segmentation fault"
  else
    print_yellow "Output:"
    cat $1.txt
    result=$(diff -u $CORRECT_OUTPUT $1.txt)
    if [ -z "$result" ]; then
      print_green "true"
    else
      print_red $result
    fi
  fi

  #check for warnings
  if [ -s $COMPILER_RESULT_FILE ]; then
    print_yellow "Warnings:"
    cat $COMPILER_RESULT_FILE
  fi
}

if [ $1 = "clean" ]; then
  echo 'Cleaning up'
  rm *.out*
  exit
fi

#these files must exist
if [ ! -e $CORRECT_OUTPUT ] || [ ! -e $INPUT_PARAMS_FILE ]
then
  print_red "should create $CORRECT_OUTPUT and $INPUT_PARAMS_FILE"
  exit
fi

for file in *.c
  do
    if [ -f "$file" ]; then
      print_underlined $file | sed -r "s/\.c//"
      out_file=$(echo $file | sed -e "s/\.c/.out/")
      gcc -lm -Wall $file -o $out_file 2> $COMPILER_RESULT_FILE
      if [ -s $out_file ]; then
        args=$(cat $INPUT_PARAMS_FILE)
        ./$out_file $args > $out_file.txt
        check_result $out_file
      else
        print_red "Can't compile"
        cat $COMPILER_RESULT_FILE
      fi

      printf "_________________________\n\n"
    fi
    rm $COMPILER_RESULT_FILE
  done

