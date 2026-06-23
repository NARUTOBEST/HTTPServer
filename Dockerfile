# ========== 阶段1：编译 ==========
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    g++ cmake make wget unzip \
    libssl-dev libmysqlcppconn-dev default-libmysqlclient-dev \
    nlohmann-json3-dev \
    libboost-system-dev libboost-thread-dev \
    && rm -rf /var/lib/apt/lists/*

# 下载编译安装 muduo
RUN wget -O /tmp/muduo.zip https://github.com/chenshuo/muduo/archive/refs/heads/master.zip \
    && unzip /tmp/muduo.zip -d /tmp \
    && cd /tmp/muduo-master \
    && chmod +x build.sh \
    && ./build.sh \
    && ./build.sh install \
    && cp -r /tmp/build/release-install-cpp11/include/muduo /usr/include/ \
    && cp /tmp/build/release-install-cpp11/lib/* /usr/local/lib/ \
    && ldconfig \
    && rm -rf /tmp/muduo.zip /tmp/muduo-master /tmp/build

WORKDIR /app
COPY . .

RUN mkdir build && cd build \
    && cmake .. \
    && make -j$(nproc)

# ========== 阶段2：运行 ==========
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/*

# 数据库、Boost 运行库
COPY --from=builder /usr/lib/x86_64-linux-gnu/libmysqlcppconn.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libmysqlclient.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libboost_system.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libboost_thread.so* /usr/lib/x86_64-linux-gnu/

# ========== 新增：补齐 muduo 动态库 ==========
COPY --from=builder /usr/local/lib/libmuduo*.so* /usr/lib/x86_64-linux-gnu/

# 刷新动态链接缓存
RUN ldconfig

WORKDIR /app/build
# 复制可执行程序（与本地 build/ 目录运行方式一致）
COPY --from=builder /app/build/simple_server .
# 复制网页静态资源（对应 ../WebApps/Server/resource）
COPY --from=builder /app/WebApps/Server/resource ../WebApps/Server/resource

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

ENV DB_HOST=tcp://mysql:3306 \
    DB_USER=root \
    DB_PASSWORD=root \
    DB_NAME=webapp

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["./simple_server", "-p", "8080"]