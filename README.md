
envoy-bootstrap
===============

A bootstrap for building envoy proxy server.


envoy
-----

[envoy](https://github.com/envoyproxy/envoy) is a front/service proxy written in C++, which supports HTTP/1.1, HTTP/2 and gRPC protocols etc.


Get Started
-----------

### Requirement ###

  * executable envoy

  * ansible


Build envoy
-----------

Recently, there are Pre-built binaries for docker users. However there is no any binary in different distributions.
For building envoy, following [bazel/README.md](https://github.com/envoyproxy/envoy/blob/master/bazel/README.md).

To get more building informations, go to [building](https://www.envoyproxy.io/docs/envoy/latest/install/building).

Run envoy
-----------

First, clone [envoy-bootstrap](https://github.com/justdoit0823/envoy-bootstrap) into your lcoal directory.

```bash
git clone https://github.com/justdoit0823/envoy-bootstrap

cd envoy-bootstrap
```

Then, copy the executable envoy into `envoy/bin` directory.

```bash
cp /path/envoy ./envoy/bin
```

(Optional)On some centos machines, you could copy `libstdc++.so.6` into the `envoy/lib64` directory rather than installing gcc-4.9 .


Next, define your envoy proxy server in ansible's iventory files `staging` and `production`.

```
[envoy-servers]

es-ec2-1
```

Now, you can deploy envoy to remote servers with ansible.

```bash
cd envoy/playbook

ansible-playbook -i staging -K envoy.yml -e user=envoy -e envoy_workspace=/home/envoy/workspace -e skip_libs=true
```

You can use variable `user` and `envoy_workspace` to define your server configuration.

**Define skip_libs variable will skip files under envoy/lib64 directory.**


The following is a output example,

```
master!envoy-bootstrap/playbook *> ansible-playbook -i staging -K envoy.yml -e user=root -e envoy_workspace=/root/envoy
SUDO password:

PLAY [envoy-servers] ***************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [notesus.info]

TASK [build envoy workspace] *******************************************************************************************************************************************************************************
ok: [notesus.info] => (item=/root/envoy)
ok: [notesus.info] => (item=/root/envoy/bin)
ok: [notesus.info] => (item=/root/envoy/conf)
ok: [notesus.info] => (item=/root/envoy/lib64)
ok: [notesus.info] => (item=/root/envoy/logs)
ok: [notesus.info] => (item=/root/envoy/pb)
ok: [notesus.info] => (item=/root/envoy/benchmark)

TASK [upload envoy files] **********************************************************************************************************************************************************************************
ok: [notesus.info] => (item={'src': '../envoy/bin/envoy', 'dst': '/root/envoy/bin/envoy'})
ok: [notesus.info] => (item={'src': '../envoy/bin/envoyd.sh', 'dst': '/root/envoy/bin/envoyd.sh'})
ok: [notesus.info] => (item={'src': '../envoy/bin/start_envoy.sh', 'dst': '/root/envoy/bin/start_envoy.sh'})
ok: [notesus.info] => (item={'src': '../envoy/bin/hot-restarter.py', 'dst': '/root/envoy/bin/hot-restarter.py'})
ok: [notesus.info] => (item={'src': '../envoy/conf/server.json', 'dst': '/root/envoy/conf/server.json'})
changed: [notesus.info] => (item={'src': '../benchmark/helloworld_pb2.py', 'dst': '/root/envoy/benchmark/helloworld_pb2.py'})
changed: [notesus.info] => (item={'src': '../benchmark/helloworld_pb2_grpc.py', 'dst': '/root/envoy/benchmark/helloworld_pb2_grpc.py'})
changed: [notesus.info] => (item={'src': '../benchmark/benchmark_grpc_server.sh', 'dst': '/root/envoy/benchmark/benchmark_grpc_server.sh'})
changed: [notesus.info] => (item={'src': '../benchmark/greeter_server.py', 'dst': '/root/envoy/benchmark/greeter_server.py'})
changed: [notesus.info] => (item={'src': '../benchmark/start_benchmark_server.sh', 'dst': '/root/envoy/benchmark/start_benchmark_server.sh'})

TASK [upload library] **************************************************************************************************************************************************************************************
ok: [notesus.info] => (item={'src': '../envoy/lib64/libstdc++.so.6', 'dst': '/root/envoy/lib64/libstdc++.so.6'})

TASK [install monit on centos] *****************************************************************************************************************************************************************************
skipping: [notesus.info]

TASK [install monit on debian] *****************************************************************************************************************************************************************************
ok: [notesus.info]

TASK [start monit service] *********************************************************************************************************************************************************************************
ok: [notesus.info]

TASK [compile envoy configuration] *************************************************************************************************************************************************************************
ok: [notesus.info]

PLAY RECAP *************************************************************************************************************************************************************************************************
notesus.info               : ok=7    changed=1    unreachable=0    failed=0
```

Benchmark
=========

For benchmark of gRPC server, I use the [h2load](https://nghttp2.org/documentation/h2load.1.html) tool which is included in `nghttp2`.
Before test, you should install `h2load` on your remote server.


Test gRPC server
----------------

Here I use the `Hello world` program in gRPC's python examples.

```bash
root@localhost:~/envoy/benchmark# cd benchmark
root@localhost:~/envoy/benchmark# ./start_benchmark_server.sh 127.0.0.1:50061
successfully create virtual environment.
Collecting grpcio==1.4.0
  Using cached grpcio-1.4.0-cp36-cp36m-manylinux1_x86_64.whl
Collecting protobuf>=3.3.0 (from grpcio==1.4.0)
  Using cached protobuf-3.5.0.post1-cp36-cp36m-manylinux1_x86_64.whl
Collecting six>=1.5.2 (from grpcio==1.4.0)
  Using cached six-1.11.0-py2.py3-none-any.whl
Requirement already satisfied: setuptools in ./venv3/lib/python3.6/site-packages (from protobuf>=3.3.0->grpcio==1.4.0)
Installing collected packages: six, protobuf, grpcio
Successfully installed grpcio-1.4.0 protobuf-3.5.0.post1 six-1.11.0
successfully install grpcio package.
runing gRPC server at 127.0.0.1:50061

```

Benchmark with `h2load`,

```bash
root@localhost:~/envoy/benchmark# export GRPC_ENDPOINT=127.0.0.1:50021
root@localhost:~/envoy/benchmark# ./benchmark_grpc_server.sh
Payload file has been generated.

======== start benchmark =======

starting benchmark...
spawning thread #0: 10 total client(s). 10000 total requests
Application protocol: h2c
progress: 10% done
progress: 20% done
progress: 30% done
progress: 40% done
progress: 50% done
progress: 60% done
progress: 70% done
progress: 80% done
progress: 90% done
progress: 100% done

finished in 5.55s, 1800.87 req/s, 28.77KB/s
requests: 10000 total, 10000 started, 10000 done, 10000 succeeded, 0 failed, 0 errored, 0 timeout
status codes: 10000 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 159.73KB (163568) total, 71.48KB (73198) headers (space savings 96.45%), 0B (0) data
                     min         max         mean         sd        +/- sd
time for request:     9.54ms     65.77ms     55.26ms      2.59ms    94.89%
time for connect:      173us      1.15ms       583us       296us    70.00%
time to 1st byte:     9.90ms     62.38ms     37.54ms     15.52ms    60.00%
req/s           :     180.10      181.51      180.81        0.45    60.00%

====Benchmark is finished.====
```


Why building this project
===========================

[envoy](https://github.com/envoyproxy/envoy) is a great modern proxy server, which has a lot of features. However the building process is painful for the beginners.
After trying more aspects, I decide to give a more simply process with [ansible](http://docs.ansible.com/).
[envoy-bootsrap](https://github.com/justdoit0823/envoy-bootstrap) is out-of-box, if you're interested, you should have a try.


License
=======

This repository is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0).
