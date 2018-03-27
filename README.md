# My REST API demonstration project

This project includes a collection of repositories that demonstrate REST web services in a variety of languages
and frameworks.

This repository (rest-demo) primarily just contains documentation and testing materials for use by the other
rest-demo-* repositories.

## Repositories in this project

### Frontend(s)

* [React](https://github.com/bmarcotte/rest-demo-react-frontend)

### Backend(s)

* [Java - JAX-RS](https://github.com/bmarcotte/rest-demo-java-backend)
* [Java - Spring](https://github.com/bmarcotte/rest-demo-spring-backend)
* [Node.js](https://github.com/bmarcotte/rest-demo-node-backend)

### Database

* [SQLite](https://github.com/bmarcotte/rest-demo-sqlite-database)

## Installation and Deployment

Here are two methods for installing and deploying applications from this collection of rest-demo-* repos.

Following the instructions for any one of these methods should setup an integrated pair of instances: one for the
frontend (the REST client UI), and one for the backend (the REST API web service).

### Method 1: Using Docker & docker-compose (preferred)

Requirements:
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) - version 1.7.10 or later recommended
* [Docker](https://www.docker.com/get-docker) - version 17.05 or later
* [docker-compose](https://docs.docker.com/compose/install/) - version 1.12.0 or later

This method will build two Docker images, one for the frontend and one for the backend, and then create and run
container instances based on each of them.

Run the following commands to use this method:
```
> git clone https://github.com/bmarcotte/rest-demo.git
> cd rest-demo
> FRONTEND=react BACKEND=java docker-compose up -d --build
```
...where `FRONTEND=react` is used to select the
[rest-demo-react-frontend](https://github.com/bmarcotte/rest-demo-react-frontend) repo as the source for the REST
client UI application, and `BACKEND=java` is used to select the
[rest-demo-java-backend](https://github.com/bmarcotte/rest-demo-java-backend) repo as the REST API web service
application.

NOTE: Currently, `react` is the default value for FRONTEND, and `java` is the default value for BACKEND, so if you'd
like to spin up a pair of those particular instances, then you can omit the environment variables at the beginning, so
the last command above can be simplified to the following:
```
> docker-compose up -d --build
```

### Method 2: Manually

Requirements:
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) - version 1.7.10 or later recommended
* See the repo-specific installation method(s) for additional tools required.

If `docker-compose` is not available, you can download the backend and frontend repos manually, and then follow the
installation steps specific to each repo.

Run the following commands to use this method:
```
git clone https://github.com/bmarcotte/rest-demo-java-backend.git backend
git clone https://github.com/bmarcotte/rest-demo-react-frontend.git frontend

cd backend
# backend specific steps...

cd ../frontend
# frontend specific steps...
```

See the `README.md` files in each of those repos for more information on the installation and deployments steps
specific to each of those applications.

## Testing

Documentation describing how to test the backend web services can be found here:
* [TESTING.md](TESTING.md)

## Author

* **Ben Marcotte** - [bmarcotte](https://github.com/bmarcotte)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
