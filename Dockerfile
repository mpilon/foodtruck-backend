# start by pulling the python image
FROM python:3.8

RUN mkdir /tmp/ssm \
	cd /tmp/ssm \
	wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb \
	sudo dpkg -i amazon-ssm-agent.deb \
	sudo systemctl enable amazon-ssm-agent

# copy every content from the local file to the image
COPY app /app

COPY ./requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["gunicorn", "-w", "2", "--threads", "2",  "-b", "0.0.0.0:5000", "wsgi:app"]




