# get_iplayer PVR Docker image

This is a smallish (100MB) Docker image that hosts the [get_iplayer](https://github.com/get-iplayer/get_iplayer/wiki) PVR. It automatically keeps itself up-to-date with the latest version of get_iplayer.

The PVR recording feature runs hourly. The get_iplayer version is updated daily.

## Image configuration

The PVR can be accessed by default on port `1935/tcp`. Set the environment variable `PORT` to override.

Downloaded TV & radio files will be placed in the `/output` bind mount.

Environment variables `PUID` and `PGID` can be set to dictate the owner and group of downloaded files (useful if you're putting these files in a shared folder).

## Example invocation

This makes the PVR available on port 1935, and makes downloaded files owned by the current user:

```sh
docker run -d -e PUID=`id -u` -e PGID=`id -g` -p 1935:1935 -v /destination/on/host:/output marginal/get_iplayer:latest
```
Replace `/destination/on/host` with the path of a folder on the host machine where you would like the downloaded files to be placed.

## get_iplayer configuration

get_iplayer's configuration and cache will be written to the `.get_iplayer` subfolder under the `/output` bind mount. You can set get_iplayer [options](https://github.com/get-iplayer/get_iplayer/wiki/options) in the file `/destination/on/host/.get_iplayer/options`.

Refer to the file [options.sample](https://raw.githubusercontent.com/Marginal/docker-get_iplayer/master/options.sample) for examples.

## Migrating an existing get_iplayer installation

1. Copy your existing `.get_iplayer` folder over to `/destination/on/host/.get_iplayer` .

2. If you have a `.get_iplayer/options` file, open it in a text editor and remove any `output`, `outputradio` and/or `outputtv` statements.

3. Open the file `.get_iplayer/download_history` in a text editor, search for "/old/destination/folder/" and globally replace with "`/output/`".
