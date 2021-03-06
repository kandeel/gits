#!/bin/bash
set -e
config="$HOME/.gits"

if [ ! -f $config ];
then
    echo "No gits config found ($config)."
    echo "Please enter the first pair username > "
    read username1
    echo "Please enter the first pair email > "
    read email1
    echo "Please enter the second pair username > "
    read username2
    echo "Please enter the second pair email > "
    read email2

    echo "$username1 $email1" > $config
    echo "$username2 $email2" >> $config

    echo "created config for: $username1 ($email1), $username2 ($email2)"
    exit 0
fi

r=$RANDOM
n=$(( r %= 2 ))

if [ $1 = "1" ];
then
    echo 'forcing author to first user'
    shift
fi

if [ $1 = "2" ];
then
    echo 'forcing author to second user'
    shift
fi

filecontent=( `cat "$config" `)
if [ $n -eq 1 ]
then
    export GIT_COMMITTER_NAME=${filecontent[0]}
    export GIT_COMMITTER_EMAIL=${filecontent[1]}
    export GIT_AUTHOR_NAME=${filecontent[2]}
    export GIT_AUTHOR_EMAIL=${filecontent[3]}
else
    export GIT_COMMITTER_NAME=${filecontent[2]}
    export GIT_COMMITTER_EMAIL=${filecontent[3]}
    export GIT_AUTHOR_NAME=${filecontent[0]}
    export GIT_AUTHOR_EMAIL=${filecontent[1]}
fi

git "$@"

echo "commit: $GIT_COMMITTER_NAME, author: $GIT_AUTHOR_NAME"
