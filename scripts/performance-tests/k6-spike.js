import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '30s', target: 5 },
    { duration: '10s', target: 200 },
    { duration: '1m', target: 200 },
    { duration: '10s', target: 5 },
    { duration: '2m', target: 5 },
    { duration: '10s', target: 400 },
    { duration: '1m', target: 400 },
    { duration: '10s', target: 0 },
  ],
  thresholds: {
    errors: ['rate<0.05'],
    http_req_duration: ['p(95)<3000'],
    http_req_failed: ['rate<0.05'],
  },
};

const BASE_URL = __ENV.API_BASE_URL || 'http://localhost:8080';

export default function () {
  const res = http.get(`${BASE_URL}/api/health`, {
    tags: { name: 'spike_health' },
    timeout: '5s',
  });

  const ok = check(res, {
    'status 200': (r) => r.status === 200,
    'response under 3s': (r) => r.timings.duration < 3000,
  });

  errorRate.add(!ok);
  sleep(0.1);
}
