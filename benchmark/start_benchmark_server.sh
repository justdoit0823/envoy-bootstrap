#!/bin/bash


function mk_env_workspace(){

    if [[ -r "venv3" ]]; then

	return

    fi

    python3 -m venv venv3

    echo "successfully create virtual environment."

}


function install_grpcio(){

    venv3/bin/pip install grpcio==1.4.0

    echo "successfully install grpcio package."

}


function main(){

    mk_env_workspace

    install_grpcio

    echo "runing gRPC server at $1"

    python greeter_server.py "$1"

}


main "$@"
