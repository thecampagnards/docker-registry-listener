# Docker registry listener

This docker image call a web service and check if the result is diferent than previous one.
I use it to check if the is a new tag for an image on dockerhub and launch my CI pipeline.

## Use

```bash
docker pull thecampagnards/docker-registry-listener
```

## Example of conf

```json
[
    {
        "tagUrl": "https://registry.hub.docker.com/v1/repositories/sonarqube/tags",
        "apiToCall": {
            "url": "https://gitlab.com/api/v4/projects/2070/trigger/pipeline",
            "requestType": "POST",
            "curlOptions": "-k -F token= -F ref=master"
        }
    }
]
```