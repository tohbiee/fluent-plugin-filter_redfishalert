require 'fluent/plugin/filter'

module Fluent::Plugin
  class RedfishAlertFilter < Filter
    # Register filter as 'redfishmetric'
    Fluent::Plugin.register_filter('redfishalert', self)

    # config_param for the plugins
    config_param :namespace, :string, :default => 'ColomanagerFluentdRedfish'
    config_param :filtering, :array, :default => [], value_type: :string
	
    def configure(conf)
      super
        @values = []
      end

    def filter_stream(tag, es)
  
      new_es = Fluent::MultiEventStream.new
      es.each { |time, record|
        @values = record['Events']
        @values&.each do |val|
          begin
            myRecord = {}
            myRecord['Namespace'] = @namespace
            myRecord['Metric'] = 'RedfishAlert'
            myRecord['Dimensions'] = {'BaremetalMachineID' => record['machineID'], 'AlertID' => val['MessageId']}
            myRecord['Value'] = '1'
            if @filtering&.include?(val['MessageId'])
              new_es.add(time, myRecord)
            end
          rescue => e
          router.emit_error_event(tag, time, record, e)
          end
        end
      }
      new_es
    end
  end
end