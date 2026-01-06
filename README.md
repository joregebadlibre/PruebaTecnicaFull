# PruebaTecnicaFull

Repositorio con 2 proyectos (backend + frontend) y despliegue completo con Docker Compose.

## Proyectos

### 1) Backend: `PruebaTecnicaEnero2026`

- **Tecnología**: Java 17, Spring Boot 3, Spring Data JPA.
- **Base de datos**: PostgreSQL.
- **Puerto**: `8080`.
- **Imagen/Build**: se construye desde `PruebaTecnicaEnero2026/Dockerfile`.

#### Datos iniciales (seed)

El backend incluye un `src/main/resources/data.sql` que se ejecuta al iniciar la aplicación.

En `src/main/resources/application.yml` está configurado:

- `spring.sql.init.mode: always`
- `spring.jpa.defer-datasource-initialization: true`

Esto permite:

- que Hibernate cree/actualice las tablas (`ddl-auto: update`)
- y luego se carguen datos iniciales en Postgres.

### 2) Frontend: `PruebaTecnicaEnero2026Front/banco-front`

- **Tecnología**: Angular.
- **Puerto**: `4000`.
- **Imagen/Build**: se construye desde `PruebaTecnicaEnero2026Front/banco-front/Dockerfile`.

#### Configuración de URL de API

- En desarrollo: `src/environments/environment.development.ts` usa `apiBaseUrl: '/api'` y el `proxy.conf.json` enruta `/api -> http://localhost:8080`.
- En producción: `src/environments/environment.ts` usa `apiBaseUrl: 'http://localhost:8080'`.

## Docker Compose (despliegue)

El despliegue recomendado es usando el `docker-compose.yml` de la **raíz** del repositorio, el cual levanta 3 servicios:

- `db` (Postgres 16)
- `api` (Spring Boot)
- `front` (Angular)

### Puertos

- **Postgres**: `localhost:5432`
- **API**: `http://localhost:8080`
- **Front**: `http://localhost:4000`

### Variables de entorno relevantes

En el `docker-compose.yml` se definen:

- **DB**
  - `POSTGRES_DB=pruebatecnica`
  - `POSTGRES_USER=postgres`
  - `POSTGRES_PASSWORD=postgres`

- **API**
  - `DB_URL=jdbc:postgresql://db:5432/pruebatecnica`
  - `DB_USERNAME=postgres`
  - `DB_PASSWORD=postgres`
  - `SERVER_PORT=8080`

- **Front**
  - `PORT=4000`

### Volúmenes

- `pgdata`: persiste la data de Postgres.

## Cómo levantar todo

Desde la raíz del repo:

```bash
docker compose build
docker compose up -d
```

Ver estado:

```bash
docker compose ps
```

Logs:

```bash
docker compose logs -f
```

Bajar servicios:

```bash
docker compose down
```

Bajar servicios y limpiar volúmenes (esto borra la data persistida de Postgres):

```bash
docker compose down -v
```

## Scripts helper

En la raíz hay scripts para facilitar el despliegue:

- `./deploy.sh`
  - `./deploy.sh` (build + up -d)
  - `./deploy.sh --logs` (además sigue logs)
  - `./deploy.sh --down` (apaga)
  - `./deploy.sh --down --clean` (apaga y borra volúmenes)

- `./down.sh`
  - `./down.sh` (apaga)
  - `./down.sh --clean` / `./down.sh -v` (apaga y borra volúmenes)

## Notas

- Si cambiaste el seed (`data.sql`) y quieres que se aplique “desde cero”, ejecuta `docker compose down -v` para eliminar el volumen `pgdata` y vuelve a levantar.
