#include "include/moxdns_linux/moxdns_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <netinet/in.h>
#include <resolv.h>
#include <arpa/nameser.h>

#include <cstring>
#include <iostream>

#define MOXDNS_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), moxdns_linux_plugin_get_type(), \
                              MoxdnsLinuxPlugin))

struct _MoxdnsLinuxPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(MoxdnsLinuxPlugin, moxdns_linux_plugin, g_object_get_type())

// Convert the data field at offset [offset] of the RR [record] into an integer
// [FlValue].
FlValue *rr_data_field_to_value(ns_rr &record, int offset) {
  auto data = ntohs(*((unsigned short*)ns_rr_rdata(record) + offset));
  return fl_value_new_int(data);
}

// Called when a method call is received from Flutter.
static void moxdns_linux_plugin_handle_method_call(
    MoxdnsLinuxPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);
  if (strcmp(method, "srvQuery") == 0) {
    FlValue* args = fl_method_call_get_args(method_call);
    gchar *domain = fl_value_to_string(fl_value_lookup_string(args, "domain"));
    //bool dnssec = fl_value_get_bool(fl_value_lookup_string(args, "dnssec"));

    res_init();

    // This is based on this gist: https://gist.githubusercontent.com/ajdavis/e5f5ddbf50b5aecdc5e1d686d72a8a7a/raw/31ec3c642d5ca4a3d0688dde8cc4a6ef8bd97146/dnssd.cpp
    unsigned char query_buffer[1024];
    int result = res_query(domain, C_IN, ns_t_srv, query_buffer, sizeof(query_buffer));
    ns_msg records;
    ns_initparse(query_buffer, result, &records);

    FlValue *results = fl_value_new_list();
    for (int i = 0; i < ns_msg_count(records, ns_s_an); i++) {
      ns_rr record;
      ns_parserr(&records, ns_s_an, i, &record);

      char target[1024];
      dn_expand(ns_msg_base(records),
		ns_msg_end(records),
		ns_rr_rdata(record) + 6,
		target, sizeof(target));
      FlValue *map = fl_value_new_map();
      fl_value_set(map,
		   fl_value_new_string("target"),
		   fl_value_new_string(target));
      fl_value_set(map,
		   fl_value_new_string("port"), 
		   rr_data_field_to_value(record, 2));
      fl_value_set(map,
		   fl_value_new_string("priority"),
		   rr_data_field_to_value(record, 0));
      fl_value_set(map,
		   fl_value_new_string("weight"),
		   rr_data_field_to_value(record, 1));

      fl_value_append(results, map);
    }

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(results));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  
  fl_method_call_respond(method_call, response, nullptr);
}

static void moxdns_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(moxdns_linux_plugin_parent_class)->dispose(object);
}

static void moxdns_linux_plugin_class_init(MoxdnsLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = moxdns_linux_plugin_dispose;
}

static void moxdns_linux_plugin_init(MoxdnsLinuxPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  MoxdnsLinuxPlugin* plugin = MOXDNS_LINUX_PLUGIN(user_data);
  moxdns_linux_plugin_handle_method_call(plugin, method_call);
}

void moxdns_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  MoxdnsLinuxPlugin* plugin = MOXDNS_LINUX_PLUGIN(
      g_object_new(moxdns_linux_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "me.polynom.moxdns_linux",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
