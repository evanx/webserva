
wsinit() {
  if [ -z "${BASH-}" ]
  then
    >&2 echo 'Please use bash shell!'
    if [ $0 = 'bash' ]
    then
      return 3
    else
      exit 3
    fi
  fi
  [ -n "${TERM-}" ] && WS_WIDTH=`tput cols`
}

wsinit

wsnone() {
  return 0
}

wscomment() {
  if [ -t 1 ]
  then
    >&2 echo -e "\e[90m${*}\e[39m"
  else
    >&2 echo "DEBUG ${*}"
  fi
}

wsnote() {
  wscomment "$*"
}

wsdebug() {
  if [ "${WSLEVEL-}" = 'debug' ]
  then
    wscomment "$@"
  fi
}

wshead() {
  if [ -t 1 ]
  then
    >&2 echo -e "\n\e[1m\e[36m${*}\e[39m\e[0m"
  else
    >&2 echo "\n# ${*}"
  fi
}

wsinfo() {
  if [ -t 1 ]
  then
    >&2 echo -e "\e[1m\e[94m${*}\e[39m\e[0m"
  else
    >&2 echo "INFO ${*}"
  fi
}

wsprop() {
  if [ -t 1 ]
  then
    >&2 echo -e "\e[1m\e[36m${1}\e[0m \e[39m${2}\e[39m\e[0m"
  else
    >&2 echo "$1 $2"
  fi
}

wsalert() {
  if [ -t 1 ]
  then
    >&2 echo -e "\e[1m\e[33m${*}\e[39m\e[0m"
  else
    >&2 echo "WARNING ${*}"
  fi
}

wswarn() {
  wsalert "$*"
}

wserror() {
   if [ -t 1 ]
   then
     >&2 echo -e "\e[1m\e[91m${*}\e[39m\e[0m"
   else
     >&2 echo "ERROR ${*}"
   fi
}

wssection() {
  echo
  wswarn `printf '%200s\n' | cut -b1-${WS_WIDTH} | tr ' ' -`
  wswarn "$*"
}

wssub() {
  echo
  wsnote `printf '%200s\n' | cut -b1-${WS_WIDTH} | tr ' ' \.`
  wsinfo "$*"
}

declare -A ErrorCodes=(
  [GENERAL]=1 [ENV]=3 [PARAM]=4 [APP]=5
)

# command: wsabort $code $*
# example: wsabort 1 @$LINENO "error message" $some
# specify 1 (default) to limit 254.
# Ideally use 3..63 for custom codes
# We use 3 for ENV errors (a catchall for system/dep/env), 4 for subsequent APP errors
# returns nonzero code e.g. for scripts with set -e
wsabort() {
  local code=1
  if [ $# -gt 0 ]
  then
    if echo "$1" | grep -q '^[A-Z]\S*$'
    then
      local errorCode="${ErrorCodes[$1]}"
      wsdebug errorCode $1 $errorCode
      if [ "$errorCode" -gt 0 ]
      then
        code=$errorCode
        shift
      fi
    elif echo "$1" | grep -q '^[0-9][0-9]*$'
    then
      code=$1
      shift
    fi
  fi
  for key in "${!ErrorCodes[@]}"
  do
    local value=${ErrorCodes[$key]}
    if [ $value -eq $code ]
    then
      errorName="$key"
      break
    fi
  done
  if [ $# -gt 0 ]
  then
    if echo "$1" | grep -q 'Try: '
    then
      wsinfo 'Try: '
      wsinfo "`echo "$1" | cut -b6-199`"
      shift
    fi
  fi
  wserror "Aborting. Reason: ${*} (code $code $errorName)"
  if [ $code -le 0 ]
  then
    code=1
  elif [ $code -ge 255 ]
  then
    code=254
  fi
  return $code
}
