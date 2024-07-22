def filter(event)
    thorDebug = event.get('THOR_DEBUG')
    if ( thorDebug != nil ) && ( 'true' == thorDebug.downcase ) 
       puts JSON.pretty_generate( event )
    end

    # indexName = event.get('thorIndexName')
    # event.set('[@metadata][target_index]', indexName )

    return [event]
end    