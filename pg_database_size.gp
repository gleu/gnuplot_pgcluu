# load common config
load 'common.gp'

# specific config
set key autotitle columnhead

# graph 1
set title 'database size'
set output png_filename_root.'.png'
plot for [j=2:(nb+1)] csv_filename_root.'.csv' using 1:j with lines
