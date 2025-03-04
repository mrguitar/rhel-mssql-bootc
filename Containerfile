FROM registry.redhat.io/rhel9/rhel-bootc

RUN <<EOF

#Minor adaptations from https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16&tabs=rhel9
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/9/mssql-server-2022.repo
curl https://packages.microsoft.com/config/rhel/9/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo

yum install -y firewalld tuned tuned-profiles-mssql mssql-server mssql-server-selinux
ACCEPT_EULA=Y yum install -y mssql-tools18 unixODBC-devel

#Will run post deployment
#/opt/mssql/bin/mssql-conf setup

#systemctl status mssql-server

#sudo firewall-cmd --zone=public --add-port=1433/tcp --permanent
#sudo firewall-cmd --reload
firewall-offline-cmd --zone=public --add-port=1433/tcp

#why is this still a thing?
mkdir /var/roothome
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile

#this is a recommended setting, but seems to break the example database restore script. Commenting it for now
#echo mssql - nofile 1048576 > /etc/security/limits.d/99-mssql-server.conf
echo mssql >> /etc/tuned/active_profile

#Enable FIPS
#echo 'kargs = ["fips=1"]' >> /usr/lib/bootc/kargs.d/fips.toml
#update-crypto-policies --no-reload --set FIPS

echo 'd /var/lib/selinux/targeted/active/modules/200/mssql 0700 - - -' > /etc/tmpfiles.d/mssql.conf

systemctl enable tuned
EOF

COPY usr usr
ADD --chown=mssql:mssql AdventureWorks2022.bak /opt
ADD --chown=mssql:mssql restore.sql /opt
ADD --chmod=755 --chown=mssql:mssql mssql_demo.sh /opt

RUN bootc container lint
