locals {
  cache = {
    "default" : {
      "query_string_caching_behavior" : "IgnoreSpecifiedQueryStrings"
      "query_strings" : ["account", "settings"]
      "compression_enabled" : true
      "content_types_to_compress" : ["text/html", "text/javascript", "text/xml"]
    }
  }
}