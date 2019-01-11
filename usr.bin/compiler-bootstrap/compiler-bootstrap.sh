#!/bin/sh

# $FreeBSD$

# SPDX-License-Identifier: BSD-2-Clause-FreeBSD
#
#  Copyright (c) 2018 Kris Moore
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
#  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
#  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#  SUCH DAMAGE.

# Script to go through and create sym-links to ports version of LLVM
DEFAULT_LLVM=llvm70

if [ -z "${TRUEOS_MANIFEST}" ] ; then
	BASEDIR="/usr/local"
else
	BASEDIR="/usr"
fi

if [ -n "$1" ] ; then
	LLVM="$1"
else
	LLVM="$DEFAULT_LLVM"
fi

if [ ! -d "$BASEDIR/$LLVM/bin" ] ; then
	echo "WARNING: $BASEDIR/$LLVM/bin does not exist"
fi

# Figure out real binary for clang
CLINK=$(readlink ${BASEDIR}/${LLVM}/bin/clang)

# Make the sym-links now
for i in cc c++ cpp clang clang++ clang-cpp clang-tblgen ld ld.lld
do
	case $i in
                cc)
			if [ ! -e "$BASEDIR/$LLVM/bin/cc" ] ; then
				ln $BASEDIR/${LLVM}/bin/$CLINK $BASEDIR/$LLVM/bin/cc
			fi
			ln -fs $BASEDIR/$LLVM/bin/$i /usr/bin/$i
			;;
               c++)
			if [ ! -e "$BASEDIR/$LLVM/bin/c++" ] ; then
				ln $BASEDIR/${LLVM}/bin/$CLINK $BASEDIR/$LLVM/bin/c++
			fi
		        ln -fs $BASEDIR/$LLVM/bin/$i /usr/bin/$i
			;;
               cpp)
			if [ ! -e "$BASEDIR/$LLVM/bin/cpp" ] ; then
				ln $BASEDIR/${LLVM}/bin/$CLINK $BASEDIR/$LLVM/bin/cpp
			fi
		        ln -fs $BASEDIR/$LLVM/bin/$i /usr/bin/$i
			;;
		ld) ln -fs $BASEDIR/$LLVM/bin/ld.lld /usr/bin/$i ;;
		*) ln -fs $BASEDIR/$LLVM/bin/$i /usr/bin/$i ;;
	esac
done
