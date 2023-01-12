# load common config
load 'common.gp'

# specific config
set timefmt epochfmt

# graph 1
set title 'Commit Memory'
set output png_filename_root.'.png'
plot csv_filename_root.'.csv' using 1:(1024*$2) title 'Commit Limit' with lines ls 101 \
   , ''                       using 1:(1024*$3) title 'Commit AS'    with lines ls 102
