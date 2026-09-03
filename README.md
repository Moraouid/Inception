*This project has been created as part of the 42 curriculum by sel-abbo.*

# Inception

## Description

Inception is a Docker-based infrastructure project that deploys a small WordPress website using three independent services:

- **Nginx**: the HTTPS entry point, using a self-signed TLS certificate and forwarding PHP requests.
- **WordPress**: the PHP-FPM application container. On its first start, it downloads and configures WordPress with WP-CLI, then creates an administrator and an author account.
- **MariaDB**: the database server used by WordPress.

The goal is to build the infrastructure from custom Dockerfiles and make the services communicate through Docker Compose, rather than running the whole stack in one container. Persistent WordPress files and MariaDB data are stored outside the containers through Docker volumes backed by directories under `/home/$USER/data`.

## Technical Choices

### Docker versus Virtual Machines

Docker containers share the host kernel, so they start quickly and use fewer resources than complete virtual machines. Each service remains isolated at the process and filesystem level while being easy to rebuild from its Dockerfile. A virtual machine provides stronger hardware-level isolation and runs a complete guest operating system, but requires more memory, storage, and startup time. Docker is appropriate here because the project needs lightweight, reproducible service isolation rather than separate operating systems.

### Secrets versus Environment Variables

Non-sensitive configuration such as `DOMAIN_NAME`, database names, usernames, and email addresses is supplied through `srcs/.env`. Passwords are stored in the `secrets/` directory and mounted by Compose as files under `/run/secrets/`; the startup scripts read these files when they need credentials. Docker secrets avoid placing passwords directly in environment variables, where they can be exposed through container inspection or process diagnostics. Secret files must be kept private and must never be replaced with real production credentials in a committed example.

### Docker Network versus Host Network

The services use the user-defined bridge network `inception_network`. Containers can reach one another by service name, for example `mariadb` and `wordpress`, while only Nginx publishes port `443` to the host. Host networking would remove this network isolation and expose containers directly on the host network namespace. The bridge network gives the stack service discovery and a smaller external attack surface.

### Docker Volumes versus Bind Mounts

The Compose file declares named volumes, `mariadb_data` and `wordpress_data`, for container-managed persistence. Their local driver options bind them to `/home/$USER/data/mariadb` and `/home/$USER/data/wordpress`, so the data remains available after containers are recreated. A direct bind mount is simpler when a host path must be edited or shared explicitly; a Docker-managed volume is more portable and easier for Docker to manage. This project combines both ideas: named-volume semantics in Compose with explicit host-backed storage required by the 42 setup.

## Instructions

### Prerequisites

- Linux with Docker Engine and the Docker Compose plugin (`docker compose`).
- GNU Make.
- Permission to create `/home/$USER/data` and, for `make fclean`, permission to run the configured `sudo rm` commands.
- A hosts-file entry resolving the configured domain to the local machine:

  ```text
  127.0.0.1 sel-abbo.42.fr
  ```

### Configuration

The application configuration is in `srcs/.env`. Before running the project, verify the domain, database values, and WordPress account values. Put the corresponding passwords in these files:

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/admin_password.txt`
- `secrets/user_password.txt`

The values in `srcs/.env` use the paths where Docker Compose mounts those secrets. Do not expose these files or reuse these credentials outside a local development environment.

### Build and run

From the repository root, run:

```sh
make
```

This creates the persistent data directories, builds the three images, and starts the services in detached mode. Once the containers are ready, open:

```text
https://sel-abbo.42.fr
```

The certificate is self-signed, so a browser warning is expected during local development. The first startup may take longer while WordPress is downloaded and installed.

### Make targets

| Command | Purpose |
| --- | --- |
| `make` or `make all` | Create data directories and build/start the stack. |
| `make down` | Stop and remove containers and the Compose network. |
| `make clean` | Remove containers, images, named volumes, and the network. |
| `make fclean` | Perform `clean`, delete the host-backed data directories, and prune Docker resources. |
| `make re` | Perform `fclean`, then build and start again. |

To inspect the running services directly, use standard Docker commands such as:

```sh
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
```

## Project Structure

```text
.
├── Makefile
├── secrets/                         # Local password files mounted as Docker secrets
└── srcs/
    ├── .env                         # Non-sensitive Compose configuration
    ├── docker-compose.yml            # Services, network, volumes, and secrets
    └── requirements/
        ├── mariadb/                  # MariaDB image and initialization script
        ├── nginx/                    # HTTPS reverse proxy and certificate setup
        └── wordpress/                # WordPress, WP-CLI, and PHP-FPM setup
```

## Resources

- [Docker documentation](https://docs.docker.com/): images, containers, networks, volumes, and Compose.
- [Docker Compose file reference](https://docs.docker.com/reference/compose-file/): service, volume, network, and secret configuration.
- [Docker storage documentation](https://docs.docker.com/engine/storage/): volumes and bind mounts.
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/): secret handling concepts and mounted secret files.
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/): server configuration and SQL administration.
- [Nginx documentation](https://nginx.org/en/docs/): HTTPS and FastCGI configuration.
- [WordPress documentation](https://developer.wordpress.org/): WordPress installation and configuration.
- [WP-CLI handbook](https://make.wordpress.org/cli/handbook/): command-line WordPress management.

### AI usage

AI assistance was used to help inspect the repository, reason about the Docker Compose architecture, and draft and review this README. It was used for documentation tasks only: organizing the project description, explaining the requested technology comparisons, and checking that the instructions reflect the Makefile, Compose file, Dockerfiles, and startup scripts. The infrastructure implementation and configuration remain in the project files under `srcs/`; AI-generated text was checked against those files before being included here.