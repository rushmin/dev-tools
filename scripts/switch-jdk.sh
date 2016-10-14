cd /wso2dev/env/sdk/jdk
rm active_jdk
ln -s `find . -maxdepth 1 -type d -regex .*jdk1.$1.* ` active_jdk
