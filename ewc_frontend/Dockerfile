# ------------------------------------------------
# Dockerfile for Android (Flutter) Build
# ------------------------------------------------
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 1) Install required packages
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    curl \
    wget \
    unzip \
    xz-utils \
    zip \
    git \
    libglu-dev \
    && apt-get clean

# 2) Install Flutter
ARG FLUTTER_VERSION=3.7.9
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    -O /tmp/flutter.tar.xz \
 && tar xf /tmp/flutter.tar.xz -C /opt \
 && rm /tmp/flutter.tar.xz

# Prevent Git “dubious ownership” warnings
RUN git config --global --add safe.directory /opt/flutter

ENV PATH="${PATH}:/opt/flutter/bin"

# 3) Install Android SDK / cmdline-tools
ARG CMDLINE_TOOLS_VERSION=9477386
RUN mkdir -p /opt/android/sdk/cmdline-tools/latest && \
    cd /opt/android/sdk/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip \
      -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    rm cmdline-tools.zip

# Set ANDROID_HOME and ANDROID_SDK_ROOT
ENV ANDROID_SDK_ROOT=/opt/android/sdk
ENV ANDROID_HOME=/opt/android/sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# Accept SDK licenses / update
RUN yes | sdkmanager --licenses || true
RUN sdkmanager --update

RUN sdkmanager \
  "platform-tools" \
  "platforms;android-33" \
  "build-tools;33.0.0" \
  "ndk;25.2.9519653"

# Let Flutter know where the SDK is
RUN flutter config --android-sdk $ANDROID_SDK_ROOT

# Accept Android licenses
RUN yes | flutter doctor --android-licenses
RUN flutter doctor

WORKDIR /app
