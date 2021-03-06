# Created by: Florent Thoumie <flz@FreeBSD.org>
# $FreeBSD: ports/net/openbgpd/Makefile,v 1.35 2012/12/24 12:56:29 svnexp Exp $

PORTNAME=	openbgpd
PORTVERSION=	5.2.20121209
CATEGORIES=	net
MASTER_SITES=	${MASTER_SITE_OPENBSD}
MASTER_SITE_SUBDIR=	OpenBGPD
DISTNAME=	${PORTNAME}-4.6
EXTRACT_SUFX=	.tgz
DIST_SUBDIR=	${PORTNAME}
NO_STAGE=	yes

MAINTAINER=	hrs@FreeBSD.org
COMMENT=	Free implementation of the Border Gateway Protocol, Version 4

CONFLICTS=	zebra-[0-9]* quagga-[0-9]*

OPTIONS_DEFINE=	IPV6LLPEER
OPTIONS_DEFAULT=IPV6LLPEER
IPV6LLPEER_DESC=Support nexthop using IPv6 link-local address

.include <bsd.port.pre.mk>

.if ${OSVERSION} < 700000
BROKEN=		does not build
.endif

WRKSRC=		${WRKDIR}
MANCOMPRESSED=	yes
USE_RC_SUBR=	${PORTNAME}
PLIST_FILES=	sbin/bgpctl sbin/bgpd
SUB_FILES=	pkg-message
USERS=		_bgpd
GROUPS=		_bgpd

MAN5=		bgpd.conf.5
MAN8=		bgpctl.8 bgpd.8

.if !defined(WITHOUT_IPV6LLPEER)
MAKE_ARGS=	-DIPV6_LINKLOCAL_PEER
.endif

post-patch:
	@${REINPLACE_CMD} -e "s|%%PREFIX%%|${PREFIX}|g"	\
		${WRKSRC}/bgpd/bgpd.8			\
		${WRKSRC}/bgpd/bgpd.conf.5		\
		${WRKSRC}/bgpctl/bgpctl.8

post-install:
	@${CAT} ${PKGMESSAGE}

.include <bsd.port.post.mk>
