# ------------------------------------------------
# Dockerfile for an Android build (Flutter)
# ------------------------------------------------

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------
# 1) Install required packages
# ------------------------------------------------
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

# ------------------------------------------------
# 2) Install Flutter
# ------------------------------------------------
ARG FLUTTER_VERSION=3.7.9
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
        -O /tmp/flutter.tar.xz \
    && tar xf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz

# -- Git safe.directory 설정 (dubious ownership 경고 방지)
RUN git config --global --add safe.directory /opt/flutter

ENV PATH="${PATH}:/opt/flutter/bin"

# ------------------------------------------------
# 3) Install Android SDK / cmdline-tools
# ------------------------------------------------
ARG CMDLINE_TOOLS_VERSION=9477386
RUN mkdir -p /opt/android/sdk/cmdline-tools && \
    cd /opt/android/sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mv cmdline-tools tools && \
    rm cmdline-tools.zip

ENV ANDROID_SDK_ROOT=/opt/android/sdk
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN yes | sdkmanager --licenses || true
RUN sdkmanager --update
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0" \
    "ndk;25.2.9519653"

# ------------------------------------------------
# 4) Configure Flutter to know the SDK path
# ------------------------------------------------
RUN flutter config --android-sdk $ANDROID_SDK_ROOT

# Accept licenses via Flutter
RUN yes | flutter doctor --android-licenses
RUN flutter doctor

# ------------------------------------------------
# 5) Working directory
# ------------------------------------------------
WORKDIR /app

# (iOS build lines omitted)

# Example usage:
# docker run --rm -v $(pwd):/app <image-name> \
#   sh -c "cd /app && flutter build apk --release"