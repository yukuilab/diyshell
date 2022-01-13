#!/bin/bash
#
# 简化日常服务器运维命令,在.bash_profile 或 .zshrc 文件中引用
# 版权 2022 yukui


#######################################
# Show file pwd
# Globals:
#   pwdResult
# Arguments:
#   filename
#######################################
function pwdf(){

  if [ -f "$1" ]; then
    pwdResult=`pwd`
    echo "${pwdResult}"/"$1"
  else
    eval "pwd"
  fi
}

#######################################
# Show process info,and kill process.
# Globals:
#   SHELL
#   kill_all_flg
#   pid
#   pid_num
#   pid_num_arr
#   runcommand
#   runcommand_a
# Arguments:
#   1: keyName about PID info
# Returns:
#   None
#######################################

function pg() {

  if [ -z "$1" ]; then
    echo 'Parameter invalid,please input key for search!'
    return
  fi

  #执行一次查看
  runcommand="ps -ef|grep $1|grep -v 'grep'"
  eval ${runcommand}

  #执行一次，如果没有结果就退出
  if [ "$?" = '1' ]; then
    echo "not result about '$1'!"
    return
  fi

  #读取参数，全部杀死｜推出程序｜输入PID 进程号码精准定位 可以多个
  #不同SHELL 的read 参数不同
  if [ "$SHELL" = '/bin/zsh' ]; then
    read -k '?Enter param: kill PID option--> [A]:All [E]:EXIT [S]PID NUM >' kill_all_flg
  else
    read -p 'Enter param: kill PID option--> [A]:All [E]:EXIT [S]PID NUM >' -n 1 kill_all_flg
  fi
  echo -e '\n'

  if [ 'A' = "${kill_all_flg}" ]; then

    runcommand_a=${runcommand}"|awk '{print \$2}'|xargs kill -9"
    echo 'Run Command==>'${runcommand_a}
    eval ${runcommand_a}
  elif [ 'E' = "${kill_all_flg}" ]; then
    echo 'exit now!'
    return
  elif [ 'S' = "${kill_all_flg}" ]; then

    if [ "$SHELL" = '/bin/zsh' ]; then
      read '?Enter param: PID NUM (Separated by spaces .etc 123 456 789) >' pid_num
    else
      read -p "Enter param: PID NUM (Separated by spaces .etc 123 456 789) >" pid_num
    fi

    #IFS=' '; $IFS default value is blank
    pid_num_arr=($pid_num)
    for pid in "${pid_num_arr[@]}"; do
      echo 'Run Command==>kill -9 '${pid}
      kill -9 ${pid}
    done
  else
    echo 'invalid param,exit now!'
    return
  fi
}

