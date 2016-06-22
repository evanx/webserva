
set -u -e

serviceLabel=${WSLABEL-WebServa}
domain=${WSCLI-cli.webserva.com}
cdn=${WSCLICDN-cli.webserva.com}

[ "$domain" != 'cli.webserva.com' ] && serviceLabel=$domain

shellName=$0
shellCommand1=${1-}
shellArgs="${*}"

if [ ! -x ~/webserva/bin/wslogging.sh ]
then
  >&2 echo "Missing: ~/webserva/bin/wslogging.sh. Try: git clone https://github.com/webserva/webserva.git"
  exit 3
fi

. ~/webserva/bin/wslogging.sh

tmp=~/.webserva/ttl/days/1
if [ ! -d $tmp ]
then
  wsalert "Creating tmp directory: mkdir -p $tmp"
  wsinfo "Press Ctrl-C to abort, or Enter to continue..."
  read _continue
  mkdir -p $tmp
else
  wsdebug tmp $tmp
fi

trap_error() {
  local code="${1}"
  local lineno="$2"
  if [ $code -lt 63 ]
  then
    wserror "line $lineno: error code $code"
    wsalert "Try using bash -x as follows:"
    wsinfo "bash -x ~/webserva/bin/wscurl $shellArgs"
  fi
}

trap_sigint() {
  find ~/.webserva/ttl/days/1 -type f -mtime +1 -delete
}

trap_sigterm() {
  find ~/.webserva/ttl/days/1 -type f -mtime +1 -delete
}

trap trap_sigint SIGINT
trap trap_sigterm SIGTERM
trap 'trap_error $? ${LINENO}' ERR

account=''

help_cert() {
  wshead 'Try curl the following script to create a client cert in ~/.webserva/live:'
  wsinfo "curl -s 'https://open.webserva.com/cert-script/$account?id=$USER&noarchive' | more"
  wshead 'Review the script and then pipe it to bash as follows:'
  wsinfo "curl -s 'https://open.webserva.com/cert-script/$account?id=$USER&noarchive' | bash"
  wsnote "Change '&noarchive' to '&archive' to force archiving of existing dir first."
}

if [ -r ~/.webserva/live/account ]
then
  account=`cat ~/.webserva/live/account`
  wsdebug "account=$account as per ~/.webserva/live/account"
else
  wserror 'Missing file: ~/.webserva/live/account'
  wsinfo 'This file must contain your WebServa account name, matching a Telegram.org username.'
  wswarn 'Try @WebServaBot /signup'
  if [ -t 1 ]
  then
    wsinfo 'Enter the authoratitive Telegram name for your WebServa account:'
    read account
    help_cert
  fi
  exit 3
fi


if [ ! -f ~/.webserva/live/privcert.pem ]
then
  wserror 'Missing file: ~/.webserva/live/privcert.pem'
  wserror 'This PEM file must contain your WebServa privkey and cert'
  wswarn 'Try @WebServaBot /signup'
  help_cert
  exit 3
fi

openssl x509 -text -in ~/.webserva/live/privcert.pem > $tmp.certInfo
CN=`cat "$tmp.certInfo" | grep 'CN=' | sed -n 's/.*CN=\(\S*\),.*/\1/p' | head -1`
OU=`cat "$tmp.certInfo" | grep 'OU=' | sed -n 's/.*OU=\(\S*\).*/\1/p' | head -1`
O=`cat "$tmp.certInfo" | grep 'O=' | sed -n 's/.*O=\(\S*\).*/\1/p' | head -1`
kshelp1() {
  local keyspace=$1
  wsinfo "ws $keyspace help # builtin help"
  wsinfo "ws $keyspace set mykey myvalue # set a key to value"
  wsinfo "ws $keyspace get mykey # get a key"
  wsinfo "ws $keyspace ttl mykey # show the key time to live"
  wsinfo "ws $keyspace lpush mylist myvalue # push to a list"
}

wshelp() {
  wshead "$serviceLabel $account "
  wsinfo 'Try:'
  if [ ! -f ~/.webserva/live/registered ]
  then
    wsinfo 'ws register-cert # register the cert in ~/.webserva/live'
  fi
  wsinfo 'ws create-ephemeral # create a new ephemeral keyspace'
  wsinfo 'ws tmp10days create-keyspace'
  wsinfo "ws keyspaces # list your account keyspaces"
  kshelp1 tmp10days
  wsinfo "ws routes # more online help"
}

kshelp() {
  local keyspace="$1"
  wshead "$serviceLabel $account $keyspace"
  wsinfo "Try the following commands:"
  wsinfo "ws keyspaces"
  wsinfo "ws $keyspace create-keyspace # if new"
  wsinfo "ws $keyspace \$command \$key ...params # e.g. set, get, sadd, smembers, hset, hgetall et al"
  wsinfo "ws $keyspace ttl \$key"
  wsinfo "ws routes # more online help"
  wsdebug "curl -s -E ~/.webserva/live/privcert.pem https://$domain/ak/$account/$keyspace"
  exit 253
}

curlpriv() {
  [ $# -eq 1 ]
  wsdebug "curl -s -E ~/.webserva/live/privcert.pem '$1'"
  curl -s -E ~/.webserva/live/privcert.pem "$1"
}

wscurl() {
  if ! echo $O | grep -q "^${account}$"
  then
    echo "ERROR O name '$O' does not match account '$account'"
    return 3
  fi
  local url=''
  if [ $# -eq 1 ]
  then
    if [ "$1" = 'help' ]
    then
      wshelp
      return 0
    elif echo "$1" | grep -q '^https'
    then
      url="$1"
    elif echo "$1" | grep -q '^[a-z].*\.com$'
    then
      url="https://$1"
    fi
    if [ -n "$url" ]
    then
      wsdebug "CN=$CN OU=$OU https://$domain/ak/$account/$keyspace/$cmd"
      curlpriv "https://$domain/ak/$account/$keyspace/$cmd"
      return $?
    fi
  fi
  wsdebug domain=$domain account=$account
  local uri=''
  if [ $# -eq 0 ]
  then
    wshelp
    return 253
  fi
  arg1="$1"
  if [ "${arg1:0:1}" = '/' ]
  then
    arg1="${arg1:1}"
  fi
  if [ "$arg1" = 'routes' ]
  then
    if [ -f $tmp/routes ]
    then
      wsdebug "cached file stat" $tmp/routes $[ `date +%s` - `stat -c %Z $tmp/routes` ]
    else
      if ! curl -s https://$cdn/routes > $tmp/routes
      then
        rm -f $tmp/routes
        wserror "https://$cdn/routes (code $?)"
        return 4
      fi
    fi
    (
      cat $tmp/routes | grep '^accountKeyspace:' -B99
      cat $tmp/routes | grep '^accountKeyspace:' -A99 |
        sed -n 's/^\/ak\/:account\/:keyspace\/\([a-z][-a-z]*\)$/\1/p' | tr '/' ' '
      cat $tmp/routes | grep '^accountKeyspace:' -A99 |
        sed -n 's/^\/ak\/:account\/:keyspace\/\([a-z][-a-z]*\)\/\(.*\)$/\1 \2/p' | tr '/' ' ' | sed 's/://g'
    ) | less
    return $?
  elif [ "$arg1" = 'keyspaces' ]
  then
    curlpriv https://$domain/keyspaces/$account
    return $?
  elif [ "$arg1" = 'create-ephemeral' ]
  then
    curlpriv https://$domain/create-ephemeral
    return $?
  elif [ "$arg1" = 'register-cert' ]
  then
    curlpriv https://$domain/register-cert
    return $?
  elif [ "$arg1" = 'create-account' -o "$arg1" = 'create-account-telegram' ]
  then
    curlpriv https://$domain/create-account-telegram/$account
    return $?
  elif [ $# -eq 1 ]
  then
    if echo "$1" | grep '^/\|^create$\|^create-keyspace\|^reg$\|^register$\|^register-keyspace$\|^help$' # TODO
    then
      wshelp
      return 253
    else
      kshelp $arg1
      return 63
    fi
  fi
  local keyspace="$1"
  shift
  if [ $# -eq 0 -o "${1-}" = 'help' ]
  then
    kshelp $keyspace
    return 253
  fi
  local cmd="$1"
  shift
  if echo "$cmd" | grep '^create$\|^create-keyspace\|^reg$\|^register$\|^register-keyspace$\|^help$' # TODO
  then
    cmd='create-keyspace'
  fi
  while [ $# -gt 0 ]
  do
    cmd="$cmd"'/'"$1"
    shift
  done
  if echo "$keyspace" | grep -q '^hub/'
  then
    curlpriv "https://$domain/ak/$keyspace/$cmd"
  else
    wsdebug "CN=$CN OU=$OU https://$domain/ak/$account/$keyspace/$cmd"
    curlpriv "https://$domain/ak/$account/$keyspace/$cmd"
  fi
}

wscurl "$@"
