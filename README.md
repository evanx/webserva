### WebServa.com

The RedisHub.com and WebServa.com home page and `/about` are redirected to this page.

Try our demo, creating a ephemeral Redis keyspace: https://demo.webserva.com/create-ephemeral

![Landing screenshot](http://evanx.github.io/images/rquery/ws040-ephemeral.png)

#### News

29 October 2016: Preparing our first 32GB server.

20 June 2016: Rebranding complete.

11 June 2016: Rebranding from RedisHub.com to WebServa.com.

#### Overview

WebServa is a provider of serverless "keyspaces," hyped as "web databases." It is cloud resource intended for web apps, mobile and IoT devices.
Technically speaking, it offers a client-authenticated HTTPS API with a subset of Redis commands for accessing virtual Redis servers.
See http://redis.io. It is essentially an deployment of Nginx and Redis integrated via our Node server for multi-tenancy and access control:
- Private access is via HTTPS using self-signed client certs e.g. generated with `openssl`
- Built-in Telegram.org bot for two-factor identity authentication of account admins
- Use the bot to control access to your keyspaces e.g. generate/grant/revoke certs
- CDN courtesy of awesome CloudFlare.com for optionally publishing keyspaces for mass consumption

You store data by key in a "keyspace," and can use lists, sets and sorted sets to keep track of things. There is more to come e.g. geographical data courtesy of Redis 3.2.

Try our demo: https://demo.webserva.com/create-ephemeral

This endpoint creates a new ephemeral keyspace with a TTL of 10 minutes, for demonstration purposes. This keyspace is assigned a randomized name, so that it is secret by default.

The goals of WebServa are:
- instant virtual Redis servers
- private, shared and public keyspaces
- access control to keyspaces and their keys
- web publication of data and views

WebServa is a fast web database of structured textual data and JSON, not media and web asset artifacts. For example, your videos and images might be hosted on YouTube.com and Cloudinary.com. Their URIs might be stored in WebServa for the purpose of rendering HTML views that reference such assets via URL.

#### Accounts

You can signup via our Telegram bot `@WebServaBot` via the command `/signup.` This will create an account as per your Telegram username. It will advise how to create an a client cert for https://secure.webserva.com/routes, and how to install our CLI `wscurl` bash script. This is a wrapper of `curl` using your cert.

![Bot signup](http://evanx.github.io/images/rquery/ws040-webservabot.png)
<hr>

Our "50MB" service is free. This service bundle is limited to 50MB peak RAM and 20GB monthly transfer.
So for example, you can store 1 million records averaging 50 characters each, on us.
Your account can be topped up via virtual currency where "50MB" bundles are priced at roughly 50c USD per month.
This is determined from Digital Ocean infrastructure costs, as a market indicator.

So sign up and imagine some cool use cases for storing data in memory in the cloud, publishable in volume via CDN, or kept private:
- ephemeral keyspaces have a randomly-generated name to be secret by default, but sharable
- keyspaces you create on account are private by default
- private access is via client certs you have authorised via @WebServaBot, our "Gateway bot"
- you can publish specific keyspaces for read-only web access via CDN

We provide a script you can curl into bash to create a client cert easily:

- https://open.webserva.com/cert-script/ME - customise with your Telegram.org username in place of "ME"

Note that it will curl other scripts as follows:

- https://open.webserva.com/cert-script-help/ME - some customised help
- https://raw.githubusercontent.com/webserva/webserva/master/bin/cert-script.sh - openssl cert generation
- https://raw.githubusercontent.com/webserva/webserva/master/docs/install.wscurl.txt - CLI installation instructions

Incidently, we will introduce a standard keyspace role `submitter` which can append to a list, set a new field,
and perform some other aggregating commands.
However it cannot access data created by other submitters.
This is potentially useful for registries, message hubs and metrics aggregators.

![Curl command line wrapper](http://evanx.github.io/images/rquery/ws040-wscurl.png)

Note that client certs are:
- self-signed e.g. created using `openssl` with your account name as the Organisation (O name)
- the Organisational Unit (OU name) is the role of the cert e.g. admin, submitter, device
- client certs are authorised by account admins via our Telegram.org bot
- Our bot will advise the URL of a custom bash script to create client certs using `openssl`

Incidently, we will introduce a mechanism for auto-enrolling client certs, e.g. for IoT devices, as follows. You populate a designated keyspace with enrollment tokens matching device roles and client IDs. A device could then enroll using the secret token matching its cert i.e. your account (O name), device/role (OU) and device/client ID (CN).

Documentation: https://github.com/evanx/rquery

#### Technical Notes

Technically speaking, WebServa is an Nginx deployment of our opensource Node webserver for Redis multi-tenancy and access control.

We use a Telegram.org bot for identity authentication and authorisation, e.g. granting cert access to your account keyspaces.

It is intended to be highly-available for reads via CDN, and also for writes, via Redis Cluster.

A client accessing a keyspace might be:
- our `curl` bash CLI wrapper script
- the WebServa.com web console
- a client-side web app fetching content and messages
- mobile app e.g. updating the state of a multi-player game
- internet-connected device e.g. submitting metrics, error and status reports
- microservice discovering its configuration
- server-side script to push operational status updates into a central hub
- server-side script to record security events offsite into an append-only keyspace
- server-side app communicating with with external partners via shared keyspaces

### Status

UNSTABLE, INCOMPLETE

### How usable?

It's MVP for small ephemeral keyspaces, where keys idle out after 10 days. We are preparing for a MVP soft launch via Twitter announcement, once the rebranding migration is complete.

Archiving has not been implemented, and `PERSIST` is not available.
Hence we only support ephemeral keyspaces.

We have not implemented `SCAN` yet. `KEYS` must be used, and this returns all keys in the keyspace.
Hence we only support small keyspaces.


### Immiment API additions

For shorter URLs, we intend the support the following endpoints by the end of June:

- `webserva.com/:account/:keyspace` - openly published keyspaces
- `secure.webserva.com/:account/:keyspace` - strictly privately secured keyspaces

### FAQ

#### What is WebServa?

It is envisaged as online hub of Redis keyspaces accessed via HTTPS. These can be private, public or shared. We support various Redis commands for lists, sets etc, although not all (yet).

WebServa is intended as a serverless database, cache and messaging hub, accessed via HTTPS.

Currently, ephemeral keyspaces are created with a randomly generated name, which you can keep secret, or share.

Private keyspaces can be created. They are secured using self-signed client certificates e.g. generated using `openssl.`

#### How do I navigate the site?

Click anywhere on the iconized header to go "back" a level e.g. to your keyspace home, `/routes` and finally here.

Otherwise links are shown in color.

For example, in the following screenshot, you would click anywhere on top row containing:
- the database icon
- the "hub" account name
- the ephemeral keyspace label

![Create ephemeral](http://evanx.github.io/images/rquery/ws040-ephemeral.png)

Incidently, "hub" is the specially named "open" account name, i.e. accessed without a cert. It is available for limited writes at this time, at least while not victim to DoS or some sudden overload.

#### How do I try Redis commands?

Try: https://demo.webserva.com/create-ephemeral

This will create a new ephemeral keyspace for you. The keyspace home page lists some sample commands you can try. These links are rendered in color.

Incidently, this will create a ephemeral keyspace on the "demo" database. TTLs are 10 minutes only, but this is fine for the playground.

Note that currently we don't have a command completion tool, but you can edit the URL itself in the browser location bar. Also try to change the domain to `replica.webserva.com` to check the replication.

#### Why use a Redis database rather than SQL?

Redis is a popular and awesome NoSQL database. It's in-memory and so really fast. It supports data structures which are well understood and pretty fundamental, e.g. sets, sorted sets, lists, hashes and geos.

Having said that, I love SQL too and may use PostgreSQL to drive `pg.webserva.com` e.g. where each command is saved in a PostgreSQL record like `{account, keyspace, key, command, params}` which can be replayed for point-in-time recovery.

#### Any query languages?

We are considering experimenting with GraphQL as soon as time permits.

#### But isn't Redis just for caching?

Certainly Redis is the leading caching server. But actually Redis is an in-memory "data structure server." As such, it has many use cases, including fast shareable data storage, analytics, geo-spatial processing, synchronisation, queuing and messaging.

#### How do I generate an WebServa admin cert?

You can use `@WebServaBot /signup` which will propose a bash script to generate a `privcert.pem` (e.g. for curl CLI) and `privcert.p12` to import into your browser.

#### How do I force my browser to send my cert

Open a new incognito window, or restart your browser. This is required if you pressed Cancel in Chrome when prompted to select the cert. The browser remembers that for the current session, and so will not ask again.

The "secure" site allows sessions without a cert e.g. for "open" routes, but performs access control for account/keyspace access.

#### What upcoming features?

- setting keys and values via HTTPS POST (pipes)
- multiple commands transactions via HTTPS POST
- sequentially tagged requests to handle retries e.g. so `lpush` commands are safe to retry if response not received
- role-based keyspace access control - admins can control which certs can access their private keyspaces, and if read-only or add-only
- export and import to JSON: Entire keyspaces can be exported as a JSON file, or imported or created from such

#### Why do keys expire after 10 minutes?

Ephemeral (unauthenticated) keyspaces expire in 10 minutes.

Authenticated accounts have a longer default expiry, currently 10 days.

The short-term plan is to enable the following features:
- account admins can modify the default TTL of account keyspaces
- authenticated clients can persist keys

Initially, we will provide a disk-based archive limited to:
- string value of keys

Later we will support archiving hashes, lists, sets, zsets and geos.

Ideally the archive should be seamless, although read-only requests might be HTTP redirected to:
- `cdn.webserva.com` for warm data not recently modified, that has been granted "open" access
- `replica.webserva.com` for reading hot data with a client certs i.e. private access

#### Who is WebServa?

I'm a web developer based in Cape Town, working on content sites for a news publisher, using Nginx, Node, React and Redis. In my spare time, I work on my Github projects. Previously, I've been a Java enterprise developer, PostgreSQL DBA and Linux engineer.

Find me at https://twitter.com/@evanxsummers.


#### Why are you doing this?

WebServa is my pet R&D project, to build something cool with my favourite toys, and thereby explore security, devops, microservices, monitoring, logging, metrics and messaging.

WebServa is already "mission accomplished" in the sense that it can be used as a "playground" for Redis commands, whilst also providing authenticated access to secure keyspaces for some professional use cases I have in mind. However I'm inspired to take it further.


#### Why does the site redirect to this Github page?

Currently all HTTP requests are redirected, and also some HTTPS ones, namely the home page and `/about.`

I wished to focus on client cert auth first, so no webpage for login/signup yet.

Having said that, you can:
- signup via Telegram.org chat to `@WebServaBot`
- login your web browser using your self-signed client cert

#### Why do my client certs have CN and OU names only?

Our scripts assist with generating WebServa client certs with DN defaults such that:
- CN - unique identity (user/device ID) granted access to the account
- OU - role for access by this cert
- O - WebServa account as per an individual or organisation
- Other location fields are optionally specified

Note that an authoritative Telegram.org account is linked to the WebServa account. Therefore an organisation, like an individual, should create its own Telegram.org account, e.g. using a prepaid SIM.

#### What are WebServa lambdas?

These are envisaged as Redis-based lambdas that can be composed into microservices and apps.
I'm choosing to misdefine "lambdas" as server-side components which access one or more keyspaces.
They must be stateless to enable auto-scaling, but can store private and shared state in Redis of course. They must be written using a specific ES2016 framework, to simplify orchestration and management, e.g. configuration, keyspace access, logging and metrics.

#### What about ACID?

Atomicity, consistency, isolation and durability guarantees are those offered by Redis. This is a trade-off sacrificing absolute durability in favour of performance, e.g. potentially loosing a second's worth of transactions in the rare event of a server crash, versus the heavy performance cost of a disk sync on every transaction.

We wish to support maximally durable transactions since this is an important use case e.g. to record financial transactions using PostgreSQL. However, I wish firstly to address web content, messaging and analytics use cases, optionally trading off performance for database size using ssdb.io, or performance for durability using PostgreSQL.

Incidently, as an former PostgreSQL DBA for a financial SaaS application, I'm not convinced that absolute durability is as important as performance.
Often application load necessitates tweaking RAID settings to boost performance at the cost of durability.
One is always vulnerable to minor "disasters," the most common of which are application and configuration errors, rather than server crashes.
Recovery procedures are always necessary, not least to handle network errors.

In my experience, SQL does not enable fast websites, and most companies use a secondary Redis cache to mitigate this.
An argument can be made that Redis be the primary data store for your site, and disk-based solutions are used for secondary persistence, e.g. for the "archival" of historical and transactional data, to ensure durability where this is specifically required.

WebServa intends to build a simple and fast web database via HTTPS, where the durability status of your transaction can be confirmed via URL query:
- for each transaction we increment a transaction ID, and we record recent transactions individually
- a query to `replica.webserva.com` can confirm that it has been replicated to another machine
- a query to `archive.webserva.com` can confirm that it has been permanently archived to disk

This mechanism provides a durability guarantee.
Importantly, it also provides a mechanism for retries, i.e. when a database update times out on the client side.
If the server did receive the request, but the reply was not received by the client, then clearly it should avoid executing the update again.
This is especially true if the command pushes to value a list, that should not be duplicated.

Typically a client app might reverse a transaction when not confirmed. For example, consider a shopping cart app.
A waiting customer orders a product through an ecommerce app or point-of-sale terminal.
However network errors at the time cause the transaction sent to WebServa to time out, and the retry also times out.
Since the app cannot confirm that the transaction is recorded, it chooses to cancel transaction and advises the customer to try the purchase again later.

The app should record unconfirmed cancellations in local storage and retry those indefinitely. When the network is restored, the app confirms that each cancelled transaction was never received by the server. If it was received and committed by the server, then the app reverses the transaction, to reflect what actually happened on the client side during the network outtage, i.e. the order was cancelled. We will provide an example implementation of this use-case, i.e. a shopping cart app.

#### Why use a hosted Redis service rather than one's own?

Actually WebServa doesn't offer hosted Redis instances (yet).
It addresses some use cases where an online serverless storage/messaging service is convenient.

#### Will you ever offer a hosted Redis service?

There are other PaaS vendors that offer hosted Redis at scale, e.g. AWS ElastiCache, RedisLabs, OpenRedis and RedisGreen.

I wish to experiment with orchestrating Redis instances, clusters and replicas, to automate WebServa itself. However I'm more interested in other things e.g. auto-archival and serverless lamdbas, than Redis hosting per se.

#### How will WebServa support its lambdas?

The platform should handle identity, auth, configuration, deployment, logging, messaging, monitoring and scaling. A notable simplication is that Redis will be used across the board for all these concerns.

#### What is free?

I want to offer a free public utility in perpetuity to support most low-volume use cases, e.g. peak database size of 50MB RAM with a 20Gb transfer limit per month.

#### Why is the service so inexpensive compared to other vendors?

We use Digital Ocean infrastructure costs as a market indicator, and price our service accordingly, e.g. $5 or 512MB, which is 50c for 50MB.
This reflects our strategic vision to build a public utility, using our cost-free resources, namely myself.

#### Why would a developer use an indie service which might become abandonware?

That is a very good question. I guess it would have to be compelling for a specific niche, e.g. Telegram bots.

Incidently, as it happens we intend to build a basic bot platform on WebServa in the coming months, i.e. a bot to deploy serverless bots which use WebServa keyspaces for config, state, monitoring, storage, etc.

We guarantee that you will be able do data dumps, activate HTTP redirects etc, to facilitate data migration at any time to yourselves or other providers. WebServa aims to align with the canonical API for a large set of Redis commands. We clearly indicate some custom commands, which you should avoid if possible.

We also guarantee is that WebServa only requires opensource software,
including our Node server that anyone can run themselves.
Our server is essentially just an HTTP interface to Redis, with access control and accounting functions for multi-tenancy.
We will provide a dedicated-account profile for the app soon e.g. where unnecessary accounting functions are disabled.

Then the same WebServa `npm` installation that you might run for offline development,
you can deploy for production on your own infrastructure.
All that changes on the client side is that the domain must be changed e.g. from `WebServa.com` to your domain. In the meantime, we'll HTTP redirect client requests for you.


#### What about higher volume usage?

Users who wish to exceed the above-mentioned free limits, should become a "funder" contributing the equivalent of 50c per month to our Bitcoin wallet. Funders' limits are 50MB RAM (Redis) storage. You can multiply as needed and contribute accordingly, e.g. $5 for 500MB.


#### What value length limits?

We currently only support `GET` where the maximum URL length is 2083 characters, most of which can be the value. So value strings are limited to around 2050 characters when URL encoded, which is quite limited for JSON documents.

Later we will support `POST` for `set, hset` et al, and thereby enable larger document limits.

#### How to create an account

Chat `/signup` to `@WebServaBot` on https://web.telegram.org. That will propose an `openssl` script for `bash.`

I haven't yet built a typical SaaS web site (yet) with signup, signin with Google, etc.

Currently, your Telegram username is used for your private WebServa account name.

#### Why Telegram.org?

I've always liked the sound of Telegram, e.g. their security and openness.
Also I have a Ubuntu phone, which has Telegram.
Last but not least, I want to enter the Bot competion and maybe get lucky and win one of those prizes.
"Then we'll be millionaires!" as Homer says ;)

#### What technology is behind a WebServa keyspace?

It is a deployment of my Node project: https://github.com/evanx/rquery, using Nginx and Redis 2.8.

We serve data globally via CDN on `cdn.webserva.com.`
This is for URL-secured data e.g. that you specifically publish from account keyspaces.
It will be cached for some minutes, and so is "warm" data, i.e. regularly updated.

Incidently, we classify `replica.webserva.com` as "hot" data, since it is updated continually via database replication,
and not cached.

There are multiple production configurations deployed via Nginx:
- demo.webserva.com - playground with short TTLs and no client auth
- secure.webserva.com - client SSL auth, account admin, longer TTLs
- open.webserva.com - no client SSL auth e.g. used for enrollment and public/secret keyspaces
- replica.webserva.com - replica and hot standby

See: https://github.com/evanx/rquery/tree/master/config

For convenience other domains are provided for the "secure" server:
- cli.webserva.com - for command-line access, so responses are `text/plain` by default
- json.webserva.com - response content always `application/javascript`

Short-term deployment plans:
- 32GB Redis Cluster
- `cdn.webserva.com` for read-only queries to open warm data via CDN
- `archive.webserva.com` for read-only authenticated access to warm data

Note that clients should follow HTTP redirects to the above domains when reading data.

As soon as warranted, we look forward to deploying Redis Clusters on multiple 32GB dedicated machines in multiple regions.

Incidently, early adopters who pay for more resources e.g. 50c per 50MB RAM, will become co-owners of WebServa via a sharepool. The shareholding of the pool will be computed by an algorithm.

#### What financial technology is planned?

For a given point in time e.g. a specific month end, the resource algo will reduce multiple time series, including the virtual currency transfers (credits) to a WebServa wallet, reconciled with the actual resource costs (debits) of the account associated with the sender's virtual currency address. It thereby generates an account statement.

Similarly, the shareholding algo will determine the virtual shareholding of each account.

The shareholding algo must reward early adopters, since they are naturally critical to success.

Clearly it must also reward pre-payment, since our financial surplus provides financial security to operations, and can be used for development and dividend payouts.

The dividend algo might also be a mechanism for share transfers, whereby account holders provide buy/sell orders for price/volume. If their buy volume is zero, then they are paid the dividend in full. Otherwise their buy/sell orders are settled, and their dividend recalculated.

I'm still working out the details, but the reality is that customers are "funders." The plan is that funders collectively own 49% of WebServa. I own 51%, make executive decisions and provide regular reports to shareholders i.e. a newsletter to customers :) Watch out for announcements via https://twitter.com/@evanxsummers.

#### What are the domains demo, open, secure et al?

The `demo` domain has its own database, but otherwise all subdomains access the same master database:
 - `open` - without client cert authentication
 - `secure` - with client cert authentication for account endpoints
 - `replica` - read-only replica (hot data) with optional client authentication
 - `cdn` - read-only cached replica (warm data)
 - `archive` - read-only disk-based archive to recover cold data

#### What are "perspectives" of keyspaces?

A "perspective" is a specific transformation of a keyspace into a web view. Currently we support:
- HTML - browser admin console with hints etc
- JSON - the Redis result is sent as a JSON HTTP response (string, array or object)
- CLI script (curl wrapper)

The desired perspective is indicated by the domain e.g. `json.webserva.com` and other means e.g. query string:
- `?html` - default HTML view
- `?json` - reply with JSON
- `?plain` - return plain text for the `bash` CLI (default curl user agent)

In the longer term, we wish to support specific "perspectives" on keyspaces:
- schema - specifies required data elements for a class of keyspaces
- HTML forms - edit and validate hash fields according to a specified schema
- Tabular data - e.g. for rendering consumption reports and account statements
- charts - for rendering dashboards of pre-defined metrics
- Schema.org content - for rendering blog articles according to a specified template

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

### Why is this page so wordy?

I use it to express and refine my ideas and plans :)

### Goals

Build a site "webserva.com" with a foundational HTTP service for accessing and mutating keys in a hosted Redis "keyspace."

A keyspace is an online database accessible via Redis-style commands, and can be Redis i.e. in-memory, or disk-based e.g. via ssdb.io.

User stories:
- Use a free hosted Redis "keyspace" for low-volume ephemeral purposes
- Deploy your own private "webserva" instance using the `rquery` opensource implementation, as used by WebServa

Potential uses of keyspaces:
- serverless backend database
- storing encrypted data
- public/shared/private online message hub
- centralised logging, monitoring and alerting
- aggregated analytics

Future user stories:
- Manage the account admins and users
- Manage access to keyspaces
- Group/classify keyspaces for access control purposes
- Web admin console to inspect and manage keys
- Use disk-based keyspaces for archival
- Manage auto-archival of keys
- Enable a durable transaction log facility with playback for recovery
- Deploy WebServa "lambdas" to `lambdas.webserva.com` to build Redis-driven serverless backends
- Page lambdas generate web pages from React templates, populated with data from WebServa

WebServa lambdas are special ES2016 scripts that use keyspaces for:
- pulling their configuration
- pushing logging messages e.g. info and errors
- pushing metrics e.g. for response time histograms, user geo distribution, et al
- messaging via Redis lists e.g. for microservice app architecture
- storing application state e.g. to support stateless microservices for auto-scaling
- persistent data storage via Redis keys e.g. values, lists, sets, sorted sets, hashes, geo et al

Related specification: https://github.com/evanx/component-validator


### Related

See: https://github.com/evanx/rquery

Notable features (June 2016):
- Create adhoc ephemeral keyspaces
- Identity verification via Telegram.org chat bot `@WebServaBot`
- Access secured via client-authenticated SSL (secure.webserva.com)
- Generate tokens for Google Authenticator
- Encrypt keys using client cert

### Documentation

See: https://github.com/evanx/rquery
