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

# Graph
set grid ls 100
set format x "%H:%M"
set format y "%.0s %co"
set xtics rotate
set nokey
set terminal pngcairo size 600,400 enhanced font 'Segoe UI,10'
set title 'Database '.db
set output 'gnuplot_png/pg_database_'.db.'_size.png'
plot 'gnuplot_csv/pg_database_'.db.'_size.csv' using 1:4 with lines ls 101
