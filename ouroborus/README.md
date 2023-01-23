# Ouroborus

A simple ruby webrick server with an end point that
restart its container.

You can easily start this server as a docker container. Firstly, make sure you build `ouroborus` docker image using `Dockerfile` provided in this project.

After that, just run `docker run ouroborus` and server will start.

## Available endpoints

Making a simple GET request to '/' will only show "Hello, World!" in your standard output.

Making a simple PUT request to '/shutdown' will go down this server. For example:

```bash
 curl -X PUT -d '' http://172.17.0.3:8000/shutdown/ 
```

Making a simple PUT request to '/respawn' will restart this server. For example:

```bash
 curl -X PUT -d '' http://172.17.0.3:8000/respawn/ 
``` 