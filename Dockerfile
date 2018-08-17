FROM openjdk:8-jdk

MAINTAINER dmytryK

ENV VERSION_SDK_TOOLS "4333796"
ENV ANDROID_COMPILE_SDK "28"
ENV ANDROID_BUILD_TOOLS "28.0.2"
ENV ANDROID_SDK_TOOLS "26.1.1"

ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME /usr/local/android-sdk

ENV PATH $PATH:$ANDROID_SDK_HOME/tools
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      lib32stdc++6 \
      lib32gcc1 \
      lib32z1 \
      unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-$VERSION_SDK_TOOLS.zip > /sdk.zip && \
    unzip /sdk.zip -d $ANDROID_HOME && \
    rm -v /sdk.zip

RUN mkdir -p $ANDROID_SDK_HOME/.android/ && \
    touch $ANDROID_SDK_HOME/.android/repositories.cfg

RUN mkdir -p $ANDROID_HOME/licenses/ && \
   echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license && \
   echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license

RUN $ANDROID_HOME/tools/bin/sdkmanager --update && \
    $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK" "build-tools;$ANDROID_BUILD_TOOLS" "extras;google;m2repository" "extras;android;m2repository" > installPlatform.log

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

RUN chmod -R a+rx $ANDROID_SDK_HOME