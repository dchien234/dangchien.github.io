---
layout: post
title: "SSL/TLS certificate verification flow"
date: 2020-11-27 09:56:54+0800
description: "Issue when dealing with certificate verification in Cloudfront"
categories: technology
tags: software http ssl tls cloudfront
---

<div class="cap"></div>
Recently, I set up a simple RESTful APIs service. To enhance the speed of distribution and provide a better load balance for my micro-service, I put it behind Route53 and Cloudfront. But when I tested using PostMan, I was caught off-guard by a simple error.

<!--more-->[ ](#){:id="more"}

```
Error: Hostname/IP does not match certificate's altnames: Host: api.example.com. is not in the cert's altnames: DNS:cloudfront.net, DNS:*.cloudfront.net
```

<div class="row">
  <div class="col-xs-12 col-md-10 col-md-offset-1">
    <br/>
    <img class="img-thumbnail img-responsive img-center" src="/assets/img/2020-11-27-figure-01.png" style="max-width:90%"/>
    <br/>
  </div>
</div>
{:.content-center}
<p style="text-align: center; font-style: italic;">Simple & straightforward RESTful APIs service setup</p>

### Troubleshooting

Like every other debugging session, we start with the error message. It's very descriptive and helpful, mentioned `cert alternate names`. So how does SSL/TLS cert look like? and how does cert name verification work?

#### SSL/TLS certificate

HTTPS (via SSL/TLS) uses public key encryption to protect client's communication with servers (clients can be a web browser or API clients like PostMan). Clients prevent `Man-in-the-middle` attacks by authenticating HTTPS servers using `X.509 certificates`, which are digital documents that bind a public key to an individual subject/organization.

In this scenario, I put my app behind AWS infra and by using `Cloudfront` + `Certificate Manager`, so I have those certificates for free to protect my service and it will be issued by `Amazon Root Certificate 1`

<div class="row">
  <div class="col-xs-12 col-md-10 col-md-offset-1">
    <br/>
    <img class="img-thumbnail img-responsive img-center" src="/assets/img/2020-11-27-figure-02.png" style="max-width:90%"/>
    <br/>
  </div>
</div>
{:.content-center}
<p style="text-align: center; font-style: italic;">Basic SSL/TLS certification chain</p>

The `binding` is asserted by having a trusted Certification Authority (CA) installed on clients end (e.g. web browser Trusted Root Certification Authorities, Java trust stores for API clients...). And it's clients' responsibility to verify those server's `X.509 certificates`.

#### Certification Path Validation

Basically, clients will iterate through all certificates in the path starting with the trust anchor (i.e. the root certificate), validating each certificate’s basic information and critical extensions.

<div class="row">
  <div class="col-xs-12 col-md-10 col-md-offset-1">
    <br/>
    <img class="img-thumbnail img-responsive img-center" src="/assets/img/2020-11-27-figure-04.png" style="max-width:90%"/>
    <br/>
  </div>
</div>
{:.content-center}
<p style="text-align: center; font-style: italic;">SSL/TLS verification flow</p>

So the certificates are limited to a specific domain or domain tree (i.e. including sub-domains) for a company or an organization, like `example.com, www.example.com, etc`. Name constraints are often used for intermediate CA certificates purchased from a publicly trusted CA to prevent the intermediate CA from issuing perfectly valid certificates for third-party domains (e.g. othercompany.com).

### Solution

After examination, it failed step 5 where the existing `Alternate Domain Names (CNAMEs)` list in `Cloudfront` doesn't contain the intended API service sub-domain `api.example.com`. The solution is simple, just add this sub-domain to the existing list and the error is no longer there.

<div class="row">
  <div class="col-xs-12 col-md-10 col-md-offset-1">
    <br/>
    <img class="img-thumbnail img-responsive img-center" src="/assets/img/2020-11-27-figure-03.png" style="max-width:90%"/>
    <br/>
  </div>
</div>
{:.content-center}
<p style="text-align: center; font-style: italic;">Error no longer there</p>

:beer:
