#!/bin/bash

kgpip() {

    install_package() {
        DEP_FILE_NAME="requirments.txt"
        package_name=$1
        echo "Package $(tput setaf 2)$package_name$(tput sgr0) is installing..."
        # installing the actual package
        pip install "$package_name"
        # check if package is already added in the dependency file
        found=0
        if [ -f "$DEP_FILE_NAME" ]; then
            found=$(cat $DEP_FILE_NAME | grep -c "$package_name")
        fi
        if [ "$found" == 0 ]; then
            # adding the new package in the dependency file in the freeze output form if not exist
            pip freeze | grep -i "$package_name" >>"$DEP_FILE_NAME"
            echo "Installation is completed and added to $(tput setaf 3)$DEP_FILE_NAME$(tput sgr0)"
        fi
    }

    install_packages() {
        package_list=("$@")
        no_of_arguments=$#
        if [ "$no_of_arguments" == 0 ]; then
            echo "$(tput setaf 1)"Package name is required!"$(tput sgr0)"
        else
            for package_name in "${package_list[@]}"; do
                install_package "$package_name"
            done
        fi
    }

    if [ "$#" == 0 ]; then
        echo "Invalid command"
    else
        arguments=("$@")
        command=${arguments[0]}
        case "$command" in
        'install')
            install_packages "${arguments[@]:1}"
            ;;
        'remove' | 3)
            echo "Package is removing"
            ;;
        *)
            echo "Invalid command"
            ;;
        esac
    fi
}
