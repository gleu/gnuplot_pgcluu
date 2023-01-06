# load common config
load 'common.gp'

# specific config
set nokey
unset format y

# graph 1: transactions per seconds
set title 'Locks granted on '.db
set output png_filename_root.'.png'
plot csv_filename_root.'.csv' using 1:5 with lines ls 101
