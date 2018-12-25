#!/bin/sh

# 要修改的@邮箱地址.com
needChangeEmail=$1
# 想要改成的邮箱
changeEmail=$2
# 想要改成的用户名
changeUser=$3

if [ -z $needChangeEmail ]
then
    echo "gitc.sh needChangeEmail changeEmail changeUser"
    exit 1
fi

git filter-branch -f --env-filter '
an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"
if [ "$GIT_COMMITTER_EMAIL" = "'$needChangeEmail'" ]
then
    cn="'$changeUser'"
    cm="'$changeEmail'"
fi
if [ "$GIT_AUTHOR_EMAIL" = '"$needChangeEmail"' ]
then
    an="'$changeUser'"
    am="'$changeEmail'"
fi
    export GIT_AUTHOR_NAME="$an"
    export GIT_AUTHOR_EMAIL="$am"
    export GIT_COMMITTER_NAME="$cn"
    export GIT_COMMITTER_EMAIL="$cm"
'

