---
layout: post
title: "PIP: Install from private PyPi repository"
date: 2021-07-13 23:28:13+0800
description: "A detailed comparison between RxJava and Reactor projects"
categories: technology
tags: software programming python pip
---

<div class="cap"></div>
When working in the corporate context, most of the time application packages / libraries will be hosted in a private repository that is managed by Nexus or other artifact management platforms. This short article will show you how to configure `pip` to install packages from private repositories **(with authentication)**.

<!--more-->[ ](#){:id="more"}

Install a package from the private PyPi repository:

```shell
$ pip install -i https://<repository-url> <package>
- or -
$ pip install -i https://<repository-url> -r requirements.txt
```

In case of the:

    SSLError “SSL: CERTIFICATE_VERIFY_FAILED”
    – or –
    WARNING “The repository located at <repository-domain> is not a trusted or secure host and is being ignored.”

You can define a path to the CA bundle and install a package from the private PyPi repository as follows:

```shell
$ pip install --cert <path> \
              -i https://<repository-url> <package>
-or-
$ pip install --trusted-host <repository-domain> \
              -i https://<repository-url> <package>
-or-
$ pip install --trusted-host <repository-domain> \
              -i https://<user>:<pass>@<repository> <package>
```

The private PyPi repository settings can also be defined in `/etc/pip.conf`, for example:

```shell
[global]
index-url = https://username:passw0rd@pypi.python.org/simple
trusted-host = pypi.python.org
#cert = /etc/pki/ca-trust/source/ca-bundle.crt
```


:100:
