function rmpc --description 'Wrapper to start mpd before running rmpc'
  if not systemctl --user is-active --quiet mpd
    systemctl --user start mpd
    sleep 0.5
  end
  command rmpc $argv
end
