# Integrity verification

Run the script for your platform from the repository root:

```sh
./verify/verify-enjyra-lab-macos.sh     # macOS
./verify/verify-enjyra-lab-linux.sh     # Linux
```

```powershell
.\verify\verify-enjyra-lab.ps1          # Windows
```

Each script checks every file listed in `checksums.txt` against its SHA-256 hash, checks that Docker, the Docker Compose plugin, and Git are present, and confirms the launcher for your platform exists. It also prints the **release fingerprint** — the SHA-256 hash of `checksums.txt` itself — so you can compare it against the value published in the README for this release.

A checksum mismatch means the file changed since it was released — either corruption in transit, or a tampered copy. It does not tell you *who* published the release; see `signatures/README.md` for that distinction.
