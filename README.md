
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
```

Then, copy the executable envoy into `envoy/bin` directory.

```bash
cp /path/envoy ./envoy-bootstrap/envoy/bin
```

(Optional)On some centos machines, you could copy `libstdc++.so.6` into the `envoy/lib64` directory rather than installing gcc-4.9 .


Next, define your envoy proxy server in ansible's iventory files `staging` and `production`.

```
[envoy-servers]

es-ec2-1
```

Now, you can deploy envoy to remote servers with ansible.

```bash
cd envoy-bootstrap/envoy

ansible-playbook -i staging -K envoy.yml -e user=envoy -e envoy_workspace=/home/envoy/workspace -e skip_libs=true
```

**Define skip_libs variable will skip files under envoy/lib64 directory.***


Why building this project
===========================

[envoy](https://github.com/envoyproxy/envoy) is a great modern proxy server, which has a lot of features. However the building process is painful for the beginners.
After trying more aspects, I decide to give a more simply process with [ansible](http://docs.ansible.com/).
[envoy-bootsrap](https://github.com/justdoit0823/envoy-bootstrap) is out-of-box, if you're interested, you should have a try.


License
=======

This repository is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0).
