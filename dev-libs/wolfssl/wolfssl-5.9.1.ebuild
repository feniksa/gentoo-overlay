# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Lightweight SSL/TLS library for embedded and general-purpose systems"
HOMEPAGE="https://www.wolfssl.com/ https://github.com/wolfSSL/wolfssl"
SRC_URI="https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${PV}-stable.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${PV}-stable"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="
	+asm
	debug
	examples
	openssl
	quic
	static-libs
	test
"

RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	# GitHub release tarball may need autotools regeneration.
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable asm)
		$(use_enable debug)
		$(use_enable examples)
		$(use_enable openssl opensslextra)
		$(use_enable quic)
		$(use_enable static-libs static)
		--enable-shared
		--enable-tls13
		--enable-dtls
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	dodoc README.md
}
