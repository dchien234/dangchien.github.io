---
layout: post
title:  "Generating a new GPG key"
date:   2018-03-12 10:15:46+0800
description: "Generating a new GPG key and use it with GitHub"
tags: software development tutorial gnu gpg
---

<div class="cap"></div>
If you don't have an existing GPG key, you can generate a new GPG key to use for signing commits and tags when using Git. GitHub supports several GPG key algorithms. If you try to add a key generated with an unsupported algorithm, you may encounter an error.

<!--more-->[ ](#){:id="more"}

### Supported GPG key algorithms

- RSA
- ElGamal
- DSA
- ECDH
- ECDSA
- EdDSA

### Generating a GPG key

```bash
# Install GNU gpg on Mac OSX
$ brew install gpg
# or
$ brew cask install gpg-suite

# Generate a GPG key pair using this and follow instructions.
$ gpg --full-generate-key

# To list GPG keys for which you have both a public and private key.
# A private key is required for signing commits or tags.
$ gpg --list-secret-keys --keyid-format LONG

/Users/<userid>/.gnupg/pubring.gpg
----------------------------------
sec   rsa4096/DBA9BB8104AB0A1E 2015-11-17 [SC] [expires: 2020-11-15]
      AD5EB395BFC02BF4CC37C13ADBA9BB8104AB0A1E
uid                 [ultimate] Username (userid) <email@address.com>
ssb   rsa4096/BB2CE832C7BEC311 2015-11-17 [E] [expires: 2020-11-15]

# To export GPG key in ASCII format, substituting in the GPG key ID below.
# A common format is ASCII-armored format which exports to Base-64.
$ gpg --armor --export <key ID>

-----BEGIN PGP PUBLIC KEY BLOCK-----

<ASCII armored PGP Public Key Block (exported to a *.asc file)>
-----END PGP PUBLIC KEY BLOCK-----
```

### Revoking a GPG key

```bash
# In case that secret key has been compromised or you lose the access to secret key.
# You should generate a revocation certificate and publish it.
# This default location contains all revocation certificates associated with GPG keys that have been created before.
$ ls /Users/<userid>/.gnupg/openpgp-revocs.d/
.
..
AD5EB395BFC02BF4CC37C13ADBA9BB8104AB0A1E.rev

# Otherwise, you can generate revocation certificate using this
$ gpg --output /Users/<userid>/.gnupg/openpgp-revocs.d/<keyId>.asc --gen-revoke <keyId>
```

:balloon::balloon::balloon::balloon: