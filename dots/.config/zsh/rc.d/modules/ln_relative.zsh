
ln_relative() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: lnr <source> <destination>"
    return 1
  fi

  local source=$1
  local destination=$2

  if [[ -d $destination ]]; then
    destination="$destination/$(basename "$source")"
  fi

  # Check if destination already exists
  if [[ -e $destination ]]; then
    read -p "'$destination' already exists. Overwrite? [y/N]: " response
    if [[ ! $response =~ ^[Yy]$ ]]; then
      echo "Operation aborted."
      return 1
    fi
  fi

  # Create the symbolic link
  if ln -s -r "$source" "$destination"; then
    echo -e "\nLINKED:- $source --> $destination  \n"
  else
    echo -e "\nFAILED:- $source --> $destination \n"
    return 1
  fi
}
