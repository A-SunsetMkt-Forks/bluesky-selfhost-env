#!/usr/bin/bash

echo "DOMAIN: ${DOMAIN}"
echo "rDir:   ${rDir}"

pushd ${rDir}/feed-generator

# starts patch >>>>>>>>>>

# starts: regarding self-hosting consideraction. >>>>
d=.
if [ -n "`grep -R '://bsky.social' ${d}`" ];then
	for f in `grep -R 'bsky.social' ${d} |cut -d : -f 1`; do sed -i "s/bsky.social/${DOMAIN}/g" $f; done
	echo "bsky.social => ${DOMAIN}"
fi

f=./src/server.ts
if [ -f $f ] && [ -n "`grep -R 'plc.directory' $f`" ];then
	sed -i "s#plc.directory#plc.${DOMAIN}#g" $f
	echo "plc.directory => plc.${DOMAIN}  for $f"
fi

# ends: regarding self-hosting consideraction. <<<<
# starts: NOT for self-hosting but easy operation for any cases; then, should move to patching/1XXX-*.sh >>>

f=./scripts/publishFeedGen.ts
if [ -f $f ] && [ -n "`grep -R 'const handle =' $f`" ];then
	sed -i "s#const handle = ''#const handle = process.env.FEEDGEN_PUBLISHER_HANDLE ?? ''#g" $f
	echo "handle  <empty> => process.env.FEEDGEN_PUBLISHER_HANDLE for $f"
fi
if [ -f $f ] && [ -n "`grep -R 'const password =' $f`" ];then
	sed -i "s#const password = ''#const password = process.env.FEEDGEN_PUBLISHER_PASSWORD ?? ''#g" $f
	echo "password  <empty> => process.env.FEEDGEN_PUBLISHER_PASSWORD  for $f"
fi

# ends: NOT for self-hosting but easy operation for any cases; then, should move to patching/1XXX-*.sh <<<


popd

# ends patch <<<<<<<<<<