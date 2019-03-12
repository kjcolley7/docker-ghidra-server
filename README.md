docker-ghidra-server
=====

The NSA software reverse engineering tool, Ghidra, uses a server component for collaboration. This project wraps Ghidra Server in a Docker container for ease of deployment and management.

## Quickstart

1. Clone this repo and cd into it.
2. `./deploy.sh` (Windows support coming soon!)
3. Add any usernames you want (default password is `changeme` and expires in 24 hours).
4. Connect to the server from Ghidra client, either by creating a New Project and chosing shared project, or by converting an existing project to a shared project. This uses the default base port of 13100, and the server is bound to all interfaces (0.0.0.0).

## TODO

* Windows support (`deploy.bat`, also merging functionality from addUsers.py since Python isn't installed by default)
* Merge addUsers.py into deploy.sh (super easy)
