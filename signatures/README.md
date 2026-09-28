# Release signatures

This repository does not yet publish cryptographically signed releases.

- `checksums.txt` (a future slice, not yet created) will provide **integrity detection** — confirming a downloaded file matches what was released, and hasn't been corrupted or tampered with in transit.
- A checksum is **not** the same as a signature. It does not prove *who* published a release, only that the bytes match a recorded hash.
- No private signing key exists in this repository, and none ever will. A private signing key must never be committed to source control.
- Signed releases (for example, using `cosign` or GPG-signed tags) are potential future work once there is an established public release process. This directory exists as a placeholder for that.

If you find a signature or key file in this directory that isn't this README, treat it as suspicious and do not trust it.
