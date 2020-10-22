# Home Assistant Configuration <!-- omit in toc -->

[![GitHub](https://img.shields.io/github/license/QNimbus/homeassistant-config?style=for-the-badge)](LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2020?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/QNimbus/homeassistant-config?style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/QNimbus/homeassistant-config?style=for-the-badge)

[![HA Version](https://img.shields.io/static/v1?label=HA%20current%20version&message=0.116.4&color=%23007ec6&style=for-the-badge)](https://github.com/home-assistant/home-assistant/releases/latest)
[![HA Version](https://img.shields.io/static/v1?label=HA%20initial%20version&message=0.116.0&color=%23007ec6&style=for-the-badge)](https://github.com/home-assistant/core/releases/0.116.0)

- [Installation](#installation)
  - [SSH](#ssh)
  - [Network setup](#network-setup)
  - [Samba](#samba)
  - [AppDaemon](#appdaemon)
  - [Clone config repository](#clone-config-repository)
- [Integrations](#integrations)
- [ZWave](#zwave)
- [To do](#to-do)
- [Useful links](#useful-links)
- [License](#license)

## Installation

After the installation and boot up of the Home Assistant machine, open a browser and navigate to [http://homeassistant.local:8123](http://homeassistant.local:8123). If HA is unreachable check if any of the other NIC's on the HA machine are reachable (using the respective ip address of the NIC).

When opening the Home Assistant interface in the browser for the first time you will need to create a new user as part of the onboarding process. When the onboarding process is finished proceed to your [`profile`](http://homeassistant.local:8123/profile). In your profile make sure you enable `Advanced Mode`. This enables the installation of advanced add-ons that would otherwise be unavailable.

### SSH

Go to the [`Supervisor >> Add-on store`](http://homeassistant.local:8123/hassio/store) and install the `SSH & Web Terminal` community add-on. Next, modify the add-on configuration to allow loging in with a password and/or private key authentication.

 ```
 ssh:
  username: hassio
  password: '<YOUR_PASSWORD_HERE>'
  authorized_keys:
    - >-
      ssh-rsa
      <YOUR_PRIVATE_KEY_HERE>
      homeassistant
  sftp: false
  compatibility_mode: false
  allow_agent_forwarding: false
  allow_remote_port_forwarding: false
  allow_tcp_forwarding: false
zsh: true
share_sessions: false
packages: []
init_commands: []
 ```

When done editing the configuration do not forget to start the SSH server on the add-on page.

### Network setup

*Note: For reference see [Using nmcli to set a static IPv4 address](https://github.com/home-assistant/operating-system/blob/dev/Documentation/network.md#using-nmcli-to-set-a-static-ipv4-address)*

Login to the HASS.io terminal using SSH (as setup in the previous section). View the current network interfaces and their configuration. Configure the network interfaces as appropriate.

```bash
$ nmcli con show
NAME            UUID                                  TYPE      DEVICE
HassOS default  2d06fa94-0ff0-11eb-adc1-0242ac120002  ethernet  enp2s3

$ nmcli
enp2s3: connected to HassOS default
        "enp2s3"
        ethernet (e1000), DE:AD:BE:EF:00:01, hw, mtu 1500
        ip4 default
        inet4 10.30.99.6/16
        route4 0.0.0.0/0
        route4 10.30.0.0/16
        inet6 fe80::ec15:9bd6:eb48:d87c/64
        route6 fe80::/64
        route6 ff00::/8

enp2s1: disconnected
        "enp2s1"
        1 connection available
        ethernet (e1000), DE:AD:BE:EF:00:02, hw, mtu 1500

enp2s2: disconnected
        "enp2s2"
        1 connection available
        ethernet (e1000), DE:AD:BE:EF:00:03, hw, mtu 1500

docker0: unmanaged
        "docker0"
        bridge, DE:AD:BE:EF:00:04, sw, mtu 1500

hassio: unmanaged
        "hassio"
        bridge, DE:AD:BE:EF:00:05, sw, mtu 1500
```

To rename existing connection:

`$ nmcli connection modify "HassOS default" connection.id "IOT"`

To add a new interface/connection:

`$ nmcli con add type ethernet con-name "HassOS default" ifname enp2s1`

### Samba

Go to the [`Supervisor >> Add-on store`](http://homeassistant.local:8123/hassio/store) and install the `Samba share` add-on from the official repository.

### AppDaemon

Go to the [`Supervisor >> Add-on store`](http://homeassistant.local:8123/hassio/store) and install the `AppDaemon` add-on from the community repository.

### Clone config repository

Prior to cloning the config repository, ensure that HA core is stopped.

`$ ha core stop`

Clone this [repository](https://github.com/QNimbus/homeassistant-config.git) in the config folder.

- copy `secrets.example.yaml` to `secrets.yaml` and edit all the dummy values.
- copy/install SSL certificates in the `/ssl` folder.
- add the required `person` entities via the GUI. [`Configuration`](http://homeassistant.local:8123/config/person) *\**
- install [HACS](https://hacs.xyz/docs/installation/manual).
- install HACS integration [in the integrations config view](http://homeassistant.local:8123/config/integrations)
- get a [GitHub access token](https://github.com/settings/tokens) to use with HACS.

*\* Note: You can add profile images to the person profile via the GUI or via the YAML config in `customize/entities/person.<person_name>.yaml`*

Finally, restart the HA core.

`$ ha core start`

## Integrations

Most integrations can be configured using YAML files. However some integration are exclusively configured through to web UI. A list of integrations that need to be installed and configured through the web UI:

- [Netatmo integration](https://www.home-assistant.io/integrations/netatmo/)
- [Ubiquiti UniFi integration](https://www.home-assistant.io/integrations/unifi/)
- [Plugwise integration](https://www.home-assistant.io/integrations/plugwise/)
- [SONOS integration](https://www.home-assistant.io/integrations/sonos/)
- [ZWave integration](https://www.home-assistant.io/integrations/zwave/)

## ZWave

Renaming the default discovered device names (not entity names, I'm referring to the device names specifically) allows for better organisation of the ZWave network in HA.

- Ensure tha HA ZWave binding has correctly started the ZWave network previously and saved it's configuration to `zwcfg_0xe12deadbeaf.xml`
- Make a backup copy of the config file. e.g. `zwcfg_0xe12deadbeaf.xml.bak`
- Install the OZWCP add-on ([`Supervisor >> Add-on store`](http://homeassistant.local:8123/hassio/store))
- Start the OZWCP add-on (this shuts down the HA core container on HASS.io)
- Navigate to http://homeassistant.local:8090 (may take up to 2 minutes to start)
- Start network discovery for your device. (e.g. `/dev/ttyACM0`)
- Rename your ZWave devices as required.
- When finished make sure to save your changes and verify last modified date of `zwcfg_0xe12deadbeaf.xml` file.

*Note: For reference see [ZWave in Home Assistant](#zwave-in-home-assistant)*

## To do

- [ ] Add ZWave-to-MQTT via standalone device (e.g. Raspberry Pi 3+)

## Useful links

#### ZWave in Home Assistant

- [How to add ZWave devices in Home Assistant (community forum post)](https://community.home-assistant.io/t/aeon-labs-z-wave-door-window-sensor/403/27)

#### Reference

- [List of Home Assistant builtin icons](https://gist.github.com/QNimbus/5fb74d8ab5b68db3731f06eefedda3f7)
- [Awesome Home Assistant](https://www.awesome-ha.com/)
- [Home Assistant cookbook](https://www.home-assistant.io/cookbook/)
- [Home Assistant cheatsheet](https://github.com/arsaboo/homeassistant-config/blob/master/HASS%20Cheatsheet.md)

#### Add-ons & tools

- [HACS - Home Assistant Community Store](https://hacs.xyz/)
- [lovelace card-mod](https://github.com/thomasloven/lovelace-card-mod)

## License

[MIT](LICENSE)
