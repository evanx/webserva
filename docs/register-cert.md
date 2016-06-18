
### How to register a client cert 

```shell
curl -E ~/.webserva/privcert.pem https://secure.webserva.com/register-cert
```

#### Troubleshooting

```shell
openssl x509 -text -in ~/.webserva/live/privcert.pem | grep 'CN='
```
 
