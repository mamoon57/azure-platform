import logging

import azure.functions as func

app = func.FunctionApp()


@app.route(route="health", methods=["GET"])
def health(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("health check hit")
    return func.HttpResponse("ok", status_code=200)
