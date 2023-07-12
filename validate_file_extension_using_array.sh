# it can be used in the Azure DevOps pipelines
      - bash: |
            git diff-tree --no-commit-id --name-only -r $(build.sourceversion) --diff-filter=AM |grep -i 'src/' > ${FILES_ADDED_LISTS}
            # only capture files which are added or modified in a commit
            echo "Git commit ID: $(build.sourceversion)"
            # if you want to add a new extension then add variables msg_<extension>, ext_<extension>, path_<extension> and update ext_array with extension type
            msg_yml="Add correct file extension .yaml or .yml to the file/s"
            ext_yml="\.yaml\|\.yml"
            path_yml="src/topics"
            msg_json="Add correct file extension .json to the file/s"
            ext_json="\.json"
            path_json="src/connectors"
            ext_array=("yml" "json")
            # variable len will store length of the array
            len=${#ext_array[@]}
            # function validate will identify if extension is correct or not
            validate() {
            # get the file name from the absolute path
            file=$(basename -- "$absolutePath")
            # extGrep gets the value of extension passed to function
            extGrep=$(echo ext_$1)
            # check if the file has required extension
            required_extension=$(basename "${absolutePath}" | grep "${!extGrep}" || echo "other_ext")
            # extract only extension of the file
            extension="${file##*.}"
            file_name_without_ext="${file%.*}"
            if [ ${required_extension} != "other_ext" ]; then
              echo "${file_name_without_ext} has a correct extension: ${extension}"
            else
              echo "${file_name_without_ext} has a wrong extension: ${extension}"
              eval "print_files_$1[${countWrongExt}]=${file}"
              countWrongExt=`expr ${countWrongExt} + 1`
            fi
            }
            # set counter to be used in array 
            countWrongExt=0
            # loop to run validate function
            for absolutePath in $(cat ${FILES_ADDED_LISTS}); do
              for (( indexCount=0; indexCount<$len; indexCount++ )); do
              arrayItem=$(echo "${ext_array[$indexCount]}")
              file_path="path_$arrayItem"
              file_ext="ext_$arrayItem"
              [[ `echo $absolutePath|grep $(eval echo \\${$file_path})` ]] && { validate $arrayItem; } || :
              done
            done
            # loop to display message 
            for (( indexCount=0; indexCount<$len; indexCount++ )); do
              arrayItem=$(echo "${ext_array[$indexCount]}")
              prn=print_files_$arrayItem
              message="msg_$arrayItem"
              [[ $(eval echo "\${$prn[@]}") ]] && { eval echo "\${$message}": "\${$prn[@]}"; } || :
            done
            # loop to exit the pipeline if required extension is missing
            for (( indexCount=0; indexCount<$len; indexCount++ )); do
              arrayItem=$(echo "${ext_array[$indexCount]}")
              prn=print_files_$arrayItem
              [[ $(eval echo "\${$prn[@]}") ]] && { exit 1; } || :
            done
        displayName: Check extension of the file added in the commit
        env:
          FILES_ADDED_LISTS: /tmp/addedfiles.txt  
