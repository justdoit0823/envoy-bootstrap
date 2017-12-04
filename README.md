
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


Run envoy
-----------

First, copy the executable envoy into `envoy/bin` directory.

```bash
cp /path/envoy /your_repository/envoy/bin
```

(Optional)On some centos machines, you could copy `libstdc++.so.6` rather than installing gcc-4.9 .


Then, define your envoy proxy server in ansible's iventory files `staging` and `production`.

```
[envoy-servers]

es-ec2-1
```


Why I build this project
========================

[envoy](https://github.com/envoyproxy/envoy) is a great modern proxy server, which has a lot of features. However the building process is painful for the beginners.
After trying more aspects, I decide to give a more simply process with [ansible](http://docs.ansible.com/).
[envoy-bootsrap](https://github.com/justdoit0823/envoy-bootstrap) is out-of-box, if you're interested, you should have a try.


License
=======

I choose [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0).
