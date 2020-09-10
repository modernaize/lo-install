# Request an Letsencrypt certificate

## Obtain a certificate

sudo ./getCertificate.sh \
--domains ts1.liveobjects.software \
--email info@liveobjects.online \
--data-path ./webserver/certbot \
--staging 1

##  Certificates

Your certificate and chain have been saved at:

```
   ./webserver/certbot/conf/live/ts1.liveobjects.software/fullchain.pem
```

Your key file has been saved at:
```
   ./webserver/certbot/conf/live/ts1.liveobjects.software/privkey.pem
```
