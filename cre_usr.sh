!/bin/bash
echo -n “Enter new username:”
read name
getent passwd $name > /dev/null
if [ $? -eq 0 ]; then
echo “User exist.”
echo “Exiting… Please try again with new username.”
else
echo “Creating new user…”
sleep 1
sudo useradd -m $name
echo “Created user $name!”
fi
