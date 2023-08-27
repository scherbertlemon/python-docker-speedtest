FROM scherbertlemon/python-poetry:3.11.4-1.1

COPY src /project/src
COPY poetry.lock poetry.toml pyproject.toml /project/
RUN poetry install --no-interaction \
    && poetry cache clear --all --no-interaction .
