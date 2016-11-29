#!/bin/bash

if [ -z "$TEAMCITY_AGENT_NUMBER" ]; then
    echo "TEAMCITY_AGENT_NUMBER variable not set; for instance for agent 0, launch with -e TEAMCITY_AGENT_NUMBER=0"
    exit 1
fi

echo "Starting buildagent..."

cp -r /opt/buildagent/conf_dist/* /data/teamcity_agent/conf
cp /data/teamcity_agent/conf/buildAgent.dist.properties /data/teamcity_agent/conf/buildAgent.properties
sed -i "s#^workDir=.*\$#workDir=../work${TEAMCITY_AGENT_NUMBER}#" /data/teamcity_agent/conf/buildAgent.properties
sed -i "s#^tempDir=.*\$#tempDir=../temp${TEAMCITY_AGENT_NUMBER}#" /data/teamcity_agent/conf/buildAgent.properties
sed -i "s#^name=.*\$#name=agent_${TEAMCITY_AGENT_NUMBER}#" /data/teamcity_agent/conf/buildAgent.properties
sed -i "s#^serverUrl=.*\$#serverUrl=${SERVER_URL}#" /data/teamcity_agent/conf/buildAgent.properties

sync
sleep 3

/run-agent.sh >& /var/log/run_agent.log


