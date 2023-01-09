#!/bin/bash

function ones {
    local param=$1
    case $param in
        1) echo "One" ;;
        2) echo "Two" ;;
        3) echo "Three" ;;
        4) echo "Four" ;;
        5) echo "Five" ;;
        6) echo "Six" ;;
        7) echo "Seven" ;;
        8) echo "Eight" ;;
        9) echo "Nine" ;;
    esac
}

function belowTwenty {
    local param=$1
    case $param in
        10) echo "Ten" ;;
        11) echo "Eleven" ;;
        12) echo "Twelve" ;;
        13) echo "Thirteen" ;;
        14) echo "Fourteen" ;;
        15) echo "Fifteen" ;;
        16) echo "Sixteen" ;;
        17) echo "Seventeen" ;;
        18) echo "Eighteen" ;;
        19) echo "Nineteen" ;;
    esac
}

function tens {
    local param=$1
    case $param in
        20) echo "Twenty" ;;
        30) echo "Thirty" ;;
        40) echo "Fourty" ;;
        50) echo "Fifty" ;;
        60) echo "Sixty" ;;
        70) echo "Seventy" ;;
        80) echo "Eighty" ;;
        90) echo "Ninety" ;;
    esac
}


function two_digit {
    local param=$1
    if(($param < 10))
    then
        local ret=$(ones $param)
        echo "$ret"
    elif(($param < 20))
    then
        local ret=$(belowTwenty $param)
        echo "$ret"
    elif((param%10 == 0))
    then
        local ret=$(tens $param)
        echo "$ret"
    else
        ((val1=$param/10*10))
        ((val2=$param%10))
        local ret1=$(tens $val1)
        local ret2=$(ones $val2)
        echo "$ret1 $ret2"
    fi
}

function three_digit {
    local param=$1
    if(($param/100 == 0))
    then
        local ret=$(two_digit $param)
        echo "$ret"
    elif(($param%100 == 0))
    then
        ((val3=$param/100))
        local ret=$(ones $val3)
        echo "$ret Hundred"
    else
        ((val4=$param/100))
        ((val5=$param%100))
        local ret1=$(ones $val4)
        local ret2=$(two_digit $val5)
        echo "$ret1 Hundred $ret2"
    fi
}


function numToWord {
    local param=$1
    if(($param == 0))
    then
        echo "Zero"
    else
        local word=''
        ((billions=$param/1000000000))
        ((tmp1=$billions*1000000000))
        ((param-=$tmp1))

        ((millions=$param/1000000))
        ((tmp2=$millions*1000000))
        ((param-=$tmp2))

        ((thousands=$param/1000))
        ((tmp3=$thousands*1000))
        ((param-=$tmp3))

        if(($billions > 0))
        then
            local num1=$(three_digit $billions)
            word="$word $num1 Billion "
        fi

        if(($millions > 0))
        then
            local num2=$(three_digit $millions)
            word="$word $num2 Million "
        fi

        if(($thousands > 0))
        then
            local num3=$(three_digit $thousands)
            word="$word $num3 Thousand "
        fi

        if(($param > 0))
        then
            local num4=$(three_digit $param)
            word="$word $num4"
        fi

        echo "$word"
    fi
}

function guess_number {
  local guess=$1
  local target=$(($RANDOM % 10 + 1))
  local n=3
  while [[ $guess -ne $target ]]
  do
      ((n=n-1))
      if [[ $guess -lt $target ]]
      then
          echo "Your guess was too low."
      elif [[ $guess -gt $target ]]
      then
          echo "Your guess was too high."
      fi
      if(($n<=0))
      then
          break
      fi
      echo -n "Enter your guess (1-10): "
      read guess
  done
  if(($n>0))
  then
      echo "Congratulations! You guessed the correct number: $target"
  else
      echo -e "YOU RAN OUT OF TRIALS GAME OVER\n"
      exit 1
  fi
}

function isPalindrome {
  local reverse="$(echo "$1" | rev)"
  if [ "$1" = "$reverse" ]
  then
    echo "true"
  else
    echo "false"
  fi
}

function bubble_sort {
    local arr=("$@")
    n=${#arr[@]}
    for ((i=0;i<n;i++))
    do
        for ((j=0;j<n-i-1;j++))
        do
            if [ "${arr[j]}" -gt "${arr[$((j + 1))]}" ]
            then
                temp=${arr[j]}
                arr[j]=${arr[$((j + 1))]}
                arr[$((j + 1))]=$temp
            fi
        done
    done
    echo "${arr[@]}"
}

function isSubstring {
  local strr1="$1"
  local strr2="$2"
  [[ $strr2 =~ $strr1 ]]
}

function FinalBossLand {
    echo -e "\n->>!Final Boss on Land is Weak Against Palindroms!<<-"
    echo -e "if i can't get a palindrom out of your string you LOSE\n"
    read st
    local ret=$(isPalindrome $st)
    if [ $ret = "true" ]
    then
        return 1
    else
        return 0
    fi
}

function FinalBossSea {
    echo -e "\n->>!Final Boss in Sea is Weak Against fire!<<-"
    echo -e "put a string, note: if the string fire isn't substring you LOSE\n"
    read -p "Enter a String : " s2
    if isSubstring "fire" $s2
    then
        return 1
    else
        return 0
    fi
}

function LastStepsSea {
    FinalBossSea
    local catchFinalBossSea=$?
    if(($catchFinalBossSea==0))
    then
        echo -e "\nFinal Boss Killed YOU\n"
        exit 1
    else
        ./solve_to_get_the_cure
    fi
}

function LastStepsLand {
    FinalBossLand
    local catchFinalBossLand=$?
    if(($catchFinalBossLand==0))
    then
        echo -e "\nFinal Boss Killed YOU\n"
        exit 1
    else
        ./solve_to_get_the_cure
    fi
}

function find_median {
  local array=("$@")
  local sorted_array=($(printf "%s\n" "${array[@]}" | sort -n))
  local n=${#sorted_array[@]}

  if [ $((n % 2)) -eq 1 ]
  then
    local median=${sorted_array[$((n / 2))]}
  else
    local median=$(((sorted_array[$((n / 2 - 1))] + sorted_array[$((n / 2))]) / 2))
  fi

  echo "Median = $median"
}

if [ -e my_rand_num_file ] #exists if true
then
    wordcount=$(wc -m < my_rand_num_file)
    if(($wordcount==1)) #true if not empty
    then
        stage=$(cut -c 1 my_rand_num_file)
    else
        echo -e "Choose Your Way :\n1- Walk on Land\n2- Jump in the sea\n3- Choose for me\n"
        read stage
    fi
fi

if(($stage==1))
then
    echo -ne "\nYOU Choosed To Walk On Land"
    echo -e "\nYou are facing your first Enemy:\n1- Kill him\n2- Get Stapped\n3- Back In Time\n"
    read tmp1
    echo -e '\n'
    if(($tmp1==2))
    then
        echo -e "\nYou Got Stapped And Died GAME OVER"
        comm1="> my_rand_num_file"
        eval $comm1
        exit 1
    elif(($tmp1==3))
    then
            echo -e "\n"
            echo "$" >> my_rand_num_file
            ./code
    elif(($tmp1==1))
    then
        echo -e "You Now have to solve one of this puzzles to pass the DOOR :"
        echo -e "1- Spell the integer number as English Words"
        echo -e "2- Sort array of integers\n"
        read tmp2
        echo -e '\n'
        if(($tmp2==1))
        then
            read -p "Enter Integer To Spell it as Words : " inp1
            ans1=$(numToWord $inp1)
            echo "$ans1" | xargs
            LastStepsLand
        elif(($tmp2==2))
        then
            echo -n "Enter Array to be sorted : "
            read -a s_arr
            bubble_sort "${s_arr[@]}"
            LastStepsLand
        fi
    fi
elif(($stage==2))
then
    echo -ne "\nYOU Choosed To Jump In The Sea"
    echo -e "\nYou facing a Shark in the Sea:\n1- Kill the Shark\n2- drown in the Sea\n3- Back In Time\n"
    read tmp3
    if(($tmp3==2))
    then
        echo -e "\nYOU Got Drown in the Sea GAME OVER"
        comm2="> my_rand_num_file"
        eval $comm2
        exit 1
    elif(($tmp3==3))
    then
        echo -e "\n"
        echo "$" >> my_rand_num_file
        ./code
    elif(($tmp3==1))
    then
        echo -e "Now You have to solve one of this puzzles to get the Sea mask :"
        echo -e "1- Play Guessing game"
        echo -e "2- Find Median of An Array\n"
        read tmp4
        if(($tmp4==1))
        then
            read -p "Enter Guess : " Guess
            guess_number $Guess
            LastStepsSea
        elif(($tmp4==2))
        then
            echo -n "Enter Array to find Median of : "
            read -a m_arr
            find_median "${m_arr[@]}"
            LastStepsSea
        fi
    fi

elif(($stage==3))
then
    my_rand_num=$(($RANDOM % 2 + 1))
    echo -n "$my_rand_num" > my_rand_num_file
    sed -i 's.\\n..g' my_rand_num_file
    sed -i 's/ //g' my_rand_num_file
    ./code
fi

