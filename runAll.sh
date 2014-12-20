#!/bin/sh

dir_name="Ekstazi_Testing_Temp"

if [ -d "${dir_name}" ]; then
       echo "Files already cloned"
else
	git clone https://github.com/sharma55-umehrot2/EkstaziPomParser ${dir_name}
fi

cd ${dir_name}

chmod +x *.sh

./run_ekstazi.sh -u "https://github.com/JodaOrg/joda-time.git" -p "joda" -r "8612f9e,9a62b06,51ca316,d0514b4,f36072e" 2>&1 | tee run_joda.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/commons/proper/math/trunk/" -p "commons-math" -r "r1604648,r1604651,r1607864,r1613723,r1615790" 2>&1 | tee run_commons-math.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/commons/proper/lang/trunk" -p "commons-lang" -r "r1620574,r1620579,r1628921,r1632874,r1633907" 2>&1 | tee run_commons-lang.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/gora/trunk/" -p "gora" -s "2.15" -r "r1558595,r1559591,r1579569,r1588039,r1588717 " 2>&1 | tee run_gora.log

./run_ekstazi.sh -u "https://git.eclipse.org/r/p/jgit/jgit.git" -p "jgit" -v "4.2.0" -s "2.18" -r "6189a68,543c523,6a1a80a,0e8f3a6,bf33a6e" 2>&1 | tee run_jgit.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/commons/proper/configuration/trunk" -p "commons-config" -r "r1629051,r1629231,r1636033,r1636041,r1636042" 2>&1 | tee run_commons-config.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/commons/proper/pool/trunk" -p "pool" -r "r1622088,r1622089,r1627270,r1629510,r1629515" 2>&1 | tee run_pool.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/commons/proper/collections/trunk" -p "commons-col" -r "r1610049,r1610057,r1633168,r1635348,r1635351" 2>&1 | tee run_commons-col.log

./run_ekstazi.sh -u "https://github.com/zxing/zxing.git"  -p "zxing" -s "2.18" -r "e061224,d40c755,6ad384a,02a6347,0d81afb" 2>&1 | tee run_zxing.log

patch run_ekstazi.sh < patch_log4j.txt
./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/logging/log4j/trunk/" -p "log4j" -v "4.2.0" -s "2.15" -r "r1344103,r1344108,r1344711,r1567107,r1567108" 2>&1 | tee run_log4j.txt
patch -R run_ekstazi.sh < patch_log4j.txt

./run_ekstazi.sh -u "https://github.com/google/closure-compiler.git" -p "closure" -d "1" -r "6a1f2d7,0fc234b,008942d,09cf300,6092983" 2>&1 | tee run_closure.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/chukwa/trunk/" -p "chukwa" -s "2.13" -r "r1611855,r1611856,r1616998,r1631229,r1631276" 2>&1 | tee run_chukwa.log

./run_ekstazi.sh -u "https://github.com/cucumber/cucumber-jvm.git" -p "cucumber" -v "4.2.0" -r "cca52ae,80a3bab,2a38c01,950814f,5df09f8" 2>&1 | tee run_cucumber.log

./run_ekstazi.sh -u "https://code.google.com/p/guava-libraries/" -p "guava" -m "guava-tests" -r "af2232f5,0d41d891,e0fe72fe,a3d831ce,a4d5ada2" 2>&1 | tee run_guava.log

./run_ekstazi.sh -u "https://github.com/netty/netty/" -p "netty" -s "2.15" -d "1" -r "239371a,de6e73e,5b0f60c,6104e44,c40b0d2" 2>&1 | tee run_netty.log

./run_ekstazi.sh -u "https://github.com/apache/phoenix"  -p "phoenix" -r "c8fbb8f,e5f4a2b,1e12e12,eddc846,bc89c9a" 2>&1 | tee run_phoenix.log

./run_ekstazi.sh -u "https://github.com/apache/tika" -p "tika" -s "2.15" -r "4d26131,452bc81,add190c,d45be55,0793445" 2>&1 | tee run_tika.log

patch run_ekstazi.sh < patch_gsachs.txt
./run_ekstazi.sh -u "https://github.com/goldmansachs/gs-collections.git" -p "gsachs" -v "3.4.2" -r "6637142,526bddb,bd63936,78388e4,8e9aaf6" 2>&1 | tee run_gsachs.log
patch -R run_ekstazi.sh < patch_gsachs.txt

./run_ekstazi.sh -u "https://github.com/hazelcast/hazelcast.git" -p "hazel" -v "4.2.0" -s "2.15" -r "f4c628c,ab61ea2,37cec23,125d103,1c27a59" 2>&1 | tee run_hazel.log

./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/whirr/trunk/" -p "whirr" -d "1" -r "1645345,1645342,1645340,1645338,1645336" 2>&1 | tee run_whirr.log

./run_ekstazi.sh -u "https://github.com/elasticsearch/elasticsearch.git" -p "elastic_search" -r "a63a055,22da975,ae11c46,60e805c,185521b" 2>&1 | tee run_elastic_search.log

./run_ekstazi.sh -u "https://github.com/jenkinsci/jenkins" -p "jenkins" -r "76adbf9,c6deabb,fef4ef1,64e5a4c,97bc2dd" 2>&1 | tee run_jenkins.log

./run_ekstazi.sh -u "https://svn.apache.org/repos/asf/ctakes/trunk/" -p "ctakes" -s "2.13" -r "1645432,1645431,1645429,1645424,1645421" 2>&1 | tee run_ctakes.log

./run_ekstazi.sh -u "https://github.com/apache/mahout" -p "mahout" -d "1" -r "ae1808b,6530e81,379863d,f1095d8,c1a10d9" 2>&1 | tee run_mahout.log

./run_ekstazi.sh -u "http://git-wip-us.apache.org/repos/asf/logging-log4j2.git" -p "log4j2" -d "1" -r "cb5b041,38d34ca,e82a9db,570d08b,33d3e71" 2>&1 | tee run_log4j2.log

./run_ekstazi.sh -u "https://svn.apache.org/repos/asf/continuum/trunk/" -p "continuum" -d "1" -r "1645433,1645431,1645429,1645426,1645425" 2>&1 | tee run_continuum.log

