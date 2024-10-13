function cacheclear --wraps='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder' --description 'alias cacheclear=sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder $argv
        
end
