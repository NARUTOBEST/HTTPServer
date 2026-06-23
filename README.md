# HTTPServer


基于 C++ 与 Muduo 库构建的 HTTP 服务框架，并提供在线五子棋作为示例 Web 应用。

## 与 WebServer 的区别

WebServer 项目一般从 socket 开始，实现简单的 HTTP 访问与响应，**重点在于网络通信框架**。

HTTP 服务框架项目的**重点在于应用层部分的实现**，可作为 WebServer 的进阶版。

## 什么是 HTTP 框架？

HTTP 框架是一种软件库，旨在简化 Web 应用程序和服务的开发。

它提供了一种结构化的方法来处理 HTTP 请求和响应，管理路由，并通常包括会话管理、安全性和数据处理的工具。

HTTP 框架抽象了网络通信的复杂性，使开发人员能够专注于构建应用程序逻辑。

## 为什么要实现 HTTP 框架？

1. 效率：通过提供可重用的组件和抽象，HTTP 框架减少了开发人员需要编写的样板代码，从而加快了开发过程。
2. 可扩展性：框架通常内置支持处理多个并发请求，使构建可扩展的应用程序变得更加容易。
3. 可维护性：结构良好的框架强制执行最佳实践和设计模式，使代码库更易于维护和扩展。
4. 安全性：框架通常包括安全功能，如输入验证、输出编码以及防止常见漏洞（如 SQL 注入和跨站脚本攻击）。
5. 社区和支持：流行的框架拥有庞大的社区和丰富的文档，为开发人员提供支持和资源。

## 项目概述

该项目是一个使用 Muduo 库构建的 HTTP 框架，Muduo 是一个用于高性能网络应用的 C++ 网络库。

该框架旨在高效处理 HTTP 请求和响应，为构建 Web 应用程序提供基础。

### 关键组件

1. HttpRequest 和 HttpResponse：这些类封装了 HTTP 请求和响应的细节。HttpRequest 处理 HTTP 方法、头部和主体内容的解析，而 HttpResponse 管理 HTTP 响应的构建，包括状态码、头部和主体内容的设置。
2. HttpContext：该类管理 HTTP 请求在处理过程中的状态。它跟踪解析状态并存储 HttpRequest 对象，确保请求的完整性和一致性。
3. HttpServer：作为框架的核心，HttpServer 负责接受连接、读取请求和发送响应。它使用 Muduo 库的高效事件驱动架构来处理网络通信，支持高并发和低延迟。
4. 路由和处理器：框架支持根据请求路径和方法将请求路由到特定的处理器。处理器负责处理请求并生成适当的响应，支持动态路由和中间件功能。
5. 日志记录和错误处理：框架包括日志记录功能以跟踪请求处理，并提供错误处理机制以优雅地管理异常和无效请求。通过详细的日志记录和错误报告，开发者可以快速定位和解决问题。
6. 会话管理：支持用户会话的创建、维护和销毁，确保用户状态的一致性和安全性。
7. 中间件支持：允许开发者在请求处理的各个阶段插入自定义逻辑，增强系统的灵活性和可扩展性。

### 工作原理

1. 请求解析：传入的 HTTP 请求由 HttpContext 类解析，提取方法、路径、头部和主体。解析后的请求被传递给路由系统。
2. 路由：根据请求路径和方法，框架将请求路由到适当的处理器。路由系统支持静态和动态路径匹配，确保请求被正确处理。
3. 响应生成：处理器处理请求并生成 HttpResponse，然后将其发送回客户端。响应生成过程包括设置状态码、头部和主体内容。
4. 连接管理：框架使用 Muduo 的事件驱动架构管理连接，使其能够高效地处理多个并发连接。通过非阻塞 I/O 和多线程支持，系统能够在高负载下保持稳定。
5. 安全通信：通过集成 OpenSSL，框架支持 HTTPS，确保数据传输的安全性和完整性。

### 项目模块

本项目分为六大模块，分别是：报文解析模块、路由模块、会话管理模块、中间件模块、数据库连接池模块、HTTPS 模块。

### 示例应用

框架下附带了一个在线五子棋示例，用于演示登录注册、会话管理、路由分发、数据库访问等完整 Web 开发流程。五子棋本身不是框架重点，仅作为业务层开发参考。

### 未来增强

* 模板渲染：添加支持渲染 HTML 模板以简化动态网页的创建。
* WebSocket 支持：扩展框架以支持 WebSocket 连接，实现实时通信。
* 身份验证和授权：集成 OAuth 和 JWT 等认证方式。
* 负载均衡和分布式支持：通过引入负载均衡策略和分布式架构，提升系统的可扩展性和可靠性。

### 项目难点

* 请求解析的准确性：解析 HTTP 请求时，需要准确地解析请求行、头部和主体。
* 继承和多态技术：完成 URI 到处理器的绑定。
* 灵活的路由机制：框架需要提供灵活的路由机制，以便根据请求路径和方法将请求路由到正确的处理器。
* 模块化设计：框架应采用模块化设计，以便于扩展和维护。
* 动态路由：支持基于 URL 模式的动态路由（例如，支持 /users/:id 这样的路径）。
* 会话支持：实现会话管理，支持用户登录状态的保持。
* 数据库集成：数据库连接池、ORM 支持等。
* 路由中间件：允许在请求到达最终处理器之前进行预处理（例如，身份验证、日志记录）。
* 常用中间件：CORS 处理、请求限流、压缩（gzip）等。

## 项目结构

```
HTTPServer/
├── HttpServer/          # HTTP 框架核心
├── WebApps/Server/      # 示例 Web 应用（五子棋）
└── CMakeLists.txt
```

## 构建与运行

示例应用依赖 MySQL 数据库。推荐用 **Docker Compose** 一键启动；也可在 Linux / WSL 下本地编译运行。

### 方式一：Docker Compose（推荐）

**环境要求：** [Docker](https://docs.docker.com/get-docker/) 与 [Docker Compose](https://docs.docker.com/compose/)

在项目根目录执行：

```bash
# 1. 拉取 Docker Hub 上的应用镜像
docker pull lly666666/httpserver:v1.0

# 2. 启动服务（MySQL 镜像已在 docker-compose.yml 中声明，compose 会自动拉取）
docker compose up -d
```

若修改了源码、需要本地重新编译应用：

```bash
docker compose up --build -d
```

首次启动会自动：

1. 拉取 `mysql:8.0`（由 compose 根据 `docker-compose.yml` 自动完成）
2. 使用 `lly666666/httpserver:v1.0` 应用镜像（或 `--build` 时从源码重新构建）
3. 执行 `init.sql` 初始化 `webapp` 库与 `users` 表
4. 等待 MySQL 就绪后启动 HTTP 服务

启动完成后，浏览器访问：

```
http://localhost:8080
```

常用命令：

```bash
# 查看日志
docker compose logs -f app

# 停止服务
docker compose down

# 停止并清除数据库卷（下次启动会重新执行 init.sql）
docker compose down -v
```

**可配置环境变量**（可在项目根目录创建 `.env` 文件，或直接 export）：

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `APP_PORT` | `8080` | 宿主机映射端口 |
| `MYSQL_ROOT_PASSWORD` | `root` | MySQL root 密码 |
| `DB_NAME` | `webapp` | 数据库名 |
| `DB_USER` | `root` | 应用连接用户名 |
| `DB_HOST` | `tcp://mysql:3306` | 应用连接地址（容器内默认即可） |

> MySQL 默认**不映射**到宿主机 3306，避免与本机已有 MySQL 冲突；应用通过 Docker 内网 `mysql:3306` 访问。

### 方式二：本地编译运行

**环境要求（Linux / WSL 推荐）：**

- C++17 编译器（g++ / clang）
- CMake ≥ 3.10
- [Muduo](https://github.com/chenshuo/muduo)（已编译安装）
- OpenSSL、Boost
- MySQL Server 8.0
- `libmysqlcppconn-dev`、`libmysqlclient-dev`、`nlohmann-json3-dev`

**1. 初始化数据库**

确保 MySQL 已启动，执行：

```bash
mysql -u root -p < init.sql
```

**2. 编译**

```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
```

**3. 运行**

默认监听 **80** 端口（需 root 权限）或指定其他端口：

```bash
# 使用 8080 端口（无需 root）
./simple_server -p 8080
```

本地运行时，数据库连接可通过环境变量覆盖（未设置时使用下列默认值）：

| 变量 | 默认值 |
|------|--------|
| `DB_HOST` | `tcp://127.0.0.1:3306` |
| `DB_USER` | `root` |
| `DB_PASSWORD` | `root` |
| `DB_NAME` | `webapp` |

示例：

```bash
export DB_PASSWORD=your_password
./simple_server -p 8080
```

浏览器访问 `http://localhost:8080`（或你指定的端口）。

> Windows 原生环境因 CMake 中 Muduo / MySQL 头文件路径为 Linux 风格，建议用 **WSL2** 或 **Docker** 运行。
