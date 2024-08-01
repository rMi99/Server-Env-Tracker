# Docker Configuration Report Script

## Overview

This script generates a detailed configuration report for a Docker environment. It checks various system settings, installed packages, PHP configurations, and more. The report is saved to a file, which can be reviewed for troubleshooting or auditing purposes.

## Script Features

- **Installed Packages**: Lists key packages related to your environment.
- **PHP Extensions**: Lists all installed PHP extensions.
- **PHP-FPM Configuration**: Checks specific settings in the PHP-FPM configuration file.
- **PHP Settings**: Retrieves key PHP settings from the `php.ini` file.
- **ImageMagick Policy**: Includes the contents of the ImageMagick policy file if available.
- **Cron Jobs**: Lists all cron job configuration files and their contents.
- **CloudWatch Agent Configuration**: Shows the configuration of the CloudWatch agent if present.
- **Init Script**: Checks permissions and existence of an init script.

## Usage

1. **Save the Script**: Save the script to a file, e.g., `generate_report.sh`.

2. **Make the Script Executable**:
    ```bash
    chmod +x generate_report.sh
    ```

3. **Run the Script**:
    ```bash
    ./generate_report.sh
    ```

4. **View the Report**: After running the script, the report will be saved to `/tmp/docker_config_report.txt`. You can view it using:
    ```bash
    cat /tmp/docker_config_report.txt
    ```

## Prerequisites

- **Bash**: Ensure that your system has `bash` installed.
- **PHP**: The script requires PHP to be installed and accessible via the command line.
- **Permissions**: The script may need appropriate permissions to access certain files and directories.

## Notes

- The script looks for specific configuration files and directories. Ensure that paths and file locations match your environment.
- If certain files or configurations are not found, they will be noted in the report.

## Troubleshooting

- If the script fails to find certain files or directories, double-check the paths and ensure that the necessary services are installed and configured correctly.
- For any errors or issues, review the output in the report for specific details.

## License

This script is provided as-is. Use it at your own risk. There are no warranties or guarantees of any kind.


