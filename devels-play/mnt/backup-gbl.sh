#!/bin/bash

backup_mnt_location=${1:-/mnt/data}
_GABRIEL=gbl
_HALOS=halos

if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

sudo mkdir -p ${backup_mnt_location}/${username}/${username}-orig && \
sudo mkdir -p ${backup_mnt_location}/gbl/gbl-orig && \
sudo mkdir -p ${backup_mnt_location}/gbl/devel-orig && \
sudo mkdir -p ${backup_mnt_location}/devel/devel-orig && \
sudo chown ${username}:${groupname} ${backup_mnt_location}/${username} && \
sudo chown ${username}:${groupname} ${backup_mnt_location}/${username}/${username}-orig && \
sudo chown gbl:halos ${backup_mnt_location}/gbl && \
sudo chown gbl:halos ${backup_mnt_location}/gbl/gbl-orig && \
sudo chown devel:horns ${backup_mnt_location}/devel && \
sudo chown devel:horns ${backup_mnt_location}/devel/devel-orig && \
# sudo chown devel:horns ${backup_mnt_location}/gbl/devel-orig && \
sudo chown devel:horns ${backup_mnt_location}/gbl/devel-orig && \
# sudo chown devel:horns ${backup_mnt_location}/${username} && \
sudo chown devel:horns ${backup_mnt_location}/${username}/devel-orig && \
sudo chown devel:horns ${backup_mnt_location}/gbl/devel-orig && \

# copy newly pulled backup script to mount location and home dirs
sudo cp -arf dwork/mnt/backup-gbl.sh ${backup_mnt_location}/gbl/backup-gbl.sh && cp -arf dwork/mnt/backup-gbl.sh /home/gbl/backup-gbl.sh  && \
sudo cp -arf dwork/mnt/backup-custom.sh ${backup_mnt_location}/${username}/backup-${username}.sh && cp -arf dwork/mnt/backup-custom.sh /home/${username}/backup-${username}.sh && \
sudo cp -arf dwork/mnt/backup-custom.sh ${backup_mnt_location}/gbl/backup-${username}.sh && cp -arf dwork/mnt/backup-custom.sh /home/gbl/${username}.sh && \
sudo cp -arf dwork/mnt/backup-custom.sh ${backup_mnt_location}/${username}/backup-gbl.sh && cp -arf dwork/mnt/backup-${username}.sh /home/gbl/gbl.sh && \
sudo cp -arf dwork/mnt/backup-custom.sh ${backup_mnt_location}/gbl/backup-gbl.sh && cp -arf dwork/mnt/backup-custom.sh /home/gbl/backup-gbl.sh && \
sudo cp -arf dwork/mnt/backup-dvl.sh ${backup_mnt_location}/devel/backup-dvl.sh && \
sudo cp -arf dwork/mnt/backup-dvl.sh ${backup_mnt_location}/${username}/backup-dvl.sh && cp -arf dwork/mnt/backup-dvl.sh /home/${username}/backup-dvl.sh  && \
sudo cp -arf dwork/mnt/backup-dvl.sh ${backup_mnt_location}/gbl/backup-dvl.sh && cp -arf dwork/mnt/backup-dvl.sh /home/gbl/backup-dvl.sh  && \
sudo cp -arf dwork/mnt/backup-dvl.sh /home/devel/backup-dvl.sh && \
# # make rwx for owner and rx for group - none for others
# sudo chmod 750 -R ${backup_mnt_location}/${username} && \
# sudo chmod 755 ${backup_mnt_location}/${username} && \
# sudo chmod 750 -R ${backup_mnt_location}/gbl && \
# sudo chmod 755 ${backup_mnt_location}/gbl && \
# sudo chmod 750 -R ${backup_mnt_location}/devel && \
# # # add warning for the backup drive
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${username}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${username}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/${username}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${username}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/gbl/README_ASAP      && \
# sudo chown ${username}:${groupname} ${backup_mnt_location}/README_ASAP

HALO_DESTINATION="$_NIX_MNT_LOCATION/gbl/devel-$WSL_DISTRO_NAME";
HALO_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/gbl/restore-devel-$WSL_DISTRO_NAME.sh";

echo "backing the /hal up to: $HALO_DESTINATION ...";

export VERSION_CONTROL=numbered;

mkdir -p $HALO_DESTINATION;
cp -arf --backup=$VERSION_CONTROL --update /home/devel $HALO_DESTINATION;

echo "creating restore script and saving as $HALO_RESTORE_SCRIPT ...";

echo "#!/bin/bash
# run as sudo

echo 'restoring $_NIX_MNT_LOCATION/gbl/devel-$WSL_DISTRO_NAME/devel to /home ...';
cp --backup=$VERSION_CONTROL --remove-destination -arf $_NIX_MNT_LOCATION/gbl/devel-$WSL_DISTRO_NAME/devel /home" > $HALO_RESTORE_SCRIPT;

chown devel:horns $HALO_RESTORE_SCRIPT;
chmod +x $HALO_RESTORE_SCRIPT;

echo "Backup complete.";
