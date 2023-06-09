# SSH

This repo is an example of how to run an SSH server as a Fly.io app.

In most cases, you probably just want to use `fly ssh` or `fly proxy`, but this can be useful when you need to give tools like Retool or Looker access to other Fly apps of yours that you don't want to expose directly to the public internet.

Running public SSH servers is risky, proceed at your own risk.

## Setup

Problem: I have a Database with no public IP on Fly.io that I need to connect to a BI tool.
This BI tool supports SSH tunnelling.
Let's say the DB is "myflydb."

1. Clone this repo
   - The example Dockerfile is configured to setup a `retool` user
   - Depending on the SSH Tunnel docs for your particular service, you may need to change the username in the Dockerfile
2. `fly launch`
   - When prompted, copy the configuration from this `fly.toml`
3. Pick an app name
4. Do not deploy
5. `fly ips allocate-v4`
   - You may be able to just allocate-v6 depending on whether the service you're using supports IPv6-only
5. Set PUBLIC_KEY as a Fly.io secret
   - `fly secrets set PUBLIC_KEY="key from service"`
6. `fly deploy`
7. Point your BI tool at this app's domain: `<mysshapp>.fly.dev`, port 1122
6. Then your connection string on the BI Tool is `myflydb.internal`
   - For postgres, the port would be `5433`, or `5432`

## Notes

Notice in `fly.toml` that this project uses the non-standard port `1122`.
This can be changed in `fly.toml`.
Whatever value you use must be used when configuring your tunnel on your BI provider.

Retool's documentation: https://docs.retool.com/docs/enabling-ssh-tunnels
Looker's documentation: https://cloud.google.com/looker/docs/using-an-ssh-tunnel

## Recommendation

Each of the BI services have security recommendations for SSH tunneling.
These are not required to make the SSH Tunnel work for your needs,
though recommend following those recommendations from the providers to be secure.
Below are some examples.

### Retool

* Allowlist incoming IPs: https://docs.retool.com/docs/allow-retools-cloud-ip-addresses

### Looker

* Allowlist incoming IPs: https://cloud.google.com/looker/docs/using-an-ssh-tunnel#step_2_create_ip_allowlist
* Limit tunnel access where possible: https://cloud.google.com/looker/docs/using-an-ssh-tunnel#tunnel_security_notes
