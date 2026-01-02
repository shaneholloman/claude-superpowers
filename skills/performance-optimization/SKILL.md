---
name: performance-optimization
description: Performance profiling, optimization techniques, and bottleneck identification. Use when addressing performance issues or optimizing systems.
---

# Performance Optimization Skill

## Purpose
Identify performance bottlenecks and apply targeted optimizations across the stack.

## Performance Investigation Methodology

### Step 1: Measure First
**Never optimize without data.**

```bash
# CPU profiling (Node.js)
node --prof app.js
node --prof-process isolate-*.log > processed.txt

# Memory profiling
node --inspect app.js
# Then use Chrome DevTools

# Load testing
wrk -t12 -c400 -d30s http://localhost:3000/api
```

### Step 2: Identify Bottleneck Type

| Symptom | Likely Cause |
|---------|--------------|
| High CPU, normal memory | CPU-bound (algorithms, parsing) |
| Normal CPU, high memory | Memory leak or large allocations |
| Low CPU, slow response | I/O bound (DB, network, disk) |
| Intermittent slowness | GC pauses, lock contention |

### Step 3: Apply Targeted Fix
Optimize the bottleneck, not everything.

## Database Optimization

### Query Analysis

```sql
-- PostgreSQL: Find slow queries
SELECT query, calls, mean_time, total_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- MySQL: Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

-- EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';
```

### N+1 Query Problem

```typescript
// ❌ N+1 Problem: 1 + N queries
const users = await User.findAll();
for (const user of users) {
  const orders = await Order.findAll({ where: { userId: user.id }});
}

// ✅ Fixed: 1 query with JOIN
const users = await User.findAll({
  include: [{ model: Order }]
});

// ✅ Or batch loading: 2 queries
const users = await User.findAll();
const userIds = users.map(u => u.id);
const orders = await Order.findAll({ where: { userId: userIds }});
```

### Indexing Strategy

```sql
-- Index for equality lookups
CREATE INDEX idx_users_email ON users(email);

-- Composite index for multi-column queries
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);

-- Partial index for filtered queries
CREATE INDEX idx_orders_pending ON orders(status)
WHERE status = 'pending';

-- Check index usage
SELECT indexrelname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
WHERE schemaname = 'public';
```

### Connection Pooling

```typescript
// pg-pool configuration
const pool = new Pool({
  max: 20,                    // Max connections
  idleTimeoutMillis: 30000,   // Close idle connections
  connectionTimeoutMillis: 2000, // Fail fast
});
```

## Caching Strategies

### Cache Hierarchy

```
┌─────────────────────────────────────────────────┐
│ L1: In-Memory (fastest, per-instance)           │
│ └─ Map, LRU Cache                               │
├─────────────────────────────────────────────────┤
│ L2: Distributed Cache (fast, shared)            │
│ └─ Redis, Memcached                             │
├─────────────────────────────────────────────────┤
│ L3: CDN (edge, static content)                  │
│ └─ Cloudflare, CloudFront                       │
├─────────────────────────────────────────────────┤
│ L4: Database (slow, persistent)                 │
│ └─ PostgreSQL, MongoDB                          │
└─────────────────────────────────────────────────┘
```

### Caching Patterns

```typescript
// Cache-Aside (Lazy Loading)
async function getUser(id: string) {
  let user = await cache.get(`user:${id}`);
  if (!user) {
    user = await db.users.findById(id);
    await cache.set(`user:${id}`, user, { ttl: 3600 });
  }
  return user;
}

// Write-Through
async function updateUser(id: string, data: UserData) {
  const user = await db.users.update(id, data);
  await cache.set(`user:${id}`, user);
  return user;
}

// Cache Invalidation
async function deleteUser(id: string) {
  await db.users.delete(id);
  await cache.delete(`user:${id}`);
  await cache.delete(`user-list`); // Invalidate related caches
}
```

### Cache Key Design

```typescript
// Good: Specific, versioned keys
`user:${userId}:v2`
`products:category:${categoryId}:page:${page}`

// Include invalidation tokens
`user:${userId}:${user.updatedAt.getTime()}`
```

## Algorithm Optimization

### Time Complexity Reference

| Operation | Array | Hash Map | Sorted Array | BST |
|-----------|-------|----------|--------------|-----|
| Search | O(n) | O(1) | O(log n) | O(log n) |
| Insert | O(1)* | O(1) | O(n) | O(log n) |
| Delete | O(n) | O(1) | O(n) | O(log n) |

### Common Optimizations

```typescript
// ❌ O(n²) - nested loops
const duplicates = [];
for (const item of arr1) {
  for (const item2 of arr2) {
    if (item === item2) duplicates.push(item);
  }
}

// ✅ O(n) - use Set
const set = new Set(arr2);
const duplicates = arr1.filter(item => set.has(item));
```

```typescript
// ❌ Repeated string concatenation O(n²)
let result = '';
for (const str of strings) {
  result += str;
}

// ✅ Array join O(n)
const result = strings.join('');
```

## Memory Optimization

### Identifying Memory Leaks

```typescript
// Common leak patterns:

// 1. Event listeners not removed
element.addEventListener('click', handler);
// Fix: element.removeEventListener('click', handler);

// 2. Closures holding references
function createHandler() {
  const largeData = new Array(1000000);
  return () => console.log(largeData.length);
}
// Fix: Only capture what's needed

// 3. Unbounded caches
const cache = new Map();
// Fix: Use LRU cache with max size

// 4. Circular references in cleanup
class Parent {
  child = new Child(this);
}
// Fix: Use WeakRef or explicit cleanup
```

### Memory-Efficient Patterns

```typescript
// Streaming large files
import { createReadStream } from 'fs';
import { pipeline } from 'stream/promises';

await pipeline(
  createReadStream('large-file.json'),
  new JSONTransformStream(),
  createWriteStream('output.json')
);

// Pagination for large datasets
async function* paginatedFetch(endpoint: string) {
  let page = 1;
  while (true) {
    const data = await fetch(`${endpoint}?page=${page}`);
    if (data.length === 0) break;
    yield* data;
    page++;
  }
}
```

## Network Optimization

### HTTP/2 and Connection Reuse

```typescript
// Keep-alive connections
const agent = new https.Agent({
  keepAlive: true,
  maxSockets: 100,
});

// HTTP/2 multiplexing
import http2 from 'http2';
const client = http2.connect('https://api.example.com');
```

### Compression

```typescript
// Express with compression
import compression from 'compression';
app.use(compression());

// Response size comparison
// JSON: 100KB → gzip: 15KB → brotli: 12KB
```

### Batching Requests

```typescript
// ❌ Individual requests
for (const id of ids) {
  await fetch(`/api/users/${id}`);
}

// ✅ Batch request
await fetch('/api/users', {
  method: 'POST',
  body: JSON.stringify({ ids })
});
```

## Frontend Optimization

### Bundle Size

```bash
# Analyze bundle
npx webpack-bundle-analyzer stats.json

# Tree shaking - use named imports
import { debounce } from 'lodash-es'; // ✅
import _ from 'lodash';               // ❌ imports everything
```

### Rendering Performance

```typescript
// React: Memoization
const MemoizedComponent = React.memo(Component);

// Avoid inline objects/functions
// ❌ Creates new object every render
<Component style={{ color: 'red' }} />

// ✅ Stable reference
const styles = { color: 'red' };
<Component style={styles} />

// Virtualization for long lists
import { FixedSizeList } from 'react-window';
```

### Core Web Vitals

| Metric | Target | How to Improve |
|--------|--------|----------------|
| LCP (Largest Contentful Paint) | < 2.5s | Optimize images, preload critical resources |
| FID (First Input Delay) | < 100ms | Reduce JS execution, code split |
| CLS (Cumulative Layout Shift) | < 0.1 | Reserve space for dynamic content |

## Profiling Commands

```bash
# Node.js CPU Profile
node --cpu-prof app.js
# Analyze with Chrome DevTools

# Memory Heap Snapshot
node --heapsnapshot-signal=SIGUSR2 app.js
kill -SIGUSR2 <pid>

# Linux system profiling
perf record -g node app.js
perf report

# HTTP load test
wrk -t12 -c400 -d30s --latency http://localhost:3000/

# Database query time
time psql -c "SELECT ..." database
```

## Optimization Checklist

### Before You Start
- [ ] Do you have metrics/baseline?
- [ ] Is this the actual bottleneck?
- [ ] What is the target performance?

### Quick Wins
- [ ] Add database indexes for slow queries
- [ ] Enable response compression
- [ ] Add caching layer
- [ ] Reduce payload sizes

### Deep Optimization
- [ ] Profile CPU usage
- [ ] Analyze memory allocation
- [ ] Review algorithm complexity
- [ ] Optimize database queries

### Validation
- [ ] Load test with realistic data
- [ ] Monitor in production
- [ ] Set up alerting for regression
