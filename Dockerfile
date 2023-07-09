FROM anibali/pytorch:1.7.0-cuda11.0-ubuntu20.04

# Install system libraries required by OpenCV.
RUN sudo apt-get update
RUN apt-get -y install git 

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

ADD . /vlar

WORKDIR /vlar

RUN pip install -r requirements.txt

ADD solve_VLAR.py solve_VLAR.py

CMD ["python", "solve_VLAR.py"]
