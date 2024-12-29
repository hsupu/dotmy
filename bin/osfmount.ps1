param(
    [string]$Drive,
    [string]$Size,
    [switch]$Physical,
    [switch]$Unmount
)

if ([string]::IsNullOrEmpty($Drive)) {
    $Drive = "R"
}

if ([string]::IsNullOrEmpty($Size)) {
    $Size = "1g"
}

$exe = "C:\Program Files\OSFMount\OSFMount.com"

if (-not $Unmount) {
    if ($Physical) {
        & $exe -a -t vm -s $Size -o physical,gpt,hd,rw,format:ntfs:RAMDISK
    }
    else {
        & $exe -a -t vm -s $Size -m "${Drive}:" -o logical,hd,rw,format:ntfs:RAMDISK
    }
}
else {
    & $exe -d -m "${Drive}:"
}


# PassMark OSFMount Command Line Interface.
# For copyrights and credits, type osfmount --version

# Syntax:
# osfmount -a -t type -m mountpoint [-n] [-o opt1[,opt2 ...]] [-f|-F file]
#        [-s size] [-b offset] [-v partition]
# osfmount -d|-D [-m mountpoint]
# osfmount -l [-m mountpoint]

# -a      Mount a virtual disk.

# -d      Dismount a virtual disk.
# -D      Force dismount a virtual disk.

# -t type
#         Select the backingstore for the virtual disk.

#    vm      Virtual disk is backed by virtual memory (ie. RAM disk).
#            If -f is specified, that file is pre-loaded into the virtual memory.

#    file    Virtual disk is backed by the file specified with -f file

#    file+wc Virtual disk is backed by the file and an existing write cache file (.osfdelta)
#            specified with -f file
#            LIMITATIONS: The disk must be mounted using physical emulation.

# -f file or -F file
#         File to use as for virtual disk.

# -l      List configured devices. If given with -m, display details about
#         that particular device.


# -s size
#         Size of the virtual disk. Size is number of bytes unless suffixed with
#           'b'    number of 512-byte blocks
#           'K'    kilobytes
#           'M'    megabytes
#           'G'    gigabytes
#           'T'    terabytes
#           'k'    thousand (1,000) bytes
#           'm'    million (1,000,000) bytes
#           'g'    billion (1,000,000,000) bytes
#           't'    trillion (1,000,000,000,000) bytes
#         The suffix can also be % to indicate percentage of free physical memory which
#         could be useful when creating vm type virtual disks.

#         It is optional to specify a size unless the file to use for a file type virtual disk
#         does not already exist or when a vm type virtual disk is created without
#         specifying an initialization image file using the -f or -F.

#         The size can be a negative value to indicate the size of free physical
#         memory minus this size. If you e.g. type -400M the size of the virtual
#         disk will be the amount of free physical memory minus 400 MB.

# -b offset
#         Specifies an offset in an image file where the virtual disk begins.
#         If not specified, the offset shall be automatically calculated.

# -v partition
#         Specifies which partition (1-based) to mount when mounting a raw hard disk image
#         file containing a MBR or GPT partition table.

#         You can specify '#' to automatically select the first detected partition.
#         You can specify 'all' to automatically mount all detected partitions.

#         If this option is not specified, the entire image shall be mounted using physical emulation.

# -o option[,option2,...]
#         Set or reset options.

#    ro      Creates a read-only virtual disk.
#            This is enabled by default if -f is specified.

#    rw      Specifies that the virtual disk should be read/writable in direct write mode.
#            This is enabled by default if vm type virtual disk is created.

#    wc      Specifies that the virtual disk should be read/writable in write cache mode.
#            This preserves the data of the original image file.
#            A write-cache file (.osfdelta) is used to store all writes.
#            LIMITATIONS: The virtual disk must be mounted using physical emulation backed by an image file. (ie. -t file)

#    rem     Specifies that the device should be created with removable media
#            characteristics. This changes the caching behaviour of the virtual disk

#    fix     Specifies that the media characteristics of the virtual disk should be
#            fixed media. This option is selected by default.

#    format:ntfs|fat32|exfat[:"Vol Label"]]
#            Specifies that virtual disk should be formatted after it is mounted.
#            The file system should be one of ntfs, fat32, or exfat.
#            This option is only available for new empty RAM disk. Optionally, to
#            specify a volume label, add a quoted string after appending a colon(:)
#            after the file system.

#            LIMITATIONS: File systems may have a minimum disk size requirement.
#            For example, FAT32 requires at least 260 MB.

#    mbr     Initialize the physical disk with an MBR-style partition table
#            LIMITATIONS: The disk must be mounted using physical emulation backed by virtual memory (ie. -t vm).

#    gpt     Initialize the physical disk with a GPT-style partition table
#            LIMITATIONS: The disk must be mounted using physical emulation backed by virtual memory (ie. -t vm).

#    cd      Creates a virtual CD-ROM/DVD-ROM. This is the default if the file
#            name specified with the -f option ends with either .iso, .nrg or .bin
#            extensions.

#    fd      Creates a virtual floppy disk. This is the default if the size of the
#            virtual disk is any of 160K, 180K, 320K, 360K, 640K, 720K, 820K, 1200K,
#            1440K, 1680K, 1722K, 2880K, 123264K or 234752K.

#    hd      Creates a virtual fixed disk partition. This is the default unless
#            file extension or size match the criterias for defaulting to the cd or
#            fd options.

#    physical
#            Mount drive using physical emulation

#    logical
#            Mount drive using logical emulation

# -m mountpoint
#         Specifies a drive letter (eg. "-m F:" for F:) or
#         physical drive (eg. "-m 1" for \\.\PhysicalDrive1) to perform the operation on.

#         When creating a new logical disk you can specify "-m #:" as mountpoint
#         in which case the first unused drive letter is automatically used.

#         When creating a new physical disk, this option is ignored as the first
#         unused physical disk number is automatically used.
