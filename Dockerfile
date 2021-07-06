FROM archlinux:base-devel

# install sudo && git
RUN set -ex \
  # enable multilib
  && echo "[multilib]" >> /etc/pacman.conf \
  && echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf \
  && pacman --noconfirm -Sy \
  && pacman --noconfirm -S git \
  && useradd -m user \
  && echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/allow_user_sudo \
  && pacman --noconfirm -Scc

USER user
WORKDIR /home/user

# install yay
RUN set -ex \
  && git clone https://aur.archlinux.org/yay.git --depth 1 \
  && cd yay \
  && makepkg -si --noconfirm --rmdeps \
  && cd - \
  && rm -rf yay \
  && yay --noconfirm -Scc

# install lineageos-devel
RUN set -ex \
  && yay -Sy \
  && yay -S --noconfirm repo multilib-devel \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys C52048C0C0748FEE227D47A2702353E0F7E48EDB \
  && yay -S --noconfirm lineageos-devel jdk8-openjdk jre8-openjdk-headless android-tools ccache openssh \
  && yay --noconfirm -Scc

# force python2 in venv, add git stuff
RUN set -ex \
  && virtualenv2 --system-site-packages ~/.venv \
  && echo ". ~/.venv/bin/activate" >> ~/.bashrc \
  && echo "ccache -M 50G" >> ~/.bashrc \
  && git config --global user.email "admin@sportloto.ru" \
  && git config --global user.name "Lineageos Dockerfile" \
  # fix jack error on build
  && sudo sed -i '/jdk.tls.disabledAlgorithms/s/TLSv1, //;/jdk.tls.disabledAlgorithms/s/TLSv1.1, //;' /etc/java-8-openjdk/security/java.security

ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache
ENV CCACHE_DIR=/home/user/android/.ccache/
ENV USER=user

# fix for the failed build:
# flex-2.5.39: loadlocale.c:130: _nl_intern_locale_data: Assertion `cnt < (sizeof (_nl_value_type_LC_TIME) / sizeof (_nl_value_type_LC_TIME[0]))' failed.
ENV LC_ALL=C
