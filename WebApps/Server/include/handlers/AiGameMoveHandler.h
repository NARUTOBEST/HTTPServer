#pragma once
#include "../../../../HttpServer/include/router/RouterHandler.h"
#include "../Server.h"

class AiGameMoveHandler : public http::router::RouterHandler
{
public:
    explicit AiGameMoveHandler(AppServer* server) : server_(server) {}
    void handle(const http::HttpRequest& req, http::HttpResponse* resp) override;
private:
    AppServer* server_;
};