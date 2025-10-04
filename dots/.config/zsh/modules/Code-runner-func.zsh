#     _____                                 _ _
#    / ____|                               | (_)
#   | (___   ___  _   _ _ __ ___   __ _  __| |_ _ __
#    \___ \ / _ \| | | | '_ ` _ \ / _` |/ _` | | '_ \
#    ____) | (_) | |_| | | | | | | (_| | (_| | | |_) |
#   |_____/ \___/ \__, |_| |_| |_|\__,_|\__,_|_| .__/
#                  __/ |                       | |
#                 |___/                        |_|
#_______________________________________________________________________
#



RED='\033[0;31m'
LAVENDER='\u001b[38;5;147m'
GREEN='\033[0;32m'
AQUA='\e[38;2;216;222;233m'
NC='\033[0m' # No Color/escape code


prnt_cprmt() {
  clear
  echo -e "${LAVENDER}============= OUTPUT ==============${NC}\n"
}


prnt_cftr() {
  echo -e "\n\n${LAVENDER}============== END ================${NC}\n"
  echo -e "${LAVENDER}Do you wanna close the Terminal now?${NC}"
  echo -n "==-> "; read confirm
  if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]] || [[ -z "$confirm" ]]; then
    exit
  fi
}



code-run() {
  local command="$1"

  if [ -z "$command" ]; then
    echo "No command provided."
    return 1
  fi

  YELLOW='\033[0;33m'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m' # No Color

  clear -x
  echo "\n${YELLOW}Command${NC}: '$command'"
  echo -e "\n${YELLOW}============= OUTPUT ==============${NC}\n"

  eval "$command"
  exit_status=$?


  if [ $exit_status -eq 0 ]; then
    color="$GREEN"
  else
    color="$RED"
  fi

  echo -e "\n${color}============== END ================${NC}\n"



 echo -e "[?] Close the Terminal now?"
 echo -n "==>"
 read answer

  case $answer in
    [Yy]* ) exit 0;;
    "" ) exit 0;;
    [Nn]* ) echo "Terminal will remain open.";;
    * ) echo "Invalid response. Terminal will remain open.";;
  esac
}
