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

Check the `--help` for `hestia` for more information.
