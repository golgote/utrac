# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(utrac, 0.3.0, http://utrac.sourceforge.net/)
AC_CONFIG_SRCDIR([src/utrac.c])
AM_INIT_AUTOMAKE([1.9 foreign])

# Checks for programs.
AC_PROG_CC
AC_PROG_LN_S

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([fcntl.h float.h limits.h stdlib.h string.h unistd.h])

LIBS="-lm"

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_CONST
AC_C_INLINE

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([floor nl_langinfo strchr strndup strstr strtoul])

AC_CONFIG_FILES([
Makefile
src/Makefile]
)
AC_OUTPUT

