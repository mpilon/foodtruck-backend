# start by pulling the python image
FROM python:3.8

# copy every content from the local file to the image
COPY app /app

COPY ./requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

EXPOSE 5000

## AWS SSM Agent

RUN mkdir /tmp/ssm && \
	cd /tmp/ssm && \
	wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb && \
	dpkg -i amazon-ssm-agent.deb

CMD ["gunicorn", "-w", "2", "--threads", "2",  "-b", "0.0.0.0:5000", "wsgi:app"]




