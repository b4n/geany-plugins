include $(top_srcdir)/build/vars.build.mk

plugin = markdown

geanyplugins_LTLIBRARIES = markdown.la

markdown_la_SOURCES = \
	conf.c \
	plugin.c \
	viewer.c

noinst_HEADERS = \
	conf.h \
	viewer.h

markdown_la_CFLAGS = \
	$(AM_CFLAGS) \
	$(MARKDOWN_CFLAGS) \
	-DMARKDOWN_DATA_DIR=\"$(pkgdatadir)/markdown\" \
	-DMARKDOWN_DOC_DIR=\"$(docdir)/markdown\" \
	-DMARKDOWN_HELP_FILE=\"$(docdir)/markdown/html/help.html\"

markdown_la_LIBADD = \
	$(MARKDOWN_LIBS)

if MARKDOWN_DISCOUNT
markdown_la_CFLAGS += -I$(top_srcdir)/markdown/discount
markdown_la_LIBADD += $(top_builddir)/markdown/discount/libdiscount.la
endif

include $(top_srcdir)/build/cppcheck.mk
