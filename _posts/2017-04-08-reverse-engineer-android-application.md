---
layout: post
title:  "Reverse Engineer Android Applications"
date:   2017-04-08 21:19:54+0800
description: "An introduction guide to reverse engineer Android applications"
tags: android apk apktool reverse-engineer java
---

<div class="cap"></div>
As digital information becomes more valuable, companies are spending a lot of money to secure their data.
Protecting mobile applications becomes even more crucial since apps have been created to do almost every thing, from booking a cab to buying a house.
The goal of this article is to walk you through the very first step in the process of hacking a mobile application, understanding the internal structure of a mobile app by reverse engineering its `apk`.

<!--more-->[ ](#){: id="more"}

## Android application package
Before we can jump into reversing an `apk`, we should understand how an Android app is built and the anatomy of an Android app.
The process of generating an `apk` is pretty much straight forward, it can be sum up nicely in the following diagram:

<div class="row">
  <div class="col-xs-12 col-md-10 col-md-offset-1">
    <br/><img class="img-thumbnail img-responsive img-center" src="/assets/img/android-build-process.svg" style="max-width:90%"/><br/>
  </div>
</div>

Result of the above process is a zip file with `.apk` extension.
When you unzip it, you can find the following files and directories:

{% highlight shell %}
$ unzip some-app.apk -d some-dir/
$ ls -la some-dir/
    total 20880
    drwxr-xr-x  13 <username>  staff   442B Apr 25 01:57 ./
    drwxr-xr-x  48 <username>  staff   1.6K Apr 25 01:57 ../
    -rw-r--r--   1 <username>  staff    39K Jan  1  2009 AndroidManifest.xml
    drwxr-xr-x   6 <username>  staff   204B Apr 25 01:57 META-INF/
    -rw-r--r--   1 <username>  staff    53B Jan  1  2009 android-support-multidex.version.txt
    drwxr-xr-x   3 <username>  staff   102B Apr 25 01:57 assets/
    -rw-r--r--   1 <username>  staff   934B Jan  1  2009 build-data.properties
    -rw-r--r--   1 <username>  staff   6.0M Jan  1  2009 classes.dex
    drwxr-xr-x   3 <username>  staff   102B Apr 25 01:57 com/
    drwxr-xr-x   3 <username>  staff   102B Apr 25 01:57 lib/
    drwxr-xr-x   3 <username>  staff   102B Apr 25 01:57 org/
    drwxr-xr-x  51 <username>  staff   1.7K Apr 25 01:57 res/
    -rw-r--r--   1 <username>  staff   4.1M Jan  1  2009 resources.arsc
{% endhighlight %}

| Directory | Content & Description |
|:-----------|:-------------|
| `AndroidManifest.xml` | a binary file describing the name, version, access rights, referenced libraries... it can be converted into readable plaintext XML with tools such as [AXMLPrinter2][1], [apktool][2], or [androguard][3] |
| `META-INF` | contains the manifest file `MANIFEST.MF`, the certificate of the application `CERT.RSA`, the list of resources hash `CERT.SF` |
| `assets` | contains applications assets, which can be retrieved by [AssetManager](https://developer.android.com/reference/android/content/res/AssetManager.html) |
| `classes.dex` | compiled classes in the dex file format understandable by the `Dalvik VM` and `Android RT` |
| `lib` | contains compiled native shared library for different CPU architecture: `armeabi`, `armeabi-v7a`, `arm64-v8a`, `x86`, `x86_64`, `mips` |
| `res` | contains resources not compiled into `resources.arsc` |
| `resources.arsc` | contains precompiled resources, such as binary XML for layouts, styles... |
{: .table}

## Obtaining the target
There are a few ways to obtain the target application `apk`:

 * Using Android Debug Bridge (a.k.a `adb`):
{% highlight shell %}
$ adb shell pm list packages | grep "google"
$ adb pull /data/app/com.google.android.music-1/base.apk
{% endhighlight %}
 * Back up `apk` to MicroSD card using one of the following applications:
   * [ASTRO File Manager][4]
   * [File Explorer][5]
   * [ES File Manager][6]
   * etc...
 * Downloading from Google Play using a third party service:
   * [APK Downloader](https://apps.evozi.com/apk-downloader/)
   * [Google Play APK Downloader](http://apk-dl.com/)

## Application general information
We can easily obtain general information after having the APK by using a tool called `aapt` which is bundled inside Android SDK

{% highlight shell %}
$ <android-sdk-path>/build-tools/<version>/aapt dump badging <sample.apk>
{% endhighlight %}

Output will contain some helpful information like package name, version name, version code...

## Reversing the target

### Prerequisite

 * [apktool][2]
 * `dex2jar` can be downloaded from [here][7] or installed via [homebrew][8].

### Configuration & resource files

First, we will use [apktool][2] to de-obfuscate the `apk` to obtain readable `AndroidManifest.xml`, assets and resource XML files.
It will also produce a list of machine readble `smali` files, together with original application certificate and resources hash (kept in `original` directory).
If the target application makes use of shared native libraries, there will be a folder called `lib` containing all `*.so` artifacts for different CPU architecture.

{% highlight shell %}
$ apktool d some-app.apk -o </some/output/dir>
    I: Using Apktool 2.2.2 on some-app.apk
    I: Loading resource table...
    I: Decoding AndroidManifest.xml with resources...
    I: Loading resource table from file: /Users/<username>/Library/apktool/framework/1.apk
    I: Regular manifest package...
    I: Decoding file-resources...
    I: Decoding values */* XMLs...
    I: Baksmaling classes.dex...
    I: Copying assets and libs...
    I: Copying unknown files...
    I: Copying original files...
$ ls -la some-app
    drwxr-xr-x   10 <username>  staff   340B Apr 25 01:38 ./
    drwxr-xr-x   47 <username>  staff   1.6K Apr 25 01:38 ../
    -rw-r--r--    1 <username>  staff    25K Apr 25 01:38 AndroidManifest.xml
    -rw-r--r--    1 <username>  staff   739B Apr 25 01:38 apktool.yml
    drwxr-xr-x    3 <username>  staff   102B Apr 25 01:38 assets/
    drwxr-xr-x    3 <username>  staff   102B Apr 25 01:38 lib/
    drwxr-xr-x    4 <username>  staff   136B Apr 25 01:38 original/
    drwxr-xr-x  200 <username>  staff   6.6K Apr 25 01:38 res/
    drwxr-xr-x  818 <username>  staff    27K Apr 25 01:38 smali/
    drwxr-xr-x    6 <username>  staff   204B Apr 25 01:38 unknown/
{% endhighlight %}

From here, we can pretty much know about the application layout structure, configuration for receivers as well as content provider if there is any.

### Java source codes

To learn more about the application logic, we need to know the Java part of it. Hence, we use `dex2jar` to convert the previous obtained `classes.dex` file, which is in `Dalvik` bytecode format, to `Java` bytecode format.
If the application is a multidex application, we need to put together all `classes.dex` files for the decompiler in order to parse properly.

{% highlight shell %}
$ d2j-dex2jar -o some-app.jar classes.dex
    dex2jar classes.dex -> some-app.jar
$ ls -la
    -rw-------   1 <username>  staff   6.7M Apr 25 02:07 some-app.jar
{% endhighlight %}

Using `jd-gui` or any Java decompiler tools, you then can view the readable Java source files.

<div class="row">
  <div class="col-xs-12 col-md-10 col-md-offset-1">
    <br/><img class="img-thumbnail img-responsive img-center" src="/assets/img/jd-gui.png" style="max-width:90%"/><br/>
  </div>
</div>


:beer: Cheers :beer:

[1]: https://code.google.com/archive/p/android4me/downloads "AXMLPrinter2"
[2]: https://github.com/ibotpeaches/apktool "apktool"
[3]: https://github.com/androguard/androguard "androguard"
[4]: https://play.google.com/store/apps/details?id=com.metago.astro "ASTRO File Manager"
[5]: https://play.google.com/store/apps/details?id=nextapp.fx "File Explorer"
[6]: https://play.google.com/store/apps/details?id=com.estrongs.android.pop "ES File Manager"
[7]: https://github.com/pxb1988/dex2jar "dex2jar"
[8]: https://brew.sh/ "homebrew"
[9]: http://jd.benow.ca/ "jd-gui"