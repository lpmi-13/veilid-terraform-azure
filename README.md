# Veilid on Azure

Details at https://veilid.com/

Running veilid nodes is a super easy way to help grow the network, and if you don't feel like manually setting up everything, this is an easy way to run one or more in Azure via terraform.

## Setup

You'll need terraform to run this, and you can get the installation instructions [here](https://developer.hashicorp.com/terraform/install).

If you don't have an Account on Azure yet, go head and [set one up](https://signup.azure.com).

You'll also need the Azure CLI to authenticate, and that can be installed following [this guide](https://learn.microsoft.com/en-gb/cli/azure/install-azure-cli).

### Setup Walkthrough

Here are the steps to get all ready to run terraform:

1. `az login`

2. `az account set --subscription "ID_FROM_THE_OUTPUT_OF_STEP_ONE"`

3. `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/ID_FROM_THE_OUTPUT_OF_STEP_ONE"`

4. `cp .env.example .env` and fill in the values from the output of step 3 (the subscription ID will be from step one).

5. `source .env` and you're ready to `terraform plan`!

> If you want to use a separate SSH key, then generate one in this folder like `ssh-keygen -t rsa -o -a 100 -f veilid-key` (unfortunately it has to be RSA because that's the only algorithm that Azure supports).

### How to connect to the instance

> The cloud init script takes a couple minutes to run, since the default for this repo (Standard_B1s) are very tiny (1 vCPU/1 GB RAM) machines, so if `which veilid-cli` doesn't show anything immediately after logging into the machine, give it a bit more time.

After running `terraform apply`, you'll see the output of the public IP address like so:

```sh
public_ip_address = "172.167.129.117"
```

so you can then SSH in if you wanna poke around a bit

```sh
ssh -i ROUTE_TO_PRIVATE_KEY veilid@IP_ADDRESS_FROM_OUTPUT
```
