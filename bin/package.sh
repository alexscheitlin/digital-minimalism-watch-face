input_file=monkey.jungle
output_file=dist/digital_minimalism_watch_face.iq
developer_key=/users/alex/repositories/garmin/developer_key.der

monkeyc -e -o $output_file -w -f $input_file -y $developer_key
