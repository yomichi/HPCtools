#!/bin/sh

## SekireiTools (https://github.com/yomichi/SekireiTools)
## Copyright (c) Yuichi Motoyama <yomichi@tsg.jp>
## Distributed under the Boost Software License Version 1.0.

# ref: リッチ・ミカン「Shell Script ライトクックブック」 まつらリッチ研究所 (2014)
#      http://richlab.org/coterie/ssr2.html

WORK="`echo $HOME | sed 's/home/work/'`"

UTCONV="$(dirname $(readlink -f $0))/utconv"

rm -f 7d_ago.tmp

now=$(date '+%Y%m%d%H%M%S')
seven_days_ago=$(echo $now |
                 $UTCONV |
                 awk '{print $0 - 3600 * 24 * 7 }' |
                 $UTCONV -r |
                 sed 's/..$/.&/'
                 )
touch -t $seven_days_ago 7d_ago.tmp

find $WORK \( \! -newer 7d_ago.tmp \) | xargs touch -m -h

rm -f 7d_ago.tmp
