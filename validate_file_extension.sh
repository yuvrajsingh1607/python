git diff-tree --no-commit-id --name-only -r $(build.sourceversion) --diff-filter=AM |grep -i 'src/topics' > ${FILES_ADDED_LISTS}
          echo "Git commit ID: $(build.sourceversion)"
          j=0
          for i in $(cat ${FILES_ADDED_LISTS})
            do
              file=$(basename -- "$i")
              required_extension=$(basename "${i}" | grep '\.yaml\|\.yml' || echo "other_ext")
              extension="${file##*.}"
              file_name="${file%.*}"
              if [ ${required_extension} != "other_ext" ]; then
                echo "${file_name} has a correct extension: ${extension}"
              else
                echo "${file_name} has a wrong extension: ${extension}"
                print_files[${j}]=\"${file}\"
                j=`expr ${j} + 1`
              fi
            done
          [[ ${print_files[@]} ]] && { echo "Add correct file extenstion .yaml or .yml to the file/s: ${print_files[@]}"; exit 1; } || :
