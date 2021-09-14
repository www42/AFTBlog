# Be sure you are in the right directory.
# List previos posts
tree -FL 1
ls -l _posts
ls -l _drafts

# Now create
#    a new postfile (markdown)
#    a new directory for all images belonging to this post

today=$(date +"%Y-%m-%d")
fulldate=$(date +"%Y-%m-%d %T %z")

title='"Loops in ARM Templates"'
title2="$today-loops-in-arm-templates"

categories="Azure ARM Automation"

imagedir="assets/images/$title2"
mkdir $imagedir
touch $imagedir/.git_keep

postfile="_drafts/$title2.md"
# postfile="_posts/$title2.md"

echo "---"                                                                    > $postfile
echo "layout: post"                                                          >> $postfile
echo "title: $title"                                                         >> $postfile
echo "date: $fulldate"                                                       >> $postfile
echo "categories: $categories"                                               >> $postfile
echo "image1: /$imagedir/dummy.png"                                          >> $postfile
echo "---"                                                                   >> $postfile
echo ""                                                                      >> $postfile
echo "[Microsoft Docs]:https://docs.microsoft.com/en-us/"                    >> $postfile
echo ""                                                                      >> $postfile
echo "## How it works"                                                       >> $postfile
echo ""                                                                      >> $postfile
echo '[See documentation.][Microsoft Docs]{:target="_blank"}'                >> $postfile
echo ""                                                                      >> $postfile
echo '[<img src="{{ page.image1 | relative_url }}" alt="dummy" width="900"/>][Microsoft Docs]{:target="_blank"}' >> $postfile
echo ""                                                                      >> $postfile


cat $postfile

# Next steps:
#    * Edit the postfile (Markdown)
#    * Save images to imagedir
#    * Test it locally: bundle exec jekyll serve 
#                       bundle exec jekyll serve --drafts