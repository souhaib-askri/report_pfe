#!/bin/bash

# Define the directory containing the .puml files
base_dir="$(pwd)" # The current directory

# Find all .puml files recursively and process them
find "$base_dir" -type f -name "*.puml" | while read -r puml_file; do
    # Navigate to the directory of the current file
    file_dir=$(dirname "$puml_file")
    cd "$file_dir" || exit

    # Generate PNG, SVG, and PDF from the .puml file
    echo "Processing: $puml_file"
    plantuml -tpng "$puml_file"
    plantuml -tsvg "$puml_file"
    plantuml -tpdf "$puml_file"
done

echo "Rendering complete."
