import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const apiLatency = new Trend('api_latency');

export const options = {
  stages: [
    { duration: '5m', target: 100 },
    { duration: '10m', target: 100 },
    { duration: '5m', target: 200 },
    { duration: '10m', target: 200 },
    { duration: '5m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(99)<2000'],
    errors: ['rate<0.05'],
  },
};

const BASE_URL = __ENV.TARGET_URL || 'https://platform.example.com';

export default function () {
  const responses = http.batch([
    ['GET', `${BASE_URL}/health`],
    ['GET', `${BASE_URL}/api/v1/status`],
  ]);

  responses.forEach((res) => {
    apiLatency.add(res.timings.duration);
    const ok = check(res, { 'status 2xx': (r) => r.status >= 200 && r.status < 300 });
    errorRate.add(!ok);
  });

  sleep(0.5);
}
