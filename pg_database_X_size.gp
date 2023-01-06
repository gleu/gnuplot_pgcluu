# load common config
load 'common.gp'

# specific config
set yrange [0:]
set nokey

# graph 1
set title 'Database '.db
set output png_filename_root.'.png'
plot csv_filename_root.'.csv' using 1:4 with lines ls 101
