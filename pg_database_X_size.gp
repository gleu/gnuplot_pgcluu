# load common config
load 'common.gp'

# specific config
set yrange [0:]
set nokey

# graph 1
set title 'Database '.db
set output 'gnuplot_png/'.db.'/pg_database_size.png'
plot 'gnuplot_csv/pg_database_'.db.'_size.csv' using 1:4 with lines ls 101
