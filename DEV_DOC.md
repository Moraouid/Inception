# Developer Documentation

## Environment Prerequisites

Install the following on the development machine:

- Linux
- Docker Engine
- Docker Compose plugin with the `docker compose` command
- GNU Make
- `sudo` access for the `fclean` target

Clone or copy the repository, then work from its root directory.

## Configuration

### Environment File

The Compose project reads non-sensitive configuration from `srcs/.env`. It contains the domain, MariaDB database and user names, and WordPress account names and email addresses. Review these values before the first launch.

The configured local domain is `sel-abbo.42.fr`. For local browser access, map it to the host in `/etc/hosts`:

```text
127.0.0.1 sel-abbo.42.fr
```

### Secrets

Create or verify these local password files before building:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/admin_password.txt
secrets/user_password.txt
```

Compose mounts these files into the containers under `/run/secrets/`. The MariaDB and WordPress startup scripts read the mounted files instead of receiving passwords directly from environment variables. Do not commit real production credentials or expose the contents of these files.

## Build and Launch

The Makefile creates the host data directories and starts the complete stack:

```sh
make
```

The equivalent Compose command, after the data directories exist, is:

```sh
docker compose -f srcs/docker-compose.yml up -d --build
```

The Compose file builds three images from `srcs/requirements/`:

- `mariadb`: MariaDB server and database initialization.
- `wordpress`: WP-CLI, WordPress initialization, and PHP-FPM on port `9000`.
- `nginx`: HTTPS reverse proxy on port `443`.

Nginx forwards PHP requests to the `wordpress` service. WordPress connects to MariaDB using the service name `mariadb` on the Docker network.

## Container and Volume Management

Show the service state:

```sh
docker compose -f srcs/docker-compose.yml ps
```

Follow logs for the whole stack or one service:

```sh
docker compose -f srcs/docker-compose.yml logs -f
docker compose -f srcs/docker-compose.yml logs -f wordpress
```

Stop the containers and remove the Compose network:

```sh
make down
```

Remove containers, images, and Docker volumes:

```sh
make clean
```

Remove all project data as well as unused Docker resources:

```sh
make fclean
```

Rebuild from a clean state:

```sh
make re
```

The Compose-level equivalents for normal lifecycle operations are `docker compose -f srcs/docker-compose.yml down` and `docker compose -f srcs/docker-compose.yml down --rmi all -v`.

## Data Persistence

The project defines two named Docker volumes:

- `mariadb_data` is mounted at `/var/lib/mysql` in the MariaDB container.
- `wordpress_data` is mounted at `/var/www/html` in both the WordPress and Nginx containers.

The local Docker volume driver maps those volumes to host directories:

```text
/home/$USER/data/mariadb
/home/$USER/data/wordpress
```

The Makefile creates these directories before launch. Because the data is outside the container writable layers, recreating containers does not remove the database or WordPress files. `make clean` removes Docker volumes, while `make fclean` additionally deletes the host-backed directories, so the latter destroys the persisted project data.

## Repository Layout

```text
.
├── Makefile
├── secrets/
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```
