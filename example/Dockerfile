# --- base image -----------------------------------------------------------------------
FROM python:3.11-slim-bookworm as base

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

# venv
RUN python -m venv /venv
ENV PATH=/venv/bin:$PATH

# base dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install build

# set workdir
WORKDIR /app

# --- dev stage ------------------------------------------------------------------------
FROM base as dev

# dev-only dependencies
COPY requirements-dev.txt .
RUN pip install -r requirements-dev.txt

# copy sources
COPY src /app/src
COPY tests /app/tests

# --- runtime stage --------------------------------------------------------------------
FROM base as runtime

# copy sources
COPY src /app/src

# default cmd
CMD ["python", "-m", "src.main"]
