# getmail-docker

## Overview

This docker image contains [getmail](http://pyropus.ca/software/getmail/).

## Entrypoint Scripts

### getmail

The embedded entrypoint script is located at `/etc/entrypoint.d/getmail` and performs the following actions:

1. A new cron configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | GETMAIL_RC | | The contents of `<getmaildir>/getmailrc`. |
 | GETMAIL_RC* | | The contents of `<getmaildir>/rc-*`. For example, `GETMAIL_RCFOO` will create `<getmaildir>`/rc-foo`. |
 | GETMAIL_SCHEDULE | &ast;/15 &ast; &ast; &ast; &ast; | Schedule section of the getmail crontab entry. |
 | GETMAIL_VGID | 5000 | Group ID of the virtual mail user. |
 | GETMAIL_VUID | 5000 | User ID of the virtual mail user. |
 | GETMAIL_VMAIL | /var/mail | Virtual mail root. |
 | GETMAIL_VNAME | vmail | Name of the virtual mail user. |

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
└─ usr/
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

