# Ansible Nginx Playbook

This directory contains an Ansible playbook to install and configure Nginx on a local machine.

## Files Overview

### 1. **install-nginx.yaml**
The main Ansible playbook that automates Nginx setup.

**Tasks:**
- **Install nginx** - Installs the Nginx web server package using apt
- **Start nginx** - Starts the Nginx service and enables it to run on boot
- **Create index.html** - Creates a custom HTML file at `/var/www/html/index.html` with the following content:
  ```html
  <html>
  <body>
  <h1>Hello World</h1>
  </body>
  </html>
  ```
- **Open port 80 in UFW** - Opens port 80 (HTTP) in the Ubuntu firewall
- **Check nginx status** - Verifies that Nginx is running

*Note: The playbook runs with `become: yes` to elevate privileges (sudo)*

### 2. **inventory.ini**
The Ansible inventory file that defines which hosts to target.

**Content:**
- Defines the target host as `127.0.0.1` (localhost)
- The playbook uses `hosts: local` which refers to this inventory entry

## How to Run

### Prerequisites
- Ansible installed on your system
- Sudo access (required for Nginx installation and system configuration)

### Run the Playbook

```bash
cd /home/felix/projects/alu/me/learn-terraform-get-started-aws/ansible-practice
ansible-playbook -i inventory.ini install-nginx.yaml
```

## How to Verify

After running the playbook, verify the setup:

### 1. Check Nginx Status
```bash
sudo systemctl status nginx
```

### 2. Test the Web Server
```bash
curl http://localhost
```
or
```bash
curl http://127.0.0.1
```

You should see the HTML output:
```html
<html>
<body>
<h1>Hello World</h1>
</body>
</html>
```

### 3. Verify Index File
```bash
sudo cat /var/www/html/index.html
```

### 4. Check Firewall Status
```bash
sudo ufw status
```
Port 80 should show `ALLOW IN` rule.

## Modifying the Playbook

To customize the HTML content, edit the `install-nginx.yaml` file and change the `content:` section under the "Create index.html" task.

## Troubleshooting

If you encounter errors:
1. Ensure Ansible is installed: `ansible --version`
2. Check that the inventory file exists: `cat inventory.ini`
3. Verify sudo access: `sudo whoami`
4. For syntax errors in YAML, check indentation carefully

## Notes

- This playbook is idempotent (safe to run multiple times)
- Nginx will be configured to start automatically on system boot
- The HTML content is served on port 80 (standard HTTP port)
