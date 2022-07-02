# aws-lambda-ric

This docker container contains these packages compiled on [`amazonlinux:2022`](https://hub.docker.com/_/amazonlinux?tab=tags):

- [`aws-lambda-nodejs-runtime-interface-client`](https://github.com/aws/aws-lambda-nodejs-runtime-interface-client)
- [`aws-lambda-python-runtime-interface-client`](https://github.com/aws/aws-lambda-python-runtime-interface-client)

Versions can be found in `/.aws-lambda-ric.versions`

## NodeJS

To include `aws-lambda-nodejs-runtime-interface-client` in your custom docker image, you should copy files from this image:

```Dockerfile
FROM fromtheexchange/aws-lambda-ric

FROM amazonlinux:2022
RUN yum install -y nodejs npm
COPY --from=fromtheexchange/aws-lambda-ric /usr/local/lib/node_modules/aws-lambda-ric/ /usr/local/lib/node_modules/aws-lambda-ric/
```

The entrypoint is `aws-lambda-ric/bin/index.js`

Please note that this package installs and builds `nodejs npm` daily, so the `node --version` will change over time.

### `node_modules` destination

Your `node_modules` destination folder depends on how you installed `npm`:

- `yum install -y npm` as `/usr/local/lib/node_modules/aws-lambda-ric/`
- `/usr/lib/node_modules/corepack/dist/npm.js install --no-audit --global npm` as `/usr/lib/node_modules/aws-lambda-ric/`

### Lightweight bundle

[`@vercel/ncc`](https://www.npmjs.com/package/@vercel/ncc) compiles “a Node.js module into a single file”.

Bundling offers substantial size savings for `aws-lambda-rcc`, from `128M` to `688K`.

This image contains the lightweight bundle:

```Dockerfile
FROM fromtheexchange/aws-lambda-ric

FROM amazonlinux:2022
RUN yum install -y nodejs npm
COPY --from=fromtheexchange/aws-lambda-ric /usr/local/lib/node_modules/vercel-ncc-aws-lambda-ric/ /usr/local/lib/node_modules/vercel-ncc-aws-lambda-ric/
```

The entrypoint is `vercel-ncc-aws-lambda-ric/index.js`

## Python3

To include `aws-lambda-nodejs-runtime-interface-client` in your custom docker image, you should copy files from this image:

```Dockerfile
FROM fromtheexchange/aws-lambda-ric

FROM amazonlinux:2022
RUN yum install -y python3 python3-pip python3-setuptools
COPY --from=fromtheexchange/aws-lambda-ric /usr/local/lib64/python3.9/site-packages/awslambdaric*/ /usr/local/lib64/python3.9/site-packages/
```

Please note that this package installs and builds `python3 python3-pip python3-setuptools` daily, so the `python3 --version` and associated paths will change over time.
