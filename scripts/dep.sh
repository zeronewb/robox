#!/bin/bash
#
# Setup the the box. This runs as root

# Grab a snapshot of the development branch.
cat <<EOF >/home/vagrant/magma-build.sh

#!/bin/bash

# Grab the latest copy of the development branch.
# wget --quiet https://github.com/lavabit/magma/archive/develop.tar.gz
# tar xzvf develop.tar.gz

git clone https://github.com/lavabit/magma.git magma-develop

# Linkup the scripts and clean up the permissions.
magma-develop/dev/scripts/linkup.sh
chmod g=,o= magma-develop/sandbox/etc/localhost.localdomain.pem
chmod g=,o= magma-develop/sandbox/etc/dkim.localhost.localdomain.pem

# Compile the code.
build.lib all
build.magma
build.check

# Reset the sandbox database and storage files.
schema.reset

# Run the unit tests.
check.run

EOF

# Make the script executable.
chown vagrant:vagrant /home/vagrant/magma-build.sh
chmod +x /home/vagrant/magma-build.sh 
