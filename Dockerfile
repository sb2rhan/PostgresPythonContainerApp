FROM ubuntu:latest
LABEL authors="Batyrkhan"
RUN apt-get update
RUN apt-get install python3 python3-pip -y
WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN pip3 install -r requirements.txt --break-system-packages

COPY part2_queries.py /app

CMD python3 part2_queries.py