echo "------------------------------------"
echo "Server Information"
echo "------------------------------------"

echo "Welcome to the server information script!"
echo "This script will provide you with some basic information about the server."

echo "Current user is $(whoami)"
echo " Hostname is $(hostname)"
echo "Current date is $(date)"
echo " Current working directory is $(pwd)"
echo "------------------------------------"

echo "Linux operating system information: "
cat /etc/os-release

echo "------------------------------------"
echo "System uptime: $(uptime)"

echo "------------------------------------"
echo "Disk usage information:"
df -h   
