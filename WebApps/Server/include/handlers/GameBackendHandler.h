#pragma once
#include "../../../../HttpServer/include/router/RouterHandler.h"
#include "../Server.h"

class GameBackendHandler : public http::router::RouterHandler 
{
public:
    explicit GameBackendHandler(AppServer* server) : server_(server) {}

    void handle(const http::HttpRequest& req, http::HttpResponse* resp) override;

private:
    AppServer* server_;
};