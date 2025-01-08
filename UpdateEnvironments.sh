#!/bin/bash

# =============================================================================
# Script to update image hashes in docker-compose
# Author: Ander Fernández
# Description: This script allows updating the image hashes in the docker-compose.yaml
#              file for different environments in a quick way.
# =============================================================================

# Function to update the docker-compose.yaml file (only for ui service)
update_docker_compose() {
    # Ask for the new hash for the selected service
    read -p "Enter the new hash for the image: " new_hash

    # Determine the path to the docker-compose.yaml file based on the selected environment
    docker_compose_file="./$selected_env/docker-compose.yaml"

    # Check if the file exists
    if [[ ! -f "$docker_compose_file" ]]; then
        echo "Error: The file $docker_compose_file is not found."
        return 1
    fi

    # Perform the update based on the selected service
    case "$1" in
        am|1)
            # Update the docker-compose.yaml file for the es service
            sed -i "s|\(/amadeusmodel:\)[^ #]*|\1$new_hash|" "$docker_compose_file"
            echo "The file $docker_compose_file has been updated with the new hash for 'am': $new_hash"
            ;;
        ui|2)
            # Update the docker-compose.yaml file for the ui service
            sed -i "s|\(/protonui:\)[^ #]*|\1$new_hash|" "$docker_compose_file"
            echo "The file $docker_compose_file has been updated with the new hash for 'ui': $new_hash"
            ;;
        es|3)
            # Update the docker-compose.yaml file for the es service
            sed -i "s|\(/protones:\)[^ #]*|\1$new_hash|" "$docker_compose_file"
            echo "The file $docker_compose_file has been updated with the new hash for 'es': $new_hash"
            ;;
        adl|4)
            # Update the docker-compose.yaml file for the es service
            sed -i "s|\(/adl:\)[^ #]*|\1$new_hash|" "$docker_compose_file"
            echo "The file $docker_compose_file has been updated with the new hash for 'adl': $new_hash"
            ;;
        spb|5)
            # Update the docker-compose.yaml file for the es service
            sed -i "s|\(/sparplug-brigde:\)[^ #]*|\1$new_hash|" "$docker_compose_file"
            echo "The file $docker_compose_file has been updated with the new hash for 'spb': $new_hash"
            ;;
        sqlb|6)
            # Update the docker-compose.yaml file for the es service
            sed -i "s|\(/sql-brigde:\)[^ #]*|\1$new_hash|" "$docker_compose_file"
            echo "The file $docker_compose_file has been updated with the new hash for 'sqlb': $new_hash"
            ;;
        *)
            echo "No update for docker-compose.yaml, as the selected service is not recognized."
            ;;
    esac
}


# Function to perform service updates
perform_update() {
    case $1 in
        am|1)
            # Here you can add the actual command for amadeusmodel
            update_docker_compose "$1"
            ;;
        es|2)
            # Update the docker-compose file only for es service
            update_docker_compose "$1"
            ;;
        ui|3)
            # Update the docker-compose file only for the ui service
            update_docker_compose "$1"
            ;;
        adl|4)
            # Update the docker-compose file only for the ui service
            update_docker_compose "$1"
            ;;
        spb|5)
            # Here you can add the actual command for spb
            update_docker_compose "$1"
            ;;
        sqlb|6)
            # Here you can add the actual command for sqlbase
            update_docker_compose "$1"
            ;;
        *)
            echo "Invalid option selected. No updates were applied."
            ;;
    esac
}

while true; do
    # Display environment selection menu
    echo "Select the environment you want to update:"
    read -p "Enter your choice (ufa-tst/vilo-tst/ufa-dev/vilo-dev...): " env_choice

    case $env_choice in
        ufa-tst|vilo-tst|ufa-dev|vilo-dev)
            selected_env=$env_choice
            echo "Selected environment: $selected_env"
            ;;
        *)
            echo "Invalid environment selected. Please try again."
            continue
            ;;
    esac

    while true; do
        # Display system update menu
        echo "Select the service you want to update in $selected_env:"
        echo "1. am"
        echo "2. es"
        echo "3. ui"
        echo "4. adl"
        echo "5. spb"
        echo "6. sqlb"
        read -p "Enter your choice (am/es/ui/adl/spb/sqlb): " choice

        # Call the function with the user's input
        perform_update "$choice"

        # Ask if the user wants to update another service in the same environment
        read -p "Do you want to update another service in $selected_env? (y/n): " again_service
        if [[ "$again_service" != "y" ]]; then
            break
        fi
    done

    # Ask if the user wants to restart the environment to apply changes
    read -p "Do you want to restart the environment $selected_env to apply changes? (y/n): " restart_env
    if [[ "$restart_env" == "y" ]]; then
        (
            cd "./$selected_env" || exit
            docker compose down
            docker compose up -d --remove-orphans --force-recreate -V
        )
        echo
        echo
        echo "The environment $selected_env has been restarted successfully."
        echo
        echo
    fi

    # Ask if the user wants to switch to another environment
    read -p "Do you want to switch to another environment? (y/n): " again_env
    if [[ "$again_env" != "y" ]]; then
        echo
        echo
        echo "Exiting the script. Goodbye!"
        echo
        echo
        break
    fi
done



