---
layout: post
title: "How to set up Minimal Mistakes theme for GitHub Pages"
date: 2021-10-03 21:38:53 +0200
categories: GitHub Jekyll
image1: /assets/images/2021-10-03-how-to-set-up-minimal-mistakes-theme-for-github-pages/dummy.png
---

[Christian Posta]:https://blog.christianposta.com/theme-setup/
[Quick-Start Guide]:https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/

<img src="{{ page.image1 | relative_url }}" alt="dummy" width="100"/>


## New Jekyll site with MM (Minimal Mistakes) theme

See [Christian Posta's blog post][Christian Posta]{:target="_blank"}.

1. Fork MM's repo, rename the forked repo 

2. Clone the forked repo

3. Install required Gems

Create a new `Gemfile`

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

Run 

```
bundle install
```


4. Remove unnecessary file

See [MM quick-start guide][Quick-Start Guide]{:target="_blank"}.

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
