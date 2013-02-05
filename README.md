[![Build Status](https://secure.travis-ci.org/brettweavnet/sdbport.png)](http://travis-ci.org/brettweavnet/sdbport)

# Sdbport

Sdbport exports & imports data from AWS SimpleDB domains. It can be used as a class or stand alone CLI.

## Installation

    gem install sdbport

## Getting Started

Set your AWS credentials:

    export AWS_ACCESS_KEY_ID=your_aws_key
    export AWS_SECRET_ACCESS_KEY=your_aws_secret

Export SimpleDB domain **sample** from **us-west-1**:

    sdbport export -k $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -r us-west-1 -n sample -o /tmp/dump.sdbport

To export larger SimpleDB domains, add -w.  This writes each chunk to file as it is received rather than storing in memory:

    sdbport export -k $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -r us-west-1 -n sample -o /tmp/dump.sdbport -w

Import into domain **sample** in **us-east-1**:

    sdbport import -k $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -r us-east-1 -n sample -i /tmp/dump.sdbport

## Exporting/Importing to/from multiple accounts.

You can specify your credentials on the command line, however it is best to add them to a configuration file.

By default, sdbport look for .sdbport.yml in your home directory. To get started, create the file **~/.sdbport.yml**:

    default:
      access_key: your_aws_key
      secret_key: your_aws_secert

You can add multiple account credentials and specify the account with --account (-a).

    prod:
      access_key: your_aws_key
      secret_key: your_aws_secert
    preprod:
      access_key: your_aws_key
      secret_key: your_aws_secert

Export SimpleDB domain **sample** from **prod** account in **us-west-1**:

```
sdbport export -a prod -r us-west-1 -n sample -o /tmp/dump.sdbport
```

Import into domain **sample** in **preprod** account in **us-east-1**:

```
sdbport import -a preprod -r us-east-1 -n sample -i /tmp/dump.sdbport
```

To list CLI subcommands:

```
sdbport -h
```

For details help on specific subcommand:

```
sdbport export -h
```

## Known Limitations

* Only supports importing into empty domain.

## Packages

* Packages for CENTOS 6 / RHEL 6 are available at [sdbport-0.4.1-1.el6.x86_64.rpm](https://dl.dropbox.com/u/52486103/Packages/sdbport-0.4.1-1.el6.x86_64.rpm)
* To build packages for another platform, see [omnibus-sdbport](https://github.com/brettweavnet/omnibus-sdbport).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
