# load common config
load 'common.gp'

# specific config
set yrange [0:]
unset format y

# graph 1
set title 'Archiver'
set output png_filename_root.'.png'
plot csv_filename_root.'.csv' using 1:2 title 'Success' with lines ls 101 \
   , ''                       using 1:5 title 'Failure' with lines ls 102
