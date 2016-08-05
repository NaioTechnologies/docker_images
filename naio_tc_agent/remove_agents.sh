#!/bin/bash

docker ps -a | grep naio_tc_agent | cut -f1 -d' ' | xargs docker rm -f

