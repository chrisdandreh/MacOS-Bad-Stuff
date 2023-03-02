read-host -prompt "Be prepared to type Y to message prompts or press Yes to message prompts that appear. Make sure you have ran powershell or terminal as a non-administrator and that you have at least 10gb of spare ram, 70gb of spare space on your C drive, and at least a 4 core 8 thread CPU from 2017 or later. Press anything to continue."

$ProgressPreference = 'SilentlyContinue';
#suppresses load bars, speeding up downloads. Thanks microsoft, remove this command and see that the download takes 4x longer;

Invoke-WebRequest -Uri "https://download.virtualbox.org/virtualbox/6.1.32/VirtualBox-6.1.32-149290-Win.exe" -OutFile "c:\temp\VirtualBox.exe";
#downloads virtualbox 6.1.32;

Invoke-WebRequest -Uri "https://download.virtualbox.org/virtualbox/6.1.32/Oracle_VM_VirtualBox_Extension_Pack-6.1.32.vbox-extpack" -OutFile "c:\temp\Oracle_VM_VirtualBox_Extension_Pack-6.1.32.vbox-extpack";
#downloads extension pack 6.1.32;

Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z2201-x64.exe" -OutFile "c:\temp\7zip.exe";
#downloads 7zip for decryption of iso;

start "https://drive.google.com/file/d/1wjRAyGnPmJDvH5QoCUtb8W2X_v_7PwKY/view?usp=share_link";
#opens ISO download for user to interact with;


read-host -prompt "A link will have opened in your browser, download the file. Once download is complete, cut and paste the file from your Downloads folder to c:\temp\ and then press anything to proceed";

start-process c:\temp\7zip.exe /S;
#silently installs 7zip;

cd "c:\temp";
#changes directory to the temporary directory;

& "C:\Program Files\7-Zip\7z.exe" x "C:\temp\ISO.7z" -p"RWa3%XmLR3XNT#" -o"C:\temp";
#extracts archive and passes password for decryption;

start-process ("VirtualBox.exe") -Wait --silent;
#silently installs Virtualbox 6.1.32;

cd "C:\Program Files\Oracle\VirtualBox\";
#changes working directory to the Virtual Box folder;

./VBoxManage extpack install "c:\temp\Oracle_VM_VirtualBox_Extension_Pack-6.1.32.vbox-extpack" --accept-license=;
#installs extension pack 6.1.32;

./VBoxManage createvm --name "macOS Monterey" --ostype MacOS_64 --register;
#creates the virtual machine with the OS type set to 64 bit Mac OS;

./VBoxManage modifyvm "macOS Monterey" --ioapic on;

./VBoxManage modifyvm "macOS Monterey" --memory 8192 --vram 256;
#sets allocated memory to 8gb and video memory to 256mb;

./VBoxManage modifyvm "macOS Monterey" --nic1 nat;
#for network connection;

./VBoxManage modifyvm "macOS Monterey" --chipset ich9;
#changes chipset to ich9;

./VBoxManage modifyvm "macOS Monterey" --firmware efi;

./VBoxManage storagectl "macOS Monterey" --name "Sata Controller" --add sata --controller IntelAhci;
#Intel storage AHCI SATA controller;

./VBoxManage createhd --filename "c:\temp\macOS Monterey.vdi" --size 50000 --format VDI --variant Fixed;
#creates VDI disk at size 50gb

./VBoxManage storageattach "macOS Monterey" --storagectl "Sata Controller" --port 0 --device 0 --type hdd --medium "c:\temp\macOS Monterey.vdi";
#Attaches storage;

./VBoxManage storageattach "macOS Monterey" --storagectl "Sata Controller" --port 1 --device 0 --type dvddrive --medium "c:\temp\macOS Monterey.iso"
#attaches installation ISO;

./VBoxManage modifyvm "macOS Monterey" --boot1 dvd --boot2 disk --boot3 none --boot4 none 
#sets boot order;

./VBoxManage modifyvm "macOS Monterey" --usbehci off --usbxhci on;
#disables usb 2.0 and enables usb 3.0;

./VBoxManage modifyvm "macOS Monterey" --cpus 8;
#sets number of CPU threads to 8;

./VBoxManage.exe modifyvm "macOS Monterey" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff;
#sets cpuid that macOS will recognize;

./VBoxManage setextradata "macOS Monterey" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac19,1";
#sets machine to be appear to be an iMac;

./VBoxManage setextradata "macOS Monterey" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0";
#;

./VBoxManage setextradata "macOS Monterey" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Mac-AA95B1DDAB278B95";
#;

./VBoxManage setextradata "macOS Monterey" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc";
#secret mac code;

./VBoxManage setextradata "macOS Monterey" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1;
#helps with preventing kernal panics;

./VBoxManage setextradata "macOS Monterey" "VBoxInternal/TM/TSCMode" "RealTSCOffset"
#helps with preventing kernal panics;

./VBoxManage modifyvm "macOS Monterey" --cpu-profile "Intel Core i7-6700K";
#sets CPU to appear as a 6700k, 4 core and 8 thread Skylake CPU;

./VBoxManage startvm "macOS Monterey" --type gui;
#starts the virtual machine and opens the gui;

#Credits;
#Created by Christian Drehmann;
#Revison 66 2023-03-01;
#Source 1 https://i12bretro.github.io/tutorials/0629.html;
#Source 2 https://www.makeuseof.com/tag/macos-windows-10-virtual-machine/;
#Source 3 https://old.reddit.com/r/PowerShell/comments/phkr76/trying_to_download_google_drive_file_in/;
#Source 4 https://docs.oracle.com/en/virtualization/virtualbox/6.0/;