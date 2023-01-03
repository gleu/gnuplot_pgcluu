# load common config
load 'common.gp'

# specific config
set nokey
unset format y

# graph 1: transactions per seconds
set title 'Locks granted on '.db
set output 'gnuplot_png/'.db.'/pg_stat_locks.png'
plot 'gnuplot_csv/pg_stat_locks_'.db.'.csv' using 1:5 with lines ls 101
