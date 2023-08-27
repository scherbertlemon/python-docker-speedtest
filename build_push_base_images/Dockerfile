ARG PYTHON_VERSION=3.11.4
FROM python:${PYTHON_VERSION}-slim-bullseye AS baseimage

WORKDIR /project
RUN apt-get update && apt-get install --no-install-recommends --yes \
    gcc \
    make \
    curl \
    wget \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

ARG POETRY_VERSION=1.6.1
RUN pip install poetry

FROM baseimage AS environment

COPY poetry.lock poetry.toml pyproject.toml /project/
RUN poetry install --no-interaction --no-root \
    && poetry cache clear --all --no-interaction .
