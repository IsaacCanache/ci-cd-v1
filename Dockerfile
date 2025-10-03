FROM ubuntu:22.04

RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install flask==2.2.5

# install app
COPY helloworld.py /

# final configuration
ENV FLASK_APP=helloworld
EXPOSE 8000
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
