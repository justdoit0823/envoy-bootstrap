#!/bin/bash

exec ./bin/envoy -c ./conf/server.json --restart-epoch $RESTART_EPOCH &>> ./logs/envoy.log
