
Project Revision Number Generator and Database
===============================================

This is a set of scripts that implement the singleton project revision
number generator and database service. Build scripts call this revdb
script over the network to reserve revision numbers for building or
packaging a project with a particular part number.

It is expected that this script is provided as a service over SSH, to
the machines building the projects. Key-based SSH authentication setup
is out of scope of this document.

Initialization
---------------

```
## fill in the config

cp conf/example.config.sh.conf conf/config.sh.conf
vim conf/config.sh.conf

## initialize the database

bin/revdb db init

## create one or more project part numbers

bin/revdb project init FOO-123 1 Project Foo 123
bin/revdb project init BAR-456 101 Project Bar 456

## display available project list

bin/revdb db show

## display list of revisions of a project FOO-123

bin/revdb project show FOO-123

```

Usage in build scripts
-----------------------

```
## reserve the next build number by providing project part number and
## comment for the next revision

BUILD_NO=$(bin/revdb project getnext FOO-123 $HOSTNAME / $LOGNAME / job 42)
```
