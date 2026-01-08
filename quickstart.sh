#!/bin/bash

# HSN Classification System - Quick Start Guide

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║         HSN CLASSIFICATION SYSTEM - QUICK START           ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check Python version
echo "Checking Python version..."
python3 --version

if [ $? -ne 0 ]; then
    echo "❌ Python 3 not found. Please install Python 3.8 or higher."
    exit 1
fi

echo "✓ Python found"
echo ""

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment exists"
fi

echo ""
echo "Activating virtual environment..."
source venv/bin/activate

echo ""
echo "Upgrading pip..."
pip install --upgrade pip -q

echo ""
echo "Installing dependencies (this may take a few minutes)..."
pip install -r requirements.txt -q

if [ $? -eq 0 ]; then
    echo "✓ All dependencies installed successfully"
else
    echo "❌ Error installing dependencies"
    exit 1
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                  INSTALLATION COMPLETE!                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "🚀 To launch the notebook, run:"
echo ""
echo "   jupyter notebook hsn_classification_system.ipynb"
echo ""
echo "📚 Or start Jupyter and navigate to the notebook:"
echo ""
echo "   jupyter notebook"
echo ""
echo "💡 First time running?"
echo "   - Use 'Kernel → Restart & Run All' to execute all cells"
echo "   - The first run will download the embedding model (~90MB)"
echo "   - Subsequent runs will be much faster"
echo ""
echo "📖 Documentation:"
echo "   - README.md - Setup and usage instructions"
echo "   - ARCHITECTURE.md - System design details"
echo "   - SUBMISSION_CHECKLIST.md - Verification checklist"
echo ""
echo "❓ Need help? Check README.md for detailed instructions"
echo ""
