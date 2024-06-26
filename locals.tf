locals {
  # if you want to SSH in and only have an IPv4 public address, change this value to `true`
  needIpv4 = false

  instance_count = 1

  # check https://learn.microsoft.com/en-gb/azure/virtual-machines/sizes-b-series-burstable for a bunch of different options for
  # the cheaper instance sizes
  #
  # the b1s is the instance class that qualifies for the free tier
  instance_size = "Standard_B1s"

  region = "uksouth"
  # this is the current region list, so use one of these if you want to run it somewhere else
  # "australiacentral",
  # "australiacentral2",
  # "australiaeast",
  # "australiasoutheast",
  # "brazilsouth",
  # "brazilsoutheast",
  # "brazilus",
  # "canadacentral",
  # "canadaeast",
  # "centralindia",
  # "centralus",
  # "centraluseuap",
  # "eastasia",
  # "eastus",
  # "eastus2",
  # "eastus2euap",
  # "francecentral",
  # "francesouth",
  # "germanynorth",
  # "germanywestcentral",
  # "israelcentral",
  # "italynorth",
  # "japaneast",
  # "japanwest",
  # "jioindiacentral",
  # "jioindiawest",
  # "koreacentral",
  # "koreasouth",
  # "malaysiasouth",
  # "mexicocentral",
  # "northcentralus",
  # "northeurope",
  # "norwayeast",
  # "norwaywest",
  # "polandcentral",
  # "qatarcentral",
  # "southafricanorth",
  # "southafricawest",
  # "southcentralus",
  # "southeastasia",
  # "southindia",
  # "spaincentral",
  # "swedencentral",
  # "swedensouth",
  # "switzerlandnorth",
  # "switzerlandwest",
  # "uaecentral",
  # "uaenorth",
  # "uksouth",
  # "ukwest",
  # "westcentralus",
  # "westeurope",
  # "westindia",
  # "westus",
  # "westus2",
  # "westus3",
  # "austriaeast",
  # "centralusfoundational",
  # "chilecentral",
  # "eastusslv",
  # "israelnorthwest",
  # "malaysiawest",
  # "newzealandnorth",
  # "westeuropefoundational",
}
