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

# various switch functions
# useful because of the cumulative nature of the PostgreSQL metrics
shift_a(x) = (a2 = a1, a1 = x)
shift_b(x) = (b2 = b1, b1 = x)
shift_c(x) = (c2 = c1, c1 = x)
shift_d(x) = (d2 = d1, d1 = x)
shift_e(x) = (e2 = e1, e1 = x)
eval_a(x) = ( shift_a(x), $0 < 1 ? NaN : a1 - a2)
eval_b(x) = ( shift_b(x), $0 < 1 ? NaN : b1 - b2)
eval_c(x) = ( shift_c(x), $0 < 1 ? NaN : c1 - c2)
eval_d(x) = ( shift_d(x), $0 < 1 ? NaN : d1 - d2)
eval_e(x) = ( shift_e(x), $0 < 1 ? NaN : e1 - e2)
evalsec_a(x) = ( shift_a(x), $0 < 1 ? NaN : (a1 - a2) / 60)
# initialize the functions' variables
a1 = a2 = b1 = b2 = c1 = c2 = d1 = d2 = e1 = e2 = 0
