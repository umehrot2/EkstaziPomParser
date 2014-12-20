#!/usr/bin/env python


import os 
import sys
import glob
import re

if __name__=="__main__":
	#os.listdir(sys.argv[1])
	ekstazi_log_files = glob.glob("ek_*.log")
	print ekstazi_log_files

	project_log = {}

	revision_match = re.compile(r'Changing revision to (\w+)')
	time_first_match = re.compile(r'Time taken for first run = (\d+) minutes and (\d+) seconds')
	time_second_match = re.compile(r'Time taken for second run = (\d+) minutes and (\d+) seconds')
	test_run_match = re.compile(r'Number of tests that ran first time =  (\d+)')
	test_run2_match = re.compile(r'Number of tests that ran second time =  (\d+)')



	for log_file in ekstazi_log_files:
		pname = log_file[3:-4]
		print pname
		lfile = open(log_file, 'r')
		inside_revision = ""
		
		project_log[pname] = {}

		for line in lfile:
			if inside_revision != "":
				match = time_first_match.match(line)
				if match:
					project_log[pname][revision][2] = int(match.group(1)) * 60 + int(match.group(2))
					continue

				match = time_second_match.match(line)
				if match:
					project_log[pname][revision][3] = int(match.group(1)) * 60 + int(match.group(2))
					continue

				match = test_run_match.match(line)
				if match:
					project_log[pname][revision][0] = int(match.group(1))
					continue
				
				match = test_run2_match.match(line)
				if match:
					project_log[pname][revision][1] = int(match.group(1))
					continue

			match = revision_match.match(line)
			if match:
				revision = match.group(1)
				project_log[pname][revision] = [-1, -1, -1, -1]
				inside_revision = revision
		lfile.close()

	print project_log['chukwa']

	wfile = open("result.csv", 'w')
	wfile.write("Project,Revision,Test_ran_first_time,Test_ran_second_time,Time_first_run,Time_second_run,Tests_reduced,Time_difference\n")
	for project in project_log:
		for revision in project_log[project]:
			reduced_tcs = (project_log[project][revision][0] - project_log[project][revision][1]) * 100.0 / (1.0 * project_log[project][revision][0])
			reduced_time = (project_log[project][revision][2] - project_log[project][revision][3]) * 100.0 / (1.0 * project_log[project][revision][2])
			reduced_tcs = round(reduced_tcs, 2)
			reduced_time = round(reduced_time, 2)
			line = project + "," + revision + "," + str(project_log[project][revision][0]) + "," + str(project_log[project][revision][1]) + "," + str(project_log[project][revision][2]) + "," + str(project_log[project][revision][3]) + "," + str(reduced_tcs) + "%" + "," + str(reduced_time) + "%" + "\n"
			wfile.write(line)
	wfile.close()
