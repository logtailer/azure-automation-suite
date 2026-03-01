import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '2m', target: 20 },   // ramp-up
    { duration: '5m', target: 20 },   // steady state
    { duration: '2m', target: 50 },   // spike
    { duration: '5m', target: 50 },   // hold spike
    { duration: '2m', target: 0 },    // ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    errors: ['rate<0.01'],
  },
};

const BASE_URL = __ENV.TARGET_URL || 'https://platform.example.com';

export default function () {
  const res = http.get(`${BASE_URL}/health`);

  const ok = check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  errorRate.add(!ok);
  sleep(1);
}
