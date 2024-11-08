import os
import logging
import azure.functions as func
# from dotenv import load_dotenv

def main(req: func.HttpRequest) -> func.HttpResponse:
    functionName = "EchoTrigger"
    logging.info(f'{functionName}: triggered by request.')

    try:
      name = req.params.get('name')
      if not name:
        req_body = req.get_json()
      if req_body:
        name = req_body.get('name')
      if not name:
        name = 'Nobody'
    except:
      name = 'Unknown'
      pass

    logging.info(f"{functionName}:   Received name: '{name}'.")
    if name:
        return func.HttpResponse(f"{functionName} executed successfully and received name '{name}'!")
    else:
        return func.HttpResponse(
             "{functionName} executed successfully but there was no name in the query string or in the request body!",
             status_code=200
        )
