  NOFILE_LIMIT=$(systemctl cat docker | grep NOFILE | tail -1 | cut -c 13-)
  echo $NOFILE_LIMIT
  # if nofile limit is equal Infinity, set it to 1048576
  if [ "$NOFILE_LIMIT" == "infinity" ]; then  
    echo "Nofile Limit is set to Infinity, this can cause problems with the MySQL container"
    echo "Adding the following line to your systemd's override.conf..."
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo echo "[Service]" | sudo tee -a /etc/systemd/system/docker.service.d/override.conf
    sudo echo "LimitNOFILE=1048576" | sudo tee -a /etc/systemd/system/docker.service.d/override.conf
    sudo mkdir -p /etc/systemd/system/containerd.service.d
    sudo echo "[Service]" | sudo tee -a /etc/systemd/system/containerd.service.d/override.conf
    sudo echo "LimitNOFILE=1048576" | sudo tee -a /etc/systemd/system/containerd.service.d/override.conf
    echo "Reloading systemd..."
    sudo systemctl daemon-reload
  fi
