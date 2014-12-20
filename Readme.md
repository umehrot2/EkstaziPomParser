CODE :
--------------------------------------------------------------------------------------------------------------------------------------------------------

All our code has been uploaded on Github at the following public repositories:

https://github.com/umehrot2/EkstaziPomParser : Contains the scripts/code that can be directly used to run the tool on any single project



STEPS To RUN :
--------------------------------------------------------------------------------------------------------------------------------------------------------

To run any single project using the tool:

STEPS:
  -> git clone https://github.com/umehrot2/EkstaziPomParser
  -> cd EkstaziPomParser
  -> ./run_ekstazi.sh -u "Project Url" -p "Project Folder Name" -v "Ekstazi Version" - s "Surefire Version" -r "rev1,rev2,rev3.." -d "{1|-1}" -m "module1,module2"

All of the arguments except project url and project folder name are OPTIONAL.
• Project Url : SVN/GIT project url
• Project Folder Name to be created locally
• Ekstazi version : Currently we support 3.4.2 and 4.2.0. (OPTIONAL)
• Modules to run : Specify comma separated list of modules to run on. (OPTIONAL)
• Revisions to run : Specify comma separated list of revisions to run on. (OPTIONAL)
• Surefire version : Specify surefire version to be used. (OPTIONAL)
• Depth parameter : Specify depth 1 for modifying only root pom.xml, else -1 for all. (OPTIONAL)

Example: 
./run_ekstazi.sh -u "http://svn.apache.org/repos/asf/commons/proper/configuration/trunk" -p "commons-config" -r "r1629051,r1629231,r1636033,r1636041,r1636042"



