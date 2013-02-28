AC_DEFUN([GP_CHECK_MARKDOWN],
[
    GP_ARG_DISABLE([markdown], [auto])
    AC_ARG_ENABLE([markdown-embedded-discount],
                  [AS_HELP_STRING([--enable-markdown-embedded-discount],
                                  [Whether to use embedded Discount library [[default=auto]]])],
                  [enable_markdown_discount=$enableval],
                  [enable_markdown_discount=auto])

    dnl check whether to use embedded copy of the Discount library
    AS_IF([test "x$enable_markdown" != xno &&
           test "x$enable_markdown_discount" != xyes],
          [old_LIBS=$LIBS
           AC_SEARCH_LIBS([mkd_compile], [markdown],
                          [have_libmarkdown=yes], [have_libmarkdown=no])
           AC_CHECK_HEADER([mkdio.h], [have_mkdio_h=yes], [have_mkdio_h=no])
           AS_IF([test "x$have_libmarkdown" = xyes &&
                  test "x$have_mkdio_h" = xyes],
                 [enable_markdown_discount=no],
                 [AS_IF([test "x$enable_markdown_discount" = xno],
                        [AS_IF([test "x$enable_markdown" = xyes],
                               [AC_MSG_ERROR([System Discount library not found])],
                               [enable_markdown=no
                                AC_MSG_WARN([System Discount library not found, disabling Markdown plugin])])],
                        [enable_markdown_discount=yes])])
           MARKDOWN_EXTRA_LIBS=$LIBS
           LIBS=$old_LIBS])
    AS_IF([test "x$enable_markdown_discount" = xyes],
          [markdown_discount_type=embedded],
          [markdown_discount_type=external])
    GP_STATUS_FEATURE_ADD([Markdown Discount library],
                          [$markdown_discount_type])
    AM_CONDITIONAL([MARKDOWN_DISCOUNT],
                   [test "x$enable_markdown_discount" = xyes])

    GTK_VERSION=2.16
    WEBKIT_VERSION=1.1.13

    GP_CHECK_PLUGIN_DEPS([markdown], [MARKDOWN],
                         [gtk+-2.0 >= ${GTK_VERSION}
                          webkit-1.0 >= ${WEBKIT_VERSION}
                          gthread-2.0])
    MARKDOWN_LIBS="$MARKDOWN_LIBS $MARKDOWN_EXTRA_LIBS"

    GP_COMMIT_PLUGIN_STATUS([Markdown])

    AC_CONFIG_FILES([
        markdown/Makefile
        markdown/discount/Makefile
        markdown/src/Makefile
        markdown/docs/Makefile
    ])
])
