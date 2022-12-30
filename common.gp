##### Common configuration

# pgcluu CSV separator
set datafile sep ';'

# pgcluu time format
epochfmt = "%s"
isofmt = "%Y-%m-%d %H:%M:%S"
set xdata time
set timefmt isofmt

# style
set style line 100 lt 1 lc rgb "grey" lw 0.5
set style line 101 lw 2 lt rgb "#77bc65"
set style line 102 lw 2 lt rgb "#ff972f"
set style line 103 lw 2 lt rgb "#a1467e"
set style line 104 lw 2 lt rgb "#e16173"

# graph
set grid ls 100
set format x "%H:%M"
set format y "%.0s %co"
set xtics rotate
set key outside center bottom horizontal
set terminal pngcairo size 600,400 enhanced font 'Segoe UI,10'
