# docker-craft-dev-env

This container helps you to setup a local environment for CRAFT CMS. This environment consists of:

- Nginx webserver
- PHP-FPM 7.0 or 7.2
- MySQL Server 5.6
- Node 9.11 + npm
- Frontend Tooling (gulp, bower, pug-cli)
- bash + some sane CLI tools (vim,curl,git, ...)

To enable you an easy workflow, this repository contains a helpful little shell script which you can use to manage this container.

## Installation

Just copy the `bin/craft` script somewhere into your $PATH. E.g. `~/bin/craft`

## Usage

### Start

```bash
cd /folder/containing/your/craft/website
cp the appropriate file containing your dev settings to the right place (.env.local or db.local.php depending on CRAFT version)
craft start
```

This will do the following things:

- Pull the latest mysql container and start it with it's database dir (/var/lib/mysql/) mounted to `~/databases`.
- Pull the latest redis container and start it with it's data dir (/data) mounted to `~/redis`.
- Pull the latest craft-dev-env container and start the nginx+pphp7.0 inside of it. Nginx will listen on port 8080 of your machine. We assume that you are currently inside the project folder and mount it into the container as the document root under `/local`.

If you wan't to use php-fpm7.2 instead of 7.0 just run `craft start 7.2`.

### Load a database

A CRAFT site is pretty useless without a database, so we need to create one. To create a DB just run

```bash
craft create <db-name>
```

If you wan't to populate the DB with some data from e.g. the current prod environment you can do this by running

```bash
cp <dump-name>.sql /folder/containing/your/craft/website
craft import <db-name> <dump-name>
```

The dump can be in one of the following formats:
  - .sql
  - .sql.gz
  - .sql.zst

### Build frontend

To compile all the SASS/SCSS/PUG/JADE files into usable assets you can run

```bash
craft shell
cd /local/src
gulp build
```

If you are modifying something in the frontend you probably want gulp to watch for filechanges and immideately rebuild. You can
archive this by running

```bash
craft gulp
```

### Finishline

When everything has worked until this point you should be able to open [localhost:8080](http://localhost:8080) in
your browser and see your webpage. Maybe you also want to visit `/admin` and see if there are outstanding database
migrations to apply.

### Teardown

When you are done and wan't to throw the containers away just run `craft stopall`. This will gracefully stop the MySQL
server and then remove all containers. Because the database files and the precompiled assets were saved to your
local disk instead of the container, the next time you can just run `craft start` and are ready to roll.

If you just want to stop the craft container to e.g. switch to a different project you can use `craft stop` which justs
stops the craft container but keeps mysql and redis running.

### Shell access

If you wan't to access the filesystem inside the container to e.g. take a look at a logfile or modify some files you
can run `craft shell` to spawn a bash.

### External Tunnel

Sometimes you need to access the CRAFT installation from the outside to e.g. receive a webhook from a third-party. To
make this easy we included [ngrok](https://ngrok.com) inside the container. Just run `craft tunnel` and you will see
the ngrok interface which will present you publicly reachable `https:<randomhash>.ngrok.io` domain which will point
to the nginx inside the container.
