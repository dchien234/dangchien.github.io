---
layout: post
title: "RxJava vs Reactor"
date: 2020-03-08 16:56:00+0800
description: "A detailed comparison between RxJava and Reactor projects"
categories: technology
tags: software programming reactor rxjava
---

<div class="cap"></div>
It's important to define the technical ladder for employees, especially in an internet company. It will help unify the title of the position, clarify the corresponding relationship between job title and its responsibilities, adapt to the needs of the internationalization and the technical advancement of the whole company. This specification is specially formulated based on those requirements.

<!--more-->[ ](#){:id="more"}

{:.table}
| RxJava2 | Reactor | Description |
|:-----------|:-----------|:-------------|
| `io.reactivex.rxjava2:rxjava:2.y.z` | `io.projectreactor:reactor-core:3.y.z.RELEASE` | Package name |
| [Completable&lt;T&gt;](http://reactivex.io/RxJava/javadoc/io/reactivex/Completable.html) | `N/A` | Completes successfully or with failure, without emitting any value. Like [CompletableFuture&lt;Void&gt;](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html) |
| [Maybe&lt;T&gt;](http://reactivex.io/RxJava/javadoc/io/reactivex/Maybe.html) | [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html) | Completes successfully or with failure, may or may not emit a single value. Like an asynchronous [Optional&lt;T&gt;](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html) |
| [Single&lt;T&gt;](http://reactivex.io/RxJava/javadoc/io/reactivex/Single.html) | `N/A` | Either complete successfully emitting exactly one item or fails. |
| [Observable&lt;T&gt;](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html) | `N/A` | Emits an indefinite number of events (zero to infinite), optionally completes successfully or with failure. Does not support backpressure due to the nature of the source of events it represents. |
| [Flowable&lt;T&gt;](http://reactivex.io/RxJava/javadoc/io/reactivex/Flowable.html) | [Flux&lt;T&gt;](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) | Emits an indefinite number of events (zero to infinite), optionally completes successfully or with failure. Support backpressure (the source can be slowed down when the consumer cannot keep up). |

:balloon:
