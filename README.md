# getmail-docker

[![version)](https://img.shields.io/docker/v/crashvb/getmail/latest)](https://hub.docker.com/repository/docker/crashvb/getmail)
[![image size](https://img.shields.io/docker/image-size/crashvb/getmail/latest)](https://hub.docker.com/repository/docker/crashvb/getmail)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/getmail-docker.svg)](https://github.com/crashvb/getmail-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [getmail](http://pyropus.ca/software/getmail/).

## Entrypoint Scripts

### getmail

The embedded entrypoint script is located at `/etc/entrypoint.d/getmail` and performs the following actions:

1. A new cron configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | GETMAIL\_RC | | The contents of `<getmaildir>/getmailrc`. |
 | GETMAIL\_RC* | | The contents of `<getmaildir>/rc-*`. For example, `GETMAIL_RCFOO` will create `<getmaildir>`/rc-foo`. |
 | GETMAIL\_SCHEDULE | &ast;/15 &ast; &ast; &ast; &ast; | Schedule section of the getmail crontab entry. |
 | GETMAIL\_VGID | 5000 | Group ID of the virtual mail user. |
 | GETMAIL\_VUID | 5000 | User ID of the virtual mail user. |
 | GETMAIL\_VMAIL | /var/mail | Virtual mail root. |
 | GETMAIL\_VNAME | vmail | Name of the virtual mail user. |

2. Volume permissions are normalized.

## Healthcheck Scripts

### cron

The embedded healthcheck script is located at `/etc/healthcheck.d/cron` and performs the following actions:

1. Verifies that all cron services are operational.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ getmail/
│  ├─ entrypoint.d/
│  │  └─ getmail
│  └─ healthcheck.d/
│     └─ cron
├─ run/
│  └─ secrets/
│     └─ <rc>_password
├─ usr/
│  └─ local/
│     └─ bin/
│        └─ getmail-wrapper
└─ var/
   ├─ spool/
   │  └─ getmail/
   └─ mail/
```

### Exposed Ports

None.

### Volumes

* `/etc/getmail` - getmail configuration directory.
* `/var/mail` - default mail directory.

## Development

[Source Control](https://github.com/crashvb/getmail-docker)

