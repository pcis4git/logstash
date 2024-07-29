def filter(event)
    puts JSON.pretty_generate( event )
    return [event]
end    