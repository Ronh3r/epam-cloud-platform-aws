#!/bin/bash

# Ejecuta el comando de AWS CLI y guarda la salida JSON
json_output=$(aws logs describe-log-groups --endpoint-url=http://localhost:4566)
# Verifica si el comando fue exitoso
if [ $? -eq 0 ]; then
    # Extrae todos los logGroupName usando jq
    log_group_names=$(echo "$json_output" | jq -r '.logGroups[].logGroupName')

    for full_group_name in $log_group_names; do
        group_name_for_file=$(basename "$full_group_name")
        echo "Getting logs for $full_group_name (saving as $group_name_for_file.json)..."
        aws logs filter-log-events --log-group-name "$full_group_name" --endpoint-url=http://localhost:4566 > "./$group_name_for_file.json"
    done
else
    echo "Error: aws logs describe-log-groups."
    echo "Output error: $json_output"
fi
 