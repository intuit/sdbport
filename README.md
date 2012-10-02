[![Build Status](https://secure.travis-ci.org/brettweavnet/sdbport.png)](http://travis-ci.org/brettweavnet/sdbport)

# Sdbport

Sdbport exports & imports data from AWS SimpleDB domains. It can be used as a class or stand alone CLI.

## Installation

gem install sdbport

## Usage

Add your AWS credentials to .sdbport.yml in your home directory. By default, sdbport will use the 'default' credentials.

```
cat > ~/.sdbport.yml << EOF
default:
  access_key: your_aws_key
  secret_key: your_aws_secert
EOF
```

You can add multiple account credentials and specify the account with --account (-a).

```
cat > ~/.sdbport.yml << EOF
prod:
  access_key: your_aws_key
  secret_key: your_aws_secert
preprod:
  access_key: your_aws_key
  secret_key: your_aws_secert
EOF
```

Export SimpleDB domain data from prod account in us-west-1:

```
sdbport export -a prod -r us-west-1 -n data -o /tmp/data-domain-dump
```

Import into preprod account in us-east-1:

```
sdbport import -a preprod -r us-east-1 -n data -i /tmp/data-domain-dump
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
