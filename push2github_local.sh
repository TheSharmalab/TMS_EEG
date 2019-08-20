#!/bin/bash


# This pushes the content of the repository directory back onto github
# must be ran from the repository directory using the command   ./push2github_local.sh
# If you alter this remember to make the file executable with   chmod a+x push2github_local.sh


pwd
git add --all
git commit -m "updated"
git push origin master

