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

## License

See `LICENSE`.
