---
layout: post
title: "Keep processes after terminate your ssh sessions"
date: 2017-07-08 03:40:15+0800
description: "A quick how-to to maintain app processes when you want to terminate your ssh sessions"
categories: technology
tags: software programming ssh http screen linux
---

<div class="cap"></div>
Wondering how to keep your `ssh` processes after you terminate a session?

<!--more-->[ ](#){:id="more"}

### Steps by steps guide

- `ssh` into your remote server, type `screen` then start any long running process you want.
  + For example, watching a directory for new files `watch -d ls -lAhFv <dir>`
- Press `Ctrl-A` (`^-A`) then `Ctrl-D` (`^-D`)
  + This will detach your screen session but leave your processes running. You can now log out of the remote server.
- When you want to resume your session, log on again and type `screen -r`
  + This will resume your `screen` session, and you can see the output of your long running process.

:balloon:
