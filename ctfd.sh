#! /bin/bash
echo"
# Copy over the CTFd repo, and then install the necessary dependencies.
Do this manually.

cd ~
git clone https://github.com/CTFd/CTFd.git
cd CTFd
chmod u+x prepare.sh
sed -i 's/python-pip/python3-pip/g' prepare.sh
./prepare.sh
"
