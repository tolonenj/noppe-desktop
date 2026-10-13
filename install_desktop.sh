#!/bin/sh
set -e

# Configure commands available
DEBIAN_FRONTEND=noninteractive \
echo 'keyboard-configuration keyboard-configuration/layout select Finnish' | debconf-set-selections && \
echo 'keyboard-configuration keyboard-configuration/variant select Finnish' | debconf-set-selections && \
echo 'keyboard-configuration keyboard-configuration/model select Generic 105-key PC' | debconf-set-selections \
&& apt-get update\
&& apt-get upgrade -y\
&& apt-get install -y\
 wget\
 tini\
 mate-desktop-environment-core \
&& wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc \
&& cd /etc/apt/sources.list.d; wget https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/bookworm/xpra.sources\
&& apt-get update\
&& apt-get install -y\
 xpra\
 xpra-html5 \
&& rm -f /etc/pam.d/login \
&& echo "" > /etc/legal \
&& apt-get clean \
&& apt-get autoremove --purge \
&& rm -fr /etc/apt \
&& rm -fr /var/log/apt \
&& rm -fr /var/lib/apt \
&& rm -fr /var/lib/dpkg \
&& rm -fr /var/cache/apt \
&& rm -fr /var/log/*

# Configure user's default settings
# rm /etc/skel/.profile
# ln -s my-work/.profile /etc/skel/.profile

# Generate a minimum pam.d/login file to correctly show motd message above
cat > /etc/pam.d/login << 'EOF'
auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      common-auth
account    include      common-account
session    required     pam_env.so readenv=1
session    required     pam_env.so readenv=1 envfile=/etc/default/locale
session    required     pam_motd.so motd=/etc/motd
session    include      common-session
session    optional     pam_mail.so standard
EOF

# Generate a welcome message and a brief disclaimer
echo '
,-.___,-.
\_/  _\_/
  )>_O(        Debian Bookworm
 { (_) }       cat /readme
  `-^-´ hjw
' > /etc/motd

cat > /readme << EOF
This Linux environment has minimal resources and lacks appropriate
security measures. It is not designed to handle personal or classified
data and exists for educational purposes only.
EOF

chmod 444 /readme
