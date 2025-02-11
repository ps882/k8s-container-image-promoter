#!/usr/bin/env bash

# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is meant to be used from inside the
# gcr.io/k8s-testimages/kubekins-e2e image when running the promoter's e2e test
# (e2e.go) as part of a Prow presubmit job. Because this script is so
# bare-bones, we choose to just run it instead of creating a custom Docker image
# that already has the setup logic in it. This way, we avoid having to
# build/maintain a separate e2e environment image of our own.

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

SCRIPT_ROOT=$(dirname "$(readlink -f "$0")")

# Turn on experimental Docker features. This enables the "docker manifest"
# subcommand.
mkdir -p $HOME/.docker
echo '{"experimental":"enabled"}' > $HOME/.docker/config.json

# Make Docker use gcloud as a credential helper when pushing to GCR.
gcloud auth configure-docker --quiet

# Invoke the e2e test!
make -C "${SCRIPT_ROOT}/.." test-e2e
