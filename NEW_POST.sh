# Be sure you are in the right directory.
# List previos posts
ls -l _posts

# Now create
#    a new postfile (markdown)
#    a new directory for all images belonging to this post

today=$(date +"%Y-%m-%d")
fulldate=$(date +"%Y-%m-%d %T %z")

title='"Azure Static Web Apps"'
title2="$today-azure-static-web-apps"

categories="Azure Cloud Web"

imagedir="assets/images/$title2"
mkdir $imagedir
touch $imagedir/.git_keep

postfile="_posts/$title2.md"
echo "---"                           > $postfile
echo "layout: post"                 >> $postfile
echo "title: $title"                >> $postfile
echo "date: $fulldate"              >> $postfile
echo "categories: $categories"      >> $postfile
echo "image1: /$imagedir/dummy.png" >> $postfile
echo "---"                          >> $postfile
echo ""                             >> $postfile
echo "## How it works"              >> $postfile
echo ""                             >> $postfile
echo '<img src="{{ page.image1 | relative_url }}" alt="dummy" width="900"/>' >> $postfile
echo ""                             >> $postfile


cat $postfile

# Next steps:
#    * Edit the postfile
#    * Save images to imagedir
#    * (If local jekyll available) bundle exec jekyll serve