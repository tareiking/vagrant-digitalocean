Digital Ocean Vagrant Provider For Chassis
==========================================
`vagrant-chassis-digitalocean` is a provider plugin for Vagrant that supports the
management of [Digital Ocean](https://www.digitalocean.com/) droplets
(instances) that setup WordPress using [Chassis](https://github.com/Chassis/Chassis/).

**NOTE:** This plugin is based on the amazing work of the [vagrant-digitalocean
](https://github.com/smdahlen/vagrant-digitalocean) plugin

Current features include:
- create and destroy droplets
- power on and off droplets
- rebuild a droplet
- setup a SSH public key for authentication
- create a new user account during droplet creation

The provider has been tested with Vagrant 1.1.5+ using Ubuntu 12.04 and
CentOS 6.3 guest operating systems.

Install
-------
Installation of the provider requires two steps:

1. Install the provider plugin using the Vagrant command-line interface:

        $ vagrant plugin install vagrant-chassis-digitalocean


**NOTE:** If you are using a Mac, you may need to install a CA bundle to enable SSL
communication with the Digital Ocean API. It is recommended to first install
[Homebrew](http://mxcl.github.io/homebrew/). With Homebrew installed, run
the following command to install the bundle:

    $ brew install curl-ca-bundle

Once the bundle is installed, add the following environment variable to your
`.bash_profile` script and `source` it:

```bash
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
```

Configure
---------
Once the provider has been installed, you will need to configure your [Chassis](https://github.com/Chassis/Chassis/) project
to use it. You can use your we recommend adding your Digital Ocean details in your projects `config.yaml` or `config.local.yaml` file:
```bash
digitalocean:
  client_id: YOUR_CLIENT_ID
  api_key: YOUR_API_KEY
  region: 'Singapore 1'
  size: '512MB'
  image: 'Ubuntu 12.10 x32'
```

Run
---
After creating your project's `Vagrantfile` with the required configuration
attributes described above, you may create a new droplet with the following
command:

    $ vagrant up --provider=digital_ocean

This command will create a new droplet, setup your SSH key for authentication,
create a new user account, and run the provisioners you have configured.

**Supported Commands**

The provider supports the following Vagrant sub-commands:
- `vagrant destroy` - Destroys the droplet instance.
- `vagrant ssh` - Logs into the droplet instance using the configured user
  account.
- `vagrant halt` - Powers off the droplet instance.
- `vagrant provision` - Runs the configured provisioners and rsyncs any
  specified `config.vm.synced_folder`.
- `vagrant reload` - Reboots the droplet instance.
- `vagrant rebuild` - Destroys the droplet instance and recreates it with the
  same IP address is was assigned to previously.
- `vagrant status` - Outputs the status (active, off, not created) for the
  droplet instance.

Contribute
----------
To contribute, clone the repository, and use [Bundler](http://gembundler.com)
to install dependencies:

    $ bundle

To run the provider's tests:

    $ bundle exec rake test

You can now make modifications. Running `vagrant` within the Bundler
environment will ensure that plugins installed in your Vagrant
environment are not loaded.
