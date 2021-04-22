# redfish_alerts_fluentd
custom fluentd plugin for redfish alerts

# Fluent::Plugin::Redfish::Alert

## Installation

build with gem build
    $ gem build fluent-plugin-redfishalert.gemspec
install with gem install
    $ gem install fluent-plugin-filter_redfishalert
unit

## Configuration

```

<filter **>
  type redfishalert
</filter>

```

converts a single json chunk of alert into indiviual streams of alert
Also has capacity to discard/filter desired redfish alert based on ids
enter list of alerts ids to @filtering flag


## Contributing
Please Read Contributing.md (coming)