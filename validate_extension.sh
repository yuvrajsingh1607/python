#!/bin/bash
msg_yml="Add correct file extenstion .yaml or .yml to the file/s"
ext_yml="\.yaml\|\.yml"
msg_json="Add correct file extenstion json to the file/s"
ext_json="\.json"
FILES_ADDED_LISTS=/tmp/addedfiles.txt
validate(){
  file=$(basename -- "$i")              
  required_extension=$(basename "${i}" | grep $1 || echo "other_ext")
  extension="${file##*.}"
  file_name="${file%.*}"
  if [ ${required_extension} != "other_ext" ]; then
    echo "${file_name} has a correct extension: ${extension}"
  else
    echo "${file_name} has a wrong extension: ${extension}"
  eval "print_files_$2[${j}]=${file}"
  j=`expr ${j} + 1`
  fi
}
j=0
for i in $(cat ${FILES_ADDED_LISTS})
do
  [[ `echo $i|grep 'src/topics'` ]] && { validate $ext_yml yml; } || :
  [[ `echo $i|grep 'src/connectors'` ]] && { validate $ext_json json; } || :
done
[[ ${print_files_yml[@]} ]] && { echo "$msg_yml: ${print_files_yml[@]}"; } || :
[[ ${print_files_json[@]} ]] && { echo "$msg_json: ${print_files_json[@]}"; } || : 
if [[ ${print_files_yml[@]} ]] || [[ ${print_files_json[@]} ]]; then exit 1; fi
