#! /bin/bash

for file in `ls Images/*.png`
do
	./BLPConverter.exe $file
done

exit 0
