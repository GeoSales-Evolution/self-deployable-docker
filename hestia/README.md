# Hestia

Hestia is the last container, the one who keeps the hearth warming
and home sweet.

You pass to it an image tag and the contaienr name, it will awake
it after a while has passed.

## The Hestia exectubale

It is a simple shell script. It takes some proper args, until a `--` is found.
When this happens, all other args will be passed to `docker`.

Alternatively, one can also pass a `--script` with an absolute path reference
and it will execute said script instead of `docker`, all other args to this
said script will be after `--`.

If you must create dyamically the script to start your container and don't have
the confidence that only mounting a volume will do, you can pass the script from
stdin. Just add `--stdin` and your script will be created from stdin until EOF
is reached. It will be saved in a file named `.script`. All args after `--` will
be given to said script.

Check the `--help` for `hestia` for more information.

## Some examples

To run hestia docker image passing a script as a parameter:

```bash
docker run hestia --script my_script.sh
```

To run hestia docker image and make its container waits for 10 seconds to finish its execution:

```bash
docker run hestia --sleep 10
```


To make hestia run docker commands to deploy another container:


```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock hestia -- run -v /var/run/docker.sock:/var/run/docker.sock ouroborus
```