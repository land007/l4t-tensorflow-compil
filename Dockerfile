FROM land007/l4t-cuda:18.04
#strings /usr/lib/aarch64-linux-gnu/libstdc++.so.6 | grep GLIBCXX

MAINTAINER Jia Yiqiu <yiqiujia@hotmail.com>

#ADD bazel-0.26.1-dist.tar.gz /opt
ADD tensorflow.tar.gz /opt

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc-7 g++-7 build-essential openjdk-11-jdk python zip unzip wget curl
#RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7
#RUN update-alternatives --config gcc
#RUN update-alternatives --config g++

ADD bazel-0.26.1-dist/output/bazel /usr/bin
RUN apt-get install -y python3-pip git
RUN pip3 install -U pip
RUN pip install future
#https://blog.csdn.net/sinat_28442665/article/details/85325232
RUN cd /opt && \
    wget https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz && \
    tar -zxvf future-0.18.2.tar.gz && \
    cd future-0.18.2 && \
    python setup.py install
RUN cd /opt/tensorflow && curl -L https://github.com/tensorflow/tensorflow/compare/master...hi-ogawa:grpc-backport-pr-18950.patch | git apply

#ADD external /root/.cache/bazel/_bazel_root/fbc06f9baef46cade6e35d9e4137e37c/external

#cd /opt/tensorflow && ./configure
#bazel build --config=opt --config=monolithic //tensorflow/tools/lib_package:libtensorflow

#https://github.com/tensorflow/tensorflow/issues/18652
#vi third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc.tpl
#:216
#nvccopts += r'-gencode=arch=compute_%s,\"code=sm_%s" ' % (capability, capability)
#TF_CUDA_COMPUTE_CAPABILITIES=7.0

#docker build -t land007/l4t-tensorflow-compil:latest .
#docker run -it --runtime nvidia --name l4t-tensorflow-compil land007/l4t-tensorflow-compil:latest bash
