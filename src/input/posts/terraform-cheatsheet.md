Title: Terraform 101
Published: 5/12/2020
Tags:
    - Terraform
    - Cheatsheet
    - Draft
---

### Files
- **main.tf** - resource definition, main logic
- **data.tf** - data from existing resources
- **output.tf** - data output
- **terraform.tf** - terraform settings
- **variables.tf** - variables definition
- **terraform.tfvars** and ***.auto.tfvars** - variable initialization

### Variables

- [Official documentation page](https://www.terraform.io/docs/configuration/types.html)
- Can be defined in files like **terraform.tfvars** or ***.auto.tfvars**
- You can use any name for **tfvars** file by using **-var-file** option of **terraform apply**
- Variables can be passed directly to **terraform apply** by using **-var "varaible=value"** (multiple instances of **-var** can be used to pass multiple variables)
- Any environment variable which starts with **TF_VAR_** gets treated by Terraform like a variable

#### Syntax
```terraform
# String variable with validation
variable "string_variable" {
    type        = string
    description = "String variable is a sequence of Unicode characters"
    validation  {
        condition = length(regexall("^(Expected|Values)", var.variable_name)) == 1
        error_message = "Variable must be set with expected value"
    }
}
```
```terraform
# Bool variable
variable "bool_variable" {
    type        = bool
    description = "Bool variable either true or false and values can be used in conditional logic"
    default     = true
}
```
```terraform
# Number variable
variable "number_variable" {
    type        = number
    description = "Number variable type can represent both whole and fractional"
}
```
```terraform
# Number variable
variable "list_variable" {
    type        = list(<type>)
    description = "List variable accepts any element type as long as every element is the same type"
}
```
```terraform
# Map variable
variable "map_variable" {
    type        = map
    description = "Map variable a collection of values where each is identified by a string label"
    default     = {
        key1    = "value"
        key2    = 43
        key3    = ("1","2","3")
        key4    = {
            subkey1 = "sample"
            subkey2 = "value"
        }
    }
}
```
#### Local variables
```terraform
# Local variables
# To use local variable you have to prefix its name with local. instead of var. e.g. local.local_string_variable
locals {
  local_string_variable = "test"
}
```

### Conditionals

```terraform
# CONDITION ? TRUEVAL : FALSEVAL

# Operators:
#  - Equality: == and !=
#  - Comparison: >, <, >= and <=
#  - Logic: &&, || and unary !

# Set resource option value based on variable value 
resource "sample_resource" "this" {
    option = var.test == "value" ? 1 : 0
}

# Conditional resource creation
resource "another_sample_resource" "this" {
    count = var.create_another_sample_resource ? 1 : 0
}
```

### Useful links
- https://www.terraform-best-practices.com/
- https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9