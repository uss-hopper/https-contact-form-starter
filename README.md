# ISSUING  SSL CERTS WITH DOCKER CERTBOT
## [original documentation](https://www.humankode.com/ssl/how-to-set-up-free-ssl-certificates-from-lets-encrypt-using-docker-and-nginx)
### Issuing the initial cert
1. add `/starter-code/starter-docker-compose.yml` to your project's `/docker-compose.yml`
2. add `/starter-code/nginx.conf` to `/nginx.conf`
3. run `sudo docker-compose up -d`
4. run the command below
```
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
```
* `-v /docker-volumes/pwp/etc/letsencrypt:/etc/letsencrypt \` 
	* Binds the `/etc/letsenscrypt` directory where the key is generated in the certbot container to the localhost's `docker-volumes/pwp/etc/letsencrypt`
* `-v /docker-volumes/pwp/etc/lib/letsencrypt:/var/lib/letsencrypt \`
	* binds `/var/lib/letsencrypt` in the certbot container to the localhost's `/docker-volumes/pwp/etc/lib/letsencrypt`
* `-v $(pwd)/public_html:/data/letsencrypt \`
 	* `$(pwd)` uses the current file location generated by pwd to run a command
 	*  binds `/data/letsencrypt` in the certbot container to the localhost's `/home/user/project/public_html` so that the ACME challenge can pass.
*  `-v "/docker-volumes/pwp/var/log/:/var/log/letsencrypt" \`
	* binds the `/var/log/letsencrypt" \` in the certbot container to the localhost's `/docker-volumes/pwp/var/log/` so that debugging logs from the certbot container can be preserved.
* `certbot/certbot`
	* is the container that is going to be used.
* `certonly --webroot \` sets the webroot to `/`
* `--register-unsafely-without-email --agree-tos \`
	* register unsafely for staging purposes and agree to the terms of service  
* `--webroot-path=/data/letsencrypt \`
	* sets the webroot-path to `/data/letsencrypt` inside of the certbot container
* `--staging \`
	* issues the ssl certificate for staging purposes
* `-d dont-blindly-copy-past.face-palm`
	* specifies the domain/domains to verify for the ssl certificate
5. If the command from step 3 is successful run `sudo rm -rf /docker-volumes/pwp`
6. run the same command from step 3 but this time without the staging flag and make sure add an email for reminders on when to reissue the certificate
```
sudo docker container run -it --rm \
-v /docker-volumes/pwp/etc/letsencrypt:/etc/letsencrypt \
-v /docker-volumes/pwp/etc/lib/letsencrypt:/var/lib/letsencrypt \
-v $(pwd)/public_html:/data/letsencrypt \
-v "/docker-volumes/pwp/var/log/:/var/log/letsencrypt" \
certbot/certbot \
certonly --webroot \
--webroot-path=/data/letsencrypt \
--agree-tos  --no-eff-email \
--email your@email.you \
-d dont-blindly-copy-past.face-palm -d www.dont-blindly-copy-past.face-palm
```
### Setting Up Production Containers for PWP
1. add `/starter-code/frontend.Dockerfile` to your project's `/public_html/Dockerfile`
2. add `/starter-code/php.Dockerfile` to your project's `/php/Dockerfile`


* __optional__: If you are not using HTTPS
	* add `/starter-code/default-docker-compose.yml` to your project's `/docker-compose.yml`
	* add `/starter-code/default.conf` to `/production.conf`
		* make sure to replace every instance of `dont-blindly-copy-past.face-palm` with your actual url
	* add `/starter-code/default-doceker-compose` to your projects
`/docker-compose.yml`
		* make sure to replace every instance of `dont-blindly-copy-past.face-palm` with your actual url
	* run `docker-compose up -d`
### Configuring Containers to Use HTTPS
1. add `/starter-code/production.conf` to your projects `/production.conf`  
	* make sure to replace every instance of `dont-blindly-copy-past.face-palm` with your actual url
2. replace `/starter-code/production-doceker-compose.yml` with your project's `/docker-compose.yml` \
	* make sure to replace every instance of `dont-blindly-copy-past.face-palm` with your actual url
3. run `mkdir dh-param` in your project on the host machine.
4. run `sudo openssl dhparam -out dh-param/dhparam-2048.pem 2048` in your project on the host machine.
5. run `docker-compose up -d`

### Configuring cron for automated reissuing of SSL certs.
**If you do not do this step, you will start getting errors about invalid certificates in 90 days.**

Instructions an be found at the [original link](https://www.humankode.com/ssl/how-to-set-up-free-ssl-certificates-from-lets-encrypt-using-docker-and-nginx).  Follow in the instructions in the sections "How to Renew Let's Encrypt SSL Certificates with Certbot and Docker" and "Set Up a Cron Job to Automatically Renew Let's Encrypt SSL/TLS Certificates."

If you wish, you can continue with the site-hardening steps after those sections, however they are not required for the bootcamp.
