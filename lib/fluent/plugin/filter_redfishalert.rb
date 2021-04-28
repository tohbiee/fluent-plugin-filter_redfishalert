require 'fluent/plugin/filter'

module Fluent::Plugin
  class RedfishAlertFilter < Filter
    # Register filter as 'redfishmetric'
    Fluent::Plugin.register_filter('redfishalert', self)

    # config_param for the plugins
    config_param :namespace, :string, :default => 'ColomanagerFluentdRedfish'
    config_param :coloregion, :string, :default => 'CentralusEUAP'
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
            myRecord['Dimensions'] = {'Region' => @coloregion, 'AlertID' => val['MessageId'], 'IP' => record['REMOTE_ADDR']}
            myRecord['Value'] = '1'
            if !@filtering&.empty?
              if @filtering&.include?(val['MessageId'])
                new_es.add(time, myRecord)
              end
            else
              myRecord['Value'] = '0' if val['Severity'] != 'Critical' 
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