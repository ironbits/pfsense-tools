#!/bin/sh

# pfSense master builder script
# (C)2005-2006 Scott Ullrich and the pfSense project
# All rights reserved.
#
# $Id$

# Crank up error reporting, debugging.
#set -e 
#set -x

# Suck in local vars
. ./pfsense_local.sh

# Suck in script helper functions
. ./builder_common.sh

# Allow old CVS_CO_DIR to be deleted later
if [ -d $CVS_CO_DIR ]; then 
	chflags -R noschg $CVS_CO_DIR
fi 

export KERNELCONF="${PWD}/conf/pfSense.$FREEBSD_VERSION"

# Define make.conf
export MAKE_CONF="${PWD}/conf/make.conf.developer.$FREEBSD_VERSION"
export SRC_CONF="${PWD}/conf/make.conf.developer.$FREEBSD_VERSION"
export SRC_CONF_INSTALL="${PWD}/conf/make.conf.developer.$FREEBSD_VERSION"

export IS_DEV_ISO=yo

# Add etcmfs and rootmfs to the EXTRA plugins used by freesbie2
export EXTRA="${EXTRA:-} rootmfs varmfs etcmfs"

# Output build flags
print_flags

# Clean out directories
echo ">>> Cleaning up old directories..."
freesbie_make cleandir

# Calculate versions
export version_kernel=`cat $CVS_CO_DIR/etc/version_kernel`
export version_base=`cat $CVS_CO_DIR/etc/version_base`
export version=`cat $CVS_CO_DIR/etc/version`

# Invoke FreeSBIE2 toolchain

# Prepare object directry
echo ">>> Preparing object directory..."
freesbie_make obj

# Check for freesbie builder issues
if [ -f ${MAKEOBJDIRPREFIX}/usr/home/pfsense/freesbie2/.tmp_buildworld ]; then
	echo "Something has gone wrong!  Press ENTER to view log file."
	read ans
	more ${MAKEOBJDIRPREFIX}/usr/home/pfsense/freesbie2/.tmp_buildworld
	exit
fi

if [ -f ${MAKEOBJDIRPREFIX}/usr/home/pfsense/freesbie2/.tmp_installworld ]; then
	echo "Something has gone wrong!  Press ENTER to view log file."
	read ans
	more ${MAKEOBJDIRPREFIX}/usr/home/pfsense/freesbie2/.tmp_installworld
	exit
fi

# Build world, kernel and install
echo ">>> Building world and kernels for ISO... $FREEBSD_VERSION  $FREEBSD_BRANCH ..."
make_world

# Build SMP, Embedded (wrap) and Developers edition kernels
echo ">>> Building all extra kernels... $FREEBSD_VERSION  $FREEBSD_BRANCH ..."
build_all_kernels

# Check for freesbie builder issues
if [ -f ${MAKEOBJDIRPREFIX}/usr/home/pfsense/freesbie2/.tmp_kernelbuild ]; then
	echo "Something has gone wrong!  Press ENTER to view log file."
	read ans
	more ${MAKEOBJDIRPREFIX}/usr/home/pfsense/freesbie2/.tmp_kernelbuild 
	exit
fi

# Fixup library changes if needed
fixup_libmap

echo ">>> Searching for packages..."
set +e # grep could fail
(cd /var/db/pkg && ls | grep bsdinstaller) > $BUILDER_TOOLS/builder_scripts/conf/packages
(cd /var/db/pkg && ls | grep grub) >> $BUILDER_TOOLS/builder_scripts/conf/packages
(cd /var/db/pkg && ls | grep lua) >> $BUILDER_TOOLS/builder_scripts/conf/packages
set -e

echo ">>> Installing packages: " 
cat $BUILDER_TOOLS/builder_scripts/conf/packages

rm -f $MAKEOBJDIRPREFIX/usr/home/pfsense/freesbie2/*pkginstall*

# Install custom packages
echo ">>> Installing custom packageas..."
freesbie_make pkginstall

cust_populate_installer_bits

# Prepare /usr/local/pfsense-clonefs
echo ">>> Cloning filesystem..."
freesbie_make clonefs

# Ensure /home exists
mkdir -p $CLONEDIR/home
# Finalize iso
echo ">>> Finalizing iso..."
freesbie_make iso

email_operation_completed
