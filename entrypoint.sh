#!/usr/bin/env ash

ARGS=$@

showCows(){
    for cow in $(/bin/ls /usr/local/share/cows | grep -v ''.pm | sed 's/\.cow//g' );do
        /usr/local/bin/cowsay -f $cow "Hello my name is $cow"
    done

}

if [ "$ARGS" == "list" ];then
    showCows
    sleep 0.5
    exit 0
fi

/usr/local/bin/cowsay $@
