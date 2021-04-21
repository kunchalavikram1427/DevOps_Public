#! usr/bin/bash

#Checking input parameters
if [ $# == 2 ];
then
	Scripts_Path=$1
	echo "Script Files Path is: ${Scripts_Path}"
	Version_File_Path=$2
	echo "Version File Path is: ${Version_File_Path}"
else
	echo "Expected 2 arguments but received $# arguments only. So exiting script..."
	exit 1
fi

cur_ver_file_num=`cat ${Version_File_Path}/Version.txt | awk -F= '{print $2}'`
echo "current version number in version file: ${cur_ver_file_num}"

cd "${Scripts_Path}"
cmd=`ls *.sh > "${Scripts_Path}"/file_list.txt`
chmod 775 "${Scripts_Path}"/file_list.txt
cd -
scripts_num=`cat "${Scripts_Path}"/file_list.txt | awk -F '[ ._]' '$1 > '$cur_ver_file_num' {print $1}'| sort -n`

if [ -z ${scripts_num} ];
then
	echo "No script files greater than version number. Exiting..."
else
	echo "Scripts file lists: ${scripts_num}"
	for line in $scripts_num
	do
		script_name=$line
		sh "${Scripts_Path}"/"${script_name}"*.sh
		sed -i "s/${cur_ver_file_num}/${script_name}/g" ${Version_File_Path}/Version.txt
		cur_ver_file_num=${script_name}
		echo "version number= ${cur_ver_file_num}"
	done
fi
