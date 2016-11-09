
FILES_DIR=../users_webpage/files/scripts


find | egrep "/html$" | while read folder
do
    echo $folder

    rsync $folder/ $FILES_DIR/ -rub --backup-dir=rsync-backups --suffix="-$(date +%F-%H-%M-%S)-$(hostname)"
done
