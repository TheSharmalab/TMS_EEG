#!/bin/bash

ROOT="/omega/"

# loop subject
for k in $(seq -f "%03g" 1 15) ; do
	# loop session
	for j in S1 S2 ;do
		# loop block
		for REM in rfdi_pre	rfdi_post  lfdi	; do
		# removes and replaces line 6
		sed -i '' '6s/.*/DataFile=HV'${k}'_'${j}'_'${REM}'.eeg/' $ROOT/HV${k}_S2_${REM}.vhdr
		# removes and replaces line 7
		sed -i '' '7s/.*/DataFile=HV'${k}'_'${j}'_'${REM}'.vmrk/' $ROOT/HV${k}_S2_${REM}.vhdr
		# removes and replaces line 5
		sed -i '' '5s/.*/DataFile=HV'${k}'_'${j}'_'${REM}'.eeg/' $ROOT/HV${k}_S2_${REM}.vmrk
		done
	done 
done


