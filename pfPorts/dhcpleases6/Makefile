# Created by:   Ermal Luçi <eri@pfsense.org>
# $FreeBSD$

PORTNAME=	dhcpleases6
PORTVERSION=	0.1
PORTREVISION?=	0
CATEGORIES?=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# none
EXTRACT_ONLY=	# empty
NO_STAGE=	yes

MAINTAINER?=	eri@pfsense.org
COMMENT?=	read dhpcd6.leases file and trigger command on modification

WHERE=		sbin
PLIST_FILES=    ${WHERE}/${PORTNAME}

do-extract:
	mkdir -p ${WRKSRC}

do-build:
	${CC} ${CFLAGS} -o ${WRKSRC}/${PORTNAME} ${FILESDIR}/${PORTNAME}.c

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/${PORTNAME} ${PREFIX}/${WHERE}/

.include <bsd.port.mk>
