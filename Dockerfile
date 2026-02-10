FROM archlinux:base

# Refresh keyring and update system first
RUN pacman -Sy --noconfirm archlinux-keyring \
    && pacman -Syu --noconfirm

# Install required tools
RUN pacman -S --noconfirm --needed \
        wget \
        ca-certificates \
        bash \
    && rm -rf /var/cache/pacman/pkg/*

# Create dummy system utilities to avoid systemd dependency
RUN install -Dm755 /dev/stdin /usr/local/bin/lsb_release <<'EOF'
#!/bin/sh
echo "Arch Linux (container environment)"
EOF

RUN install -Dm755 /dev/stdin /usr/local/bin/hostnamectl <<'EOF'
#!/bin/sh
echo "Static hostname: $(hostname)"
EOF

RUN install -Dm755 /dev/stdin /usr/local/bin/systemctl <<'EOF'
#!/bin/sh
echo "Systemd not available inside container"
exit 0
EOF

# Download & execute EarnApp installer
ADD https://cdn-earnapp.b-cdn.net/static/earnapp/install.sh /tmp/earnapp-install.sh

RUN chmod +x /tmp/earnapp-install.sh \
    && /bin/bash /tmp/earnapp-install.sh -y \
    && earnapp stop \
    && rm -f /tmp/earnapp-install.sh

# App directory
WORKDIR /opt/app
COPY . .

RUN chmod 0755 run.sh

# Persistent config
VOLUME ["/etc/earnapp"]

ENTRYPOINT ["/opt/app/run.sh"]
