# Use the official Alpine base image
FROM alpine:latest

# Install necessary packages
RUN apk update && apk add --no-cache \
    wget \
    curl \
    vim \
    nano \
    htop \
    patch \
    bash-completion \
    nginx \
    sudo \
    openjdk8-jdk \
    openssh-server

# Create the task user with sudo privileges
RUN adduser -D task && \
    echo "task:password1234" | chpasswd && \
    echo "task ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up SSH for the task user
RUN mkdir -p /var/run/sshd && \
    mkdir -p /home/task/.ssh && \
    chmod 700 /home/task/.ssh

# Copy the public key for SSH authentication
COPY id_rsa.pub /home/task/.ssh/authorized_keys

# Set appropriate permissions for SSH files
RUN chown task:task -R /home/task/.ssh && \
    chmod 600 /home/task/.ssh/authorized_keys

# Copy the index.html file to the Nginx directory
COPY index.html /var/www/html/index.html

# Expose the required ports
EXPOSE 80 22

# Start Nginx and SSH services
CMD ["/bin/sh", "-c", "nginx && /usr/sbin/sshd -D"]
