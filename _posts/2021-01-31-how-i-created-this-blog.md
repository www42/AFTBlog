---
layout:     post
title:      "How I created this blog"
date:       2021-01-31 17:30:00 +0100
categories: Jekyll GitHub-Pages VS-Code
image1:      /assets/images/2021-01-31-how-i-created-this-blog/create-repo.png
image2:      /assets/images/2021-01-31-how-i-created-this-blog/brand-new-blog.png
image3:      /assets/images/2021-01-31-how-i-created-this-blog/github-settings-section.png
image4:      /assets/images/2021-01-31-how-i-created-this-blog/enable-github-pages.png
image5:      /assets/images/2021-01-31-how-i-created-this-blog/github-pages-url.png
---

[jekyll-home]: https://jekyllrb.com/
[vscode-home]: https://code.visualstudio.com/
[githubpages-home]: https://pages.github.com/


| | Software I used to create this blog
| -------------- | --------------------------------- |
| Editor         | [Visual Studio Code][vscode-home] |
| -------------- | --------------------------------- |
| Site generator | [Jekyll][jekyll-home]             |
| -------------- | --------------------------------- |
| Hosting        | [GitHub Pages][githubpages-home]  |



# Meet prerequisites

* Be sure Jekyll is running locally

```bash
ruby --version
bundle --version
jekyll --version
```

* Create a new empty repo on GitHub

![create repo]({{ page.image1 | relative_url }})

# Create new Jekyll blog site

Clone the repo to a local folder. Inside that folder `jekyll new .` produces a file structure:

```bash
git clone https://github.com/www42/AFTBlog.git
cd AFTBlog
jekyll new .
```

The new file structure contains 
* configuration files for the new site (basically `Gemfile` and `_config.yml`)
* content files for the new site (`index.markdown` and `about.markdown`)
* the first post (`2021-01-31-welcome-to-jekyll.markdown`) in the `_posts` folder

The web site does not yet exist.

To generate the web site run

```bash
bundle exec jekyll serve --livereload
```

**Note!** If you receive an error message `cannot load such file -- webrick (LoadError)` add the following line to your `Gemfile`

```bash
gem "webrick"
```

and update your gems

```
bundle update
```


Now a brand new site was generated in folder `_site` and a web service starts up at http://localhost:4000

![brand new site]({{ page.image2 | relative_url }})


Commit the changes to your local git repo and push it to GitHub

```shell
git add -A
git commit -m "my brand new blog site"
git push
```

To activate GitHub Pages go to the `Settings` sections of your GitHub repo

![github settings section]({{ page.image3 | relative_url }})

and set the root directory of the master branch as source of GitHub Pages.

![enable github pages]({{ page.image4 | relative_url }})

After a few seconds your blog site is live at the URL shown in the `Settings` section.

![github pages url]({{ page.image5 | relative_url }})



👍 Congratulations! Your site is up and running.


# Basic configuration

Edit your `Gemfile`

```bash
#gem "jekyll", "~> 4.2.0"
gem "github-pages", group: :jekyll_plugins
```

```bash
bundle update
```

Edit your `_config.yml`

```bash
title:              Azure for Trainers Blog
email:              thomas.jaekel@gfn.training
description:        This is the world-famous Azure for Trainers blog site. Have fun!
twitter_username:   tjkkll
github_username:    www42
baseurl:            "/AFTBlog"
url:                "https://www42.github.io"

# Fields minima uses, but are not defaulted by `jekyll new`
author:             Thomas Jäkel
linkedin_username:  tjkkll
```

**Note!** Changes in `_config.yml` are **not** recognized by `bundle exec jekyll serve --livereload`

```bash
bundle exec jekyll serve --livereload
```

Edit your `about.md`

👍 Congratulations! You have a basic blog site on the Internet!
