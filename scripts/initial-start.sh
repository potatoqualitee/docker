# load up environment variables
export $(xargs < /app/sapassword.env)

# set the configs
cp /app/mssql.conf /var/opt/mssql/mssql.conf 

# check for arm64 which does not support sqlcmd
arch=$(lscpu | awk '/Architecture:/{print $2}')

# startup, wait for it to finish starting
# then run the setup script

if [ "$arch" = "aarch64" ]; then
    /opt/mssql/bin/sqlservr & sleep 10 & /app/setup-arm.sh
 else
    /opt/mssql/bin/sqlservr & sleep 10 & /app/setup.sh
fi

# kill the sqlservr process so that it 
# can be started again infinitely by docker
pkill sqlservr