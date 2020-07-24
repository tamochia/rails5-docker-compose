sample\_app-docker
=======================

"sample\_app-docker" is a template for Rails application(Rails 5 + MariaDB 10.3 + Puma + Nginx) with Docker.

* Ruby 2.6.5-slim
* Rails 5.2.4
* MariaDB 10.3
* Nginx 1.16.1

Requirement
=======================

* Docker Engine 18.06.0 or higher
* Docker Compose 1.25.4 or higher

Usage
=======================

First, specify the absolute path of the parent directory of this git project(directory) in `.env` file

* `.env`
``` bash
HOSTSRCPATH=c:/Users/foo/Workspace/devel
```

Change the following if you want to change the Rails project name (Application Directory name).

```bash
foo@localhost:sample_app-docker$ grep -R -e 'sample_app[^-]' *
docker-compose.yml:              target: /opt/sample_app/public
docker-compose.yml:              target: /opt/sample_app/tmp
docker-compose.yml:              target: /opt/sample_app/public
docker-compose.yml:              target: /opt/sample_app/tmp
nginx/Dockerfile:ADD nginx.conf /etc/nginx/conf.d/sample_app.conf
nginx/nginx.conf:    server unix:///opt/sample_app/tmp/sockets/puma.sock;
nginx/nginx.conf:    root /opt/sample_app/public;
```

Change the DB username(`dbmaster`) and root password.

* `mariadb/sql/00_init.sql`
``` bash
GRANT ALL PRIVILEGES ON *.* TO 'dbmaster'@'%';
```

* `docker-compose.yml`
``` yaml
:
       environment:
            MYSQL_ROOT_PASSWORD: PASSWORD
            MYSQL_USER: dbmaster
            MYSQL_PASSWORD: PASSWORD
            :
```

Run the following command for create a Rails project and update Gemfile and Gemfile.lock.

``` bash
$ docker-compose run --rm app rails new . --force --no-deps  --database=mysql --skip-coffee --skip-turbolinks --webpack
```
