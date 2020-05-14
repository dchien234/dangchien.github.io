---
layout: post
title:  "Makefile basic"
date:   2018-03-07 17:38:56+0800
description: "make - a handy automation tool"
tags: engineering unix programming tutorial
---

<div class="cap"></div>
Keep seeing `Makefile` in popular open source repositories and wondering what it is? Me too, after browsing the Internet and learn some basic stuff on `make` utility, I decide to take note here, in this blog. The `make` utility requires a file, `Makefile` , which defines a set of tasks to be executed. You can use `make` to compile source codes, produce a final executable binary, which can then be installed using `make install`.

<!--more-->[ ](#){:id="more"}

Let's start by printing the classic `Hello world...` on the terminal. Create a empty directory which containing a file `Makefile` with this content:

```bash
welcome:
    @echo "Hello world..."
```

Now run the file by typing `make`, the output will be:

```bash
$ make
echo "Hello world..."
Hello world...
```

In the example above:
- `welcome` behaves like a function name, as in any programming language. This is called the `target`.
- The `prerequisites` or dependencies follow the `target`. In the above example, we have not defined any `prerequisites` in this example.
- The command `echo "Hello world..."` is called the `recipe`. The `recipe` uses `prerequisites` to make a `target`.
- The `target`, `prerequisites`, and `recipes` together make a `rule`.

To summarize, below is the syntax of a typical `rule`:

```bash
target: [prerequisites]
<TAB> [recipes]
[targets]
```

Let's add a few more `targets`: `generate` and `clean` to the `Makefile`:

```bash
welcome:
    @echo "Hello world..."
generate:
    @echo "Creating empty text files..."
    touch file-{1..10}.txt
clean:
    @echo "Cleaning up..."
    rm *.txt
```

If we try to run `make` after the changes, only the target `welcome` will be executed. That's because only the first target in the `Makefile` is the default target. Often called the default goal, this is the reason you will see all as the first target in most projects. It is the responsibility of all to call other targets. We can override this behavior using a special phony target called `.DEFAULT_GOAL`.

Let's include that at the beginning of our `Makefile`:

```bash
.DEFAULT_GOAL := generate
```

This will run the target `generate` as the default:

```bash
$ make
Creating empty text files...
touch file-{1..10}.txt
```

As the name suggests, the phony target `.DEFAULT_GOAL` can run only one target at a time. This is why most `Makefile` include `all` as a target that can call as many targets as needed.

Let's include the phony target `all` and remove `.DEFAULT_GOAL`:

```bash
all: welcome generate

welcome:
    @echo "Hello world..."
generate:
    @echo "Creating empty text files..."
    touch file-{1..10}.txt
clean:
    @echo "Cleaning up..."
    rm *.txt
```

Before running `make`, let's include another special phony target, `.PHONY`, where we define all the targets that are not files. `make` will run its recipe regardless of whether a file with that name exists or what its last modification time is. Here is the complete `Makefile`:

```bash
.PHONY: all welcome generate clean

all: welcome generate

welcome:
    @echo "Hello world..."
generate:
    @echo "Creating empty text files..."
    touch file-{1..10}.txt
clean:
    @echo "Cleaning up..."
    rm *.txt
```

The `make` invocation should run `welcome` and `generate`:

```bash
$ make
Hello world...
Creating empty text files...
touch file-{1..10}.txt
```

It is a good practice not to call `clean` in `all` or put it as the first target (default target). `clean` should be called manually when cleaning is needed as a first argument to `make`:

```bash
$ make clean
Cleaning up...
rm *.txt
```

Now that you have an idea of how a basic `Makefile` works and how to write a simple `Makefile`.

:smile:
