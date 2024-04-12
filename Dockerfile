FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH:/usr/bin:/bin:/usr/sbin:/sbin

# packages
RUN apt-get -y update && \
    apt-get install -y wget xvfb ffmpeg git python3-pip \
    build-essential libffi-dev libssl-dev libegl-dev

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    mkdir $HOME/work

# install pyenv
RUN pip install pip --upgrade
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
RUN eval "$(pyenv init --path)"
ENV PATH $HOME/.pyenv/versions/3.10.4/bin:$PATH
RUN pyenv install 3.10.4
RUN pyenv local 3.10.4

# install poetry
RUN pip install poetry --upgrade
RUN poetry config virtualenvs.in-project true --local

# environment variables
ENV MUJOCO_GL egl