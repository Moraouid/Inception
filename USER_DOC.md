# User Documentation

## Services

This project provides a WordPress website through three Docker services:

- **Nginx** receives HTTPS requests on port `443` and serves the website.
- **WordPress** runs the PHP application through PHP-FPM.
- **MariaDB** stores the WordPress database.

The services communicate through the private Docker network `inception_network`. Only Nginx is published to the host.

## Start the Project

From the repository root, run:

```sh
make
```

This creates the data directories, builds the images, and starts the containers in the background. The first start can take a few minutes while WordPress is downloaded and configured.

## Stop the Project

To stop and remove the containers and Docker network while keeping persistent data, run:

```sh
make down
```

To remove the containers, images, volumes, and persistent host data, run:

```sh
make fclean
```

`make fclean` uses `sudo` to remove the data directories and also prunes unused Docker resources. Use it only when you are sure that the stored website and database data can be deleted.

## Access the Website

Add the following entry to `/etc/hosts` if the domain does not already resolve locally:

```text
127.0.0.1 sel-abbo.42.fr
```

Open the website at:

```text
https://sel-abbo.42.fr
```

The project uses a self-signed certificate, so the browser may display a certificate warning. This is expected for local development.

The WordPress administration panel is available at:

```text
https://sel-abbo.42.fr/wp-admin
```

The administrator username and email are configured in `srcs/.env`. The administrator password is stored in `secrets/admin_password.txt`.

## Credentials

Credential files are kept in the `secrets/` directory:

| File | Used for |
| --- | --- |
| `secrets/admin_password.txt` | WordPress administrator account |
| `secrets/user_password.txt` | WordPress author account |
| `secrets/db_password.txt` | WordPress database user |
| `secrets/db_root_password.txt` | MariaDB root user |

Non-sensitive usernames, database names, domain values, and email addresses are configured in `srcs/.env`. Keep all password files private. After changing a password, recreate the relevant data or update the corresponding service credentials consistently; existing WordPress and MariaDB data are not automatically reinitialized on every start.

## Check the Services

List the containers and their states:

```sh
docker compose -f srcs/docker-compose.yml ps
```

View all service logs:

```sh
docker compose -f srcs/docker-compose.yml logs -f
```

View one service's logs:

```sh
docker compose -f srcs/docker-compose.yml logs -f nginx
docker compose -f srcs/docker-compose.yml logs -f wordpress
docker compose -f srcs/docker-compose.yml logs -f mariadb
```

A healthy basic setup should show running `nginx`, `wordpress`, and `mariadb` containers. If the website is unavailable, check that Docker is running, the containers are running, the hosts-file entry is present, and port `443` is not already in use.
