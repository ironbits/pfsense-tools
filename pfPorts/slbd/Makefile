# New ports collection makefile for:	php4
# Date created:				Tue Feb 18 11:17:13 CET 2003
# Whom:					Alex Dupre <sysadmin@alexdupre.com>
#
# $FreeBSD: ports/lang/php4/Makefile,v 1.88 2005/07/13 19:56:27 ale Exp $
#

PORTNAME=	slbd
PORTVERSION=	0.0.2
PORTREVISION?=	0
CATEGORIES?=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# none
EXTRACT_ONLY=	# empty
NO_STAGE=	yes

MAINTAINER?=	jebc@c4solutions.net
COMMENT?=	reinits ata channel 0

WHERE=		sbin
PLIST_FILES=    ${WHERE}/${PORTNAME}

do-extract:
	mkdir -p ${WRKSRC}
	cp ${FILESDIR}/Makefile ${WRKSRC}/
	cp ${FILESDIR}/*.* ${WRKSRC}/

do-build:
	cd work/slbd-0.0.2 && make

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/${PORTNAME} ${PREFIX}/${WHERE}/
	${CP} ${WRKSRC}/slbd.sh ${PREFIX}/${WHERE}/
	${CHMOD} 0555 ${PREFIX}/${WHERE}/slbd.sh

.include <bsd.port.mk>
