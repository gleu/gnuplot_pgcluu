# load common config
load 'common.gp'

# specific config
set yrange [0:]
unset format y

# graph 1
set title 'Transaction files'
set output 'gnuplot_png/pg_xlog_stat.png'
plot 'pgcluu_csv/pg_xlog_stat.csv' using 1:2 title 'Total' with lines ls 101 \
   , ''                             using 1:4 title 'Recycled' with lines ls 102 \
   , ''                             using 1:5 title 'Written' with lines ls 103
