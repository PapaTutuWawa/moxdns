# moxdns

A very small wrapper around platform-"native" methods to perform
DNS SRV lookups.

## Usage

```dart
import "package:moxdns/moxdns.dart";

Future<void> main() async {
	final result = await MoxdnsPlugin.srvQuery("_xmpps-client._tcp.example.server", false);
}
```

The first argument to `srvQuery` is the SRV record you want to query. The second one is
whether to use DNSSEC or not. Note that DNSSEC is currently not supported, so the option
essentially does nothing right now.

The function will return a future that either resolves to a list of SRV records, an empty
list of no records were found or `null` if an error occured.

## Contributing

The development of this package is based on [melos](https://pub.dev/packages/melos).

To make all packages link to each other locally, begin by running `melos bootstrap`. After editing
the code and making your changes, please run `melos run analyze` to make sure that no linter warnings
are left inside the code.

## License

See `LICENSE`.
