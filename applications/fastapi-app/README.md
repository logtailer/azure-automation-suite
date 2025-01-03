# FastAPI Sample Microservice

This is a sample FastAPI application demonstrating modern Python microservice patterns for the Azure DevOps platform.

## Features

- **FastAPI Framework**: Modern, fast web framework for building APIs
- **Async Support**: Asynchronous request handling for better performance
- **Health Checks**: Built-in health endpoints for monitoring
- **Metrics**: Prometheus metrics integration
- **Documentation**: Auto-generated OpenAPI/Swagger documentation
- **Container Ready**: Optimized Docker image for Kubernetes deployment

## API Endpoints

- `GET /` - Root endpoint with API information
- `GET /health` - Health check endpoint
- `GET /metrics` - Prometheus metrics endpoint
- `GET /api/v1/users` - Sample user management endpoint
- `POST /api/v1/users` - Create new user
- `GET /api/v1/status` - Application status and version

## Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
uvicorn main:app --reload --port 8000

# Access the API
curl http://localhost:8000/
curl http://localhost:8000/health

# View documentation
open http://localhost:8000/docs
```

## Docker

```bash
# Build the image
docker build -t fastapi-app:latest .

# Run the container
docker run -p 8000:8000 fastapi-app:latest

# Test the deployment
curl http://localhost:8000/health
```

## Kubernetes Deployment

The application is automatically deployed via ArgoCD when changes are pushed to the main branch.

```bash
# Manual deployment
kubectl apply -f k8s/

# Check deployment status
kubectl get pods -l app=fastapi-app
kubectl get services -l app=fastapi-app

# View logs
kubectl logs -l app=fastapi-app -f
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | 8000 |
| `LOG_LEVEL` | Logging level | info |
| `METRICS_ENABLED` | Enable Prometheus metrics | true |
| `DATABASE_URL` | Database connection string | sqlite:///./app.db |

## Monitoring

The application exposes Prometheus metrics at `/metrics`:

- `http_requests_total` - Total HTTP requests
- `http_request_duration_seconds` - Request duration
- `app_users_total` - Total registered users
- `app_version_info` - Application version information

## Testing

```bash
# Unit tests
pytest tests/unit/

# Integration tests  
pytest tests/integration/

# Load testing
locust --host=http://localhost:8000
```
