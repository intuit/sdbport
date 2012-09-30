[![Build Status](https://secure.travis-ci.org/brettweavnet/sdbport.png)](http://travis-ci.org/brettweavnet/sdbport)

# Sdbport

Sdbport exports & imports data from AWS SimpleDB domains. It can be used as a class or stand alone CLI.

## Installation

gem install sdbport

## Usage

Set your AWS credentials:

```
export AWS_ACCESS_KEY_ID=key
export AWS_SECRET_ACCESS_KEY=secret
```

Export SimpleDB domain:

```
sdbport export -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -r us-west-1 -n test -o /tmp/test-domain-dump
```

Import into new domain:

```
sdbport import -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -r us-west-1 -n new-domain -i /tmp/test-domain-dump
```

Purge domain:

```
sdbport purge -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -r us-west-1 -n new-domain
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

* Only performs a single query for exports, which gives it a maxmimum of 1,000 entries.
* Single serialiazed process.
* Only supports importing into empty domain.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
