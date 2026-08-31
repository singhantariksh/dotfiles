function wake_dgpu
  echo 1 | sudo tee /sys/bus/pci/rescan > /dev/null
end
