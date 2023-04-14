# NOFILE limit fix

In some linux distros, the NOFILE limit is set to infinity. This can cause major problems with the mysql container running out of memory through not respecting the limit. To prevent this, the NOFILE limit has to be set to a value below infinity, moste distros default to `1048576`.

An override can be easily created by adding the two following files:

`/etc/systemd/system/docker.service.d/override.conf`

```
[Service]
LimitNOFILE=1048576
```

`/etc/systemd/system/containerd.service.d/override.conf`

```
[Service]
LimitNOFILE=1048576
```

make sure to reload systemd and docker after that:

```
systemctl daemon-reload
systemctl restart docker
```
