#!/bin/bash

kgpip() {
    DEP_FILE_NAME="requirments.txt"
    install_package() {
        package_name=$1
        echo "Package $(tput setaf 2)$package_name$(tput sgr0) is installing..."
        # installing the actual package
        pip install "$package_name"
        # check if package is already added in the dependency file
        found=0
        if [ -f "$DEP_FILE_NAME" ]; then
            found=$(grep -c "$package_name" $DEP_FILE_NAME)
        fi

        if [ "$found" == 0 ]; then
            # adding the new package in the dependency file in the freeze output form if not exist
            pip freeze | grep -i "$package_name" >>"$DEP_FILE_NAME"
            found=$(grep -c "$package_name" $DEP_FILE_NAME)
            if [ "$found" == 1 ]; then
                echo "Installation is completed and added to $(tput setaf 3)$DEP_FILE_NAME$(tput sgr0)"
            fi
        fi
    }

    uninstall_package() {
        package_name=$1
        echo "Package $(tput setaf 2)$package_name$(tput sgr0) is uninstalling..."
        # uninstalling the actual package
        pip uninstall "$package_name" -y
        if [ -f "$DEP_FILE_NAME" ]; then
            # check if package is present in the dependency file
            found=$(grep -c "$package_name" $DEP_FILE_NAME)
            if [ "$found" -gt 0 ]; then
                number_of_other_package=$(grep -v "$package_name" $DEP_FILE_NAME | grep -c $DEP_FILE_NAME)
                if [ "$number_of_other_package" -gt 0 ]; then
                    grep -v "$package_name" $DEP_FILE_NAME >${DEP_FILE_NAME}.bak &&
                        mv ${DEP_FILE_NAME}.bak $DEP_FILE_NAME
                else
                    echo -n "" >$DEP_FILE_NAME
                fi
            fi
        fi
    }

    install_packages() {
        package_list=("$@")
        no_of_arguments=$#
        if [ "$no_of_arguments" == 0 ]; then
            pip install -r "$DEP_FILE_NAME"
        else
            for package_name in "${package_list[@]}"; do
                install_package "$package_name"
            done
        fi
    }

    uninstall_packages() {
        package_list=("$@")
        no_of_arguments=$#
        if [ "$no_of_arguments" == 0 ]; then
            echo "$(tput setaf 1)"Package name is required!"$(tput sgr0)"
        else
            for package_name in "${package_list[@]}"; do
                uninstall_package "$package_name"
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
        'uninstall')
            uninstall_packages "${arguments[@]:1}"
            ;;
        'list' | 'ls')
            cat "$DEP_FILE_NAME"
            ;;
        *)
            echo "Invalid command"
            ;;
        esac
    fi
}
