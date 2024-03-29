#!/bin/bash

# Update system packages
sudo apt update
sudo apt install -y gnupg2 wget vim

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import PostgreSQL signing key
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

# Update package lists
sudo apt update

# Install PostgreSQL and contrib package
sudo apt install -y postgresql-16 postgresql-contrib-16

# Start and enable PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Modify PostgreSQL configuration to listen on all addresses
# NOTE: This step opens the file in nano. You need to manually change listen_addresses to '*' and save the file.
# sudo nano /etc/postgresql/16/main/postgresql.conf

# Automatically update listen_addresses without using nano
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/16/main/postgresql.conf

# Modify pg_hba.conf for appropriate authentication methods
sudo sed -i '/^host/s/ident/md5/' /etc/postgresql/16/main/pg_hba.conf
sudo sed -i '/^local/s/peer/trust/' /etc/postgresql/16/main/pg_hba.conf

# Allow remote connections
echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf

# Restart PostgreSQL to apply changes
sudo systemctl restart postgresql

# Allow PostgreSQL port in the firewall
sudo ufw allow 5432/tcp

# NOTE: The next line changes the password for the 'postgres' user. You must manually execute this command.
# sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'newpassword';"

# Add a reminder for manual steps
echo "Remember to manually set the PostgreSQL user password using: sudo -u postgres psql -c \"ALTER USER postgres PASSWORD 'newpassword';\""
