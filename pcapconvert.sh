## Set Universal Script Variables ##

#Set this to your UserID
uid="parrot"

# Set to the location of your cap2hccapx.bin file
convbin="/home/$uid/hashcat-utils/src/cap2hccapx.bin"

# Set to the location of your wordlists
wordlists="/home/$uid/Documents/wordlists/*.txt"

# Set to the location of your pcap files
handshakes="/home/$uid/handshakes"

# Set to the location you want to keep your files for hashcat to read
cats="/home/$uid/handshakes/cats"

# Set to the location you want to keep your converted pcap files 
# DO NOT set $converted to the same folder as the $handshakes variable 
converted="/home/parrot/handshakes/converted"

## This sets the script to run in the $handshakes folder ##
cd $handshakes

## Adding $pcap variable pcap file so the "while" wont fail            ##
## The ls command lists all files and folders in the current directory ##
## "grep" and ".pcap" tell it to only show lines that contain ".pcap"  ##
## The "-m 1" arguement returns only the first pcap filename ##
pcap=$(ls | grep -m 1 .pcap)

## "while [ -z "$pcap" ]" would mean "While $pcap is NULL"              ##
## By adding the "!" makes it false or "While $pcap is not NULL"        ##
## This will run down to the "done" command then loop back to "while"   ##
## until the $pcap variable is empty, when there are no pcap files left ##
while [ ! -z "$pcap" ]
do

## The next 2 lines set the hashcat file name to be the same as the pcap    ##
## "basename -s .pcap" removes the ".pcap" portion of the filename from the ##
## file specified with the variables set earlier $handshakes/$pcap          ##
name=$(basename -s .pcap $handshakes/$pcap)

## Creates the hashcat file name by adding the extension to the ## 
## variable created in the last command                         ## 
hashfile=$name.hccapx

## The next command uses the variables created to form the command that ##
## will convert the pcap file to a hccapx file                          ##
convcmd="$convbin $handshakes/$pcap $cats/$hashfile"

## Clears the screen and makes it a bit easier to follow while running ##
clear

## Runnung the command ##
sudo $convcmd 

## This is just a quick 5 second pause to see if there are handshakes ##
# It's perfectly okay to comment out this sleep #
sleep 5

## Clears the screen and makes it a bit easier to follow while running ##
clear

## Move the pcap file to your $converted folder ##
mv $handshakes/$pcap $converted/$pcap

## Clears the screen and makes it a bit easier to follow while running ##
clear

## Next we'll run hashcat on the newly created hccapx file ##
## the output will be saved in $cats/hashout               ##
hashcat -m 2500 -o $cats/hashout/$name.txt $cats/$hashfile $wordlists
hashcat -m 2500 -o $cats/hashout/$name.txt --show $cats/$hashfile $wordlists

## Clears the screen and makes it a bit easier to follow while running ##
clear

## Change the owner of the output file to your UserID ##
chown $uid $cats/hashout/$name.txt

## Now that $pcap isn't used until we get to the "done" command this ##
## will set the variable to the next pcap on the list                ##
pcap=$(ls | grep -m 1 .pcap)

done

## Last screen will stay up until you notice and close it, or for 100 days ##
clear
echo "Complete! You can close the window or use ctrl+C."
sleep 100d
