# Stage 1: Build frontend
FROM node:20-alpine AS frontend
WORKDIR /build
COPY package.json yarn.lock tsconfig.json ./
COPY frontend/ frontend/
RUN yarn install --frozen-lockfile --network-timeout 120000 && \
    yarn run build --env production

# Stage 2: Build backend
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS backend
WORKDIR /build
COPY src/ src/
COPY Logo/ Logo/
COPY --from=frontend /build/_output/UI _output/UI
RUN dotnet msbuild -restore src/Readarr.sln \
    -p:Configuration=Release \
    -p:Platform=Posix \
    -p:RuntimeIdentifiers=linux-x64 \
    -p:TreatWarningsAsErrors=false \
    -p:EnforceCodeStyleInBuild=false \
    -t:PublishAllRids

# Stage 3: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0
LABEL maintainer="SharXeniX"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libicu-dev \
    libsqlite3-0 \
    xmlstarlet \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Copy published backend
COPY --from=backend /build/_output/net6.0/linux-x64/publish/ /app/readarr/bin/
# Copy UI
COPY --from=backend /build/_output/UI/ /app/readarr/bin/UI/

RUN chmod +x /app/readarr/bin/Readarr

EXPOSE 8787
VOLUME /config /data

ENV HOME=/config

ENTRYPOINT ["/app/readarr/bin/Readarr", "-nobrowser", "-data=/config"]
