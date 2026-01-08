# HSN Classification System Architecture

## System Design Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                          │
│                    (Natural Language Query)                     │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      QUERY PROCESSOR                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Query Type   │  │   Pattern    │  │  Preprocessing│         │
│  │ Detection    │  │   Matching   │  │  & Cleaning   │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
            ┌──────────────────┴──────────────────┐
            │                                      │
            ▼                                      ▼
┌────────────────────────┐              ┌────────────────────────┐
│   VECTOR STORE (FAISS) │              │   KNOWLEDGE GRAPH      │
│  ┌──────────────────┐  │              │  ┌──────────────────┐  │
│  │  Sentence        │  │              │  │  NetworkX        │  │
│  │  Transformers    │  │              │  │  DiGraph         │  │
│  │  Embeddings      │  │              │  └──────────────────┘  │
│  └──────────────────┘  │              │                        │
│  ┌──────────────────┐  │              │  ┌──────────────────┐  │
│  │  Similarity      │  │              │  │  Hierarchy       │  │
│  │  Search          │  │              │  │  Traversal       │  │
│  │  (L2 Distance)   │  │              │  └──────────────────┘  │
│  └──────────────────┘  │              │                        │
└────────────┬───────────┘              └────────────┬───────────┘
             │                                       │
             └───────────────┬───────────────────────┘
                             │
                             ▼
             ┌───────────────────────────────┐
             │   DISAMBIGUATION ENGINE       │
             │  ┌────────────────────────┐   │
             │  │  Confidence Scoring    │   │
             │  └────────────────────────┘   │
             │  ┌────────────────────────┐   │
             │  │  Multi-option Handler  │   │
             │  └────────────────────────┘   │
             └───────────────┬───────────────┘
                             │
                             ▼
             ┌───────────────────────────────┐
             │      RESULT FORMATTER         │
             │  ┌────────────────────────┐   │
             │  │  Hierarchy Display     │   │
             │  └────────────────────────┘   │
             │  ┌────────────────────────┐   │
             │  │  Related Codes         │   │
             │  └────────────────────────┘   │
             └───────────────┬───────────────┘
                             │
                             ▼
             ┌───────────────────────────────┐
             │         USER RESPONSE         │
             │  • HSN Code                   │
             │  • Full Hierarchy             │
             │  • Trade Status               │
             │  • Related Codes              │
             └───────────────────────────────┘
```

## Component Details

### 1. Query Processor

**Responsibilities:**
- Parse natural language queries
- Detect query type (direct HSN, product description, category)
- Extract key features and keywords
- Route to appropriate handler

**Query Types:**
1. **Direct HSN Lookup**: Contains 8-digit code
2. **Product Query**: Product description or name
3. **Broad Category**: General classification request

### 2. Vector Store (FAISS)

**Technology Stack:**
- Sentence Transformers (all-MiniLM-L6-v2)
- FAISS IndexFlatL2
- 384-dimensional embeddings

**Process:**
1. Document text → Embedding model → Vector representation
2. Query text → Embedding model → Query vector
3. FAISS search → Top-K similar documents
4. Distance → Similarity score conversion

**Optimization:**
- Pre-computed embeddings
- Efficient L2 distance calculation
- Batch processing support

### 3. Knowledge Graph

**Structure:**
- **Nodes**: HSN codes at all hierarchy levels
- **Edges**: Parent-child relationships
- **Attributes**: Descriptions, trade status, metadata

**Hierarchy Levels:**
```
Chapter (2-digit)
    ├── Heading (4-digit)
    │   ├── Subheading (6-digit)
    │   │   ├── Specific Code (8-digit)
    │   │   ├── Specific Code (8-digit)
    │   │   └── ...
    │   └── ...
    └── ...
```

**Operations:**
- Path traversal (root to leaf)
- Sibling retrieval
- Children enumeration
- Ancestor lookup

### 4. Disambiguation Engine

**Logic Flow:**
```python
if single_high_confidence_match:
    return direct_result
elif multiple_matches:
    group_by_subheading()
    rank_by_similarity()
    present_top_options()
else:
    suggest_refinement()
```

**Scoring Factors:**
- Semantic similarity score
- Hierarchy level match
- Description keyword overlap
- Historical query patterns

### 5. Data Processing Pipeline

```
Raw PDF Data
    ↓
[Extract Tables from PDF]
    ↓
[Parse to DataFrame]
    ↓
[Extract Hierarchy]
    ↓
[Create Enriched Documents]
    ↓
[Generate Embeddings]
    ↓
[Build Knowledge Graph]
    ↓
[Index in Vector Store]
    ↓
Ready for Queries
```

## Data Flow Example

**Query**: "natural rubber latex prevulcanised"

1. **Query Processor**:
   - Type: Product query
   - Keywords: [natural, rubber, latex, prevulcanised]

2. **Vector Store**:
   - Generate query embedding
   - Search FAISS index
   - Return top 10 matches

3. **Knowledge Graph**:
   - Retrieve hierarchy for each match
   - Get related codes
   - Build context

4. **Disambiguation**:
   - Filter matches above threshold
   - Group similar codes
   - Rank by relevance

5. **Result**:
   ```
   HSN Code: 40011010
   Description: Prevulcanised
   Chapter: Rubber And Articles Thereof
   Trade Status: Free
   ```

## Scalability Considerations

### Current Implementation
- In-memory FAISS index
- NetworkX graph
- Single-machine deployment

### Production Scale
```
┌─────────────────┐
│   Load Balancer │
└────────┬────────┘
         │
    ┌────┴────┬────────┬────────┐
    ▼         ▼        ▼        ▼
┌────────┐ ┌────────┐ ┌────────┐
│ API    │ │ API    │ │ API    │
│ Server │ │ Server │ │ Server │
└───┬────┘ └───┬────┘ └───┬────┘
    │          │          │
    └──────────┼──────────┘
               ▼
    ┌─────────────────────┐
    │  Vector DB Cluster  │
    │  (Pinecone/Weaviate)│
    └─────────────────────┘
               │
               ▼
    ┌─────────────────────┐
    │   Graph Database    │
    │   (Neo4j/Neptune)   │
    └─────────────────────┘
               │
               ▼
    ┌─────────────────────┐
    │   Cache Layer       │
    │   (Redis)           │
    └─────────────────────┘
```

## Performance Optimization

### Embedding Generation
- **Batch Processing**: Process multiple documents together
- **Caching**: Store frequently accessed embeddings
- **Quantization**: Reduce vector precision for storage

### Search Optimization
- **Index Type**: Consider HNSW for large-scale
- **Pre-filtering**: Apply hierarchy filters before search
- **Approximate Search**: Trade accuracy for speed when needed

### Graph Operations
- **Materialized Paths**: Pre-compute common paths
- **Adjacency Lists**: Optimize for traversal
- **Caching**: Store frequent hierarchy lookups

## Security Considerations

1. **Input Validation**: Sanitize all user queries
2. **Rate Limiting**: Prevent API abuse
3. **Access Control**: Authenticate API requests
4. **Data Privacy**: Encrypt sensitive trade data
5. **Audit Logging**: Track all classification requests

## Monitoring & Observability

**Key Metrics:**
- Query latency (p50, p95, p99)
- Search accuracy
- Disambiguation rate
- Cache hit ratio
- Error rates

**Logging:**
- Query patterns
- Search results
- User selections
- System errors

## Technology Stack

| Component | Technology |
|-----------|-----------|
| PDF Extraction | PyPDF2, pdfplumber |
| Embeddings | Sentence Transformers |
| Vector Search | FAISS |
| Knowledge Graph | NetworkX |
| Data Processing | Pandas, NumPy |
| Visualization | Matplotlib, Seaborn |
| Environment | Python 3.8+ |

## API Design (Future)

### RESTful Endpoints

```
POST /api/v1/classify
Body: {"query": "natural rubber latex"}
Response: {
  "hsn_code": "40011010",
  "confidence": 0.95,
  "hierarchy": {...},
  "alternatives": [...]
}

GET /api/v1/hsn/{code}
Response: {
  "hsn_code": "40011010",
  "description": "Prevulcanised",
  "hierarchy": {...},
  "related": [...]
}

GET /api/v1/chapter/{chapter_code}
Response: {
  "chapter": "40",
  "description": "Rubber And Articles Thereof",
  "headings": [...]
}
```

## Testing Strategy

1. **Unit Tests**: Individual components
2. **Integration Tests**: End-to-end workflows
3. **Performance Tests**: Load and stress testing
4. **Accuracy Tests**: Classification precision/recall
5. **User Acceptance**: Real-world query validation

---

**Last Updated**: January 8, 2026
