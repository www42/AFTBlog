---
layout:     post
title:      "JMESPath Queries"
date:       2021-01-21 17:30:00 +0100
categories: Azure CLI JMESPath
image1:     assets/images/2021-01-21-jmespath-queries/jpterm.png
image2:     assets/images/2021-01-21-jmespath-queries/array-vs-object.png
---

[ms-docs]:        https://docs.microsoft.com/en-us/cli/azure/query-azure-cli
[azure-citadel]:  https://azurecitadel.com/prereqs/cli/cli-3-jmespath/
[jmespath]:       https://jmespath.org/
[jpterm]:         https://github.com/jmespath/jmespath.terminal


**JMESPath queries are very useful to filter Azure CLI output.**

This post is an excerpt of:
* [Query command results with Azure CLI - Microsoft Docs][ms-docs]
* [CLI 2.0 JMESPATH - Azure Citadel][azure-citadel]

For a complete language specification see [JMESPath.org][jmespath].


### In the JSON world ...

...there are two kinds of things - lists and objects:

  <img src="{{ page.image2 | relative_url }}" alt="array vs. object" width="800"/>


In Azure CLI a `list` command will produce a list, whereas a `show` command will show an object. Often a list is a list of objects.

JSON is the default format of Azure CLI outputs. Therefore it's a common need to filter JSON outcome. The global `--query` parameter accepts JMESPath queries only.

Let's have a look to JMESPath queries.

### Selecting values

```bash
az group show -g $rg    # single object with several key:value pairs

az group show -g $rg --query "name"                          # single value
az group show -g $rg --query "[name,location]"               # two values, output is formatted as a list
az group show -g $rg --query "{foo:name,bar:location}"       # two values, output is formatted as an object, 
                                                             # keys are required, just added 'foo' and 'bar'
az group show -g $rg --query "{name:name,location:location}" # More convinient keys.

```

### Selecting objects from the list

```bash
az group list                       # list of all objects, i.e. resource groups

az group list --query "[0]"         # first object
az group list --query "[1]"         # second object
az group list --query "[-1]"        # last object
az group list --query "[0:2]"       # first to second object,[a:b]  slicing from a to b-1  (sic!)
az group list --query "[*]"         # all objects
az group list --query "[]"          # all objects but flatten them, see below

```


### Combine it with `.` operator

```bash
az group list --query "[0].name"
az group list --query "[*].[name,location]"
az group list --query "[].{name:name,location:location}"

```

### Advanced: Filter objects with projection operator  `?key=='value'`

```bash
az group list --query "[?name=='foo']"
az group list --query "[?name=='foo' && location=='westeurope']"  #  &&    logical AND
                                                                  #  ||    logical OR
```                                                                            

What other comapators do exist?

`==`  equal

`!=`   not equal

`>`   greater then (numeric values only)

etc.



### Even more advanced: Functions

```bash
# length()
az group list --query "length([*])"                         # number of elements

# starts_with()
az group list --query "[?starts_with(name, 'Cloud')].name"
az group list --query "[?ends_with(name, '-RG')].name"
az group list --query "[?contains(name, 'e')].name"

# sort()    --> Sorting array  
az group list --query "sort([*].name)"
az group list --query "reverse(sort([*].name))"


# sort_by() --> Sorting array of objects       
az group list --query "sort_by([*], &name)"
az group list --query "reverse(sort_by([*], &name))"


# Pipe Expressions
az group list --query "[?name=='Cloudshell-RG'].name"           # array of a single string
az group list --query "[?name=='Cloudshell-RG'].name | [0]"     # string
```


### Flatten Operator `[]`

Example 1

```json
[
    1,2,[3,[4,5],6],7,[8,9]
]
```

```bash
#   [*]       [1,2,[3,[4,5],6],7,[8,9]]
#   []        [1,2,3,[4,5],6,7,8,9]
#   [][]      [1,2,3,4,5,6,7,8,9]
```


Example 2
```json
{
    "foo": [
      { "numbers": [1,2,3] },
      { "numbers": [4,5,6] }
    ]
}
```


```bash
#   foo[*]                          [{n:[1,2,3]},{n:[4,5,6]}]
#   foo[*].numbers                  [[1,2,3],[4,5,6]]
#   foo[*].numbers.[]               [1,2,3,4,5,6]
```

### Tipps

***Tipp 1:*** 
*Use variable to store complex queries*

```bash
query="[*].{name:name,location:location}"
az group list --query $query
```


***Tipp 2:*** 
*Format output as table in conjuction with queries*

```bash
az ... list --query ... --output table
```


***Tipp 3:*** 
*Try* `jpterm` *Great tool for exploring JMESPath queries.*

<img src="{{ page.image1 | relative_url }}" alt="jpterm" width="800"/>
