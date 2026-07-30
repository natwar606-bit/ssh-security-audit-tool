#!/usr/bin/bash

# System Information
DATE=""
CURRENT_USER=""
HOSTNAME=""
OS_NAME=""
KERNEL_VERSION=""

# SSH
SSH_STATUS=""
SSH_BOOT_STATUS=""
PERMIT_ROOT_LOGIN=""
PASSWORD_AUTHENTICATION=""

#Firewall
FIREWALL_STATUS=""
FIREWALL_BOOT=""
ACTIVE_ZONE=""

# Login Audit
LAST_LOGIN=""
FAILED_LOGIN_COUNT=""
LAST_BOOT=""

# Score
SECURITY_SCORE=0

# Summary Results
SSH_SERVICE_RESULT=""
SSH_CONFIGURATION_RESULT=""
FIREWALL_RESULT=""
ACTIVE_ZONE_RESULT=""

check_root(){
    if [[ $EUID -ne 0 ]]; then
        echo "Error: Please run this script as root."
        exit 1
    fi
}


check_dependencies() {

   REQUIRED_COMMANDS=(
        systemctl
        sshd
        firewall-cmd
        last
        lastb
    )

    echo "====================="
    echo "Dependency Check"
    echo "====================="
    echo

    for cmd in "${REQUIRED_COMMANDS[@]}"; do

        if command -v "$cmd" >/dev/null 2>&1; then
            echo "[PASS] $cmd"
        else
            echo "[FAIL] $cmd not found."
            echo "Please install the required package and try again."
            exit 1
         fi

    done
log_message "Dependency Check Completed"
 echo
          }

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/ssh-security-audit.log"

log_message() {

  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

get_system_info(){
DATE=$(date)
 CURRENT_USER=$(whoami)
  HOSTNAME=$(hostname)
   OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
    KERNEL_VERSION=$(uname -r)

echo "===================="
echo "Basic Server Information"
echo "====================="

echo "Hostname         : $HOSTNAME"
echo "Current User     : $CURRENT_USER"
echo "Date & Time      : $DATE"
echo "Operating System : $OS_NAME"
echo "Kernel Version   : $KERNEL_VERSION"

}
check_ssh_service(){

 SSH_STATUS=$(systemctl is-active sshd)
  SSH_BOOT_STATUS=$(systemctl is-enabled sshd)

  if [[ "$SSH_STATUS" == "active" && "$SSH_BOOT_STATUS" == "enabled" ]]; then
     SSH_SERVICE_RESULT="PASS"
     ((SECURITY_SCORE+=25))

  else
     SSH_SERVICE_RESULT="FAIL"
  fi

echo "=================="
echo "SSH Service Audit"
echo "=================="
echo
echo "SSH Status     : $SSH_STATUS"
echo "SSH Boot Status: $SSH_BOOT_STATUS"

log_message "SSH Service Audit Completed"
}


check_ssh_configuration(){
PERMIT_ROOT_LOGIN=$(sshd -T | awk '/^permitrootlogin/ {print $2}')
PASSWORD_AUTHENTICATION=$(sshd -T | awk '/^passwordauthentication/ {print $2}')


  if [[ "$PERMIT_ROOT_LOGIN" == "no" && "$PASSWORD_AUTHENTICATION" == "no" ]]; then
     SSH_CONFIGURATION_RESULT="PASS"
     ((SECURITY_SCORE+=25))

  else
     SSH_CONFIGURATION_RESULT="FAIL"
  fi

echo "========================="
echo "SSH Configuration Audit"
echo "========================="
echo 

echo "Permit Root Login       : $PERMIT_ROOT_LOGIN"
echo "Password Authentication : $PASSWORD_AUTHENTICATION"
echo

log_message "SSH Configuration Audit Completed"
}


check_firewall(){
 FIREWALL_STATUS=$(systemctl is-active firewalld)
  FIREWALL_BOOT=$(systemctl is-enabled firewalld)
    ACTIVE_ZONE=$(firewall-cmd --get-active-zones | awk 'NR==1 {print $1}')

                  # Firewall Service
  if [[ "$FIREWALL_STATUS" == "active" && "$FIREWALL_BOOT" == "enabled" ]]; then
     FIREWALL_RESULT="PASS"
     ((SECURITY_SCORE+=25))
  
  else
      FIREWALL_RESULT="FAIL"
  fi

                 # Active Zone
  if [[ -n "$ACTIVE_ZONE" ]]; then
      ACTIVE_ZONE_RESULT="PASS"
      ((SECURITY_SCORE+=25))
  else
      ACTIVE_ZONE_RESULT="FAIL"
  fi

echo "====================="
echo "Firewall Audit"
echo "====================="
echo

echo "Firewalld Status : $FIREWALL_STATUS"
echo "Firewalld Boot   : $FIREWALL_BOOT"
echo "Active Zone      : $ACTIVE_ZONE"
log_message "Firewall Audit Completed"
}

check_login_audit() {
 LAST_LOGIN=$(last -n 1 | head -n 1 | awk '{print $1, $2, $4, $5, $6, $7}')
  LAST_BOOT=$(who -b | awk '{print $3, $4}')
   FAILED_LOGIN_COUNT=$(lastb | grep -v "btmp begins" | wc -l)

echo "====================="
echo "Login Audit"
echo "====================="
echo

echo "Last Login         : $LAST_LOGIN"
echo "Failed Login Count : $FAILED_LOGIN_COUNT"
echo "Last Boot          : $LAST_BOOT"

log_message "Login Audit Completed"
}


show_summary(){

echo
echo "========================="
echo "Security Audit Summary"
echo "========================="
echo

echo "SSH Service          : $SSH_SERVICE_RESULT"
echo "SSH Configuration    : $SSH_CONFIGURATION_RESULT"
echo "Firewall             : $FIREWALL_RESULT"
echo "Active Firewall Zone : $ACTIVE_ZONE_RESULT"

echo
echo "Overall Security Score : $SECURITY_SCORE/100"

log_message "Security Audit Completed"
}

main(){
   mkdir -p "$LOG_DIR"
   log_message "Script Started"
check_root
 check_dependencies()
  get_system_info
   check_ssh_service
    check_ssh_configuration
      check_firewall
       check_login_audit
         show_summary
  log_message "Script Finished"
}
main
