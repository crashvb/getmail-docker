FROM crashvb/base:20.04-202201080422@sha256:57745c66439ee82fda88c422b4753a736c1f59d64d2eaf908e9a4ea1999225ab
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:57745c66439ee82fda88c422b4753a736c1f59d64d2eaf908e9a4ea1999225ab" \
	org.opencontainers.image.base.name="crashvb/base:20.04-202201080422" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing getmail." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/getmail-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/getmail" \
	org.opencontainers.image.url="https://github.com/crashvb/getmail-docker"

# Install packages, download files ...
RUN docker-apt cron getmail

# Configure: getmail
ENV GETMAIL_CONFIG=/etc/getmail GETMAIL_VGID=5000 GETMAIL_VMAIL=/var/mail GETMAIL_VNAME=vmail GETMAIL_VUID=5000
ADD getmail-* /usr/local/bin/
ADD getmail.* /usr/local/share/getmail/
RUN groupadd --gid=${GETMAIL_VGID} ${GETMAIL_VNAME} && \
	useradd --create-home --gid=${GETMAIL_VGID} --home-dir=/home/${GETMAIL_VNAME} --shell=/usr/bin/bash --uid=${GETMAIL_VUID} ${GETMAIL_VNAME} && \
	ln --symbolic ${GETMAIL_CONFIG} /home/${GETMAIL_VNAME}/.getmail && \
	rm --force /etc/cron.*/*

# Configure: profile
RUN echo "export GETMAIL_CONFIG=$GETMAIL_CONFIG GETMAIL_VMAIL=${GETMAIL_VMAIL}" > /etc/profile.d/getmail.sh && \
	chmod 0755 /etc/profile.d/getmail.sh

# Configure: supervisor
ADD supervisord.cron.conf /etc/supervisor/conf.d/cron.conf

# Configure: entrypoint
ADD entrypoint.getmail /etc/entrypoint.d/getmail

# Configure: healthcheck
ADD healthcheck.cron /etc/healthcheck.d/cron

VOLUME ${GETMAIL_CONFIG} ${GETMAIL_VMAIL}
