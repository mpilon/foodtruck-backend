# start by pulling the python image
FROM python:3.8

#RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
#RUN apk add --update --no-cache py3-numpy py3-pandas@testing
#ENV PYTHONPATH=/usr/lib/python3.8/site-packages

# copy every content from the local file to the image
COPY app /app

COPY ./requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["gunicorn", "-w", "2", "--threads", "2",  "-b", "0.0.0.0:5000", "wsgi:app"]




