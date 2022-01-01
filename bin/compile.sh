device=fenix6xpro
input_file=monkey.jungle
output_file=dist/digital_minimalism_watch_face.prg
developer_key=/users/alex/repositories/garmin/developer_key.der

monkeyc -d $device -f $input_file -o $output_file -y $developer_key
