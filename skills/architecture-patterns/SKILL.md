---
name: architecture-patterns
description: Architectural patterns and design principles for scalable, maintainable systems. Use when designing systems, refactoring architecture, or choosing patterns.
---

# Architecture Patterns Skill

## Purpose
Guide architectural decisions with proven patterns for building scalable, maintainable, and testable systems.

## Core Architectural Styles

### Clean Architecture (Onion Architecture)

```
┌─────────────────────────────────────────────────────────────┐
│                    Frameworks & Drivers                      │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                 Interface Adapters                       ││
│  │  ┌─────────────────────────────────────────────────────┐││
│  │  │              Application Business Rules              │││
│  │  │  ┌─────────────────────────────────────────────────┐│││
│  │  │  │          Enterprise Business Rules               ││││
│  │  │  │              (Domain/Entities)                   ││││
│  │  │  └─────────────────────────────────────────────────┘│││
│  │  └─────────────────────────────────────────────────────┘││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

**Key Principles:**
- Dependencies point inward
- Inner layers know nothing about outer layers
- Domain entities are framework-agnostic

**Layer Responsibilities:**

| Layer | Contains | Depends On |
|-------|----------|------------|
| Entities | Business objects, domain logic | Nothing |
| Use Cases | Application-specific logic | Entities |
| Adapters | Controllers, gateways, presenters | Use Cases, Entities |
| Frameworks | Web framework, database, UI | All inner layers |

### Hexagonal Architecture (Ports & Adapters)

```
                    ┌──────────────┐
                    │   Driving    │
                    │   Adapter    │
                    │  (REST API)  │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │    Port      │
                    │  (Interface) │
                    └──────┬───────┘
                           │
┌──────────────────────────▼──────────────────────────┐
│                    Application Core                  │
│  ┌────────────────────────────────────────────────┐ │
│  │              Domain Model                       │ │
│  │         (Entities + Business Rules)             │ │
│  └────────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────────┘
                           │
                    ┌──────▼───────┐
                    │    Port      │
                    │  (Interface) │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │   Driven     │
                    │   Adapter    │
                    │  (Database)  │
                    └──────────────┘
```

**Key Concepts:**
- **Ports**: Interfaces defining how the core communicates
- **Driving Adapters**: Things that call your application (HTTP, CLI, tests)
- **Driven Adapters**: Things your application calls (DB, external APIs)

### Domain-Driven Design (DDD)

**Strategic Patterns:**

| Pattern | Purpose |
|---------|---------|
| Bounded Context | Define clear boundaries between domains |
| Ubiquitous Language | Shared vocabulary between devs and domain experts |
| Context Mapping | Define relationships between bounded contexts |

**Tactical Patterns:**

| Pattern | Purpose | Example |
|---------|---------|---------|
| Entity | Object with identity | User, Order |
| Value Object | Immutable, no identity | Money, Address |
| Aggregate | Cluster of entities | Order + OrderItems |
| Repository | Abstraction for persistence | UserRepository |
| Domain Event | Something that happened | OrderPlaced |
| Domain Service | Logic not belonging to entity | PaymentProcessor |

## Distributed System Patterns

### Microservices

**When to Use:**
- Large teams (> 10 developers)
- Need independent deployability
- Different scaling requirements per service
- Polyglot persistence needed

**When to Avoid:**
- Small teams
- Simple domains
- Tight latency requirements
- Limited DevOps capability

### Event-Driven Architecture

```
┌─────────┐     ┌──────────────┐     ┌─────────┐
│ Service │────▶│ Event Broker │────▶│ Service │
│    A    │     │  (Kafka/SQS) │     │    B    │
└─────────┘     └──────────────┘     └─────────┘
      │                                    │
      └──────────── Events ────────────────┘
```

**Patterns:**
- **Event Sourcing**: Store all changes as events
- **CQRS**: Separate read and write models
- **Saga**: Manage distributed transactions

### API Gateway Pattern

```
┌─────────┐     ┌─────────────┐     ┌───────────┐
│ Client  │────▶│ API Gateway │────▶│ Service A │
└─────────┘     └──────┬──────┘     ├───────────┤
                       │            │ Service B │
                       └───────────▶├───────────┤
                                    │ Service C │
                                    └───────────┘
```

**Gateway Responsibilities:**
- Authentication/Authorization
- Rate limiting
- Request routing
- Load balancing
- Response caching

## Resilience Patterns

### Circuit Breaker

```typescript
enum CircuitState {
  CLOSED,   // Normal operation
  OPEN,     // Failing, reject calls
  HALF_OPEN // Testing recovery
}

class CircuitBreaker {
  private state = CircuitState.CLOSED;
  private failures = 0;
  private threshold = 5;

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === CircuitState.OPEN) {
      throw new CircuitOpenError();
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
}
```

### Retry with Exponential Backoff

```typescript
async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  maxRetries: number = 3
): Promise<T> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await sleep(Math.pow(2, i) * 1000); // 1s, 2s, 4s
    }
  }
}
```

### Bulkhead

Isolate failures to prevent cascade:

```typescript
class Bulkhead {
  private semaphore: Semaphore;

  constructor(maxConcurrent: number) {
    this.semaphore = new Semaphore(maxConcurrent);
  }

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    await this.semaphore.acquire();
    try {
      return await fn();
    } finally {
      this.semaphore.release();
    }
  }
}
```

## Data Patterns

### Repository Pattern

```typescript
interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<void>;
  delete(id: string): Promise<void>;
}

// Implementation details hidden
class PostgresUserRepository implements UserRepository {
  // ...database-specific code
}
```

### Unit of Work

```typescript
interface UnitOfWork {
  users: UserRepository;
  orders: OrderRepository;

  commit(): Promise<void>;
  rollback(): Promise<void>;
}
```

### CQRS (Command Query Responsibility Segregation)

```
┌──────────────┐         ┌──────────────────┐
│   Commands   │────────▶│   Write Model    │
│  (Create,    │         │   (Normalized)   │
│   Update)    │         └────────┬─────────┘
└──────────────┘                  │
                                  │ Sync
                                  ▼
┌──────────────┐         ┌──────────────────┐
│   Queries    │────────▶│   Read Model     │
│  (GetById,   │         │  (Denormalized)  │
│   Search)    │         └──────────────────┘
└──────────────┘
```

## When to Use What

| Scenario | Recommended Pattern |
|----------|---------------------|
| Complex domain logic | DDD + Clean Architecture |
| High scalability | Microservices + Event-Driven |
| Simple CRUD | MVC / Layered Architecture |
| Real-time updates | Event Sourcing + CQRS |
| Legacy migration | Strangler Fig Pattern |
| API aggregation | BFF (Backend for Frontend) |

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Big Ball of Mud | No structure | Introduce bounded contexts |
| Distributed Monolith | Coupled services | True service boundaries |
| Anemic Domain Model | Logic in services | Rich domain model |
| Golden Hammer | One pattern for all | Right tool for job |
| Premature Abstraction | Over-engineering | YAGNI, iterate |

## Decision Framework

Before choosing an architecture:

1. **What are the scaling requirements?**
   - Users, requests, data volume

2. **What is the team size/structure?**
   - Small team → simpler architecture
   - Multiple teams → clear boundaries

3. **What are the consistency requirements?**
   - Strong consistency → synchronous
   - Eventual consistency → event-driven

4. **What is the expected rate of change?**
   - High change → modular, loosely coupled
   - Stable → simpler is better

5. **What are the operational capabilities?**
   - Limited DevOps → monolith
   - Strong DevOps → microservices possible
