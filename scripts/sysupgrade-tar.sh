#!/bin/sh

board=""
alt_boards=""
kernel=""
rootfs=""
outfile=""
err=""

do_exit() {
	[ -d "$tmpdir" ] && rm -rf "$tmpdir"
	exit $err
}

while [ "$1" ]; do
	case "$1" in
	"--board")
		board="$2"
		shift
		shift
		continue
		;;
	"--alt-boards")
		alt_boards="$2"
		shift
		shift
		continue
		;;
	"--kernel")
		kernel="$2"
		shift
		shift
		continue
		;;
	"--rootfs")
		rootfs="$2"
		shift
		shift
		continue
		;;
	*)
		if [ ! "$outfile" ]; then
			outfile=$1
			shift
			continue
		fi
		;;
	esac
done

if [ ! -n "$board" -o ! -r "$kernel" -a  ! -r "$rootfs" -o ! "$outfile" ]; then
	echo 'syntax: $0 [--board boardname] [--alt-boards "alt board list"] [--kernel kernelimage] [--rootfs rootfs] out'
	exit 1
fi

tmpdir="$( mktemp -d 2> /dev/null )"
if [ -z "$tmpdir" ]; then
	# try OSX signature
	tmpdir="$( mktemp -t 'ubitmp' -d )"
fi

if [ -z "$tmpdir" ]; then
	exit 1
fi

mkdir -p "${tmpdir}/sysupgrade-${board}"

echo "BOARD=${board}" > "${tmpdir}/sysupgrade-${board}/CONTROL"
[ -z "${rootfs}" ] || cp "${rootfs}" "${tmpdir}/sysupgrade-${board}/root"
[ -z "${kernel}" ] || cp "${kernel}" "${tmpdir}/sysupgrade-${board}/kernel"

# "Legacy" nand_upgrade_tar() finds asset directory with
# $(tar tf $tar_file | grep -m 1 '^sysupgrade-.*/$')
# and doesn't use CONTROL at all; add the "real" files first

tar_args="--directory ${tmpdir} --sort=name --owner=0 --group=0 --numeric-owner \
	 -vf ${tmpdir}/sysupgrade.tar"
if [ -n "$SOURCE_DATE_EPOCH" ]; then
	tar_args="${tar_args} --mtime=@${SOURCE_DATE_EPOCH}"
fi

tar -c $tar_args $(ls -A "${tmpdir}")
err="$?"
[ "$err" != 0 ] && do_exit

for ab in $alt_boards ; do
	[ "$ab" = "$board" ] && continue
	mkdir "${tmpdir}/sysupgrade-${ab}/"
	cp -vp "${tmpdir}/sysupgrade-${board}/CONTROL" "${tmpdir}/sysupgrade-${ab}/"
	tar -r $tar_args "sysupgrade-${ab}/CONTROL"
	err="$?"
	[ "$err" != 0 ] && do_exit
done

if [ -e "$tmpdir/sysupgrade.tar" ]; then
	cp "$tmpdir/sysupgrade.tar" "$outfile"
else
	err=2
fi

do_exit
