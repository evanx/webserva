
#### How to create a client cert

You can use our `bash` cert creation script using your account name, via https://telegram.me/WebServaBot

Our bot will propose a bash script rendered with your account name, as per your Telegram.org username.

```shell
curl -s https://open.webserva.com/cert-script/ACCOUNT
```
where `ACCOUNT` is a placeholder for your Telegram.org username.

Click on the link given by the bot with your Telegram.org name substituted already, to review the script, and copy its URL.

![Cert script review](https://evanx.github.io/images/rquery/ws040-cert-script-review.png)

We recommend reviewing any script first <b>before</b> executing it

As per the second line of the custom script, you can curl and pipe into bash to execute the script on your local machine, and so care must be taken.

The custom script will execute the following:
- create ~/.webserva/live 
- use `openssl` to create a private key, self-signed certificate, and P12 for your browser
- advise how to install the `wscurl` wrapper script

Optional query paramaters for `/cert-script` include:
- `archive` - archive `~/.webserva/live` to `~/webserva/archive/TIMESTAMP`
- `id` - the client cert id e.g. `admin`
- `role` - the client cert tole e.g. `admin`

### Scripts

The content of this script should be as follows when run with a placeholder `ACCOUNT` account name:
```shell
# Curl this script and pipe it into bash for execution, as per the following line:
# curl -s 'https://open.webserva.com/cert-script/ACCOUNT' | bash
# 
( # create subshell for local vars and to enable set -u -e
  set -u -e # error exit if any undeclared vars or unhandled errors
  account='ACCOUNT' # same as Telegram.org username
  role='admin' # role for the cert e.g. admin
  id='admin' # user/device id for the cert
  CN='ws:ACCOUNT:admin:admin' # unique cert name (certPrefix, account, role, id)
  OU='admin' # role for this cert
  O='ACCOUNT' # account name
  dir=~/.webserva/live # must not exist, or be archived
  # Note that the following files are created in this dir:
  # account privkey.pem cert.pem privcert.pem privcert.p12 x509.txt cert.extract.txt
  commandKey='cert-script'
  serviceUrl='https://secure.webserva.com' # for cert access control
  telegramBot='WebServaBot' # bot for granting cert access
  archive='~/.webserva/archive' # directory to archive existing live dir when ?archive
  certWebhook='https://secure.webserva.com/create-account-telegram/ACCOUNT'
  mkdir -p ~/.webserva # ensure default dir exists
  if [ -d ~/.webserva/live ] # directory already exists
  then # must be archived first
    echo "Directory ~/.webserva/live already exists. Try add '?archive' query to the URL."
  else # fetch, review and check SHA of static cert-script.sh for execution
    mkdir ~/.webserva/live && cd $_ # error exit if dir exists
    curl -s https://raw.githubusercontent.com/webserva/webserva/master/bin/cert-script.sh -O
    echo 'Please review and press Ctrl-C to abort within 8 seconds:'
    cat cert-script.sh # review the above fetched script, we intend to execute
    echo 'Double checking script integrity hashes:'
    sha1sum cert-script.sh # double check its SHA against another source below
    curl -s https://open.webserva.com/assets/cert-script.sh.sha1sum
    echo 'f6edc446466e228965e51bee120425b497605949' # hardcoded SHA of stable version
    echo 'Press Ctrl-C in the next 8 seconds to abort, and if any of the above hashes differ'
    sleep 8 # give time to abort if SHAs not consistent, or script review incomplete
    source <(cat cert-script.sh) # execute fetched script, hence the above review and SHA
  fi
)
```
where we fetch https://raw.githubusercontent.com/evanx/webserva/master/bin/cert-script.sh which should be:

```shell
  echo "${account}" > account
  if openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/CN=${CN}/OU=${OU}/O=${O}" \
    -keyout privkey.pem -out cert.pem
  then
    openssl x509 -text -in cert.pem > x509.txt
    grep 'CN=' x509.txt
    cat cert.pem | head -3 | tail -1 | tail -c-12 > cert.extract.pem
    cat privkey.pem cert.pem > privcert.pem
    openssl x509 -text -in privcert.pem | grep 'CN='
    curl -s -E privcert.pem "$certWebhook" ||
      echo "Registered account ${account} ERROR $?"
    if ! openssl pkcs12 -export -out privcert.p12 -inkey privkey.pem -in cert.pem
    then
      echo "ERROR $?: openssl pkcs12 ($PWD)"
      false # error code 1
    else
      echo "Exported $PWD/privcert.p12 OK"
      pwd; ls -l
      sleep 2
      curl -s https://open.webserva.com/cert-script-help/${account}
      curl -s https://raw.githubusercontent.com/webserva/webserva/master/docs/install.wscurl.txt
      certExtract=`cat cert.extract.pem`
      echo "Try https://telegram.me/WebServaBot '/grantcert $certExtract'"
    fi
  fi
```

Please review these scripts, and raise any issues with us.

Note that the customised script will show the fetched script's content, with comparative hashes that must match.
It then sleeps for 8 seconds to give you a chance to press Ctrl-C to abort.

### How to register a client cert

```shell
curl -E ~/.webserva/live/privcert.pem https://secure.webserva.com/register-cert
```

Actually, we recommend that you install `wscurl,` our `curl` wrapper script to use that `~/.webserva/live/privcert.pem` by default.
It also offers some builtin help with hints.

### How to CLI

Read the following instructions to install `wscurl,` our `curl` wrapper script to use your `privcert.pem` in `~/.webserva/live.`

https://raw.githubusercontent.com/webserva/webserva/master/docs/install.wscurl.txt

#### Troubleshooting

Check your cert details:
```shell
openssl x509 -text -in ~/.webserva/live/privcert.pem | grep 'CN='
```

To see the commands being executed including `openssl,` you can use `bash -x` as follows:
```shell
curl -s https://open.webserva.com/cert-script/ACCOUNT | bash -x
```

