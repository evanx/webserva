### WebServa.com

The WebServa.com home page and `/about` are redirected to this page.

Try create a ephemeral Redis keyspace: https://webserva.com/create-ephemeral

![Landing screenshot](http://evanx.github.io/images/rquery/ws050-ephemeral.png)

#### News

29 October 2016: Migrated to Scaleway.com 8GB RAM server in Paris.

20 June 2016: WebServa.com rebranding complete, from RedisHub.com, commenced 11 June 2016.

#### Overview

WebServa is an experimental service with a subset of Redis commands for accessing virtual Redis servers.
See http://redis.io.
- Private access is via HTTPS using self-signed client certs e.g. generated with `openssl`
- Built-in Telegram.org bot for identity authentication and authorisation of account admins

Try the demo: https://webserva.com/create-ephemeral

This endpoint creates a new ephemeral keyspace with a TTL of 10 minutes, for demonstration purposes. This keyspace is assigned a randomized name, so that it is secret by default.

The goals of WebServa are:
- instant virtual Redis servers
- private, shared and public keyspaces
- access control to keyspaces and their keys
- web publication of data

#### Accounts

You can signup via our Telegram bot `@WebServaBot` via the command `/signup.` This will create an account as per your Telegram username.

The bot offers a command `/login` which will create a magic login session link to your account.

![Bot signup](http://evanx.github.io/images/rquery/ws051-bot-signup.png)
<hr>

### Certs

We provide a script you can curl into bash to create an admin cert rather easily:

- https://webserva.com/cert-script/ACCOUNT - customise with your account's Telegram.org username in place of `ACCOUNT`

Note that it will curl other scripts as follows:

- https://webserva.com/cert-script-help/ACCOUNT - some customised help
- https://raw.githubusercontent.com/evanx/webserva/master/bin/cert-script.sh - openssl cert generation
- https://raw.githubusercontent.com/evanx/webserva/master/docs/install.wscurl.txt - CLI installation instructions

Then you can install our CLI `wscurl` bash script. This is a wrapper of `curl` using your admin cert.

![Curl command line wrapper](http://evanx.github.io/images/rquery/ws050-wscurl-register.png)

![Bot signup](http://evanx.github.io/images/rquery/ws050-bot.png)
<hr>

Note that client certs are:
- self-signed e.g. created using `openssl` with your account name as the Organisation (O name)
- the Organisational Unit (OU name) is the role of the cert e.g. admin, submitter, device
- client certs are authorised by account admins via our Telegram.org bot
- Our bot will advise the URL of a custom bash script to create client certs using `openssl`

Documentation: https://github.com/evanx/rquery


#### Technical Notes

Technically speaking, WebServa is an Nginx deployment of our opensource Node webserver for Redis multi-tenancy and access control.

We use a Telegram.org bot for identity authentication and authorisation, e.g. granting cert access to your account keyspaces.

### Status

UNSTABLE, INCOMPLETE

### How usable?

It's MVP for small ephemeral keyspaces, where keys idle out after 10 days.

Archiving has not been implemented, and `PERSIST` is not available.
Hence we only support ephemeral keyspaces.

We have not implemented `SCAN` yet. `KEYS` must be used, and this returns all keys in the keyspace.
Hence we only support small keyspaces.

### FAQ

#### How do I navigate the site?

Click anywhere on the iconized header to go "back" a level e.g. to your keyspace home, `/routes` and finally here.

Otherwise links are shown in color.

For example, in the following screenshot, you would click anywhere on top row containing:
- the database icon
- the "hub" account name
- the ephemeral keyspace label

![Create ephemeral](http://evanx.github.io/images/rquery/ws040-ephemeral.png)

Incidently, "hub" is the specially named "open" account name, i.e. accessed without a cert.

#### How do I try Redis commands?

Try: https://webserva.com/create-ephemeral

This will create a new ephemeral keyspace for you. The keyspace home page lists some sample commands you can try. These links are rendered in color.

Incidently, this will create a ephemeral keyspace were TTLs are 10 minutes only, but this is fine for the playground.


#### Why use a Redis database rather than SQL?

Redis is a popular and awesome NoSQL database. It's in-memory and so really fast. It supports data structures which are well understood and pretty fundamental, e.g. sets, sorted sets, lists, hashes and geos.

Having said that, I love SQL too and may use PostgreSQL to drive `pg.webserva.com` e.g. where each command is saved in a PostgreSQL record like `{account, keyspace, key, command, params}` which can be replayed for point-in-time recovery.

#### Any query languages?

We are considering experimenting with GraphQL at some stage.

#### But isn't Redis just for caching?

Certainly Redis is the leading caching server. But actually Redis is an in-memory "data structure server." As such, it has many use cases, including fast shareable data storage, analytics, geo-spatial processing, synchronisation, queuing and messaging.


#### Who is WebServa?

I'm a Node/React web developer based in Oxfordshire.

Find me at https://twitter.com/@evanxsummers.


#### Why are you doing this?

WebServa is my pet R&D project, to build something cool with my favourite toys, and thereby explore security, devops, microservices, monitoring, logging, metrics and messaging.

WebServa is already "mission accomplished" in the sense that it can be used as a "playground" for Redis commands.


#### Why do my client certs have CN and OU names only?

Our scripts assist with generating WebServa client certs with DN defaults such that:
- CN - unique identity (user/device ID) granted access to the account
- OU - role for access by this cert
- O - WebServa account as per an individual or organisation
- Other location fields are optionally specified

Note that an authoritative Telegram.org account is linked to the WebServa account. Therefore an organisation, like an individual, should create its own Telegram.org account, e.g. using a prepaid SIM.


#### What about ACID?

Atomicity, consistency, isolation and durability guarantees are those offered by Redis. This is a trade-off sacrificing absolute durability in favour of performance, e.g. potentially loosing a second's worth of transactions in the rare event of a server crash, versus the heavy performance cost of a disk sync on every transaction.

In my experience, SQL does not enable fast websites, and most companies use a secondary Redis cache to mitigate this. An argument can be made that Redis be the primary data store for your site, and disk-based solutions are used for secondary persistence, e.g. for the "archival" of historical and transactional data, to ensure durability where this is specifically required.


#### What value length limits?

We currently only support `GET` where the maximum URL length is 2083 characters, most of which can be the value. So value strings are limited to around 2050 characters when URL encoded, which is quite limited for JSON documents.


#### How to create an account

Chat `/signup` to `@WebServaBot` on https://web.telegram.org. That will propose an `openssl` script for `bash.`

I haven't yet built a typical SaaS web site (yet) with signup, signin with Google, etc.

Currently, your Telegram username is used for your private WebServa account name.


#### Why Telegram.org?

I've always liked the sound of Telegram, e.g. their security and openness.
Also I have a Ubuntu phone, which has Telegram.
Last but not least, I want to enter the Bot competion and maybe get lucky and win one of those prizes.
"Then we'll be millionaires!" as Homer says ;)


#### What are "perspectives" of keyspaces?

A "perspective" is a specific transformation of a keyspace into a web view. Currently we support:
- HTML - browser admin console with hints etc
- JSON - the Redis result is sent as a JSON HTTP response (string, array or object)
- CLI script (curl wrapper)

The desired perspective is indicated by the domain e.g. `json.webserva.com` and other means e.g. query string:
- `?html` - default HTML view
- `?json` - reply with JSON
- `?plain` - return plain text for the `bash` CLI (default curl user agent)


#### How do I trust your server cert?

Our domains are secured via Let's Encrypt:
```shell
echo -n | openssl s_client \
  -connect cli.webserva.com:443 2>/dev/null | grep '^Cert' -A2
```
```shell
Certificate chain
 0 s:/CN=secure.webserva.com
   i:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
```

Some systems have an outdated "CA certs" file which does not include Let's Encrypt cert.

We can support only clients that trust Let's Encrypt, explicity if not by default:
```shell
$ curl --cacert ~/.cacerts/letsencrypt/isrgrootx1.pem.txt https://cli.webserva.com/time/seconds
1464377206
```

See: https://letsencrypt.org/2015/06/04/isrg-ca-certs.html


### Documentation

See: https://github.com/evanx/rquery
