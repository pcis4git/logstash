
OAG_API_GTWY_LOGGING = "OAG-API-GTWY-LOGGING"


def filter(event)
    thorDebug = event.get('THOR_DEBUG')
    if ( thorDebug != nil ) && ( 'true' == thorDebug.downcase ) 
       puts JSON.pretty_generate( event )
    end

    event.remove('headers')

    # indexName = event.get('thorIndexName')
    # event.set('[@metadata][target_index]', indexName )

    message = event.get('message')
    event.set('[@metadata][dropEvent]', 'true' )
    if(  message != nil && message.include?( OAG_API_GTWY_LOGGING ) )
        event.set('[@metadata][dropEvent]', 'false' )

        start_index = message.index(OAG_API_GTWY_LOGGING) + OAG_API_GTWY_LOGGING.length
        substring = message[start_index..-1].strip

        # Parse the substring to JSON
        begin
            json_node = JSON.parse(substring)
            event.remove('message')
            json_node.each { | key, value |
               event.set(key, value)
            }

        rescue JSON::ParserError => e
            puts "Failed to parse JSON: #{e.message}"
        end

    end

    

    return [event]
end    