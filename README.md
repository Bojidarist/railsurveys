# Rail Surveys

Create most informative surveys with the click of a button

## Table of Contents
- [Rail Surveys](#rail-surveys)
	- [Table of Contents](#table-of-contents)
	- [Setup](#setup)
	- [Endpoints](#endpoints)

## Setup

1. Install bundler:

    ```sh
    gem install bundler
    ```

2. Bundle:

    ```sh
    bundle
    ```

3. Migrate database:

    ```sh
    rake db:migrate
    ```

4. Run server:

    ```sh
    rails server
    ```

## Endpoints


- [/surveys](./docs/SurveysEndpoint.md)
- [/surveys/new](./docs/NewSurveyEndpoint.md)
- [/surveys/:id](./docs/ShowSurveyEndpoint.md)
- [/surveys/:id/edit](./docs/EditSurveyEndpoint.md)
- [/surveys/result/:id](./docs/SurveyResultEndpoint.md)