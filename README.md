# Terraform module for Azure Prerequisites - Cosmo Tech Platform >= v2.3.5

## Description

This documentation describes the Azure prerequisite infrastructure deployed to install the Cosmo Tech Simulation Platform using Terraform. This module creates Azure resources, app registrations and specific Cosmo Tech Simulation Platform roles. Here is the detail of the resources created

* Azure Virtual Network for AKS (with one subnet, range /26)
* Azure public IP for the Cosmo Tech Platform
* Azure DNS record (type A on Public IP)

* Azure App Registration for the Cosmo Tech Platform
  * Authentication
    * Supported account types: Single tenant
    * Platform configurations: 
      * Type: Web
      * Redirect URIs: `platform-api-url`/v2/swagger-ui/oauth2-redirect.html (e.g. https://lab.api.cosmo-platform.com/v2/swagger-ui/oauth2-redirect.html)
  * Secrets
    * Create and save a secret
  * Expose an API
    * Add a scope
      * Application ID URI: keep default value, should be `api://app-registration-client-id`
      * Scope name: `platform`
      * Who can consent: `Admins and users`
      * Admin consent display name: `Cosmo Tech Platform Impersonate`
      * Admin consent description: `Allow the appication to use the Cosmo Tech Platform with user account`
  * Manifest
    * In the manifest, replace appRoles property value with the [app-roles.json file](app-roles.json)
  * API permissions
    * API: `Microsoft Graph`
      * Permission name: `User.Read`
      * Type: `Delegated`
      * Admin consent required
    * API: `Azure App Registration for the Cosmo Tech Platform`
      * Permission name: `Platform.Admin`
      * Type: `Application`
      * Admin consent required
* Azure App Registration for AKS Network (previously used for ADT authentication)
  * Secrets
    * Create and save a secret
  * Role assignments
    * `Contributor` on the Public IP
    * `Network contributor` ont he Virtual Network
* Azure App Registration for Cosmo Tech API Swagger UI
  * Authentication
    * Supported account types: Single tenant
    * Platform configurations: 
      * Type: Single-Page Application
      * Redirect URIs: `platform-api-url`/v2/swagger-ui/oauth2-redirect.html (e.g. https://lab.api.cosmo-platform.com/v2/swagger-ui/oauth2-redirect.html)
  * API permissions:
    * API: `Microsoft Graph`
      * Permission name: `User.Read`
      * Type: `Delegated`
      * Admin consent required
    * API: `Azure App Registration for the Cosmo Tech Platform`
      * Permission name: `platform`
      * Type: `Delegated`
      * Admin consent required
* Azure App Registration for WebApp
  * Authentication
    * Supported account types: Single tenant
    * Platform configurations: 
      * Type: Single-age Application
      * Redirect URIs: 
        * `web-app-url`/sign-in (e.g. https://app.cosmo-platform.com/sign-in)
        * http://localhost:3000/sign-in
  * API permissions:
    * API: `Microsoft Graph`
      * Permission name: `User.Read`
      * Type: `Delegated`
      * Admin consent required
    * API: `Azure App Registration for the Cosmo Tech Platform`
      * Permission name: `platform`
      * Type: `Delegated`
      * Admin consent required
  * Depending on Power BI Authentication mode
    * If authentication based on service principal and application secret
      * Secrets
        * Create and save a secret
    * If authentication based on user credentials
      * API: `Power BI Service`
        * Permission name: `Workspace.Read.All` and `Reports.Read.All`
        * Type: `Delegated`
        * Admin consent required

## How to deploy Azure prerequisites with Terraform

You can use this module or reference it in your Terraform configuration

### Run in local

There are two authentication modes for runnning this Terraform module in local:

#### Option 1: Azure user identity

##### Requirements

- Connect to Azure CLI with `az login`
- Install [Terraform Cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your machine
- Have the following Assigned roles on Active Directory:
  - Application Administrator
  - Groups Administrator
- Subscription Owner

##### Commands and steps to run the Terraform script

- [ ] Reference this module and the required version in your Terraform configuration file
- [ ] Ensure you have the right Azure AAD roles; we advise to have `Application Administrator`
- [ ] Login throw Azure Cli `az login`
- [ ] Edit file `terraform.tfvars` with mandatory values (see terraform variables documentation below)
- [ ] Init the terraform by running `terraform init`
- [ ] Validate the terraform by running `terraform validate`
- [ ] Plan the terraform by running `terraform plan`
- [ ] End with applying the terraform by running `terraform apply`, reply `yes` for the terraform prompt to confirm Resources creation.


#### Option 2: Azure App registration

##### Requirements

The requirements are the same as for the Azure user identity, except that you need to create an Azure App registration with the following API permissions:

Create an app registration for Terraform with the following API permissions:

[Azure Active Directory for the Terraform azuread provider.](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) to create Azure application registration, roles and role assignments in Azure Active Directory

- `Application.ReadWriteAll`

- `Group.ReadWriteAll`

- `User.ReadAll`

To give these API permissions to the app registration, go to `API Permission` >> `Add a permission` >> `Azure Active Directory Graph` >> `Application.ReadWrite.All` >> `Delegated Permissions` >> `Add permissions` repeat the same for `Group.ReadWrite.All`

Then you have to grant admin consent for the app registration, go to `API Permission` >> `Grant admin consent for <your tenant name>` >> `Yes`

[Azure subscription for the Terraform azurerm provider.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) :  to create Azure resources :

- `Subscription Owner`

To grant this IAM permission to the app registration, go `subscription` >> `access control (IAM)` >> `Add` >> `Add role assignment` >> `Owner` >> Choose your app registration name >> `Select` >> `Save`

> **_NOTE:_**  Cloud Application Administrator or Application Administrator, for granting consent for apps requesting any permission for any API, except Azure AD Graph or Microsoft Graph app roles (application permissions) such as User.ReadAll. It means that you can't grand admin consent on Active Directory Application witch have Microsoft Graph app roles if your don't have the role Global Admin in the tenant.


##### Commands and steps to run the Terraform script


- [ ] Reference this module and the required version in your Terraform configuration file
- [ ] Ensure you have the right Azure AAD roles; we advise to have `Application Administrator`
- [ ] Create your own Azure App registration with the right Azure AAD roles
- [ ] Add a secret to your Azure App registration
- [ ] Set the following environment variables with the values of your Azure App registration or set `*__` values in `terraform.tfvars` file
- [ ] Edit file `terraform.tfvars` with mandatory values (see terraform variables documentation below)
- [ ] Init the terraform by running `terraform init`
- [ ] Validate the terraform by running `terraform validate`
- [ ] Plan the terraform by running `terraform plan`
- [ ] End with applying the terraform by running `terraform apply`, reply `yes` for the terraform prompt to confirm Resources creation.


### Run with terraform cloud

Terraform cloud run require using of a service principals (Azure Application registration ) configured as seen for the local run. You have to set up the same variables.
The new requirement is a terraform cloud Account.

- [ ] Create a terraform cloud account
- [ ] Create a new workspace in terraform cloud
- [ ] Choose `Version control workflow` and select `Github`
- [ ] Select your Github account and the repository containing your Terraform configuration
- [ ] Select `Terraform v1.3.9` as terraform version
- [ ] Set the `terraform.tfvars` file as `Terraform Variables` (see terraform variables documentation below)
- [ ] Fill the `Terraform Variables` with required `___**` values
- [ ] Start a new run on the workspace

The output of the terraform cloud workspace will be the Azure Active Directory Application ID and the Azure Active Directory Application Secret, inspect the output file ```terraform.tfstate``` to get theses values.

See more about Terraform Cloud : [What is Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs)

### Post deployment manual actions

#### Azure Active Directory Application

After the deployment, you have to grant admin consent for the Azure Active Directory Application created by the terraform script.

Go to Azure Portal and select the Azure Active Directory Application created by the terraform script, then select `API Permissions` and `Grant admin consent for <your tenant name>`.

You also need to add required identifier URI for the Azure Active Directory Application created by the terraform script. Go to Azure Portal and select the Azure Active Directory Application created by the terraform script, then in overview tab, select `Add a Redirect URI` and add the following URI: `api://<the created app id>`.

## Azure Prerequisites Terraform Variables

| Description                  | Description                                                                    | Mandatory             | Type         | HCL   | Default             | Example                            |
| ---------------------------- | ------------------------------------------------------------------------------ | --------------------- | ------------ | ----- | ------------------- | ---------------------------------- |
| **location**                 | The Azure resources location                                                   | No                    | String       | false | West Europe         | West Europe                        |
| **tenant_id**                | The customer tenant id                                                         | Yes                   | String       | false |                     |                                    |
| **subscription_id**          | The customer subscription id                                                   | Yes                   | String       | false |                     |                                    |
| **client_id**                | The application registration created to run terraform object id                | Yes For Azure App reg | String       | false |                     |                                    |
| **client_secret**            | The application registration secret value                                      | Yes For Azure App reg | String       | false |                     |                                    |
| **platform_url**             | The Cosmotech Platform API Url                                                 | Yes                   | String       | false |                     | https://lab.api.cosmo-platform.com |
| **api_version_path**         | The API version path (Ex: /v2/)                                                | No                    | String       | false | "/"                 | /v2/                               |
| **project_stage**            | The project stage (Dev, Prod, QA,...)                                          | Yes                   | String       | false |                     |                                    |
| **customer_name**            | The Customer name                                                              | Yes                   | String       | false |                     |                                    |
| **project_name**             | The Project name                                                               | Yes                   | String       | false |                     |                                    |
| **resource_group**           | The new resource group to use for the platform deployment to create            | Yes                   | String       | false |                     | rg-myrg                            |
| **owner_list**               | The list of AAD user which will be owner of the deployment resource group | Yes                   | list[String] | true  |                     | ["user.foo@mail.com"]              |
| **audience**                 | The App Registration audience type                                             | No                    | String       | false | AzureADMultipleOrgs |                                    |
| **webapp_url**               | The Web Application URL                                                        | No                    | String       | false |                     | https://project.cosmo-platform.com |
| **dns_zone_name**            | The Azure DNS Zone name                                                        | Yes                   | String       | false |                     | api.cosmo-platform.com             |
| **dns_zone_rg**              | The resource group witch contain the Azure DNS Zone                            | Yes                   | String       | false |                     |                                    |
| **dns_record**               | The DNS zone name to create platform subdomain. Example: myplatform            | Yes                   | String       | false |                     | projectname                        |
| **create_restish**           | Create the Azure Active Directory Application for Restish ?                    | No                    | bool         | false | true                |                                    |
| **create_webapp**            | Create the Azure Active Directory Application for Webapp ?                     | No                    | bool         | false | true                |                                    |
| **create_powerbi**           | Create the Azure Active Directory Application for Power BI ?                   | No                    | bool         | false | true                |                                    |
| **create_publicip**          | Create the public IP for the platform ?                                        | No                    | bool         | false | true                |                                    |
| **create_dnsrecord**         | Create the Azure DNS record ?                                                  | No                    | bool         | false | true                |                                    |
| **create_vnet**              | Create the Virtual Network for AKS ?                                           | No                    | bool         | false | true                |                                    |
| **create_secrets**           | Create secrets for Azure Active Directory Applications ?                       | No                    | bool         | false | true                |                                    |
| **vnet_iprange**             | The Virtual Network IP range                                                   | Yes                   | String       | false |                     | 10.48.0.0/26                       |
| **azuread_application_tags** | Common tags for AZ AD application                                              | Yes                   | list[String] | true  |                     | ["AI","Simulation"]                |
| **common_tags**              | Common tags for AZ AD service principal                                        | No                    | list[String] | true  | Yes                 | ["AI","Simulation"]                |

