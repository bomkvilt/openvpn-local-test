# Local OpenVPN deployment test

This project is a sandbox that allow to understand how to deploy an OpenVPN instrastracture.
The infrastructure consists from three elemenst:
- **CA**     — Certification Authotity — entity that sign sertification requests
- **Server** —
- **Client** —

In the small implementation I find it redundant to have separate CA container couse it requires to
    build a multiservice architecture:
- deploy a DNS
- create additional daemons on a client and server siztes create new client serts

To semplify the infrastructure it's need to
- combine CA and server in one instance
- place PKI derectory into an external volume


---

## Related links

| what | note | url |
| :--- | :--- | :-- |
| if u dont't understant what happens | [ru] | https://www.youtube.com/watch?v=mVwT4FzvvKc&t=2885s |
| dicker 2-in-1: server + CA          |      | https://github.com/dockovpn/docker-openvpn |
| step-by-step doc from DO            |      | https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04 |
| step-by-step doc from OpenVPN       |      | https://openvpn.net/community-resources/how-to/ |
|                                     |      | https://openvpn.net/community-resources/setting-up-your-own-certificate-authority-ca/ |
