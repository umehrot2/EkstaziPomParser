#!/bin/bash

cwd=`pwd`

if [ -z "$1" ]; then
	  echo "help-> ./run_ekstazi.sh -u [svn/git project url] -p [local_project_folder_name] -v [ekstazi_version] -s [forced_surefire_version] -m [modules separated by ,] -r [revision/otherwise latest] -c [true/false to clean local cloned projects] -d [max_depth_allowed_for_pom_change]" >&2
	echo "Arguments except -u and -p are optional."
	exit 0
fi

default_location="mvn_test_project"
project_url=""
project=${default_location}
version="4.2.0"
git_project="0"
surefire_version="0.0"
modules="."
clean_all="false"
project_revisions="0"
max_depth="-1"

while getopts ":u:p:v:s:m:r:d:c:h" opt; do
  case $opt in
  	u)
      #echo "-url was triggered! Parameter: ${OPTARG}" >&2
      project_url=${OPTARG};
      ;;
    p)
      #echo "-pname was triggered! Parameter: ${OPTARG}" >&2
      project=${OPTARG}
      ;;
    v)
      #echo "-ek_version was triggered! Parameter: ${OPTARG}" >&2
      version=${OPTARG}
      ;;
    s)
      #echo "-surefire_version was triggered! Parameter: ${OPTARG}" >&2
      surefire_version=${OPTARG}
      ;;
   	m)
   	  #echo "-modules was triggered! Parameter: ${OPTARG}" >&2
   	  modules=(${OPTARG//,/ })
      ;; 
	r)
	  project_revisions=(${OPTARG//,/ })
	  ;;
	d)
	  max_depth="${OPTARG}"
      ;;
	c)
	  clean_all=${OPTARG}
	  ;;
    h)
	  echo "help-> ./run_ekstazi.sh -u [svn/git project url] -p [local_project_folder_name] -v [ekstazi_version] -s [forced_surefire_version] -m [modules separated by ,] -r [revision/otherwise latest] -c [true/false to clean local cloned projects] -d [max_depth_allowed_for_pom_change]" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ "$clean_all" == "true" ]; then
	pnames=`find ./ -maxdepth 1 -type d -iname ".*_clone" | sed -e "s/^[.][/][.]//"  | sed -e "s/_clone$//"`
	for pname in $pnames; do
		echo -n "Deleting project folder and configurations: "
		rm -rvf ".${pname}_clone"
		rm -rvf ${pname}
		#rm -rvf "ek_${pname}.log"
		#rm -rvf "ekstazi_parser_log_${pname}.log"
	done
	exit 0;
fi

if [ "$project_url" == "" ]; then
	echo "Please mention url of a project to begin"
	exit 1;
fi

surefire_check=$(awk 'BEGIN{ print "'${surefire_version}'"=="0.0" }')
#echo "Surefire Version"
#echo $surefire_check

clone_project_dir=".${project}_clone"

echo "Settings of the ekstazi pom parser"
echo "=================================="
#echo $clone_project_dir
echo "Url of the project = $project_url"
echo "Folder of the project = $project"
echo "Using Ekstazi Version = $version"
if [ $surefire_check -eq "1" ]; then
	echo "Using default surefire version"
else
	echo "Using Surefire Version = $surefire_version"
fi
echo "Depth of run = $max_depth"

echo -n "Running on modules = "
for index in "${!modules[@]}"
do
    echo -n "${modules[index]},"
done
echo ''

echo -n "Running on revisions = "
for index in "${!project_revisions[@]}"
do
    echo -n "${project_revisions[index]},"
done

echo ''
echo "================================="

rm -rf ${default_location}


protocol=`echo $project_url | cut -d':' -f 2`
git_project_url="git:${protocol}"
#echo $protocol
#echo $git_project_url
git_project=`timeout 5 git ls-remote $project_url 2> /dev/null | wc -l | tail -1 | awk '{if ($1 > 0) {print "0"} else {print "1"}}'`

if [ $git_project -ne "0" ]; then 
	git_project=`timeout 5 git ls-remote $git_project_url 2> /dev/null | wc -l | tail -1 | awk '{if ($1 > 0) {print "0"} else {print "1"}}'`
fi

if [ ! -d "${clone_project_dir}" ]; then

	rm -rf ${project}

	if [ $git_project -eq "0" ]; then
		echo "A Git project"
		git clone ${project_url} ${project}
	else
		echo "Not a git project"
		echo "Try if it's an svn project"
		svn co ${project_url} ${project} 2> /dev/null
	fi
	cd ${project}
	mvn install -DskipTests
	cd ${cwd}
	cp -r ${project} ${clone_project_dir} 2> /dev/null
else
	rm -rf ${project}
	cp -r ${clone_project_dir} ${project}
	#	rm -rf ${project}/.ekstazi
fi

## Check if clone was good
if [ ! -d "${project}" ]; then
       echo "Nothing was cloned. Check network connection or check if the url is valid git or svn url."
       exit 1
fi


log_file="${cwd}/ek_${project}.log"
debug_log_file="${cwd}/ekstazi_parser_log_${project}.log"

echo "" > ${log_file}
echo "" > ${debug_log_file}

cd ${project}

mvn install -DskipTests

for pro_index in "${!project_revisions[@]}"
do
	pro_revision=${project_revisions[pro_index]}

	echo '' | tee -a ${log_file}

	if [ "$pro_revision" != "0" ]; then
		echo "Changing revision to $pro_revision" | tee -a ${log_file}
		if [ $git_project -eq "0" ]; then
			git reset --hard $pro_revision
			#git checkout $pro_revision
		else
			svn up -r"${proj_revision}"
		fi
	else
		echo "Using latest revision" | tee -a ${log_file}
		if [ $git_project -eq "0" ]; then
			git checkout
		else
			svn up
		fi
	fi

	
	for index in "${!modules[@]}"
	
	do
		echo "In Module ${modules[index]}," | tee -a ${log_file}
		
		cd ${cwd}/${project}/${modules[index]}
		
		#echo "${cwd}/${project}/${modules[$index]}" 
		
		if [ $surefire_check -eq "1" ]; then
			java -jar ${cwd}/pom_parser.jar "${cwd}/${project}/${modules[$index]}" "${max_depth}" "${version}" 2>&1 | tee -a ${debug_log_file}
		else
			java -jar ${cwd}/pom_parser.jar "${cwd}/${project}/${modules[$index]}" "${max_depth}" "${version}" "${surefire_version}" 2>&1 | tee -a ${debug_log_file}	
		fi

		${cwd}/test_ekstazi.sh "${cwd}/${project}/${modules[$index]}"  "${log_file}"
		
		cd ${cwd}/${project}
	
	done

done
cd ${cwd}



#rm -rf pom.xml
#
#if [ $git_project -eq "0" ]; then
#	git checkout pom.xml
#	git checkout
#else	
#	svn up
#fi

# Download Ekstazi
# url="mir.cs.illinois.edu/gliga/projects/ekstazi/release/"
# if [ ! -e org.ekstazi.core-${version}.jar ]; then wget "${url}"org.ekstazi.core-${version}.jar; fi
# if [ ! -e org.ekstazi.ant-${version}.jar ]; then wget "${url}"org.ekstazi.ant-${version}.jar; fi
# if [ ! -e ekstazi-maven-plugin-${version}.jar ]; then wget "${url}"ekstazi-maven-plugin-${version}.jar; fi

# Install Ekstazi
#mvn install:install-file -Dfile=org.ekstazi.core-${version}.jar -DgroupId=org.ekstazi -DartifactId=org.ekstazi.core -Dversion=${version} -Dpackaging=jar -DlocalRepositoryPath=$HOME/.m2/repository/
#mvn install:install-file -Dfile=ekstazi-maven-plugin-${version}.jar -DgroupId=org.ekstazi -DartifactId=ekstazi-maven-plugin -Dversion=${version} -Dpackaging=jar -DlocalRepositoryPath=$HOME/.m2/repository/
