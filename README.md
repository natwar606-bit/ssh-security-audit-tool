# 🔐 SSH Security Audit Tool

A production-style Bash scripting project that performs an automated security audit of an SSH server on Linux systems. The tool validates SSH service status, SSH configuration, firewall settings, login activity, and generates a security audit summary with a security score and execution logs.

---

## ✨ Features

* ✅ Root Permission Validation
* ✅ Dependency Validation
* ✅ Basic Server Information
* ✅ SSH Service Audit
* ✅ SSH Configuration Audit
* ✅ Firewall Audit
* ✅ Login Audit
* ✅ Security Score Calculation
* ✅ Timestamp-based Audit Logging
* ✅ Modular Bash Script Design

---

## 🖥️ Platform

This project is designed for **Linux systems using systemd**.

Required components:

* OpenSSH Server (`sshd`)
* firewalld
* systemd

---

## 📂 Project Structure

```text
ssh-security-audit-tool/
├── logs/
│   └── ssh-security-audit.log
├── ssh-security-audit.sh
└── README.md
```

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/natwar606-bit/ssh-security-audit-tool.git
```

Move into the project directory:

```bash
cd ssh-security-audit-tool
```

Make the script executable:

```bash
chmod +x ssh-security-audit.sh
```

---

## ▶️ Usage

Run the script with root privileges:

```bash
sudo ./ssh-security-audit.sh
```

---

# 🔍 Audit Modules

## 1. Dependency Check

Verifies that all required commands are available before executing the audit.

---

## 2. Root Permission Check

Ensures the script is executed with root privileges.

---

## 3. Basic Server Information

Collects:

* Hostname
* Current User
* Date & Time
* Operating System
* Kernel Version

---

## 4. SSH Service Audit

Checks:

* SSH Service Status
* SSH Boot Status

---

## 5. SSH Configuration Audit

Audits:

* PermitRootLogin
* PasswordAuthentication

---

## 6. Firewall Audit

Checks:

* Firewalld Status
* Firewalld Boot Status
* Active Firewall Zone

---

## 7. Login Audit

Displays:

* Last Login
* Failed Login Count
* Last Boot Time

---

## 8. Security Audit Summary

Provides a concise security overview:

* SSH Service
* SSH Configuration
* Firewall
* Active Firewall Zone
* Overall Security Score

---

## 9. Audit Logging

Each execution is recorded with timestamps in:

```text
logs/ssh-security-audit.log
```

Example:

```text
[2026-07-30 19:03:34] Script Started
[2026-07-30 19:03:34] Dependency Check Completed
[2026-07-30 19:03:35] SSH Service Audit Completed
[2026-07-30 19:03:35] SSH Configuration Audit Completed
[2026-07-30 19:03:35] Firewall Audit Completed
[2026-07-30 19:03:35] Login Audit Completed
[2026-07-30 19:03:35] Security Audit Completed
[2026-07-30 19:03:35] Script Finished
```

---

## 📊 Sample Output

```text
=========================
Security Audit Summary
=========================

SSH Service          : PASS
SSH Configuration    : FAIL
Firewall             : PASS
Active Firewall Zone : PASS

Overall Security Score : 75/100
```

---

## 🛠️ Technologies Used

* Bash
* Linux
* Systemd
* OpenSSH
* Firewalld

---

## 📚 Commands Used

* systemctl
* sshd
* firewall-cmd
* last
* lastb
* who
* hostname
* uname
* grep
* awk
* date

---

## 💡 Future Improvements

* Export reports in JSON format
* HTML audit report generation
* Email notifications
* Colored terminal output
* Additional SSH security checks
* Support for more Linux distributions

---

## 👨‍💻 Author

**Natwar Kumar**

**GitHub:** https://github.com/natwar606-bit

**LinkedIn:** https://www.linkedin.com/in/natwarkumar7427

---

⭐ If you found this project useful, consider giving it a star on GitHub.

