#!/bin/sh

set -e # quit on first error
set -x # print commands

case "x$1" in
	x)
		echo "Generating build system..."
		echo "(If this fails, you can just run autoreconf with your favorite flags instead)"
		mkdir -p m4
		mkdir -p build-aux
		cp -f /usr/share/gettext/config.rpath build-aux || \
		cp -f /usr/local/share/gettext/config.rpath build-aux || \
		cp -f /opt/local/share/gettext/config.rpath build-aux || \
		cp -f /opt/sw/share/gettext/config.rpath build-aux || true
		if autoreconf --force --install --verbose $*; then
			echo "Build system has been generated."
		else
            echo "$0: build system not generated, see above" >&2
		fi;;

	xhelp)
		echo "Usage: $0 [ACTION]"
		echo ""
		echo "Generates Autotools build system."
		echo ""
		echo "Actions:"
		echo "  help   print this help message"
		echo "  clean  remove generated files"
		echo ""
		echo "If no actions are specified it will generate the build system."
		echo ""
		echo "Report bugs at: <http://www.secretmaryo.org/phpBB3>";;

	xclean)
		if [ -f Makefile ]; then
			echo "Trying 'make maintainer-clean...'"
			if ! make maintainer-clean
				then echo "WARNING: 'make maintainer-clean' failed, continuing anyway..."
			fi
		fi
		echo "Removing various generated files..."
		rm -rf *~ aclocal.m4 config.h.in config.guess config.sub config.rpath configure depcomp install-sh autoscan.log autom4te.cache/ build-aux/ m4/
		echo "Removing 'Makefile.in's recursively..."
		MYFIND=find
		if test -n "`which gfind`" && test -x "`which gfind`"; then
			MYFIND=gfind
		fi
		for file in `${MYFIND} -name Makefile.in`; do
			rm -f $file
		done
		echo "Generated files removed.";;

	*)
		echo "$0: Unrecognized option $1." >&2
		echo "Try '$0 help'.";;
esac
