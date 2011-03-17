# Packaging commands (all run from libdmtx-wrappers root):
# $ make distclean
# $ make dist-bzip2
# $ make dist-gzip
# $ script/dist-image.sh

ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = -Wshadow -Wall -pedantic -ansi

if ENABLE_PHP
   PHP_DIR = php
endif

if ENABLE_PYTHON
   PYTHON_DIR = python
endif

if ENABLE_RUBY
   RUBY_DIR = ruby
endif

if ENABLE_VALA
   VALA_DIR = vala
endif

# Only include directories that were enabled at ./configure time
SUBDIRS = . $(PHP_DIR) $(PYTHON_DIR) $(RUBY_DIR) $(VALA_DIR)

# Force DIST_SUBDIRS equal to SUBDIRS. Otherwise "distclean" target will
# break in unconfigured directories. This is allowed because all wrapper
# directories (configured and unconfigured) are also listed in EXTRA_DIST.
DIST_SUBDIRS = $(SUBDIRS)

EXTRA_DIST = KNOWNBUG \
	README.cygwin \
	README.freebsd \
	README.linux \
	README.mingw \
	README.osx \
	README.unix \
	README.visualc \
	m4 \
	script/check_all.sh \
	script/check_comments.sh \
	script/check_copyright.sh \
	script/check_headers.pl \
	script/check_keyword.sh \
	script/check_license.sh \
	script/check_spacing.sh \
	script/check_todo.sh \
	script/check_whitespace.sh \
	script/dist-image.sh \
	wrapper/cocoa/* \
	wrapper/java/* \
	wrapper/net/* \
	wrapper/php/* \
	wrapper/python/* \
	wrapper/ruby/* \
	wrapper/vala/*
