#!/usr/bin/env bash

# PLEASE NOTE: This script has been automatically generated by conda-smithy. Any changes here
# will be lost next time ``conda smithy rerender`` is run. If you would like to make permanent
# changes to this script, consider a proposal to conda-smithy so that other feedstocks can also
# benefit from the improvement.

set -xeuo pipefail
export PYTHONUNBUFFERED=1
export FEEDSTOCK_ROOT=/home/conda/feedstock_root
export RECIPE_ROOT=/home/conda/recipe_root
export CI_SUPPORT=/home/conda/feedstock_root/.ci_support
export CONFIG_FILE="${CI_SUPPORT}/${CONFIG}.yaml"

cat >~/.condarc <<CONDARC

conda-build:
 root-dir: /home/conda/feedstock_root/build_artifacts

CONDARC

conda install --yes --quiet conda-forge::conda-forge-ci-setup=2 conda-build

# set up the condarc
setup_conda_rc "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artifacts.
conda clean --lock

source run_conda_forge_build_setup


# Install the yum requirements defined canonically in the
# "recipe/yum_requirements.txt" file. After updating that file,
# run "conda smithy rerender" and this line will be updated
# automatically.
/usr/bin/sudo -n yum install -y gtk2 xorg-x11-server-Xvfb


# make the build number clobber
make_build_number "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

conda build "${RECIPE_ROOT}" -m "${CI_SUPPORT}/${CONFIG}.yaml" \
    --clobber-file "${CI_SUPPORT}/clobber_${CONFIG}.yaml"  --quiet

upload_package "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

touch "/home/conda/feedstock_root/build_artifacts/conda-forge-build-done-${CONFIG}"
