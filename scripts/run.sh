#!/usr/bin/env bash
# This script takes a chart directory as an argument and creates a `.tgz` archive and an unsigned `.prov` file for the chart.

function usage {
  echo "Usage: $0 <chart-directory>"
  echo "  <chart-directory> - The directory containing the chart"
  exit 1
}

# Check for yq
if ! [ -x "$(command -v yq)" ]; then
  echo "Error: yq is not installed." >&2
  echo "Please install yq. For more information, visit https://github.com/mikefarah/yq/#install" >&2
  exit 1
fi

chart=$1

# Validate that it is a directory and that it contains a `Chart.yaml` file
if [ ! -d $chart ] || [ ! -f $chart/Chart.yaml ]; then
  echo "The chart directory does not exist or does not contain a Chart.yaml file" >&2
  echo "Please provide a valid chart directory" >&2
  usage
  exit 1
fi

# Get the version from the `Chart.yaml` file
version=$(cat $chart/Chart.yaml | yq '.version')
# Get the chart name
name=$(cat $chart/Chart.yaml | yq '.name')

# Validate that the values are not empty
if [ -z "$version" ] || [ -z "$name" ]; then
  echo "The Chart.yaml file does not contain a valid version or name" >&2
  exit 1
fi

# Create chart tgz archive
message=$(helm package $chart 2>&1)

if [ $? -ne 0 ]; then
  echo "Failed to create the chart archive" >&2
  echo "[ERROR] $message" >&2
  exit 1
fi

# Create the `.prov` file
cat $chart/Chart.yaml > ./${name}-${version}.tgz.prov

# Get sha256 hash of the chart
sha256=$(shasum -a 256 ${name}-${version}.tgz | awk '{print $1}')

# Add the sha256 hash to the `.prov` file
echo "..." >> ./${name}-${version}.tgz.prov
echo "files:" >> ./${name}-${version}.tgz.prov
echo "  ${name}-${version}.tgz: sha256:${sha256}" >> ./${name}-${version}.tgz.prov

echo "Chart archive and .prov file created successfully"
echo
echo "Chart archive: ${name}-${version}.tgz"
echo "Chart provenance: ${name}-${version}.tgz.prov"
echo
echo "Note: the provenance is unsigned and should be signed through an external tool"
echo "      such as gpg or rpm-sign."
echo
echo "Helm expects the provenance file to be a clearsigned file, for example:"
echo "  gpg --clearsign ${name}-${version}.tgz.prov"
echo "  rm ${name}-${version}.tgz.prov"
echo "  mv ${name}-${version}.tgz.prov.asc ${name}-${version}.tgz.prov"
echo
echo "You can verify the signed provenance file with the following command:"
echo "  helm verify ${name}-${version}.tgz"