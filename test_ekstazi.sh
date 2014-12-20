#!/bin/bash

cd $1

log_file=$2

cwd=`pwd`

tfile1=".ekstazi_mvn_run_t1"
tfile2=".ekstazi_mvn_run_t2"


find ./ -iname ".ekstazi" -exec rm -rf {} \; 2> /dev/null


t1=$(date +"%s")

mvn test -fae | tee ${tfile1}

trun1=`awk '/Results :/{y=1;next}y' ${tfile1} | grep -i "Tests run: " | awk '{print $3}' | cut -d',' -f 1`

rm -rf ${tfile1}

t2=$(date +"%s")

mvn test -fae | tee ${tfile2}

trun2=`awk '/Results :/{y=1;next}y' ${tfile2} | grep -i "Tests run: " | awk '{print $3}' | cut -d',' -f 1`

rm -rf ${tfile2}

t3=$(date +"%s")

if [ -z "$trun1" ]
then
	trun1=0
	echo "Some problem in running tests"  | tee -a ${log_file}
	exit 0
fi

if [ -z "$trun2" ]
then
	trun2=0
fi


ek_folders=`find ./ -iname ".ekstazi" -print`

for ekFolder in ${ek_folders}; do
	if [ -d ${ekFolder} ]; then
		ekstazi_gen=`ls -ltr ${ekFolder} | wc -l | awk '{if ($1 > 3) print "1"; else print "0";}'`
		#echo -n $ekFolder
		#echo -n $ekstazi_gen
		module_name=`echo $ekFolder  | sed -e 's/\/\.ekstazi//g' | sed -e 's/^\.\///g'`
		echo -n "Module -> ${module_name} -> " | tee -a ${log_file}
		if [ $ekstazi_gen -eq "1" ]; then
			echo "Passed" | tee -a ${log_file}
		else
			echo "Failed" | tee -a ${log_file}
		fi
	fi
done


strun1=0
#IFS=', ' read -a tests_array <<< "$trun1"
#for element in "${tests_array[@]}"
for element in ${trun1//\s/ } ;
do
	strun1=$(( $strun1 + $element ))
done
trun1=$strun1

strun2=0
#IFS=', ' read -a ek_tests_array <<< "$trun2"
#for element in "${ek_tests_array[@]}"
for element in ${trun2//\s/ } ;
do
	strun2=$(( $strun2 + $element ))
done
trun2=$strun2

time_diff=$(($t2-$t1))
time_diff2=$(($t3-$t2))

echo "" | tee -a ${log_file}
echo "Time taken for first run = $(($time_diff / 60)) minutes and $(($time_diff % 60)) seconds." | tee -a ${log_file}
echo "Time taken for second run = $(($time_diff2 / 60)) minutes and $(($time_diff2 % 60)) seconds." | tee -a ${log_file}


echo "" | tee -a ${log_file}
echo "Number of tests that ran first time = " $trun1 | tee -a ${log_file}
echo "Number of tests that ran second time = " $trun2 | tee -a ${log_file}
echo "" | tee -a ${log_file}

tdiff=`expr ${trun1} - ${trun2}`

echo "Difference of testcases that ran = " $tdiff | tee -a ${log_file}

if [ $tdiff -eq $trun1 ]
then
	echo "Tests reduced 100% successfully" | tee -a ${log_file}
elif [ $tdiff -gt 0 ]
then
	echo "Some of the tests were reduced by ekstazi." | tee -a ${log_file}
elif [ $tdiff -eq 0 ]
then	
	echo "Ekstazi didn't ran successfully. Check pom configuration again." | tee -a ${log_file}
else
	echo "Something wrong here. Check pom configuration again." | tee -a ${log_file}
fi

