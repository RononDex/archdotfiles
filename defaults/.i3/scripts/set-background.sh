#!/usr/bin/env bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} | shuf -n 1) # ten random files
echo $backgroundImage
wal -i $backgroundImage --saturate 0.6
