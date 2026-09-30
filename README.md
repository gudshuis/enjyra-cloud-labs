# ENJYRA Cloud Labs

Local AWS, Azure, and Google Cloud storage learning environments for official ENJYRA lessons.

**NO REAL CLOUD ACCOUNT REQUIRED.**
**NO CLOUD BILLING RESOURCES CREATED.**
**RUNS LOCALLY WITH DOCKER.**

## Current release status

**REMOTE STUDENT READY.** The three console images are published to Docker Hub for `linux/amd64` and `linux/arm64`, and `start` was proven end-to-end from a genuinely fresh `git clone` on this machine — with the images removed first so the test could not silently reuse a local build:

| Lab | Image | Manifest digest |
|---|---|---|
| AWS | `enjyra/aws-labs:console-0.1.1` | `sha256:b2cebb2e8ce1c0b2e788fec79cd5ac5b4e370f8d11a5506d9f33b65449b0e14b` |
| Azure | `enjyra/azure-labs:console-0.1.1` | `sha256:5b6cefb5712c5b942e5eeef0c04d7176327d753744fb09ae01870fbcc0f9b7bc` |
| GCP | `enjyra/gcp-labs:console-0.1.1` | `sha256:4499bffba2cc5c0a89f142c7ec2c7a7b758f8ed07a8453b05698f1435931bcb5` |

Each digest is an OCI image index covering both `linux/amd64` and `linux/arm64`. Each image carries an embedded ENJYRA usage licence (`/licenses/ENJYRA-LAB-LICENSE.txt`, a legal-review-pending draft), full OCI identity/fingerprint labels, an SPDX SBOM, and build provenance — see `docs/FUTURE_SECURE_LAB_DELIVERY.md` in the private course repository for what security measures are real today versus future work. These images are **not cryptographically signed** — no secure signing identity is configured yet.

Release fingerprint (SHA-256 of `checksums.txt`): `349460bf446d1ac37210d43e2d00ada19a783ce1d904c316de2897eae49d385b`.

## What this repository is

Each ENJYRA cloud bonus lesson (AWS, Azure, GCP) pairs a real local cloud-storage emulator with an ENJYRA-built browser console, so you can practise creating buckets/containers, uploading and managing objects, and configuring storage security settings — all against genuine emulator behaviour, on your own machine, with nothing sent to a real cloud provider.

## Supported labs

| Lab | Emulator | Console |
|---|---|---|
| AWS (S3) | LocalStack | http://localhost:8081 |
| Azure (Blob Storage) | Azurite | http://localhost:8082 |
| GCP (Cloud Storage) | GCS-compatible emulator | http://localhost:8083 |

## Repository structure

```text
enjyra-cloud-labs/
├── README.md
├── LICENSE
├── SECURITY.md
├── VERSION
├── scripts/cloud-labs/          launcher scripts (macOS, Linux, Windows)
├── compose/                     Docker Compose definitions (one per provider)
├── verify/                      integrity verification (not yet built)
└── signatures/                  release-signing notes (not yet built)
```

## Prerequisites

You need, on any platform:

- **Docker** — Docker Desktop (macOS, Windows) or Docker Engine (Linux), with the `docker compose` plugin. https://docs.docker.com/get-docker/
- **Git**, to download this repository. https://git-scm.com/downloads

Nothing else is required to run the labs themselves. If your ENJYRA lesson also asks you to install Python, or Visual Studio Code, that's for the main ENJYRA course, not for this repository.

## Getting this repository

```sh
git clone <repository URL — not yet published>
cd enjyra-cloud-labs
```

## Launching a lab

### macOS

```sh
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh aws start
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh azure start
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh gcp start
```

### Linux

```sh
./scripts/cloud-labs/enjyra-cloud-lab-linux.sh aws start
./scripts/cloud-labs/enjyra-cloud-lab-linux.sh azure start
./scripts/cloud-labs/enjyra-cloud-lab-linux.sh gcp start
```

### Windows (PowerShell)

```powershell
.\scripts\cloud-labs\enjyra-cloud-lab.ps1 aws start
.\scripts\cloud-labs\enjyra-cloud-lab.ps1 azure start
.\scripts\cloud-labs\enjyra-cloud-lab.ps1 gcp start
```

WSL is not required — this launcher runs natively in PowerShell and talks to Docker Desktop directly.

Once started, open the console at the port shown (8081/8082/8083).

## Checking status

Replace `start` with `status` in any of the commands above, for example:

```sh
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh aws status
```

## Resetting a lab

Removes only that lab's own buckets/containers and objects — not the emulator or console themselves, and nothing outside this lesson.

```sh
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh aws reset
```

## Stopping a lab

```sh
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh aws stop
```

Your lesson data is kept in a Docker volume between stop and the next start. To discard it too, remove the corresponding Docker volume yourself (`docker volume ls`, then `docker volume rm`) — the launcher will not do this for you.

## Using the provider CLI (advanced)

Some lessons ask you to run AWS/Azure/gcloud CLI commands against the lab's emulator directly, through a small helper container:

```sh
./scripts/cloud-labs/enjyra-cloud-lab-macos.sh aws cli s3 ls
```

## Troubleshooting

- **"Docker is installed but not reachable"** — start Docker Desktop (or the Docker Engine service on Linux), then retry.
- **"pull access denied" / image not found** — confirm Docker can reach Docker Hub, then compare the requested tag with the "Current release status" table above.
- **A port (8081/8082/8083) is already in use** — stop whatever else is using it, or ask in the ENJYRA course for guidance; the launcher does not currently support remapping ports.

## Security

See `SECURITY.md`. In short: no real cloud credentials are ever needed here.

## Licence

See `LICENSE`. It is a draft educational-use licence and has not yet had legal review — do not treat it as final.

## Official ENJYRA use

This repository is built for use with the official ENJYRA course. It is not an independent product.
