function pbj --wraps='pbpaste | jq' --description 'alias pbj=pbpaste | jq'
  pbpaste | jq $argv
        
end
