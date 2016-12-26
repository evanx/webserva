  echo "${account}" > account
  if openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/CN=${CN}/OU=${OU}/O=${O}" \
    -keyout privkey.pem -out cert.pem
  then
    openssl x509 -text -in cert.pem > x509.txt
    grep 'CN=' x509.txt
    echo -n `cat cert.pem | tail -n+2 | sed '$ d'` | sed -e 's/\s//g' | shasum | cut -f1 -d' ' > cert.pem.shasum
    cat privkey.pem cert.pem > privcert.pem
    openssl x509 -text -in privcert.pem | grep 'CN='
    if ! openssl pkcs12 -export -nodes -out privcert.p12 -inkey privkey.pem -in cert.pem
    then
      echo "ERROR $?: openssl pkcs12 ($PWD)"
      false # error code 1
    else
      echo "Exported $PWD/privcert.p12 OK"
      if uname | grep Linux
      then
        echo "Trying: curl -E privcert.pem $certWebhook"
        curl -s -E privcert.pem "$certWebhook"
      else
        echo "Trying: curl -E privcert.p12 $certWebhook"
        curl -s -E privcert.p12 "$certWebhook"
      fi
      if [ $? -ne 0 ]
      then
        echo "ERROR $? curl $certWebhook"
      fi
      pwd; ls -l
      sleep 2
      curl -s https://webserva.com/cert-script-help/${account}
      curl -s https://raw.githubusercontent.com/evanx/webserva/master/docs/install.wscurl.txt
    fi
  fi
