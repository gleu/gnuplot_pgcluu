# load common config
load 'common.gp'

# specific config
set yrange [0:]
unset format y

# graph 1
set title 'Archiver'
set output 'gnuplot_png/pg_stat_archiver.png'
plot 'pgcluu_csv/pg_stat_archiver.csv' using 1:2 title 'Success' with lines ls 101 \
   , ''                                using 1:5 title 'Failure' with lines ls 102
