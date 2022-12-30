# pgcluu CSV separator
set datafile sep ';'

# pgcluu time format
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set yrange [0:]

# Style
set style line 100 lt 1 lc rgb "grey" lw 0.5
set style line 101 lw 2 lt rgb "#77bc65"
set style line 102 lw 2 lt rgb "#ff972f"
set style line 103 lw 2 lt rgb "#a1467e"
set style line 104 lw 2 lt rgb "#e16173"

# Graph 1: par statut
set grid ls 100
set format x "%H:%M"
set xtics rotate
set key outside center bottom horizontal
set terminal pngcairo size 600,400 enhanced font 'Segoe UI,10'
set title 'Connections per status for '.db
set output 'gnuplot_png/'.db.'/pg_stat_connections_perstatus.png'
plot 'gnuplot_csv/pg_stat_connections_'.db.'.csv' using 1:3 title 'Active' with lines ls 101 \
   , '' using 1:4 title 'Waiting for a lock' with lines ls 102 \
   , '' using 1:($2-$3-$4-$5) title 'Idle' with lines ls 103 \
   , '' using 1:5 title 'Idle in transaction' with lines ls 104

# Graph 2: total
set nokey
set title 'Total connections for '.db
set output 'gnuplot_png/'.db.'/pg_stat_connections_total.png'
plot 'gnuplot_csv/pg_stat_connections_'.db.'.csv' using 1:2 with lines ls 101
