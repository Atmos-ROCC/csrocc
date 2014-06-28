read -p "Serial Number: " serial; master=$(show_master.py | grep RMG | grep "$(echo $HOSTNAME | cut -c 1-4)" | awk '{print $3}'); fsuuid=$(psql -U postgres -d rmg.db -h $master -c "select * from fsdisks where diskuuid='$serial';" | awk 'NR==3' | awk -F " " '{print $5}'); devpath=$(psql -U postgres -d rmg.db -h $master -c "select fspath from filesystems where uuid='$fsuuid';" | awk 'NR==3' | awk -F " " '{print $1}'); host=$(psql -U postgres -d rmg.db -h $master -c "select hostname from filesystems where uuid='$fsuuid';" | awk 'NR==3' | awk -F " " '{print $1}'); echo "Drive $devpath is on host $host"; unset serial; unset master; unset fsuuid; unset devpath; unset host;



read -p "Serial Number: " serial; 
master=$(show_master.py | grep RMG | grep "$(echo $HOSTNAME | cut -c 1-4)" | awk '{print $3}'); 
fsuuid=$(psql -U postgres -d rmg.db -h $master -c "select * from fsdisks where diskuuid='$serial';" | awk 'NR==3' | awk -F " " '{print $5}'); 
devpath=$(psql -U postgres -d rmg.db -h $master -c "select fspath from filesystems where uuid='$fsuuid';" | awk 'NR==3' | awk -F " " '{print $1}'); 
host=$(psql -U postgres -d rmg.db -h $master -c "select hostname from filesystems where uuid='$fsuuid';" | awk 'NR==3' | awk -F " " '{print $1}'); 
echo "Drive $devpath is on host $host"; 
unset serial; unset master; unset fsuuid; unset devpath; unset host;