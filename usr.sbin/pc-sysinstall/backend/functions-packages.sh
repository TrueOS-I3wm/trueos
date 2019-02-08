#!/bin/sh
#-
# SPDX-License-Identifier: BSD-2-Clause-FreeBSD
#
# Copyright (c) 2010 iXsystems, Inc.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $FreeBSD$

# Functions which runs commands on the system

. ${BACKEND}/functions.sh
. ${BACKEND}/functions-parse.sh
. ${BACKEND}/functions-ftp.sh

bootstrap_pkgng()
{
  # Check if we need to boot-strap pkgng
  sync
  if [ -e "${FSMNT}/usr/local/sbin/pkg-static" ] ; then
	  return 0
  fi
  local PKGPTH

  # Ok, lets boot-strap this sucker
  echo_log "Bootstraping pkgng.."

  # Figure out real location of "pkg" package
  PKGFLAG="add"
  case "${INSTALLMEDIUM}" in
    usb|dvd|local) rc_halt "cd ${LOCALPATH}"
		   PKGPTH="/mnt/`ls pkg-[0-9]*.txz`"
		   ;;
              ftp) if [ ! -e "${FSMNT}/usr/local/etc/pkg" ] ; then
		      mkdir ${FSMNT}/usr/local/etc
	              cp -r /root/pkg ${FSMNT}/usr/local/etc/pkg
                   fi
		   PKGPTH="ports-mgmt/pkg"
		   PKGFLAG="install -y"
		   # Copy over resolv.conf
		   rc_halt "cp /etc/resolv.conf ${FSMNT}/etc"
                   ;;
          *) PKGPTH="pkg" ;;
  esac
  rc_halt "pkg -c ${FSMNT} ${PKGFLAG} ${PKGPTH}"
}
