A collection of my Docker experiments and configurations.

* a PHP 5.2.17 (with Xdebug, Opcache, Memcached and Mailcatcher) LNMP stack aimed at WordPress development
* a PHP 5.6 (with Xdebug, Opcache, Memcached and Mailcatcher) LNMP stack aimed at WordPress development
* a PHP 7.0 (with Xdebug, Opcache, Memcached and Mailcatcher) LNMP stack aimed at WordPress development
* a PHP 7.1 (with Xdebug and Opcache) LNMP stack aimed at WordPress development

While the images are meant for WordPress development they do not come with WordPress and can really be tailored to any PHP application.

## Installation
Clone the repository in a known location:

```bash
git clone https://github.com/lucatume/dockerfiles.git dockerfiles
```

In this README file I will assume the repository has been cloned in the `~/dockerfiles` folder.

## Usage
The images are not meant to be alone, but in the context of a Compose managed stack; copy a stack, e.g. the `stack/php-52` one, to the project folder:

```bash
cp -r ~/dockerfiles/stacks/php-52 project
```

Change directory to the `project` folder and set up the project:

```bash
cd project
sh ./setup
```

The script will ask one or more questions to setup the site, answer correctly and the script will build the images.  
Assuming the domain of the stack has been set to `app` the next step is to start the stack using the `up` script:

```bash
sh ./up
```

Beside the PHP version all the stacks provide PHP FPM with an Nginx server, a Memcached server to handle caching, a MySQL database available to the PHP container at `db.localhost` and a Mailcatcher container to handle and debug emails.  
Thanks to the reverse proxy the stack will also expose:

* the database container at `db.localhost:3306`, see "Database" section for credentials
* the Mailcatcher container at `mailcatcher.localhost`
* the stack available at `app.localhost` (assuming the `app` domain above)
* all the stacks have XDebug activated on each request calling back on port `9001`

## Database
The stack database container will create the default MySQL databases and an additional database with the same name as the domain.  
Assuming the domain is set to `app` the database would:

* have a `root` user with `root` password
* create an `app` database with a default `app` user (password: `app`)

The database is accessible at the `db.localhost` host, port `3306`; you can access it like this:

```shell
mysql -uroot -p -hdb.localhost
```

## XDebug
Each PHP container has XDebug set up to autostart and connect to a remote host by default.  
The `up` script will try to infer the host machine IP address and set it in the `xdebug.remote_host` setting; should this value be consistently wrong you can define the IP adddress in the `.env` file of each container.

The stacks **are not** meant for production!