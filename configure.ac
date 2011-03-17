AC_INIT([libdmtx], [0.7.3], [mike@dragonflylogic.com])
AM_INIT_AUTOMAKE([-Wall -Werror gnu])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([
   Makefile
])

AC_PROG_CC
AC_PROG_LIBTOOL
AM_PROG_CC_C_O

AC_SEARCH_LIBS([atan2], [m] ,[], AC_MSG_ERROR([libdmtx requires libm]))

AC_ARG_ENABLE(
   [cocoa],
   AS_HELP_STRING([--enable-cocoa], [enable Cocoa bindings]),
   [enable_cocoa="$enableval"],
   [enable_cocoa="no"]
)
AM_CONDITIONAL(ENABLE_COCOA, [test x$enable_cocoa = xyes])

if test x$enable_cocoa = xyes; then
   AC_MSG_WARN([Building the Cocoa wrapper though the libdmtx build system is not yet supported])
fi

AC_ARG_ENABLE(
   [java],
   AS_HELP_STRING([--enable-java], [enable Java bindings]),
   [enable_java="$enableval"],
   [enable_java="no"]
)
AM_CONDITIONAL(ENABLE_JAVA, [test x$enable_java = xyes])

if test x$enable_java = xyes; then
   AC_MSG_WARN([Building the Java wrapper though the libdmtx build system is not yet supported])
fi

AC_ARG_ENABLE(
   [net],
   AS_HELP_STRING([--enable-net], [enable .NET bindings]),
   [enable_net="$enableval"],
   [enable_net="no"]
)
AM_CONDITIONAL(ENABLE_NET, [test x$enable_net = xyes])

if test x$enable_net = xyes; then
   AC_MSG_WARN([Building the .NET wrapper though the libdmtx build system is not yet supported])
fi

AC_ARG_ENABLE(
   [php],
   AS_HELP_STRING([--enable-php], [enable PHP bindings]),
   [enable_php="$enableval"],
   [enable_php="no"]
)
AM_CONDITIONAL([ENABLE_PHP], [test x$enable_php = xyes])

if test x$enable_php = xyes; then
   AC_PATH_PROG([PHPIZE], [phpize])
   if test ! -e "$PHPIZE"; then
      AC_ERROR([phpize is required to generate the PHP bindings.])
   fi

   AC_MSG_WARN([Building the PHP wrapper will break make uninstall])

   dmtx_dir=`pwd`
   cd php && \
   $PHPIZE && \
   ./configure --prefix=${prefix} && \
   cd $dmtx_dir
fi

AC_ARG_ENABLE(
   [python],
   AS_HELP_STRING([--enable-python], [enable Python bindings]),
   [enable_python="$enableval"],
   [enable_python="no"]
)
AM_CONDITIONAL(ENABLE_PYTHON, [test x$enable_python = xyes])

if test x$enable_python = xyes; then
   AM_PATH_PYTHON
   AC_MSG_WARN([Building the Python wrapper will break make uninstall])
fi

AC_ARG_ENABLE(
   [ruby],
   AS_HELP_STRING([--enable-ruby], [enable Ruby bindings]),
   [enable_ruby="$enableval"],
   [enable_ruby="no"]
)
AM_CONDITIONAL(ENABLE_RUBY, [test x$enable_ruby = xyes])

if test x$enable_ruby = xyes; then
   AC_PATH_PROG([RUBY], [ruby])
   if test ! -e "$RUBY"; then
      AC_ERROR([ruby is required to generate the Ruby bindings.])
   fi

   AC_MSG_WARN([Building the Ruby wrapper will break make uninstall])

   dmtx_dir=`pwd`
   cd ruby && \
   $RUBY extconf.rb --with-dmtx-dir=${prefix}
   cd $dmtx_dir
fi

AC_ARG_ENABLE(
   [vala],
   AS_HELP_STRING([--enable-vala], [enable Vala bindings]),
   [enable_vala="$enableval"],
   [enable_vala="no"]
)
AM_CONDITIONAL(ENABLE_VALA, [test x$enable_vala = xyes])

if test x$enable_vala = xyes; then
   PKG_PROG_PKG_CONFIG

   PKG_CHECK_EXISTS(
      [vala-1.0],
      [VALA_VAPIDIR=`$PKG_CONFIG --variable=vapidir vala-1.0`],
      [
         #AC_MSG_WARN([Can't find vala development files, guessing where to install vala bindings...])
         VALA_VAPIDIR='${prefix}/share/vala/vapi'
      ]
   )

   AC_SUBST(VALA_VAPIDIR)
   AC_CONFIG_FILES([vala/Makefile])
fi

AC_OUTPUT
