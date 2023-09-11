# Running with a Docker Postgresql backend

## First run the docker db 

```
$ cd Docker
$ docker-compose up -d
$ docker-compose logs


```

This will run a postgresql server locally with the terraform user and db, with password "somepassword"

```

$ psql -U terraform -h 127.0.0.1 terraform -W

```

## Then run the Terraform recipe


```

$ cd terraform
$ terraform init

```
