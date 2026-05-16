import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter, Rate, Trend } from 'k6/metrics';

const errorCount   = new Counter('errors');
const successRate  = new Rate('success_rate');
const latencyTrend = new Trend('api_latency_ms', true);

export const options = {
  stages: [
    { duration: '2m',  target: 20  },
    { duration: '5m',  target: 50  },
    { duration: '10m', target: 100 },
    { duration: '5m',  target: 50  },
    { duration: '2m',  target: 0   },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    success_rate:      ['rate>0.99'],
    errors:            ['count<10'],
  },
};

const BASE_URL = __ENV.BASE_URL || 'https://api.platform.example.com';
const API_TOKEN = __ENV.API_TOKEN || '';

const headers = {
  'Content-Type':  'application/json',
  'Authorization': `Bearer ${API_TOKEN}`,
};

export default function () {
  // Health check
  const healthRes = http.get(`${BASE_URL}/health`, { headers });
  const healthOk = check(healthRes, {
    'health status 200': (r) => r.status === 200,
    'health latency <100ms': (r) => r.timings.duration < 100,
  });
  successRate.add(healthOk);
  latencyTrend.add(healthRes.timings.duration);
  if (!healthOk) errorCount.add(1);

  // List resources
  const listRes = http.get(`${BASE_URL}/api/v1/resources`, { headers });
  const listOk = check(listRes, {
    'list status 200': (r) => r.status === 200,
    'list has data':   (r) => r.json('data') !== undefined,
  });
  successRate.add(listOk);
  latencyTrend.add(listRes.timings.duration);
  if (!listOk) errorCount.add(1);

  // Create resource
  const payload = JSON.stringify({ name: `load-test-${Date.now()}`, type: 'test' });
  const createRes = http.post(`${BASE_URL}/api/v1/resources`, payload, { headers });
  const createOk = check(createRes, {
    'create status 201': (r) => r.status === 201,
    'create latency <300ms': (r) => r.timings.duration < 300,
  });
  successRate.add(createOk);
  if (!createOk) errorCount.add(1);

  sleep(1);
}

export function handleSummary(data) {
  return {
    'stdout': JSON.stringify(data.metrics, null, 2),
  };
}
