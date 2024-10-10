1.  Dbdiagram.io

  Table accounts as A {
    id bigserial [pk]
    owner varchar [not null]
    balance bigint [not null]
    currency varchar [not null]
    created_at  timestamp [not null, default: 'now()']

    indexes {
      owner
    }
  }

  Table entries {
    id bigserial [pk]
    account_id bigint [ref: > A.id]
    amount bigint [not null, note: 'can eb negative or positive']
    created_at  timestamptz [not null, default: 'now()']

    indexes {
      account_id
    }
  }

  Table transfers {
    id bigserial [pk]
    from_account_id bigint [ref: >A.id]
    to_account_id bigint [ref: >A.id]
    amount bigint [not null, note : 'must be positive']
    created_at timestamptz [not null, default: 'now()']

    indexes {
      from_account_id
      to_account_id
      (from_account_id, to_account_id)
    }
  }

2. Docker Postgres TablePlus

hub.docker.com
                                                                                                                                                                                
docker pull postgres:12-alpine
docker images
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=mysecretpassword -d postgres:12-alpine


3. write run database migration in golang

scoop install migrate
migrate create -ext sql -dir db/migration -seq init_schema

docker exec -it postgres12 createdb --username=root --owner=root simple_bank
docker exec -it postgres12 dropdb simplebank

migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5432/simple_bank?sslmode=disable" -verbose up
migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5432/simple_bank?sslmode=disable" -verbose down


4. Generate CRUD golang code
  use sqlc  for fast on postgres, mysql(sqlc.dev)

  docker pull sqlc/sqlc

  docker run --rm -v "%cd%:/src" -w /src sqlc/sqlc generate
  docker run --rm -v "%cd%:/src" -w /src sqlc/sqlc init             (create the sqlc.yaml file)
  https://github.com/sqlc-dev/sqlc/tree/v1.4.0

  docker run --rm -v "%cd%:/src" -w /src sqlc/sqlc generate


  while working on sql file on db/query folder , there must be an comment


go mod init github.com/techschool/simplebank
go mod tidy


5. Unit test on CRUD

 go get github.com/lib/pq
 
 (go mod init <your-module-name>
  go get module name)

 go get github.com/stretchr/testify

 go test -v ./...


6. Go DB transaction

BEGIN ;
COMMIT;|| ROLLBACK;

7.

FOR NO KEY UPDATE   ---------- means not update key  will work for foriegn keys transaction effect
  


8. avoid DB deadlock



9. Mock tester

mockgen -package mockdb -destination db/mock/store.go github.com/charles-leonard/bank_system/db/sqlc Store
at here, Store means interface name


                

10. user table add with foreign keys

migrate create -ext sql -dir db/migration -seq add_users


migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5432/simple_bank?sslmode=disable" -verbose up 1
migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5432/simple_bank?sslmode=disable" -verbose down 1
