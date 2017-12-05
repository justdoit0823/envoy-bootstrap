#!/bin/bash

DEFAULT_GRPC_ENDPOINT="localhost:50051"

# First generate a file filled with gRPC request payload
python -c "import helloworld_pb2; open('/tmp/test.grpc.payload', 'wb').write(helloworld_pb2.HelloRequest(name='Python').SerializeToString())"
echo -e "Payload file has been generated.\n"

if [[ -z $GRPC_ENDPOINT ]]; then

    GRPC_ENDPOINT=$DEFAULT_GRPC_ENDPOINT

fi

# start benchmark with h2load
echo -e "======== start benchmark =======\n"
h2load -n 10000 -c 10 -m 10 -d /tmp/test.grpc.payload -H 'te: trailers' -H 'content-type: application/grpc' "http://$GRPC_ENDPOINT/helloworld.Greeter/SayHello"
echo -e "\n====Benchmark is finished.====\n"
