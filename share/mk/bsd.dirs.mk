# $FreeBSD$
#
# Directory permissions management.

# List of directory variable names to install.  Each variable name's value
# must be a full path.  If non-default permissions are desired, <DIR>_MODE,
# <DIR>_OWN, and <DIR>_GRP may be specified.
DIRS?=

.for dir in ${DIRS}
.if defined(${dir}) && !empty(${dir})
# Set default permissions for a directory
${dir}_MODE?=	0755
${dir}_OWN?=	root
${dir}_GRP?=	wheel

.if defined(NO_ROOT)
.if !defined(${group}TAGS) || ! ${${group}TAGS:Mpackage=*}
${dir}_TAGS+=		package=${${group}PACKAGE:Uruntime}
.endif
${dir}_TAG_ARGS=	-T ${${group}TAGS:[*]:S/ /,/g}
.endif

installfiles: installdirs-${dir}

installdirs-${dir}:
	@echo installing DIRS ${dir}
	${INSTALL} ${${dir}_TAG_ARGS} -d -m ${${dir}_MODE} -o ${${dir}_OWN} \
		-g ${${dir}_GRP} ${DESTDIR}${${dir}}
.endif
.endfor
