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

#### 1. First, specify the absolute path of the parent directory of this git project(directory) in `.env` file

* `.env`
``` bash
HOSTSRCPATH=c:/Users/foo/devel
```

#### 2. Change the following if you want to change the Rails project name (Application Directory name).

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

#### 3. Change the DB username(`dbmaster`) and root password.

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

#### 4. Run the following command for create a Rails project and update Gemfile and Gemfile.lock.

``` bash
$ docker-compose run --rm app rails new . --force --no-deps  --database=mysql --skip-coffee --skip-turbolinks --skip-sprockets --webpack
```

Directories and files are created under rails/src and Gemfile and Gemfile.lock files are updated.

#### 5. Delete a running container (sample\_app-docker\_db\_1).

``` bash
$ docker-compose down
Removing sample_app-docker_db_1 ... done
Removing network sample_app-docker_default
```

#### 6. Building docker images.

``` bash
$ docker-compose build
```

#### 7. Change items of `username`, `password`, and `host` in `database.yml`

``` bash
$ vi rails/src/config/database.yml
```
``` bash
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

``` bash
$ docker-compose up
```

#### 9. open another terminal window and execute `rake db:create` in app container.

``` bash
$ cd ~/devel/sample_app-docker
$ docker-compose exec app rake db:create
Created database 'sample_app_development'
Created database 'sample_app_test'
```

#### 10. Close this termnal window.

#### 11. Stop containers by pressing Ctrl+C in termnal where containers are launched.

``` bash
:
app_1  | Use Ctrl-C to stop
^CGracefully stopping... (press Ctrl+C again to force)
Stopping sample_app-docker_web_1 ... done
Stopping sample_app-docker_app_1 ... done
Stopping sample_app-docker_db_1  ... done
```

#### 12. Modify puma.rb.
``` bash
$ vi rails/src/config/puma.rb
```

Comment out the following line.
``` bash
#port        ENV.fetch("PORT") { 3000 }
```

Add the following lines at the end.
``` bash
bind "unix:///opt/sample_app/tmp/sockets/puma.sock"
stdout_redirect "/opt/sample_app/log/puma.stdout.log",  "/opt/sample_app/log/puma.stderr.log", true
```

#### 13. Restarting containers.
``` bash
$ docker-compose start
Starting db  ... done
Starting app ... done
Starting web ... done
```

#### 14. Try accessing the URL `http://localhost/` in a web browser.
``` bash
$  curl -I http://localhost/
HTTP/1.1 200 OK
Server: nginx/1.16.1
:
```
