# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "debian-acuris"
  config.vm.box = "finch/debian9.11-pl-50gb"
  config.vm.hostname = "debian-acuris"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 3306, host: 3308
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.name = "debian-acuris"
    v.memory = 2048
  end
  $rootscript = <<-SHELL
    apt-get -y upgrade
    apt-get -y install \
      atool \
      autossh \
      curl \
      default-mysql-client \
      firefox-esr-l10n-pl \
      git \
      gmrun \
      gnupg2 \
      htop \
      iceweasel \
      jq \
      lightdm \
      lxappearance \
      mc \
      meld \
      mousepad \
      ncdu \
      nitrogen \
      numix-gtk-theme \
      numix-icon-theme \
      obmenu \
      openbox \
      python3-pip \
      ranger \
      screen \
      terminator \
      thunar \
      tig \
      tint2 \
      tmux \
      vim \
      zsh ;
    curl -fsSL https://get.docker.com -o- | sh
    curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod 755 /usr/local/bin/docker-compose
    echo "127.0.0.1 dev-app.dev.parr-global.com dev-feed.dev.parr-global.com dev-admin.dev.parr-global.com" >> /etc/hosts

    echo "[SeatDefaults]" >>  /etc/lightdm/lightdm.conf
    echo "autologin-user=vagrant" >>  /etc/lightdm/lightdm.conf
    curl https://sdpdownloads.cyxtera.com/latest/ubuntu/AppGate-SDP-client.deb > /tmp/AppGate-SDP-client.deb
    apt install -y /tmp/AppGate-SDP-client.deb ; apt -y --fix-broken install
    if [[ -f "/opt/appgate/chrome-sandbox" ]]; then
      chmod 4755 /opt/appgate/chrome-sandbox
    fi
    apt-get -y install snapd
    snap install hello-world
    snap install --classic code
    snap install --classic slack
    snap install teams-for-linux
    snap install postman
    snap install chromium
  SHELL
  $userscript = <<-SHELL
    # NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install v12.14.0
    # openbox
    cp /vagrant/configs/tint2rc $HOME/.config/tint2/tint2rc
    cp /vagrant/configs/gtkrc-2.0 $HOME/.gtkrc-2.0
    mkdir -p $HOME/.config/openbox/
    cp /vagrant/configs/openbox/autostart $HOME/.config/openbox/
    cp /vagrant/configs/openbox/menu.xml $HOME/.config/openbox/
    cp /vagrant/configs/openbox/rc.xml $HOME/.config/openbox/
  SHELL
  config.vm.provision "shell", inline: $rootscript
  config.vm.provision "shell", inline: $userscript, privileged: false
end

