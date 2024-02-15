# helm-unsigned-provenance-generator-plugin
This is a Helm plugin that generates a provenance file for a Helm chart that is unsigned. This is useful for testing, development, and signing the chart using external tools.

## Prerequisites

- [Helm](https://helm.sh/docs/intro/install/)
- [yq](https://github.com/mikefarah/yq/#install)

## Install Plugin
```bash
helm plugin install https://github.com/SecKatie/helm-unsigned-provenance-generator-plugin
```

## Usage
```bash
helm generate-unsigned-provenance
```

## Update Plugin
```bash
helm plugin update generate-unsigned-provenance
```

## Uninstall Plugin
```bash
helm plugin remove generate-unsigned-provenance
```

## Testing and Development
```bash
git clone git@github.com:SecKatie/helm-unsigned-provenance-generator-plugin.git
# or
git clone https://github.com/SecKatie/helm-unsigned-provenance-generator-plugin.git

cd helm-unsigned-provenance-generator-plugin
make test
```

## Next Steps
- [ ] Add a version flag to the `helm generate-unsigned-provenance` command
- [ ] Capture the `--help` flag and provide `helm generate-unsigned-provenance` usage information