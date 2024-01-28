#Dockerfile

FROM public.ecr.aws/lambda/python:3.12

# Installieren Sie notwendige Pakete
RUN pip install Pillow boto3

# Fügen Sie den Code zur Lambda-Funktion hinzu
COPY lambda_function.py ${LAMBDA_TASK_ROOT}

# Setzen Sie die Datei, die ausgeführt werden soll
CMD ["lambda_function.lambda_handler"]
