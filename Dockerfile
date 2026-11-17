
# Stage 1: Builder

FROM python:3 AS builder

WORKDIR /app

COPY requirements.txt .


# Stage 2: Production

FROM python:3.10-slim

RUN adduser --disabled-password --gecos '' appuser

WORKDIR /app

ENV PYTHONUNBUFFERED=1

# Install dependencies using the runtime Python version
COPY --from=builder /app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["python", "-m", "gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]
