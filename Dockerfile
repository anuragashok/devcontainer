FROM gitpod/workspace-full

# change uid and gid to 1000 so that it works in wsl. hacky solution not generic as uid might be different on different systems
ARG UID=1000
ARG GID=1000
ARG USERNAME=gitpod
USER root
RUN groupmod -g ${GID} ${USERNAME}
RUN usermod -u ${UID} ${USERNAME} &&  usermod -g ${GID} ${USERNAME}
USER ${USERNAME}

#shell setup zsh and ohmyzsh
RUN sudo usermod -s /bin/zsh ${USERNAME}
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
COPY .zshrc /home/${USERNAME}/.zshrc
COPY .p10k.zsh /home/${USERNAME}/.p10k.zsh

#remove .gitconfig so that vscode can copy over from host
RUN rm -rf ~/.gitconfig

#misc
RUN go install honnef.co/go/tools/cmd/staticcheck@latest