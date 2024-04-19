# Veilid on Azure

Details at https://veilid.com/

Running veilid nodes is a super easy way to help grow the network, and if you don't feel like manually setting up everything, this is an easy way to run one or more in Azure via terraform.

## Cost

Because this is configured to run in Azure's free tier, the cost should be nothing. The only thing you might need to pay for is an IPv4 address if you require it for SSH access.

> see note below on enabling/disabling IPv4 connectivity.

Veilid is designed to contact the network with both IPv4 and IPv6, if available, so if only IPv6 connectivity exists, the node can still run fine.

## Setup

You'll need terraform to run this, and you can get the installation instructions [here](https://developer.hashicorp.com/terraform/install).

If you don't have an Account on Azure yet, go head and [set one up](https://signup.azure.com).

You'll also need the Azure CLI to authenticate, and that can be installed following [this guide](https://learn.microsoft.com/en-gb/cli/azure/install-azure-cli).

### Walkthrough

Here are the steps to get all ready to run terraform:

1. `az login`

2. `az account set --subscription "ID_FROM_THE_OUTPUT_OF_STEP_ONE"`

3. `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/ID_FROM_THE_OUTPUT_OF_STEP_ONE"`

4. `cp .env.example .env` and fill in the values from the output of step 3 (the subscription ID will be from step one).

5. If you want SSH access to play with `veilid-cli`, then add your public key under the `admin_ssh_key` block in `main.tf`. If you don't need SSH access, skip this step.

> If you want to use a separate SSH key, then generate one in this folder like `ssh-keygen -t rsa -o -a 100 -f veilid-key` (unfortunately it has to be RSA because that's the only algorithm that Azure supports).

6. `source .env` and you're ready to `terraform apply`!

### How to connect to the instance

By default, the instance starts up with only IPv6 connectivity. The main reason for this, as mentioned above, is that IPv6 addresses are free in Azure, whereas IPv4 addresses cost about $4/month.

> If you don't know whether you can connect via IPv4 or IPv6, you can go to https://www.whatismyip.com/ and you'll see if you have one or both. You'll either have only an IPv4 address, in which case you can only connect via IPv4, or you'll have both, in which case you can connect via IPv6.

If you need to connect via IPv4, change the flag in `locals.tf` for `needIpv4` to `true`, and then run `terraform apply`. After running that, you should see the IPv4 address in the output:

```sh
Outputs:

public_ip_address_ipv4 = [
  "172.167.141.82",
]
public_ip_address_ipv6 = [
  "2603:1020:700:1::a5",
]
```

When you're finished with SSH and want to get rid of the IPv4 address, you can change the flag back and rerun `terraform apply`. You'll see that the output now only contains an IPv6 address.

```sh
Outputs:

public_ip_address_ipv4 = []
public_ip_address_ipv6 = [
  "2603:1020:700:1::a5",
]
```

And whichever address you want to use to connect, you should be able to run the following to access the instance:

```sh
ssh -i ROUTE_TO_PRIVATE_KEY veilid@IP_ADDRESS_FROM_OUTPUT
```

> The cloud init script takes a couple minutes to run, since the default for this repo (Standard_B1s) are very tiny (1 vCPU/1 GB RAM) machines, so if `which veilid-cli` doesn't show anything immediately after logging into the machine, give it a bit more time.
