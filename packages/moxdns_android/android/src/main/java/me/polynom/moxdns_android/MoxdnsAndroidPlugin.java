package me.polynom.moxdns_android;

import androidx.annotation.NonNull;

import org.minidns.hla.DnssecResolverApi;
import org.minidns.hla.ResolutionUnsuccessfulException;
import org.minidns.hla.ResolverResult;
import org.minidns.record.SRV;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** MoxdnsAndroidPlugin */
public class MoxdnsAndroidPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "me.polynom.moxdns_android");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("srvQuery")) {
      ArrayList args = (ArrayList) call.arguments;
      String domain = (String) args.get(0);
      boolean dnssec = (boolean) args.get(1);
      Thread thread = new Thread(new Runnable() {
        @Override
        public void run() {
          try {
            ResolverResult<SRV> dns_result = DnssecResolverApi.INSTANCE.resolve(domain, SRV.class);
            // TODO: DNSSEC
            Set<SRV> records = dns_result.getAnswersOrEmptySet();
            ArrayList tmp = new ArrayList();
            for (SRV srv : records) {
              tmp.add(new HashMap<String, String>() {{
                put("target", srv.target.toString());
                put("port", String.valueOf(srv.port));
                put("priority", String.valueOf(srv.priority));
                put("weight", String.valueOf(srv.weight));
              }});
            }
            result.success(tmp);
          } catch (Exception ex) {
            ex.printStackTrace();
            result.success(new ArrayList());
          }
        }
      });
      thread.start();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
