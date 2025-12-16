#!/bin/bash
# Neural Studio - Dependency Status Check
# Run this anytime to see all dependencies

cd "$(dirname "$0")/.." || exit 1

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     Neural Studio - Dependency Status                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Run CMake in script mode to check dependencies
cmake \
    -DCHECK_LATEST_VERSIONS=ON \
    -DCMAKE_PREFIX_PATH=/home/subtomic/Qt/6.10.1/gcc_64 \
    -P cmake/modules/CheckDependencies.cmake 2>&1 | grep -v "^CMake"

echo ""
echo "To see full dependency tree, run:"
echo "  cd build_ubuntu && cmake -LAH | grep -A1 \"FOUND\|VERSION\""
