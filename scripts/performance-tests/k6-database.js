import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const dbErrorRate = new Rate('db_errors');
const queryDuration = new Trend('query_duration_ms');

export const options = {
  stages: [
    { duration: '1m', target: 20 },
    { duration: '3m', target: 20 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
    db_errors: ['rate<0.01'],
    query_duration_ms: ['p(95)<500'],
    http_req_duration: ['p(95)<1000'],
  },
};

const BASE_URL = __ENV.API_BASE_URL || 'http://localhost:8080';

export default function () {
  // Read-heavy workload — simulates typical OLTP pattern
  const responses = http.batch([
    ['GET', `${BASE_URL}/api/users?limit=10`, null, { tags: { name: 'list_users' } }],
    ['GET', `${BASE_URL}/api/items?page=1`, null, { tags: { name: 'list_items' } }],
    ['GET', `${BASE_URL}/health/db`, null, { tags: { name: 'db_health' } }],
  ]);

  responses.forEach((res) => {
    const ok = check(res, { 'status is 2xx': (r) => r.status >= 200 && r.status < 300 });
    dbErrorRate.add(!ok);
    queryDuration.add(res.timings.duration);
  });

  // Occasional write
  if (Math.random() < 0.1) {
    const writeRes = http.post(
      `${BASE_URL}/api/events`,
      JSON.stringify({ type: 'k6_test', timestamp: Date.now() }),
      { headers: { 'Content-Type': 'application/json' }, tags: { name: 'write_event' } }
    );
    check(writeRes, { 'write accepted': (r) => r.status === 201 || r.status === 200 });
  }

  sleep(0.5);
}
