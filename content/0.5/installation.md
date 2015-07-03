+++
date = "2015-06-29T19:14:23-05:00"
draft = true
title = "Installation"

+++

- [Installation](#installation)
- [Configuration](#configuration)
	- [Basic Configuration](#basic-configuration)
	- [Environment Configuration](#environment-configuration)
	- [Configuration Caching](#configuration-caching)
	- [Accessing Configuration Values](#accessing-configuration-values)
	- [Naming Your Application](#naming-your-application)

<a name="installation"></a>
## Installation

### Server Requirements

The Gophersaurus framework has a few system requirements:

<div class="content-list" markdown="1">
- Golang >= 1.4
</div>

<a name="install-gophersaurus"></a>
### Installing Gophersaurus

Gophersaurus utilizes the [gf](https://github.com/gophersaurus/gf) tool to start a project.

#### Via gf tool

First, download the `gf` installer tool on your machine using Go:

	go get -u github.com/gophersaurus/gf

Make sure to place the `$GOPATH/bin` directory in your PATH so the `gf` executable can be located by your system.

Once installed, the simple `gf new` command will create a fresh Gophersaurus installation in the directory you specify. For instance, `gf new api` will create a directory named `api` containing a fresh Gophersaurus installation with all of Gophersaurus's dependencies already installed. This method of installation is much faster than installing via git:

	gf new api

<a name="configuration"></a>
## Configuration

<a name="basic-configuration"></a>
### Basic Configuration

All of the configuration files for the Gophersaurus framework are stored in the `config` directory. Each option is documented, so feel free to look through the files and get familiar with the options available to you.

#### Directory Permissions

After installing Gophersaurus, you may need to configure some permissions. Directories within the `storage` and the `bootstrap/cache` directories should be writable by your web server. If you are using the [Homestead](/docs/{{version}}/homestead) virtual machine, these permissions should already be set.

#### Application Key

The next thing you should do after installing Gophersaurus is set your application key to a random string. If you installed Gophersaurus via Composer or the Gophersaurus installer, this key has already been set for you by the `key:generate` command. Typically, this string should be 32 characters long. The key can be set in the `.env` environment file. If you have not renamed the `.env.example` file to `.env`, you should do that now. **If the application key is not set, your user sessions and other encrypted data will not be secure!**

#### Additional Configuration

Gophersaurus needs almost no other configuration out of the box. You are free to get started developing! However, you may wish to review the `config/app.php` file and its documentation. It contains several options such as `timezone` and `locale` that you may wish to change according to your application.

You may also want to configure a few additional components of Gophersaurus, such as:

- [Cache](/docs/{{version}}/cache#configuration)
- [Database](/docs/{{version}}/database#configuration)
- [Session](/docs/{{version}}/session#configuration)

Once Gophersaurus is installed, you should also [configure your local environment](/docs/{{version}}/installation#environment-configuration).

<a name="pretty-urls"></a>
#### Pretty URLs

**Apache**

The framework ships with a `public/.htaccess` file that is used to allow URLs without `index.php`. If you use Apache to serve your Gophersaurus application, be sure to enable the `mod_rewrite` module.

If the `.htaccess` file that ships with Gophersaurus does not work with your Apache installation, try this one:

	Options +FollowSymLinks
	RewriteEngine On

	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteRule ^ index.php [L]

**Nginx**

On Nginx, the following directive in your site configuration will allow "pretty" URLs:

	location / {
		try_files $uri $uri/ /index.php?$query_string;
	}

Of course, when using [Homestead](/docs/{{version}}/homestead), pretty URLs will be configured automatically.

<a name="environment-configuration"></a>
### Environment Configuration

It is often helpful to have different configuration values based on the environment the application is running in. For example, you may wish to use a different cache driver locally than you do on your production server. It's easy using environment based configuration.

To make this a cinch, Gophersaurus utilizes the [DotEnv](https://github.com/vlucas/phpdotenv) PHP library by Vance Lucas. In a fresh Gophersaurus installation, the root directory of your application will contain a `.env.example` file. If you install Gophersaurus via Composer, this file will automatically be renamed to `.env`. Otherwise, you should rename the file manually.

All of the variables listed in this file will be loaded into the `$_ENV` PHP super-global when your application receives a request. You may use the `env` helper to retrieve values from these variables. In fact, if you review the Gophersaurus configuration files, you will notice several of the options already using this helper!

Feel free to modify your environment variables as needed for your own local server, as well as your production environment. However, your `.env` file should not be committed to your application's source control, since each developer / server using your application could require a different environment configuration.

If you are developing with a team, you may wish to continue including a `.env.example` file with your application. By putting place-holder values in the example configuration file, other developers on your team can clearly see which environment variables are needed to run your application.

#### Accessing The Current Application Environment

The current application environment is determined via the `APP_ENV` variable from your `.env` file. You may access this value via the `environment` method on the `App` [facade](/docs/{{version}}/facades):

	$environment = App::environment();

You may also pass arguments to the `environment` method to check if the environment matches a given value. You may even pass multiple values if necessary:

	if (App::environment('local')) {
		// The environment is local
	}

	if (App::environment('local', 'staging')) {
		// The environment is either local OR staging...
	}

An application instance may also be accessed via the `app` helper method:

	$environment = app()->environment();

<a name="configuration-caching"></a>
### Configuration Caching

To give your application a speed boost, you should cache all of your configuration files into a single file using the `config:cache` Artisan command. This will combine all of the configuration options for your application into a single file which can be loaded quickly by the framework.

You should typically run the `config:cache` command as part of your deployment routine.

<a name="accessing-configuration-values"></a>
### Accessing Configuration Values

You may easily access your configuration values using the global `config` helper function. The configuration values may be accessed using "dot" syntax, which includes the name of the file and option you wish to access. A default value may also be specified and will be returned if the configuration option does not exist:

	$value = config('app.timezone');

To set configuration values at runtime, pass an array to the `config` helper:

	config(['app.timezone' => 'America/Chicago']);

<a name="naming-your-application"></a>
### Naming Your Application

After installing Gophersaurus, you may wish to "name" your application. By default, the `app` directory is namespaced under `App`, and autoloaded by Composer using the [PSR-4 autoloading standard](http://www.php-fig.org/psr/psr-4/). However, you may change the namespace to match the name of your application, which you can easily do via the `app:name` Artisan command.

For example, if your application is named "Horsefly", you could run the following command from the root of your installation:

	php artisan app:name Horsefly

Renaming your application is entirely optional, and you are free to keep the `App` namespace if you wish.
