FROM composer:1.7 as vendor

COPY composer.json composer.json

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

# main build stage


FROM gkephart/alpine-php-apache

# copy vendor into the project from the prebuild stage
COPY --from=vendor /app/vendor/ /app/public/vendor

COPY . /app/public

EXPOSE 80
