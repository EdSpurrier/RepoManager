#!/bin/bash

# Clear the console
clear

# Define text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[38;5;208m'
BLUE='\033[38;5;39m'
PURPLE='\033[38;5;165m'
NC='\033[0m' # No color

# Define the JSON config filename
configFileName="installer.config.json"

# Read the repository URLs from the JSON config file
data=$(cat "$configFileName")
if [ $? -ne 0 ]; then
  echo -e "${RED}Error reading the $configFileName file${NC}"
  exit 1
fi

# Extract the repository URLs using pattern matching
repoUrls=($(echo "$data" | grep -o 'https://[^"]*'))

# Check if there are any repository URLs in the JSON file
if [ ${#repoUrls[@]} -eq 0 ]; then
  echo -e "${RED}No repository URLs found in the JSON $configFileName file${NC}"
  exit 1
fi

# Function to check if a repository exists in the current folder
repoExists() {
  local repoName=$(basename "$1" .git)
  if [ -d "$repoName" ]; then
    return 0
  else
    return 1
  fi
}

while true; do
  # Clear the console
  clear
  
  consoleWidth=$(tput cols)

  echo -e "${BLUE}$(printf '=%.0s' $(seq 1 $(tput cols)))${NC}"
  echo -e "${ORANGE}Repo Installer${NC}"
  echo -e "${BLUE}$(printf '=%.0s' $(seq 1 $(tput cols)))${NC}"
  
  for ((i=0; i<${#repoUrls[@]}; i++)); do
    repoUrl="${repoUrls[$i]}"
    repoName=$(basename "$repoUrl" .git)
    upperCaseRepoName=$(echo "$repoName" | tr '[:lower:]' '[:upper:]')
    

    if repoExists "$repoUrl"; then
      padding=$((consoleWidth - ${#upperCaseRepoName} - 17))  # Adjust padding based on the length of the repo name
      echo -e "${BLUE}($((i+1)))${NC} ${RED}${upperCaseRepoName} $(printf '%*s' $padding) [EXISTS] ${NC}"
    else
      padding=$((consoleWidth - ${#upperCaseRepoName} - 17))  # Adjust padding based on the length of the repo name
      echo -e "${BLUE}($((i+1)))${NC} ${GREEN}${upperCaseRepoName} $(printf '%*s' $padding) [INSTALL]${NC}"
    fi
  done
  echo -e "${BLUE}$(printf '=%.0s' $(seq 1 $(tput cols)))${NC}"
  read -p "" choice

  if [ "$choice" == "q" ]; then
    echo -e "${RED}Quitting.${NC}"
    break
  elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#repoUrls[@]} ]; then
    repoUrl="${repoUrls[$((choice-1))]}"
    repoName=$(basename "$repoUrl" .git)

    # Check if the repository directory already exists
    if repoExists "$repoUrl"; then
      while true; do
        echo -e "The repository directory already exists. Do you want to:"
        echo -e "  ${GREEN}(1)${NC} ${RED}Delete and reclone${NC}"
        echo -e "  ${GREEN}(2)${NC} ${RED}Pull the latest commit${NC}"
        read -p "Enter your choice (1/2): " choice
        case $choice in
          1)
            # Delete the existing directory and reclone
            rm -rf "$repoName"
            echo -e "${GREEN}Cloning $repoUrl${NC}"
            git clone "$repoUrl"
            if [ $? -eq 0 ]; then
              echo -e "${GREEN}Cloned $repoUrl successfully${NC}"
            else
              echo -e "${RED}Error cloning $repoUrl${NC}"
            fi
            break
            ;;
          2)
            # Pull the latest commit
            cd "$repoName"
            echo -e "${GREEN}Pulling the latest commit for $repoUrl${NC}"
            git pull
            if [ $? -eq 0 ]; then
              echo -e "${GREEN}Pulled the latest commit for $repoUrl successfully${NC}"
            else
              echo -e "${RED}Error pulling the latest commit for $repoUrl${NC}"
            fi
            break
            ;;
          *)
            echo -e "${RED}Please enter 1 or 2.${NC}"
            ;;
        esac
      done
    else
      # Clone the selected repository if it doesn't exist
      echo -e "${GREEN}Cloning $repoUrl${NC}"
      git clone "$repoUrl"
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}Cloned $repoUrl successfully${NC}"
      else
        echo -e "${RED}Error cloning $repoUrl${NC}"
      fi
    fi
  else
    echo -e "${RED}Invalid choice. Please enter a valid number or 'q' to quit.${NC}"
  fi
done