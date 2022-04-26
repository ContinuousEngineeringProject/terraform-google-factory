#!/usr/bin/env bash
#
# Script to release a new Terraform Module version.

# ToDo: re-write the release script

if [ -n "$(git status --porcelain)" ]; then
  echo -e "\nError, repository dirty, please commit or stash your changes.\n"
  exit 1
fi

NEW_VERSION=$(grep '##' CHANGELOG.md | head -n 1 | cut -d' ' -f2)
NEW_RELEASE_NAME=v$NEW_VERSION
CURRENT_RELEASE_NAME=$(git describe --abbrev=0 --tags)

if [ "$NEW_RELEASE_NAME" == "$CURRENT_RELEASE_NAME" ]; then
  echo -e "\nLatest version already released.\n"
  echo -e "If this is not so, make sure CHANGELOG.md is updated as necessary.\n"
  exit 1
fi

echo -e "\nUpdating usage examples in README to use $NEW_RELEASE_NAME and commiting...\n"

sed -i.bak -e "s/$CURRENT_RELEASE_NAME/$NEW_RELEASE_NAME/g" README.md && rm README.md.bak

git checkout main && \
  git add README.md && \
  git commit -m "Update usage examples in README to use $NEW_RELEASE_NAME." > /dev/null 2>&1

echo -e "Releasing $NEW_RELEASE_NAME...\n"

git tag -a "$NEW_RELEASE_NAME" -m "$NEW_RELEASE_NAME" && \
  git push origin main --verbose && \
  git push origin "$NEW_RELEASE_NAME" --verbose