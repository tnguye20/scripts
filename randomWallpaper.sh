#!/bin/bash

wallpaper_path=~/.dotfiles/.wallpaper/

images=`ls -l $wallpaper_path | sed '1d' | awk '{ print $9 } '`
count=`echo "$images" | wc -l`
random=`shuf -i 0-$count -n 1`p

image_name=`echo "$images" | sed -n $random`
wal -i $wallpaper_path$image_name
