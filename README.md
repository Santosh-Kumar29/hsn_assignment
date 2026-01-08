# HSN Code Classification System

An intelligent HSN (Harmonized System Nomenclature) Code Classification System using RAG and Knowledge Graphs.

## Overview

This project implements a complete RAG-based classification system for HSN codes used in international trade and customs declarations. It combines:

- **Knowledge Graphs** for hierarchical relationships
- **Vector Embeddings** for semantic similarity
- **FAISS** for efficient similarity search
- **Intelligent Query Processing** with disambiguation

## Features

✓ Hierarchical HSN code mapping (Chapter → Heading → Subheading → Specific)  
✓ Vector-based semantic search  
✓ Knowledge graph visualization  
✓ Natural language query processing  
✓ Smart disambiguation for ambiguous queries  
✓ Performance benchmarking  

## Installation

### 1. Clone or Download

```bash
cd hsn_assignment
```

### 2. Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Launch Jupyter Notebook

```bash
jupyter notebook hsn_classification_system.ipynb
```

## Usage

### Run All Cells

In Jupyter Notebook, use "Kernel → Restart & Run All" to execute the entire notebook.

### Test Queries

The notebook includes 5 comprehensive test cases:

1. **Direct Product Query**: "What is the HSN code for natural rubber latex?"
2. **Specific Product**: "HSN code for prevulcanised rubber"
3. **Broad Category**: "Rubber products classification"
4. **Disambiguation**: "Natural rubber latex"
5. **Direct Lookup**: "Tell me about HSN 40011010"

### Custom Queries

```python
query = "your product description here"
result = query_processor.process_query(query)
print(query_processor.format_response(result))
```

## Architecture

```
User Query
    ↓
Query Processor (NLP preprocessing)
    ↓
Vector Store (FAISS similarity search)
    ↓
Knowledge Graph (hierarchy traversal)
    ↓
Disambiguation Logic
    ↓
Formatted Result
```

## Dataset

The included `hsn_data.pdf` contains sample HSN codes from Chapter 40 (Rubber and Articles Thereof) with:

- 50+ HSN codes
- Complete hierarchical descriptions
- Trade status information

The system automatically extracts and processes the tabular data from the PDF file.

## Project Structure

```
hsn_assignment/
├── hsn_classification_system.ipynb  # Main notebook
├── hsn_data.pdf                     # Sample HSN dataset (PDF)
├── requirements.txt                  # Python dependencies
└── README.md                         # This file
```

## System Components

### 1. Data Processing
- Extracts 2-digit, 4-digit, 6-digit, and 8-digit codes
- Creates enriched documents with full hierarchy
- Validates data integrity

### 2. Knowledge Graph
- NetworkX-based graph construction
- Hierarchical node relationships
- Visualization capabilities
- Traversal operations

### 3. Vector Store
- Sentence-Transformers embeddings (all-MiniLM-L6-v2)
- FAISS index for similarity search
- Optimized retrieval performance

### 4. Query Processor
- Natural language understanding
- Multi-strategy query handling
- Smart disambiguation
- Confidence scoring

## Performance Metrics

Average query time: ~0.01-0.05 seconds  
Direct match rate: 60-70%  
Disambiguation rate: 20-30%  

## Limitations

- Sample dataset limited to Chapter 40
- Uses lightweight embedding model
- No LLM integration for generation
- Fixed similarity thresholds

## Future Enhancements

- [ ] Expand to all HSN chapters
- [ ] Integrate GPT/Claude for NLG
- [ ] Multi-language support
- [ ] Image-based classification
- [ ] REST API development
- [ ] Active learning from feedback
- [ ] Real-time regulatory updates

## Requirements

- Python 3.8+
- 4GB RAM minimum
- Internet connection (first run for model download)

## Author

Santosh Kumar  
Date: January 8, 2026

## Acknowledgments

- Sentence Transformers library
- FAISS by Meta Research
- NetworkX for graph operations
- HSN classification system standards
