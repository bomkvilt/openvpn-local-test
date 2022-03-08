
USER=$(whoami)
cd $HOME

mkdir easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chown $USER ~/easy-rsa
chmod 700 ~/easy-rsa/*

