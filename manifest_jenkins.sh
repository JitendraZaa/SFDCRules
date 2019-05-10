#!bin/sh

## Description: This shell file used to prepare delta Manifest file used for manifest based deployed used by Jenkins
##              Script all the components committed after a specified tagged commmit. Tag name is passed as a parameter
## Usage: Called from Git CLI
## Note : Script needs to be run by passing certain parameters
## Parameters : 1. Commit tag name 2. Manifest file name  3. Branch Name 4. Path where to copy changed components(optional)

if [ "$#" -eq 0 ] ; then
	echo "Usage: sh manifest_jenkins.sh <COMMITID>  <Branch name> <path where files are to be copied>"
	exit
fi

#==========================================================
# Calculate the number of commits after the tag name 
#==========================================================

if [ "$#" -eq 3 ]; then
	sudo git checkout $3
else
	git checkout $3
fi

#count=$(git log --pretty=oneline HEAD...$1 --first-parent | wc -l )
#count=$(git rev-parse HEAD | wc -l )
#last_commitID=$(git log --format="%h" -n 1)

count=$(git log --pretty=oneline HEAD $1 --first-parent | wc -l )
last_commitID=$(git log --format="%h" -n 1)


#count=$(git log --pretty=oneline head...$1 | wc -l )

echo ""
echo "***********************************************************"
echo "Total number of Commits: " $count
echo "***********************************************************"

if [ $count = 0 ]
then
    echo "No components to be deployed"
    exit
else   		
	## if components.txt file exist already then delete it
	if [ -e "components.txt" ]
		then
			rm components.txt
	fi
				
	## command to prepare components file
	git diff --diff-filter=MARCT  HEAD~$count --name-only >> components.txt
	
	## Possible deleted Components
	git diff --diff-filter=D  HEAD~$count --name-only > del_components.txt

	## Generate the file containing all the list of components to be which were commited
	truncate -s 0 componentsFile.txt
	sed 's/[a-zA-Z_]*\///g' components.txt >> componentsFile.txt
	
	echo ""
	echo "***********************************************************"
	echo "Total Number of components(Non Deleted): "$(cat components.txt | wc -l)
	echo "***********************************************************"
	
	echo ""
	echo "***********************************************************"
	echo "Total number Of newly added Components: " $(git diff --diff-filter=A  HEAD~$count --name-only | wc -l)
	echo "***********************************************************"
	
	echo ""
	echo "***********************************************************"
	echo "Total number of deleted components: " $(git diff --diff-filter=D  HEAD~$count --name-only | wc -l)
	echo "Deleted Components Are (Not included in component file):"
	echo "***********************************************************"

fi 

#echo "Total Number of components: "$(cat components.txt | wc -l)

#==========================================
#find max depth of folder structure
#if component path is src/classes/example.cls then depth is 1
#if component path is src/reports/IPM_Reports/example.report then depth is 2 
#Depth is calculated as : (Max Occurence of / character in a line)-1
#===========================================
filename='components.txt'

# variable to store maximum
max_occurences=0;

echo ""
echo "Starting Process...."

# Read each line of the components.txt file and find count of / characters in that line
while read p; do 

	#number_of_occurrences=$(grep -o "/" <<< "$p" | wc -l)
    number_of_occurrences=$(grep "/" <<< "$p" | wc -l)
   	
	#echo $number_of_occurrences of /
	if [[ $max_occurences -lt $number_of_occurrences ]]
		then 
		max_occurences=$number_of_occurrences
	fi
	done < $filename

echo ""
echo "***********************************************************"
echo "Maximum depth of folder structure is" $max_occurences
echo "***********************************************************"

maxDepthFolderStrt=$max_occurences

#=====================================================================
# prepare manifest file using regex to find the folder structure
#=====================================================================

# empty all the temporary files used. If they are not present then they are created
truncate -s 0 componentstemp.txt
truncate -s 0 test.txt
truncate -s 0 tempManifest.txt
truncate -s 0 uniqManifest.txt
truncate -s 0 project-manifest.txt 

#Initail regex
#regExForFolderStrt="^[a-zA-Z_]*/"
regExForFolderStrt=""

##Applying regex for the depth of the folder
#for 1st iteration regex is "^src/[a-zA-Z_]*/" (matches "src/classes/")
#for 2nd iteration regex is "^src/[a-zA-Z_]*/[a-zA-Z_]*/" (matches "src/reports/IPM_Reports/")
# and so on
counter=$maxDepthFolderStrt

while [ $counter -gt 0 ]
do
	if [ $counter = $maxDepthFolderStrt ]
	then 
	   regExForFolderStrt="^[a-zA-Z_$]*/"
	else
	   regExForFolderStrt=$regExForFolderStrt"[a-zA-Z_$]*/"
	fi
	
	# add matched strings to componentstemp.txt file after removing trailing /
	grep -io $regExForFolderStrt components.txt | sed 's/.$//' >> componentstemp.txt
	
	counter=`expr $counter - 1`
	
done

echo ""
echo "STEP:1 Starting delta manifest file preparation ..."

# find all the unique folder structure and put it in test file
uniq -u componentstemp.txt >> test.txt

# find all the duplicate folder structre and put it in test file
uniq -d componentstemp.txt >> test.txt

# put the componets file content to test file
cat components.txt >> test.txt

##Add meta files of all .cls files
regExForClass="\.cls"
regExForTrigger="\.trigger"
regExForPage="\.page"
regExForComponent="\.component"
regExForResource="\.resource"
regExForEmail="\.email"
regExForPNG="\.png$"
regExForGIF="\.gif$"

#Aura App and Componets file extensions
regExForAPP="\.app$"
regExForCMP="\.cmp$"
regExForDGN="\.design$"
regExForEVT="\.evt$"
regExForINTF="\.intf$"
regExForJS="\.js$"
regExForSVC="\.svc$"
regExForCSS="\.css$"
regExForDoc="\.auradoc$"
regExForTKNS="\.tokens$"
regExForLgtAPPMeta="\.app-meta.xml$"
regExForLgtCMPMeta="\.cmp-meta.xml$"
regExForLgtEVTMeta="\.evt-meta.xml$"
regExForLgtLWCMeta="\.js-meta.xml$"

#End of Aura App and Componets file extensions

#LWC App and Componets file extensions

regExForHtml="\.html$"

#End of LWC App and Componets file extensions


while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ $regExForClass || "$line" =~ $regExForTrigger || "$line" =~ $regExForPage || "$line" =~ $regExForComponent || 
	"$line" =~ $regExForResource || "$line" =~ $regExForEmail || "$line" =~ $regExForPNG || "$line" =~ $regExForGIF || 
	"$line" =~ $regExForAPP || "$line" =~ $regExForCMP || "$line" =~ $regExForDGN || "$line" =~ $regExForEVT || 
	"$line" =~ $regExForINTF || "$line" =~ $regExForJS || "$line" =~ $regExForSVC || "$line" =~ $regExForCSS || 
	"$line" =~ $regExForDoc || "$line" =~ $regExForTKNS || "$line" =~ $regExForHtml || 
	"$line" =~ $regExForLgtAPPMeta || "$line" =~ $regExForLgtCMPMeta || "$line" =~ $regExForLgtEVTMeta || "$line" =~ $regExForLgtLWCMeta ]];
	
	then
		str=`echo "$line" | cut -d"-" -f1`
		echo "$str" >> tempManifest.txt
		echo "$str"'-meta.xml' >> tempManifest.txt
	else
	    if grep -Fxq "$line"'-meta.xml' "test.txt"
		then
			echo "matched"
		else
			echo "$line" >> tempManifest.txt
		fi
	fi
done < "test.txt"

#Preparation of actual manifest file
#add the base src directory
#echo "src" >> project-manifest.txt

# find all the unique folder structure and put it in test file
uniq -u tempManifest.txt >> uniqManifest.txt

# find all the duplicate folder structre and put it in test file
uniq -d tempManifest.txt >> uniqManifest.txt

# replace / with \ in the test file and append its content to actual manifest file
#sed 's/\//\\/g' uniqManifest.txt | sort >> project-manifest.txt
cat uniqManifest.txt | sort | uniq >> project-manifest.txt

echo "***********************************************************"
echo "List of files changed after the commit id provided:"
echo "-----------------------------------------------------------"
cat components.txt

echo ""
echo "STEP:2 Create project-manifest.txt:"
echo "***********************************************************"


s_path=`pwd`
cd "`echo $s_path`"
#cd "`echo $s_path`"/scripts

if grep -q "^src" project-manifest.txt ; then
        grep "^src" project-manifest.txt| grep -v 'src/labels' > delta.txt
		grep "^src" project-manifest.txt| grep '^src/labels' >> delta.txt
		
	## Handle Placement of Labels in the manifest - bring it on top
	##grep "^src/labels" project-manifest.txt | grep -v "/labels" > labels.txt
	sed -i "1r labels.txt" delta.txt
    echo "Delta file is as follows:"
	echo "-----------------------------------------------------------"
	cat "`echo $s_path`"/delta.txt
	
	## Handle Aura components
	if grep -q  "^src/aura" delta.txt ; then
	    echo "Preparing Aura components"
		grep  "^src/aura" delta.txt |cut -d"/" -f3 | sort | uniq -d > aura.txt
		echo "src/aura" > auralist.txt
		sed -i 's/\r//g' aura.txt 
		
		for i in `cat aura.txt`;
		do
			cd ..
			echo "src/aura/$i" >> scripts/auralist.txt
			ls -b -R src/aura/$i/* >> scripts/auralist.txt
			cd -
		done;
		sed -i '/src\/aura/d' delta.txt
		cat auralist.txt >>delta.txt
	fi
	## Handle LWC components
	if grep -q  "^src/lwc" delta.txt ; then
	    echo "Preparing LWC components"
		grep  "^src/lwc" delta.txt |cut -d"/" -f3 | sort | uniq -d > lwc.txt
		echo "src/lwc" > lwclist.txt
		sed -i 's/\r//g' lwc.txt 
		
		for i in `cat lwc.txt`;
		do
			cd ..
			echo "src/lwc/$i" >> scripts/lwclist.txt
			ls -R src/lwc/$i/* >> scripts/lwclist.txt
			cd -
		done;
		sed -i '/src\/lwc/d' delta.txt
		cat lwclist.txt >>delta.txt
	fi
else
	cat ../project-manifest.txt > delta.txt
	echo "Preparing Labels else"
fi

	cp delta.txt ../project-manifest.txt; 
	echo "Copying project-manifest.txt to $s_path"
	echo ""
	echo "project-manifest.txt file is as follows:"
	echo "-----------------------------------------------------------"
	cat "`echo $s_path`"/../project-manifest.txt

# Case to handle when project manifest was not changed in between a given commitid

if ! grep -q "project-manifest" components.txt; then
	cat ../project-manifest.txt >> components.txt
fi

# Remove temporary files
rm uniqManifest.txt || true
rm components.txt || true
rm test.txt || true
rm componentstemp.txt || true
rm tempManifest.txt || true
#rm aura.txt || true
#rm auralist.txt || true
#rm lwc.txt || true
#rm lwclist.txt || true
#rm delta.txt || true|| true
rm componentsFile.txt || true
rm del_components.txt || true
rm "$s_path/project-manifest.txt" || true


echo ""
echo "****************End Of Process*****************************"
echo ""