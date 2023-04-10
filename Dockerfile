FROM ubuntu:latest
ENV USERNAME "retool"

RUN apt update && apt install openssh-server sudo -y
RUN sudo adduser ${USERNAME} --disabled-password

RUN mkdir -p /home/${USERNAME}/.ssh
RUN touch /home/${USERNAME}/.ssh/authorized_keys

RUN echo "PubkeyAcceptedKeyTypes +ssh-rsa" >> /etc/ssh/sshd_config
RUN service ssh start
EXPOSE 22

COPY --chown=${USERNAME}:${USERNAME} ./boot.sh .

CMD ["./boot.sh"]
