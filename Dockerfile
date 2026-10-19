FROM python:3.12-slim AS base
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
COPY pyproject.toml README.md ./
COPY emberline ./emberline
RUN pip install --no-cache-dir '.[api]'
COPY scripts ./scripts
COPY web ./web
COPY data/raw ./data/raw
# Build the simulated demo at image build time so the container starts ready.
RUN python scripts/run_demo.py --out build/demo && python scripts/run_australia.py --out build/australia \
    && python scripts/run_india.py --out build/india && python scripts/validate_static_real.py \
    && python scripts/build_web.py
EXPOSE 8000
HEALTHCHECK CMD python -c "import urllib.request;urllib.request.urlopen('http://localhost:8000/health')"
CMD ["uvicorn", "emberline.api:app", "--host", "0.0.0.0", "--port", "8000"]
