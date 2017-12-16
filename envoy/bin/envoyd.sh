#!/bin/bash


DEFAULT_PYTHON="python"


function get_master_pid(){

    python=$DEFAULT_PYTHON
    if [[ -n "$ENVOY_PYTHON" ]]; then

	python=$ENVOY_PYTHON

    fi

    master_process="$python `pwd`/bin/hot-restarter.py ./bin/start_envoy.sh"
    master_pid=$(ps aux|grep "$master_process"|grep -v grep|awk '{print $2}')

    echo $master_pid

}


function set_ld_path(){

    libpath=`pwd`"/lib64"
    export LD_LIBRARY_PATH=$libpath:$LD_LIBRARY_PATH

}


function start_envoy(){

    set_ld_path

    exec ./bin/hot-restarter.py ./bin/start_envoy.sh &

}


function stop_envoy(){

    master_pid=$(get_master_pid)

    if [[ -z $master_pid ]]; then

	echo "envoy is already stopped."
	return

    fi

    kill $master_pid
    echo "stop envoy."

}


function reload_envoy(){

    master_pid=$(get_master_pid)

    if [[ -z $master_pid ]]; then

	echo "envoy is already stopped."
	return

    fi

    set_ld_path

    ./bin/envoy --mode validate -c conf/server.json --base-id 24
    if [[ $? != 0 ]]; then

	echo "validate configuration failed."
	return

    fi

    kill -SIGHUP $master_pid
    echo "reload envoy."

}


function usage(){

    echo "usage: ./envoyd.sh {start|stop|reload}"

}


function open_workspace(){

    workspace=$(pwd)"/"$(dirname "$1")
    workspace=${workspace%.}
    workspace=${workspace%/}
    workspace=${workspace%bin}
    cd $workspace
    echo "open workspace $workspace"

}


function main(){

    open_workspace "$0"

    command="$1"

    case $command in

	"start")

	    start_envoy;;

	"stop")

	    stop_envoy;;

	"reload")

	    reload_envoy;;

	*)

	    usage;;

    esac

}

main "$@"
