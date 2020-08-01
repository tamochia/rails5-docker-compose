Dockerize a Rails5 Application
=======================

This repository gives you a Rails application (Rails 5 + MariaDB 10.3 + Puma + Nginx) development environment in Docker.

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

#### 1. First, specify the absolute path of the parent directory of this git project (directory) in `.env` file

* `.env`
``` console
HOSTSRCPATH=c:/Users/foo/devel
```
In the above example, the PATH in Docker Desktop for Windows.

#### 2. Change the following if you want to change the Rails project name (Application Directory name).

```shell-session
[foo@localhost:rails5-docker-compose]$ grep -R -e 'sample_app[^-]' *
docker-compose.yml:              target: /opt/sample_app/public
docker-compose.yml:              target: /opt/sample_app/tmp
docker-compose.yml:              target: /opt/sample_app/public
docker-compose.yml:              target: /opt/sample_app/tmp
nginx/Dockerfile:ADD nginx.conf /etc/nginx/conf.d/sample_app.conf
nginx/nginx.conf:    server unix:///opt/sample_app/tmp/sockets/puma.sock;
nginx/nginx.conf:    root /opt/sample_app/public;
```

#### 3. Change the DB username(`dbmaster`) and root password.

* `mariadb/sql/00_init.sql`
```console
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

#### 4. Run the following command for create a Rails project and update Gemfile and Gemfile.lock.

```shell-session
$ docker-compose run --rm app rails new . --force --no-deps  --database=mysql --skip-coffee --skip-turbolinks --skip-sprockets --webpack
```

Asset Pipline (Sporokets) seems to be out of date.
We'll use Webpacker gem.
Webpacker uses Yarn. You need to install Yarn beforehand (see `rails/Dockerfile`) .


Directories and files are created under rails/src and Gemfile and Gemfile.lock files are updated.

#### 5. Delete a running container (sample\_app-docker\_db\_1).

```shell-session
$ docker-compose down
Removing sample_app-docker_db_1 ... done
Removing network sample_app-docker_default
```

#### 6. Building docker images.

```shell-session
$ docker-compose build
```

#### 7. Change items of `username`, `password`, and `host` in `database.yml`

```shell-session
$ vi rails/src/config/database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: dbmaster
  password: PASSWORD
  host: db
development:
  <<: *default
  database: sample_app_development
:
```

#### 8. Create and launch containers.

```shell-session
$ docker-compose up
```

#### 9. Open another terminal window and execute `rake db:create` in app container.

```shell-session
$ cd ~/devel/sample_app-docker
$ docker-compose exec app rake db:create
Created database 'sample_app_development'
Created database 'sample_app_test'
```

#### 10. Close this termnal window.

#### 11. Stop containers by pressing Ctrl+C in termnal where containers are launched.

```console
:
app_1  | Use Ctrl-C to stop
^CGracefully stopping... (press Ctrl+C again to force)
Stopping sample_app-docker_web_1 ... done
Stopping sample_app-docker_app_1 ... done
Stopping sample_app-docker_db_1  ... done
```

#### 12. Modify puma.rb.
```shell-session
$ vi rails/src/config/puma.rb
```

Comment out the following line.
```console
#port        ENV.fetch("PORT") { 3000 }
```

Add the following lines at the end.
```console
bind "unix:///opt/sample_app/tmp/sockets/puma.sock"
stdout_redirect "/opt/sample_app/log/puma.stdout.log",  "/opt/sample_app/log/puma.stderr.log", true
```

#### 13. Restarting containers.
```shell-session
$ docker-compose start
Starting db  ... done
Starting app ... done
Starting web ... done
```

#### 14. Try accessing the URL `http://localhost/` in a web browser.
```shell-session
$  curl -I http://localhost/
HTTP/1.1 200 OK
Server: nginx/1.16.1
:
```
