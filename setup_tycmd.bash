sudo mkdir -p -m0755 /etc/apt/keyrings

curl https://download.koromix.dev/debian/koromix-archive-keyring.gpg -o /etc/apt/keyrings/koromix-archive-keyring.gpg
sudo echo "deb [signed-by=/etc/apt/keyrings/koromix-archive-keyring.gpg] https://download.koromix.dev/debian stable main" > /etc/apt/sources.list.d/koromix.dev-stable.list

sudo apt update
sudo apt install tytools