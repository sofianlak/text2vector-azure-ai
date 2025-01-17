#!/bin/bash

# Function to import a resource if not already managed by Terraform
import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  if ! terraform state list | grep -q "${resource_type}.${resource_name}"; then
    echo "Importing ${resource_type}.${resource_name}..."
    terraform import "${resource_type}.${resource_name}" "${resource_id}"
  else
    echo "${resource_type}.${resource_name} is already managed by Terraform."
  fi
}

# Function to check if a resource exists
resource_exists() {
  local resource_id=$1
  echo "Checking if resource exists: ${resource_id}"
  az resource show --ids "${resource_id}" &> /dev/null
  local status=$?
  echo "Resource exists: status: ${status}"
  return $?
}

# Variables for resource names and IDs
RESOURCE_GROUP_NAME=${RESOURCE_GROUP_NAME}
COGNITIVE_ACCOUNT_NAME=${COGNITIVE_ACCOUNT_NAME}
COGNITIVE_DEPLOYMENT_NAME=${COGNITIVE_DEPLOYMENT_NAME}
SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}

# Resource IDs
RESOURCE_GROUP_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}"
COGNITIVE_ACCOUNT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.CognitiveServices/accounts/${COGNITIVE_ACCOUNT_NAME}"
COGNITIVE_DEPLOYMENT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.CognitiveServices/accounts/${COGNITIVE_ACCOUNT_NAME}/deployments/${COGNITIVE_DEPLOYMENT_NAME}"

# Check and import resources
if resource_exists "${RESOURCE_GROUP_ID}"; then
  import_resource "azurerm_resource_group" "example" "${RESOURCE_GROUP_ID}"
else
  echo "Resource ${RESOURCE_GROUP_ID} does not exist. Skipping import."
fi

if resource_exists "${COGNITIVE_ACCOUNT_ID}"; then
  import_resource "azurerm_cognitive_account" "example" "${COGNITIVE_ACCOUNT_ID}"
else
  echo "Resource ${COGNITIVE_ACCOUNT_ID} does not exist. Skipping import."
fi

if resource_exists "${COGNITIVE_DEPLOYMENT_ID}"; then
  import_resource "azurerm_cognitive_deployment" "example" "${COGNITIVE_DEPLOYMENT_ID}"
else
  echo "Resource ${COGNITIVE_DEPLOYMENT_ID} does not exist. Skipping import."
fi