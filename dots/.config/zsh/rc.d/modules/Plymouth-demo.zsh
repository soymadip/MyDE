# Plymouth demo function
demo_plymouth() {
  local R='\033[1;31m'
  local B='\033[1;34m'
  local G='\033[1;32m'
  
  # duration in seconds, default is 10s
  local duration=${1:-10}

  echo -e $G"Starting Plymouth demo for $duration seconds..."

  # Use sudo for individual Plymouth commands that need root
  sudo plymouthd

  sudo plymouth --show-splash

  for ((I = 0; I < $duration; I++)); do
    sudo plymouth --update=test$I
    sleep 1
  done

  sudo plymouth quit
  
  echo -e $G"Plymouth demo completed"
}
