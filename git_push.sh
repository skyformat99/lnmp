#!/bin/bash
#Hehl 20170710
#git push origin master with shell

warn="Usage: $0 { [ file | dir ] [commit notes] }"
[[ -z $1 || -z $2 ]] && echo -e "\033[33m===================================================================\n${warn}\n===================================================================\n\033[0m"
echo "You typed $2"
#git add $1 && git commit -m "$2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}" && git push origin master && echo "push success"
git add $1 && git commit -m "$*" && git push origin master && echo "push success"
