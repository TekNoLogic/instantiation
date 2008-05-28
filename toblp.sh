#! /bin/bash

for file in `ls *.png`
do
	./BLPConverter.exe $file
done

exit 0
