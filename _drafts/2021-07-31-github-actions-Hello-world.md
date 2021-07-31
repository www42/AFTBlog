---
layout: post
title: "GitHub Actions - Hello World!"
date: 2021-07-31 15:17:37 +0200
categories: GitHub CI/CD Automation
image1: /assets/images/2021-07-31-github-actions-Hello-world/overview-actions-design.png
image2: /assets/images/2021-07-31-github-actions-Hello-world/GH-Actions-Hello-World.png
---

[GitHub Actions Docs]:https://docs.github.com/en/actions/learn-github-actions
[GitHub Actions Docs Intro]:https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions
[Wokflow Syntax]:https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions
[Usage limits]:https://docs.github.com/en/actions/reference/usage-limits-billing-and-administration
[Learning Path]:https://docs.microsoft.com/en-us/learn/paths/automate-workflow-github-actions

## Vocabulary

* A **Workflow** is a yaml file inside a GitHub repository.
  * A Workflow consists of one or more **Jobs**.
    * A Job includes of one or **Steps**.
      * A Step runs commands. You can use ready to use **Actions** from a marketplace.
  * A Job is running in a (Docker) container called **Runner**.
* A Workflow is triggered by an **Event**.


<img src="{{ page.image1 | relative_url }}" alt="GH Actions overview" width="400"/>

(Image from the [Docs][GitHub Actions Docs Intro]{:target="_blank"}.)

## Further details

* To create a GitHub Action you have to write a yaml file in `.github/workflows/` folder. The path is crucial. Every yaml file in `.github/workflows/` is interpretated as GitHub Action. A yaml file ouside this folder is only a yaml file.

* You can find the syntax  reference for GitHub Actions [here][Wokflow Syntax]{:target="_blank"}.

* "Hello World" works like this:

{% highlight yaml linenos %}
name: helloWorld
on:
  workflow_dispatch:

jobs:
  build:
    name: My first job
    runs-on: ubuntu-latest

    steps:
      - name: Run a one line script
        run:  echo "Hello World!"
{% endhighlight %}

<img src="{{ page.image2 | relative_url }}" alt="GH Actions Hello World" width="800"/>

## About costs

GitHub Actions usage is fairly for free. There are limits, see [Usage limits, billing, and administration][Usage limits]{:target="_blank"}.

## Learn more

[GitHub Actions Docs][GitHub Actions Docs]{:target="_blank"}

[Automate your workflow with GitHub Actions - Microsoft Learn Learning Path][Learning Path]{:target="_blank"}