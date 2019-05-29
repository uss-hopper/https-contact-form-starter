sudo docker container run -it --rm \
-v /docker-volumes/pwp/etc/letsencrypt:/etc/letsencrypt \
-v /docker-volumes/pwp/etc/lib/letsencrypt:/var/lib/letsencrypt \
-v $(pwd)/public_html:/data/letsencrypt \
-v "/docker-volumes/pwp/var/log/:/var/log/letsencrypt" \
certbot/certbot \
certonly --webroot \
--register-unsafely-without-email --agree-tos \
--webroot-path=/data/letsencrypt \
--staging \
-d dont-blindly-copy-past.face-palm -d www.dont-blindly-copy-past.face-palm