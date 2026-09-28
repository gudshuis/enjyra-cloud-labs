# Security

## What this repository is

ENJYRA Cloud Labs runs entirely on your own machine, using Docker. It does **not** require or use a real AWS, Azure, or Google Cloud account, and it does not create any real, billable cloud resource. The "cloud" it talks to is a local emulator (LocalStack for AWS, Azurite for Azure, and a GCS-compatible emulator for Google Cloud), all running in containers on your own computer.

## No real credentials needed

Never put real AWS, Azure, or GCP credentials into any file in this repository or into the containers it starts. They are not needed, and there is no code path here that is designed to accept or protect them. If a lesson or script ever appears to ask for real cloud credentials, stop and report it — that would be a bug, not an intended feature.

## Reporting a vulnerability

If you find a security issue in this repository's scripts or Compose definitions:

- Do not include real credentials, tokens, or other secrets in your report.
- Once this repository is published on GitHub, use GitHub's private Security Advisories feature to report it, rather than opening a public issue.
- Until then, there is no separate security contact address published for this repository; do not send reports to a guessed email address.

## Integrity verification

A future release of this repository will include a `checksums.txt` file and per-OS verification scripts (`verify/`) so you can confirm a download matches what was actually released. That work has not shipped yet — see `verify/README.md` and `signatures/README.md` for the current status. Until checksums exist, there is no integrity verification step to run.

## Release signing

No release of this repository is cryptographically signed today. See `signatures/README.md`.
