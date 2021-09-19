# Rail Surveys

Create most informative surveys with the click of a button

## Table of Contents
- [Rail Surveys](#rail-surveys)
  - [Table of Contents](#table-of-contents)
  - [Setup with docker](#setup-with-docker)
  - [Endpoints](#endpoints)

## Setup with docker

1. Run docker-compose:

    ```sh
    docker-compose up
    ```

2. Setup database:

    ```sh
    docker-compose exec app bundle exec rake db:setup
    ```

3. If you have permission problems with files created by the docker containers simply chown the directory:
   
    ```sh
    sudo chown -R $USER railsurveys/
    ```

## Endpoints

- [/surveys](./docs/SurveysEndpoint.md)
- [/surveys/new](./docs/NewSurveyEndpoint.md)
- [/surveys/:id](./docs/ShowSurveyEndpoint.md)
- [/surveys/:id/edit](./docs/EditSurveyEndpoint.md)
- [/surveys/result/:id](./docs/SurveyResultEndpoint.md)