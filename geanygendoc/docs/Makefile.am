include $(top_srcdir)/build/vars.docs.mk
plugin = geanygendoc
pluginhtmldocdir = $(plugindocdir)/html

EXTRA_DIST = \
	manual.css \
	html4css1.css

dist_plugindoc_DATA = \
	manual.rst

dist_pluginhtmldoc_DATA = \
	manual.html

if BUILD_RST
.PHONY: manual.html

manual.html: manual.rst manual.css html4css1.css
	echo "  DEBUG    CURDIR=$(CURDIR)"
	echo "  DEBUG    PWD=$(PWD)"
	echo "  DEBUG    `pwd`"
	echo "  DEBUG    srcdir=$(srcdir)"
	echo "  DEBUG    abs_srcdir=$(abs_srcdir)"
	echo "  DEBUG    at abs_srcdir=@abs_srcdir@"
	$(AM_V_GEN) $(RST2HTML) -d --strict \
		--stylesheet-path $(srcdir)/html4css1.css,$(srcdir)/manual.css \
		$(srcdir)/manual.rst $@
endif BUILD_RST
