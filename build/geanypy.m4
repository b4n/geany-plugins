AC_DEFUN([GP_CHECK_GEANYPY],
[
    GP_ARG_DISABLE([Geanypy], [auto])
    GP_CHECK_PLUGIN_GTK2_ONLY([Geanypy])
    GP_CHECK_PLUGIN_DEPS([Geanypy], [PYGTK], [pygtk-2.0])
    GP_CHECK_PLUGIN_DEPS([Geanypy], [GMODULE], [gmodule-2.0])
    dnl FIXME: Checks for Python below should gracefully disable the plugin
    dnl        if they don't succeed and enable_geanypy is set to `auto`.
    dnl        However, since these macros don't seem to gracefully handle
    dnl        failure, and since if PyGTK is found they are likely to succeed
    dnl        anyway, we assume that if the plugin is not disabled at this
    dnl        point it is OK for these checks to be fatal.  The user can pass
    dnl        always pass --disable-geanypy anyway.
    AS_IF([! test x$enable_geanypy = xno], [
        AX_PYTHON_DEVEL([>= '2.6'])
        AX_PYTHON_LIBRARY(,[AC_MSG_ERROR([Cannot find Python library])])
        AC_SUBST([PYTHON])
        AC_DEFINE_UNQUOTED([GEANYPY_PYTHON_LIBRARY],
                           ["$PYTHON_LIBRARY"],
                           [Location of Python library to dlopen()])

        dnl check for C flags we wish to use
        GEANYPY_CFLAGS=
        for flag in -fno-strict-aliasing \
                    -Wno-write-strings \
                    -Wno-long-long
        do
            GP_CHECK_CFLAG([$flag], [GEANYPY_CFLAGS="${GEANYPY_CFLAGS} $flag"])
        done
        AC_SUBST([GEANYPY_CFLAGS])
    ])
    GP_COMMIT_PLUGIN_STATUS([Geanypy])
    AC_CONFIG_FILES([
        geanypy/Makefile
        geanypy/src/Makefile
        geanypy/geany/Makefile
        geanypy/plugins/Makefile
    ])
])

dnl GEANYPY_ARG_DISABLE(PluginName, "auto")
dnl Same as GP_ARG_DISABLE but sets up Python support and checks whether
dnl GeanyPy is enabled
AC_DEFUN([GEANYPY_ARG_DISABLE],
[
    AC_REQUIRE([GP_CHECK_GEANYPY])

    GP_ARG_DISABLE([$1], [$2])

    _GP_ENABLE_CASE([$1],[no],[],
        [dnl check for GeanyPy itself
         AC_MSG_CHECKING([for GeanyPy])
         AC_MSG_RESULT([(cached) $enable_geanypy])
         AS_IF([test "$enable_geanypy" != yes],
               [_GP_CHECK_FAILED([$1], [$1 requires GeanyPy but it is not enabled])])])
])

dnl _GEANYPY_CHECK_MODULE(MODULE, [action if found], [action if not found])
dnl checks for Python module MODULE.  Caches in geanypy_cv_python_module_$1
AC_DEFUN([_GEANYPY_CHECK_MODULE],
[
    AC_REQUIRE([GP_CHECK_GEANYPY]) dnl for $PYTHON

    AC_CACHE_CHECK([for python module $1], [$(eval echo geanypy_cv_python_module_$1)],
                   [AS_IF([$PYTHON -c "import $1" 2>/dev/null],
                          [eval geanypy_cv_python_module_$1=yes],
                          [eval geanypy_cv_python_module_$1=no])])
    AS_IF([test "$(eval echo \$geanypy_cv_python_module_$1)" = yes], [$2], [$3])
])

dnl GEANYPY_CHECK_PLUGIN_DEPS(PluginName, MODULES)
dnl Checks whether Python modules exist, and error out/disables plugins
dnl appropriately depending on enable_$plugin
AC_DEFUN([GEANYPY_CHECK_PLUGIN_DEPS],
[
    _GP_ENABLE_CASE([$1],[no],[],
        [_geanypy_missing_modules=
         for module in $2; do
            _GEANYPY_CHECK_MODULE([$module],,[_geanypy_missing_modules="${_geanypy_missing_modules} $module"])
         done
         AS_IF([test "$_geanypy_missing_modules" = ""],,
               [_GP_CHECK_FAILED([$1], [missing Python modules for plugin $1:$_geanypy_missing_modules])])])
])
