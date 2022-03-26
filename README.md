# wireproxy-docker
Wireguard client that exposes itself as a socks5 proxy or tunnels.   
This is specifically the docker version of this forked project for easy deployment.
# What is this
wireproxy is a completely userspace application that connects to a wireguard peer,
and exposes a socks5 proxy or tunnels on the machine. This can be useful if you need
to connect to certain sites via a wireguard peer, but do not want to setup a new network
interface for whatever reasons.

# Why you might want this
- You simply want wireguard as a way to proxy some traffic
- You don't want root permission just to change wireguard settings

Currently I am running wireproxy connected to a wireguard server in another country,
and configured my browser to use wireproxy for certain sites. It is pretty useful since
wireproxy is completely isolated from my network interfaces, also I don't need root to configure
anything.

# Usage
```shell
docker run --expose (internal port) -p 0.0.0.0:(host port):(internal port) -v (config directory on host):(config directory in container) --env wireproxyconfigpath=(config name) daycat/wireproxy-docker
```

For example, this is a valid command to start:
```shell
    screen docker run --expose 23944 -p 0.0.0.0:23944:23944 -v /root:/etc/wireproxy --env wireproxyconfigpath=/etc/wireproxy/wireguard-argentina.conf daycat/wireproxy-docker
```
# Configuration

The original wireproxy project relies on a configuration file to set up connections both inbound and outbound. No modifications to the workings of the config file was made to this dockerized version.

This may be a valid configuration file:
```
SelfSecretKey = uCTIK+56CPyCvwJxmU5dBfuyJvPuSXAq1FzHdnIxe1Q=
SelfEndpoint = 172.16.31.2

PeerPublicKey = QP+A67Z2UBrMgvNIdHv8gPel5URWNLS4B3ZQ2hQIZlg=
PeerEndpoint = 172.16.0.1:53
DNS = 1.1.1.1

[TCPClientTunnel]
BindAddress = 0.0.0.0:25565
Target = play.cubecraft.net:25565

[TCPServerTunnel]
ListenPort = 3422
Target = localhost:25545

[Socks5]
BindAddress = 0.0.0.0:25344
```


| Option        | Description                                                                   | Example |
|---------------|-------------------------------------------------------------------------------|---------|
| SelfSecretKey | Private Key of Wireguard peer / server                                        |         |
| SelfEndpoint  | IP to be assigned. Must be a Local IP and generally provided by your provider | 10.14.100.22        |
| PeerPublicKey | Public key of Wireguard peer / server                                         |         |
| PeerEndpoint  | Public address of your server, including the port number.                     | 91.26.168.68:51820        |
| DNS | DNS server to use. This can accept multiple arguments, seperated by a comma. | 162.252.172.57, 149.154.159.92 |
| KeepAlive | The keep alive interval of the WireGurad device | Usually left blank |
| PreSharedKey | Pre-shared key for WireGuard | Usually left blank |
| [TCPClientTunnel] | A tunnel forwarding any TCP traffic received to the specified target via wireguard | |
| [TCPServerTunnel] | A tunnel listening on wireguard, forwarding any TCP traffic received to the specified target via local network | Option may not work in Dockerized version |
| [Socks5] | A SOCKS5 proxy listening on a specified port that forwards all traffic through wireguard | You must use 0.0.0.0 instead of 127.0.0.1 in dockerized version |

This is a real configuration for a SOCKS5 proxy that routes traffic through a SurfShark Argentina server:
```
SelfSecretKey = (Private Key)
SelfEndpoint = 10.14.100.22
PeerPublicKey = (Public Key)
PeerEndpoint = 91.206.168.68:51820
DNS = 162.252.172.57, 149.154.159.92
[Socks5]
BindAddress = 0.0.0.0:23944