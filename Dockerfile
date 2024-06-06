# Use a lightweight Linux distribution as the base image
FROM debian:buster-slim

# Install necessary packages
RUN apt-get update \
    && apt-get install -y \
        xfce4 \
        xfce4-goodies \
        tightvncserver \
        novnc \
        supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC password (replace 'your-password' with your desired password)
RUN mkdir -p $HOME/.vnc \
    && echo "your-password" | vncpasswd -f > $HOME/.vnc/passwd \
    && chmod 600 $HOME/.vnc/passwd

# Set up noVNC
COPY ./novnc_web $HOME/novnc_web

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose VNC port and noVNC port
EXPOSE 5901 8080

# Start supervisord to manage processes
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
