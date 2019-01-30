running_agent_user=$(pgrep -u $USER ssh-agent | wc -l)
tmp_ssh_agent="/tmp/${USER}_ssh_agent"
# timeout in seconds, lifetime = 0 (not a good idea if you are using a server)
timeout_ssh_agent=10800

function start_ssh_agent() {
    echo "Starting ssh-agent"
    ssh-agent -t $timeout_ssh_agent > $tmp_ssh_agent
    chmod 600 $tmp_ssh_agent
    eval $(cat $tmp_ssh_agent)
}

if [ $running_agent_user == 1  ]
then
    echo "ssh-agent already running, setting up the environment variables"
    eval $(cat $tmp_ssh_agent)
elif [ $running_agent_user == 0 ]
then
    echo "ssh-agent is not running"
    start_ssh_agent
else
    echo "Multiple ssh-agent services are running, stopping all the agents"
    kill $(pgrep -u $USER ssh-agent)
    start_ssh_agent
fi
