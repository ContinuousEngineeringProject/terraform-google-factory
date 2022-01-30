#!/usr/bin/env bash
#
# Script to release a new Terraform Module version.

# ToDo: re-write the release script

set -e

if [ -z "$GH_TOKEN" ]
then
    echo "A valid GitHub token must be set via the environment variable GH_TOKEN"
    exit 1
fi

docker run -w /app --rm -v $(pwd):/app -e GH_TOKEN=$GH_TOKEN semantic-release/semantic-release:19.0.0-beta.2 -r https://github.com/ContinuousEngineeringProject/terraform-google-factory --no-ci