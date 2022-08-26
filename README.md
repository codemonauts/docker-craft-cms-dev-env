# docker-craft-dev-env
![docker build badge](https://img.shields.io/docker/build/codemonauts/craft-cms-dev-env)
![docker pulls badge](https://img.shields.io/docker/pulls/codemonauts/craft-cms-dev-env)

This container helps you to setup a local environment for CRAFT CMS. This environment consists of:

- Ubuntu 20.04
- nginx webserver
- PHP-FPM 7.0, 7.2, 7.4, 8.0 and 8.1
- MySQL Server 5.7
- Redis Server 5.0
- Node 12 + npm
- Frontend Tooling (gulp, pug-cli)
- bash + some handy CLI tools (vim,curl,git, ...)

To enable you an easy workflow, this repository contains a helpful little shell script which you can use to manage this container.

## Installation

* Make sure you have Docker installed
* Copy the `bin/craft` script somewhere into your $PATH. E.g. `~/bin/craft`
* Done :)

## Usage


### Update

Regulary run `craft selfupdate` so the tool will get the latest version from GitHub and update itself.

### Start

```bash
cd /folder/containing/your/craft/website
cp the appropriate file containing your dev settings to the right place (.env.local or db.local.php depending on CRAFT version)
craft start
```

The database credentials in your dev setting must be the following:
```
Host: mysql
Username: root
Password: root
Database: See next step
```


`craft start` will do the following things:

- Pull the latest mysql container and start it with it's database dir (/var/lib/mysql/) mounted to `~/databases`.
- Pull the latest redis container and start it with it's data dir (/data) mounted to `~/redis`.
- Pull the latest craft-dev-env container and start nginx and php-fpm inside of it. Nginx will listen on port 8080 of your machine. We assume that you are currently inside the project folder and mount it into the container as the document root under `/local`.

To speed things up (the craft-dev-env container is quite big) the tool checks how old your local image is, and only
pulls a new image if it's older than two days.

If you wan't to use a different PHP version than 7.4, you can start the container with an extra argument like this: `craft start 8.0`.

### Load a database

A CraftCMS site is pretty useless without a database, so we need to create one. To create an empty database run 

```bash
craft create <db-name>
```

If you wan't to populate the DB with some data, e.g. from the current prod environment you can do this by running

```bash
cp <dump-name>.sql /folder/containing/your/craft/website
craft import <db-name> <dump-name>
```

The dump can be in one of the following formats:
  - .sql
  - .sql.gz
  - .sql.zst
  - .zip

If you want to clear the DB beforehadn completly, you can use `replace` instead of `import`. This is a shorthand for `drop`, `create`, `import` and will guarante a clean import of your DB.

### Build frontend

To start gulp inside the container you can run
```bash
craft gulp
```
This will start the default action defined in your gulpfile. To run a specific task, you can add it at the end:

```bash
craft gulp build
```

### Define webserver root directory
Rename the `web` folder to `public`. This is the access point for our webserver.

### Finishline

When everything has worked until this point you should be able to open [localhost:8080](http://localhost:8080) in
your browser and see your webpage. Maybe you also want to visit `/admin` and see if there are outstanding database
migrations to apply.

### Teardown

When you are done and wan't to throw the containers away, just run `craft stopall`. This will gracefully stop the MySQL
server and then remove all containers. Because the database files and the precompiled assets were saved to your
local disk, the next time you run `craft start` everything will already be there.

If you only want to switch to another CraftCMS projekct, you can use `craft stop` which wil only stop the PHP container
and keep the MySQL and the Redis container running because they are shared between all projects.

### Custom scripts

If you have custom scripts which you want to execute for this specific project (e.g. installing packages or copying
files) you can create a `scripts` folder in your project root (where you start `craft`) and put your scripts into it.
Everything ending with `.sh` gets executed with `bash` when you run `craft gulp`.

### Shell access

If you wan't to access the filesystem inside the container to e.g. take a look at a logfile or modify some files you
can run `craft shell` to spawn a bash.
