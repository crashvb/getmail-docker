FROM crashvb/supervisord:202103212252
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

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
