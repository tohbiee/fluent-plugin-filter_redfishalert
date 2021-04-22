require_relative 'helper'
require 'fluent/plugin/test/driver/filter'
require 'fluent/plugin/redfishalertfilter'

class RedfishalertfilterTest < Test::Unit::TestCase
    include Fluent

    def setup 
        Fluent::Test.setup
    end

    # default configuration for tests
    CONFIG = %[
        filtering = ["CPU0003"]
      ]

    def create_driver(conf = CONFIG)
        Fluent::Test::Driver::Filter.new(Fluent::Plugin::RedfishAlertFilter).configure(conf)
    end

    def filter(config, messages)
        d = create_driver(config)
        d.run(default_tag: 'input.access') do
            messages.each do |message|
                d.feed(message)
            end
        end
        d.filtered_records
    end

    #sub_test_case 'configure' do
    sub_test_case 'configured with invalid configuration' do
        test 'empty configuration' do
            assert_raise(Fluent::ConfigError) do
                create_driver('')
            end
        end
        
        test 'param1 should reject too short string' do
            conf = %[
                param1 a
            ]
            assert_raise(Fluent::ConfigError) do
                create_driver(conf)
            end
        end
    end

    sub_test_case 'plugin will add some fields' do
        test 'filter alert and add dimension to record' do
            conf = CONFIG

            messages =
            {
                "@odata.type"=> "#Event.v1_3_0.Event",
                "Events"=> [      
                   {
                      "MemberId"=> "84893",
                      "Message"=> "The session for root from 172.16.1.54 using SSH is logged on.",
                      "MessageArgs"=> ["root","172.16.1.54","SSH"]
                      ],
                      "MessageArgs@odata.count"=> 3,
                      "MessageId"=> "USR0032",
                      "Severity"=> "Informational"
                   },
                   {
                    "MemberId"=> "84883",
                    "Message"=> "The session for root from 172.16.1.55 using SSH is logged off.",
                    "MessageArgs"=> ["root","172.16.1.55","SSH"]
                    ],
                    "MessageArgs@odata.count"=> 3,
                    "MessageId"=> "CPU0003",
                    "Severity"=> "Critical"
                 }
                ],
                "Id"=> "37470",
                "Name"=> "Event Array"
             }

            expected = [{"Namespace"=>"ColomanagerFluentdRedfish","Metric"=>"USR0032","Dimensions"=>
                {"Region"=>"CentralUSEUAP","IP"=>null,"Root"=>"172.16.1.55","Message"=>"The session for root from 172.16.1.54 using SSH is logged on."},"Value"=>"0"},
                {"Namespace"=>"ColomanagerFluentdRedfish","Metric"=>"CPU0003","Dimensions"=>
                    {"Region"=>"CentralUSEUAP","IP"=>null,"Root"=>"172.16.1.55","Message"=>"The session for root from 172.16.1.55 using SSH is logged off."},"Value"=>"1"}]

            filtered_records = filter(conf, messages)
            assert_equal(expected, filtered_records)
        end
    end    
end 