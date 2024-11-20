# Azure terraform modules

## Prerequisites

Install required software:
* [Docker](https://docs.docker.com/engine/install/)
* Python3 with [invoke](https://www.pyinvoke.org/) module (for Linux users)

## Development environment

For terraform modules development purpose you should spin up local development environment.  

### Windows

For Windows users the instruction is simple: 
* install docker desktop;
* build docker image from Dockerfile;
* run container and mount repository code folder into it.

### Linux

For Linux users we prepared wrapper that will do all the job.

#### Build

Build docker image
```
    $ cd "${INFRA_DIR}"
    $ inv docker.image.build
```

#### Run

Create and run docker container
```
    $ inv docker.container.create
```

#### Connect

Get container status and `name`
```
    $ inv docker.container.status
```

Connect to the container
```
    $ docker exec -ti <name> bash
```

#### Turnkey solution

To do all the above actions with a single command
```
    $ inv docker.up
```

## Modules development

### Convention

* Module requirements:
  * `tags` argument(if supported by resource), as the last real argument, followed by `depends_on` and `lifecycle`(if necessary), separated by a single empty line; 
  * `count`/`for_each` inside resource or data source block as the first argument at the top and separated by newline after it;
  * test coverage in format of simple `example` folder in which:
    * all depended objects should be declared as `resource` block type;
    * different variation of module usage can have sub-example folders(if no backward capabilities);
  * files:
    * `main.tf` - module resources;
    * `output.tf` - module outputs;
    * `variables.tf` - module variables.
  * run `terraform fmt -recursive` on module folder after finish

### Sample

As an example we will create `Event Grid topic` module.

Workflow:

1. Create new folder `event_grid_topic`
2. Add required files:

```
   $ cat main.tf
   
   resource "azurerm_eventgrid_topic" "this" {
      name                = var.name
      location            = var.location
      resource_group_name = var.resource_group_name
      tags                = var.tags
   }
```

```
   $ cat variables.tf

   variable "name" {
       type        = string
       description = "Resource name"
   }
   
   variable "location" {
       type        = string
       description = "Azure region"
   }
   
   variable "resource_group_name" {
       type        = string
       description = "Resource group name"
   }
   
   variable "tags" {
       type        = map(string)
       description = "Resource tags"
   }
```

```
   $ cat output.tf
   output "id" {
       value       = azurerm_eventgrid_topic.this.id
       description = "Resource ID"
   }
   
   output "name" {
       value       = azurerm_eventgrid_topic.this.name
       description = "Resource name"
   }
```

3. Add `example` folder with related use cases (use `apim` module example folder as a base template)

```
$ tree example/
example/
├── locals.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars.json
└── variables.tf
```

4. Fix possible formatting issues
```
  $ inv tools.fmt     # Or 'terraform fmt -recursive <module_folder>' in case of Windows user
```
