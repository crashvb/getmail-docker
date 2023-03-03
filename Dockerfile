FROM crashvb/supervisord:202303031721@sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68" \
	org.opencontainers.image.base.name="crashvb/supervisord:202303031721" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing getmail." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/getmail-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/getmail" \
	org.opencontainers.image.url="https://github.com/crashvb/getmail-docker"

# Install packages, download files ...
RUN docker-apt cron getmail6

# Configure: getmail
ENV GETMAIL_CONFIG=/etc/getmail GETMAIL_VGID=5000 GETMAIL_VMAIL=/var/mail GETMAIL_VNAME=vmail GETMAIL_VUID=5000
COPY getmail-* /usr/local/bin/
COPY getmail.* /usr/local/share/getmail/
RUN groupadd --gid=${GETMAIL_VGID} ${GETMAIL_VNAME} && \
	useradd --create-home --gid=${GETMAIL_VGID} --home-dir=/home/${GETMAIL_VNAME} --shell=/usr/bin/bash --uid=${GETMAIL_VUID} ${GETMAIL_VNAME} && \
	ln --symbolic ${GETMAIL_CONFIG} /home/${GETMAIL_VNAME}/.getmail && \
	rm --force /etc/cron.*/*

# Configure: profile
RUN echo "export GETMAIL_CONFIG=$GETMAIL_CONFIG GETMAIL_VMAIL=${GETMAIL_VMAIL}" > /etc/profile.d/getmail.sh && \
	chmod 0755 /etc/profile.d/getmail.sh

# Configure: supervisor
COPY supervisord.cron.conf /etc/supervisor/conf.d/cron.conf

# Configure: entrypoint
COPY entrypoint.getmail /etc/entrypoint.d/getmail

# Configure: healthcheck
COPY healthcheck.cron /etc/healthcheck.d/cron

VOLUME ${GETMAIL_CONFIG} ${GETMAIL_VMAIL}
