function audio --wraps='SwitchAudioSource -s "$(SwitchAudioSource -a | fzf)"' --description 'alias audio=SwitchAudioSource -s "$(SwitchAudioSource -a | fzf)"'
  SwitchAudioSource -s "$(SwitchAudioSource -a | fzf)" $argv
        
end
