#!/bin/bash

backup_mnt_location=${1:-/mnt/data}
_GBL=${2:-gbl}
_HALOS=${3:-halos}

if [ -z $_NIX_MNT_LOCATION ]
then 
    export _NIX_MNT_LOCATION=/mnt/data
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

sudo mkdir -p ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo mkdir -p ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo mkdir -p ${backup_mnt_location}/${_GBL}/devel-orig && \
sudo mkdir -p ${backup_mnt_location}/devel/devel-orig && \
sudo chown ${_GBL}:${_HALOS} ${backup_mnt_location}/${_GBL} && \
sudo chown ${_GBL}:${_HALOS} ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo chown ${_GBL}:halos ${backup_mnt_location}/${_GBL} && \
sudo chown ${_GBL}:halos ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo chown devel:horns ${backup_mnt_location}/devel && \
sudo chown devel:horns ${backup_mnt_location}/devel/devel-orig && \
# sudo chown devel:horns ${backup_mnt_location}/${_GBL}/devel-orig && \
sudo chown devel:horns ${backup_mnt_location}/${_GBL}/devel-orig && \
# sudo chown devel:horns ${backup_mnt_location}/${_GBL} && \
sudo chown devel:horns ${backup_mnt_location}/${_GBL}/devel-orig && \
sudo chown devel:horns ${backup_mnt_location}/${_GBL}/devel-orig && \

# copy newly pulled backup script to mount location and home dirs
sudo cp -arf dwork/mnt/backup-gbl.sh ${backup_mnt_location}/gbl/backup-gbl.sh && cp -arf dwork/mnt/backup-gbl.sh /home/gbl/backup-gbl.sh  && \
sudo cp -arf dwork/mnt/backup-custom.sh ${backup_mnt_location}/${_GBL}/backup-${_GBL}.sh && cp -arf dwork/mnt/backup-custom.sh /home/${_GBL}/backup-${_GBL}.sh && \
sudo cp -arf dwork/mnt/backup-devel.sh ${backup_mnt_location}/devel/backup-devel.sh && \
sudo cp -arf dwork/mnt/backup-devel.sh ${backup_mnt_location}/${_GBL}/backup-devel.sh && cp -arf dwork/mnt/backup-devel.sh /home/${_GBL}/backup-devel.sh  && \
sudo cp -arf dwork/mnt/backup-devel.sh ${backup_mnt_location}/gbl/backup-devel.sh && cp -arf dwork/mnt/backup-devel.sh /home/gbl/backup-devel.sh
#  # make rwx for owner and rx for group - x for others
# sudo chmod 751 -R ${backup_mnt_location}/${_GBL} && \
# sudo chmod 755 ${backup_mnt_location}/${_GBL} && \
# sudo chmod 751 -R ${backup_mnt_location}/gbl && \
# sudo chmod 755 ${backup_mnt_location}/gbl && \
# sudo chmod 751 -R ${backup_mnt_location}/devel && \
# # # add warning for the backup drive
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/${_GBL}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/gbl/README_ASAP      && \
# sudo chown ${_GBL}:${_HALOS} ${backup_mnt_location}/README_ASAP

HEL_DESTINATION="$_NIX_MNT_LOCATION/${_GBL}/devel-$WSL_DISTRO_NAME"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/devel/restore-devel-$WSL_DISTRO_NAME.sh"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/gbl/restore-devel-$WSL_DISTRO_NAME.sh"


echo "backing the /hel up to: $HEL_DESTINATION ..."

export VERSION_CONTROL=numbered

# mkdir -p $HEL_DESTINATION
cp -arf --backup=$VERSION_CONTROL --update /home/devel $HEL_DESTINATION

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo

echo 'restoring $_NIX_MNT_LOCATION/gbl/devel-$WSL_DISTRO_NAME/devel to /home ...'
cp --backup=$VERSION_CONTROL --remove-destination -arf $_NIX_MNT_LOCATION/gbl/devel-$WSL_DISTRO_NAME/devel /home" > $HEL_RESTORE_SCRIPT

chown devel:horns $HEL_RESTORE_SCRIPT
chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
