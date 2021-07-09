#Store current directory location
currdir=$(pwd)

## Create temporary directory to unzip and merge all log files
incominglogs_tmp="/tmp/incomingserverlogs_tmp"
serverReqlogs_tmp="/tmp/serverlogs_tmp"
mkdir $incominglogs_tmp
mkdir $serverReqlogs_tmp

#Move incoming server logs to temp folder
mv -f *INCOMING_SERVER_REQUEST* $incominglogs_tmp

#Move server request logs to temp folder
mv -f *REQUEST* $serverReqlogs_tmp

#Unzip Incoming server request logs and merge all logs in single log file
cd $incominglogs_tmp
for dir in *.zip; do
file=$(basename "$dir" .zip)
unzip -p $dir > $(printf $file)
done

cat *INCOMING_SERVER_REQUEST_*.log *INCOMING_SERVER_REQUEST_*.log.[0-10] > incomingserverlogfile.txt

#Unzip Server Request logs and merge all logs in single log file
cd $serverReqlogs_tmp
for dir in *.zip; do
file=$(basename "$dir" .zip)
unzip -p $dir > $(printf $file)
done

cat *REQUEST_*.log *REQUEST_*.log.[0-10] > serverlogfile.txt

#Filter details Request_time, Begin_free_memory, Client host, Client description, Appname, Request id , Method name and Invocation depth from Server request log file to create new serverlogfile_filter.txt
awk -F"|" '{print $1"|"$7"|"$14"|"$15"|"$16"|"$17"|"$18"|"$19}' serverlogfile.txt > serverlogfile_filter.txt

#Compare two merged log files for server logs and incoming server logs and print the unmatched methods in inCompleteRequests.txt

cd $currdir/
awk -F"|" 'NR==FNR {a[$5,$7];next} !(($5,$7) in a)' $serverReqlogs_tmp/serverlogfile_filter.txt $incominglogs_tmp/incomingserverlogfile.txt >InCompleteRequests.txt

#To add header to the resultant incompleterequest file
sed -i '1iREQUEST_START_TIME|BEGIN_FREE_MEMORY|CLIENT_HOST|CLIENT_DESCRIPTION|REQUEST_ID|SERVER_NAME|METHOD_NAME|INVOCATIONDEPTH' InCompleteRequests.txt

#Move log files from tmp directory and delete the temp directory
mv -f $incominglogs_tmp/*INCOMING_SERVER_REQUEST*.log $incominglogs_tmp/*INCOMING_SERVER_REQUEST*.zip $currdir
rm -f $incominglogs_tmp/*
rm -d $incominglogs_tmp

mv -f $serverReqlogs_tmp/*_REQUEST*.log $serverReqlogs_tmp/*_REQUEST*.zip $currdir
rm -f $serverReqlogs_tmp/*
rm -d $serverReqlogs_tmp