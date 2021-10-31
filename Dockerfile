FROM python:3.7
COPY . .
WORKDIR .
RUN pip install -r requirements.txt
ENTRYPOINT ["python", "main.py"]