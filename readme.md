# Repo Installer

This repository contains a script,  `installer.sh` , that automates the installation process for multiple repositories. It allows you to easily clone or update repositories listed in a JSON configuration file.

## Prerequisites

Before using this script, ensure that you have the following:

- [Git](https://git-scm.com/) installed on your system.
- A JSON configuration file ( `installer.config.json` ) that contains the repository URLs.

## Usage

To use the  `installer.sh`  script, follow these steps:

1. Clone this repository to your local machine.
2. Navigate to the repository's directory.
3. Open the  `installer.config.json`  file and add the repository URLs you want to install/update.
4. Open a terminal window and navigate to the repository's directory.
5. Run the following command:  `./installer.sh` 
6. Follow the prompts to select and install/update the desired repositories.

## Configuration

The  `installer.config.json`  file should be formatted as follows:
{
  "repos": [
    "https://github.com/username/repo1.git",
    "https://github.com/username/repo2.git",
    "https://github.com/username/repo3.git"
  ]
}
Ensure that each repository URL is listed as a separate item in the  `"repos"`  array.

## Troubleshooting

If you encounter any issues during the installation process, please refer to the [troubleshooting guide](troubleshooting.md).

## License

This repository is licensed under the [MIT License](LICENSE).

## Credits

This script was created by Ed Spurrier.