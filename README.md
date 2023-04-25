# replace git cache to store new PAT:
git config --global --replace-all credential.helper cache

# salary changes
https://mijn.toeslagen.nl/Overzicht
# get the latest commit id
git rev-parse HEAD
# get the files changed in a commit id
git diff-tree --no-commit-id --name-only 552544e9cde70269e37784aff2e62dd97420b862 -r
# config git variables
git config --global user.email "email id" 

git config --global user.name "Yuvraj Singh"
# exit the bash scrit if there is any error in command output
set -ex
