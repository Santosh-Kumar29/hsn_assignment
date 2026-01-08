#!/bin/bash

echo "=========================================="
echo "HSN Classification System Setup"
echo "=========================================="
echo ""

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
else
    echo "✓ Virtual environment exists"
fi

echo ""
echo "Activating virtual environment..."
source venv/bin/activate

echo ""
echo "Installing dependencies..."
pip install --upgrade pip -q
pip install -r requirements.txt -q

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "To start:"
echo "1. source venv/bin/activate"
echo "2. jupyter notebook hsn_classification_system.ipynb"
echo ""
