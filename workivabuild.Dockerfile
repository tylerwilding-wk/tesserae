FROM clojure:lein-2.8.3-alpine as build

# Setup Leiningen Profile with Authentication
COPY ./workivabuild.profiles.clj /root/.lein/profiles.clj

# Copy in Source
WORKDIR /build
COPY . /build

# Fetch Dependencies
RUN lein deps

# Lint
RUN lein cljfmt check

# Run Tests
RUN lein test

# Build Docs
RUN lein docs
RUN cd ./documentation && tar cvfz "../tesserae-docs.tgz" ./
ARG BUILD_ARTIFACTS_DOCUMENTATION=/build/tesserae-docs.tgz

# Build Artifact
RUN lein jar
ARG BUILD_ARTIFACTS_JAVA=/build/target/tesserae-*.jar

# Audit Artifacts
RUN lein pom
ARG BUILD_ARTIFACTS_AUDIT=/build/pom.xml

FROM scratch
