# Use an OpenJDK base image
FROM openjdk:17-slim

# Install essential packages
RUN apt-get update && apt-get install -y wget unzip

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

# Create SDK directory
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

# Download Android Command Line Tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Accept licenses and install necessary packages
RUN yes | sdkmanager --licenses

# Install build tools, platform tools and desired platforms
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-8.6-bin.zip -O gradle.zip && \
    unzip gradle.zip -d /opt && \
    rm gradle.zip

ENV PATH=$PATH:/opt/gradle-8.6/bin

# Set working directory inside container
WORKDIR /workspace

# Copy your Android project into the container
COPY . /workspace

# Make gradlew executable
RUN chmod +x ./gradlew

# Build the APK
CMD ["./gradlew", "assembleDebug"]
