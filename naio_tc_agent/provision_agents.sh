#!/bin/bash

set -x
#./remove_agent.sh

for i in `seq 0 2` 
do
  docker run -d --privileged=true --restart=always --name=naio-tc-agent$i --link naio-tc-server:naio-tc-server -v /opt/buildagent/work$i:/opt/buildagent/work$i -v /var/run/docker.sock:/var/run/docker.sock -e SERVER_URL=http://naio-tc-server:8111 -e TEAMCITY_AGENT_NUMBER=$i naio_tc_agent:latest
done

