#!/bin/bash

# Define report file
REPORT_FILE="/tmp/server_config_report.txt"

# Create or clear the report file
> "$REPORT_FILE"

echo "Server Configuration Report" >> "$REPORT_FILE"
echo "=========================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check for installed packages
echo "Installed Packages:" >> "$REPORT_FILE"
dpkg -l | grep -E 'nginx|curl|libcurl4-openssl-dev|libfreetype6|libjpeg62-turbo|libpng-dev|libjpeg-dev|libgbm1|ffmpeg|libfreetype6-dev|zip|libzip-dev|inkscape|libmagickwand-dev|ghostscript|jq|cron' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check PHP extensions
echo "PHP Extensions:" >> "$REPORT_FILE"
php -m >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check PHP-FPM configuration
echo "PHP-FPM Configuration:" >> "$REPORT_FILE"
PHP_FPM_CONF=$(php -i | grep 'Configuration File (php.ini) Path' | awk '{print $NF}' | sed 's|php.ini||')fpm/pool.d/www.conf
if [ -f "$PHP_FPM_CONF" ]; then
    grep -E 'pm.max_children|pm.start_servers|pm.min_spare_servers|pm.max_spare_servers' "$PHP_FPM_CONF" >> "$REPORT_FILE"
else
    echo "PHP-FPM configuration file not found at $PHP_FPM_CONF." >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Check PHP settings
echo "PHP Settings:" >> "$REPORT_FILE"
PHP_INI=$(php --ini | grep 'Loaded Configuration File' | awk '{print $4}')
if [ -f "$PHP_INI" ]; then
    grep -E 'upload_max_filesize|post_max_size' "$PHP_INI" >> "$REPORT_FILE"
else
    echo "PHP INI file not found at $PHP_INI." >> "$REPORT_FILE"
fi

MEMORY_LIMIT_CONF=$(dirname "$PHP_INI")/conf.d/docker-php-memlimit.ini
if [ -f "$MEMORY_LIMIT_CONF" ]; then
    grep 'memory_limit' "$MEMORY_LIMIT_CONF" >> "$REPORT_FILE"
else
    echo "PHP memory limit configuration file not found at $MEMORY_LIMIT_CONF." >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Check ImageMagick policy
echo "ImageMagick Policy:" >> "$REPORT_FILE"
IMAGEMAGICK_POLICY_FILE=$(find /etc -name 'policy.xml' 2>/dev/null)
if [ -f "$IMAGEMAGICK_POLICY_FILE" ]; then
    cat "$IMAGEMAGICK_POLICY_FILE" >> "$REPORT_FILE"
else
    echo "ImageMagick policy file not found." >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Check cron jobs
echo "Cron Jobs:" >> "$REPORT_FILE"
CRON_JOBS_FILES=$(find /etc/cron.d /etc/cron.* -type f 2>/dev/null)
if [ -n "$CRON_JOBS_FILES" ]; then
    for file in $CRON_JOBS_FILES; do
        echo "Cron jobs in $file:" >> "$REPORT_FILE"
        cat "$file" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    done
else
    echo "No cron jobs configuration files found." >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Check CloudWatch agent configuration
echo "CloudWatch Agent Configuration:" >> "$REPORT_FILE"
CLOUDWATCH_CONF="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
if [ -f "$CLOUDWATCH_CONF" ]; then
    cat "$CLOUDWATCH_CONF" >> "$REPORT_FILE"
else
    echo "CloudWatch agent configuration file not found." >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Check init script
echo "Init Script Permissions:" >> "$REPORT_FILE"
INIT_SCRIPT="/var/www/html/init.sh"
if [ -f "$INIT_SCRIPT" ]; then
    ls -l "$INIT_SCRIPT" >> "$REPORT_FILE"
else
    echo "Init script not found." >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Output report path
echo "Report generated at $REPORT_FILE"
