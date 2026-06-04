#!/usr/bin/env bash
# =============================================================================
# generate-service.sh — Service Scaffolder from Golden Templates
# =============================================================================
set -euo pipefail

usage() {
  echo "Usage: $0 -n <service-name> -t <dotnet-api|node-api|python-api|react-app|worker-service> -o <output-dir>"
  exit 1
}

SERVICE_NAME=""
TEMPLATE_TYPE=""
OUTPUT_DIR=""

while getopts "n:t:o:" opt; do
  case ${opt} in
    n) SERVICE_NAME="$OPTARG" ;;
    t) TEMPLATE_TYPE="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    *) usage ;;
  esac
done

if [[ -z "${SERVICE_NAME}" || -z "${TEMPLATE_TYPE}" || -z "${OUTPUT_DIR}" ]]; then
  usage
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd "${SCRIPT_DIR}/../golden-templates/${TEMPLATE_TYPE}" && pwd)"

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
  echo "❌ Error: Template type '${TEMPLATE_TYPE}' does not exist."
  exit 1
fi

echo "Scaffolding '${SERVICE_NAME}' using template '${TEMPLATE_TYPE}'..."
mkdir -p "${OUTPUT_DIR}"
cp -r "${TEMPLATE_DIR}/"* "${OUTPUT_DIR}/"

# Walk files and replace names/placeholders
find "${OUTPUT_DIR}" -type f | while read -r file; do
  # Replace file contents
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/dotnet-api/${SERVICE_NAME}/g" "${file}"
    sed -i '' "s/node-api/${SERVICE_NAME}/g" "${file}"
    sed -i '' "s/python-api/${SERVICE_NAME}/g" "${file}"
    sed -i '' "s/react-app/${SERVICE_NAME}/g" "${file}"
    sed -i '' "s/worker-service/${SERVICE_NAME}/g" "${file}"
  else
    sed -i "s/dotnet-api/${SERVICE_NAME}/g" "${file}"
    sed -i "s/node-api/${SERVICE_NAME}/g" "${file}"
    sed -i "s/python-api/${SERVICE_NAME}/g" "${file}"
    sed -i "s/react-app/${SERVICE_NAME}/g" "${file}"
    sed -i "s/worker-service/${SERVICE_NAME}/g" "${file}"
  fi

  # Rename files if necessary
  dir_path=$(dirname "${file}")
  base_name=$(basename "${file}")
  new_base_name="${base_name/dotnet-api/${SERVICE_NAME}}"
  new_base_name="${new_base_name/node-api/${SERVICE_NAME}}"
  new_base_name="${new_base_name/python-api/${SERVICE_NAME}}"
  new_base_name="${new_base_name/react-app/${SERVICE_NAME}}"
  new_base_name="${new_base_name/worker-service/${SERVICE_NAME}}"

  if [[ "${base_name}" != "${new_base_name}" ]]; then
    mv "${file}" "${dir_path}/${new_base_name}"
  fi
done

echo "🎉 Service '${SERVICE_NAME}' generated successfully at '${OUTPUT_DIR}'."
