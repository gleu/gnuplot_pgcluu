# load common config
load 'common.gp'

# specific config
set key autotitle columnhead

# graph 1
set title 'tablespace size'
set output 'gnuplot_png/pg_tablespace_size.png'
plot for [j=2:(nb+1)] 'gnuplot_csv/pg_tablespace_size.csv' using 1:j with lines
