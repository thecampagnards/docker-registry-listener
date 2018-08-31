# Docker registry listener

This docker image calls web services and checks if the result is different from the previous one. If the result is different it makes a call on another web service. I use it to check if there is no new tag for a dockerhub image and launch my CI pipeline.

## Use

```bash
docker run -v ./template.json:/opt/docker-registry-listener/configuration.json thecampagnards/docker-registry-listener
```

## Example of conf

Check `template.json`. The field `curlOptions` is not manatory.