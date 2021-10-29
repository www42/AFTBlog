---
layout: post
title: "How to set up Minimal Mistakes theme for GitHub Pages"
date: 2021-10-03 21:38:53 +0200
categories: GitHub Jekyll
image1: /assets/images/2021-10-03-how-to-set-up-minimal-mistakes-theme-for-github-pages/Enable-GHPages-for-Repo.png
---

[Christian Posta]:https://blog.christianposta.com/theme-setup/
[Quick-Start Guide]:https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/



## Set up a new site with Minimal Mistakes (MM) theme

See [Christian Posta's blog post][Christian Posta]{:target="_blank"}.

* Fork [MM's repo](https://github.com/mmistakes/minimal-mistakes){:target="_blank"}, optional: Rename the forked repo 

* Enable GH Pages for the forked repo

<img src="{{ page.image1 | relative_url }}" alt="Enable GH Pages for repo" width="900"/>

* Clone the forked repo



* Create a new `Gemfile`

```
source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins

gem "jekyll"
gem "minimal-mistakes-jekyll"

# The following plugins are automatically loaded by the theme-gem:
#   gem "jekyll-paginate"
#   gem "jekyll-sitemap"
#   gem "jekyll-gist"
#   gem "jekyll-feed"
#   gem "jekyll-include-cache"
#
# If you have any other plugins, put them here!
group :jekyll_plugins do
end
```

* Optional: Install required Gems for local testing

Run 
```
bundle install
```


* Remove unnecessary file

See [MM quick-start guide][Quick-Start Guide]{:target="_blank"}. Remove these files and folders

```
/docs
/test
.editorconfig
.gitattributes
README.md
CHANGELOG.md
minimal-mistakes-jekyll.gemspec
screenshot.png
screenshot-layouts.png
```

* Optional: Test site locally

```
bundle exec jekyll serve
```


* Commit changes to GitHub repo


## Configuration

### _config.yaml


## Migrate existing blog posts to MM

Change the layout declaration
```
layout: post
```
into
```
layout: posts
```
