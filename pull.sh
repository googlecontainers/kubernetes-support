#!/bin/bash
# curl  https://api.github.com/orgs/googlecontainers/repos?access_token=760cc6977d6631e8ef06cf5dbb8374ce1c43aa28
#imageRepos=`curl https://api.github.com/orgs/googlecontainers/repos?access_token=760cc6977d6631e8ef06cf5dbb8374ce1c43aa28 | jq -r '.[].name'`

curl -LO https://raw.githubusercontent.com/mclarkson/JSONPath.sh/master/JSONPath.sh
chmod +x JSONPath.sh
mv -f JSONPath.sh ~bin

imageRepos=`curl https://api.github.com/orgs/googlecontainers/repos?access_token=0c465edc7c178cd73fdf1d3683b061eebfea1aac | JSONPath.sh '.[*].name' -b`

for repo in $imageRepos;
do
  git clone "https://github.com/googlecontainers/"$repo".git"
  cd $repo
  tags=`git tag`
  for tag in $tags;
  do
    imageCoordinate="guglecontainers/"$repo:$tag
    docker pull $imageCoordinate
    googleCoordinate="gcr.io/google_containers/"$repo:$tag
    docker tag $imageCoordinate $googleCoordinate
  done
  cd ..
done
