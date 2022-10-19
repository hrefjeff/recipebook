# Pull base image
FROM python:3.10.2-slim-bullseye

# Set environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONDONOTWRITEBYTECODE 1
ENV PYTHONNUMBEFFERED 1
ENV PATH="/scripts:${PATH}"

# Set work directory
WORKDIR /code

# Install dependencies
COPY ./requirements.txt .
RUN echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y gcc
RUN rm -rf /var/lib/apt/lists/*
RUN pip install -r requirements.txt

# Copy project
COPY ./scripts /scripts
COPY . .

RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

RUN adduser --disabled-login nginxuser
RUN chown -R nginxuser:nginxuser /vol
RUN chmod -R 755 /vol/web
USER nginxuser

CMD ["entrypoint.sh"]
