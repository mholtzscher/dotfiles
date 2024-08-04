function ifactive --wraps=ifconfig\ \|\ pcregrep\ -M\ -o\ \'^\[^\\t:\]+:\(\[^\\n\]\|\\n\\t\)\*status:\ active\' --description alias\ ifactive=ifconfig\ \|\ pcregrep\ -M\ -o\ \'^\[^\\t:\]+:\(\[^\\n\]\|\\n\\t\)\*status:\ active\'
  ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active' $argv
        
end
