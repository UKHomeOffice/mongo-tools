MongoDB Tools (ACP Variant)
===================================

This is a modified copy of the mongo tools (mongodump, mongorestore) which is compatible
the (legacy) certificates used by https://github.com/UKHomeOffice/cfssl-sidekick

Mongodump and other tools were originally written in C++ and part of the Mongo packages.
In Version 4.2 they were rewritten in go lang and that's what's introduced these back
compatability issues.

Whilst patching database backup tools raises concern, it is preferable in the short term
to move us from Mongo 3.6 to Mongo 5. It can recieve security updates without downtime
and confidence in our existing configuration is valid. Our environment relies on x509
security certificates for authorisation and we have many clients. This solution
gives us time to plan the downtime associated with changing our certificates etc.

When upgrading above Mongo 5 care should be taken to ensure a version of mongodump and
mongorestore are tested. This codebase was forked from v5.0.5.

To simplify building the binaries a new dockerfile has been provided that contains the
go build tools.

The specific patches we address in this fork are:

A bug where a PEM file has intermediate certificates and isn't read correctly.

* https://jira.mongodb.org/browse/GODRIVER-1753
* https://github.com/mongodb/mongo-go-driver/pull/521/files

A bug where openssl leaves trailing data at the end of the file.

* https://github.com/golang/go/issues/40545

Tools inside

 - **bsondump** - _display BSON files in a human-readable format_
 - **mongoimport** - _Convert data from JSON, TSV or CSV and insert them into a collection_
 - **mongoexport** - _Write an existing collection to CSV or JSON format_
 - **mongodump/mongorestore** - _Dump MongoDB backups to disk in .BSON format, or restore them to a live database_
 - **mongostat** - _Monitor live MongoDB servers, replica sets, or sharded clusters_
 - **mongofiles** - _Read, write, delete, or update files in [GridFS](http://docs.mongodb.org/manual/core/gridfs/)_
 - **mongotop** - _Monitor read/write activity on a mongo server_

Report any bugs, improvements, or new feature requests at https://jira.mongodb.org/browse/TOOLS

Building Tools
---------------

This modified copy of the app includes a Dockerfile.build file, allowing you to build the binaries
using a docker container with the go lang tools.

Simply follow these steps to build a "build environment", then use docker run and a new script
to build the apps. This will create a bin/ directory if it doesn't exist with the binaries inside.

```
git clone https://github.com/mongodb/mongo-tools
cd mongo-tools
docker build -t mongo-tools-build -f Dockerfile.build .
docker run -itv "$PWD:/app" mongo-tools-build
bash> /app/acp-build-patched-apps.sh
```

For more information see the README.md for the upstream project.

<<<<<<< HEAD
https://github.com/mongodb/mongo-tools/
=======
You can also build a subset of the tools using the `-pkgs` option. For example, `./make build -pkgs=mongodump,mongorestore` builds only `mongodump` and `mongorestore`.
>>>>>>> upstream-master

Pipeline and usage
------------------
There are "proper" and comprehensive ways of packaging binaries like these. Binaries only work in the right environment with the right dependencies. (See Dockerfile.build). An ideal solution might be to compile this code and produce a docker image that contains the Mongo 5 dependencies with these binaries also included. Then our database and dbtools images could use that docker image as their base image.

However given the small amount of investment we expect to make to these tools, it seems easier to check-in the binaries to git as they only amount to 55MB and ship them on the dbtools image instead. This repo is here, more to provide the transparency of where our binaries come from, rather than being a new pipeline that needs maintaining.

[These mongo binaries are available here](https://github.com/UKHomeOffice/mongo-tools/blob/master/bin.tgz)
