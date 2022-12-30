# load common config
load 'common.gp'

# specific config
set yrange [0:]
set y2range [0:]

# graph 1: checkpointer, bgwriter, backends
set format y "%.0s %c"
set title 'Datafile writer processes'
set output 'gnuplot_png/pg_stat_bgwriter_processes.png'
cp2 = cp1 = bw1 = bw2 = be1 = be2 = 0
shift_cp(x) = (cp2 = cp1, cp1 = x)
shift_bw(x) = (bw2 = bw1, bw1 = x)
shift_be(x) = (be2 = be1, be1 = x)
plot 'pgcluu_csv/pg_stat_bgwriter.csv' using 1:(shift_cp($6), $0 < 1 ? 0 : cp1 - cp2) title 'checkpointer' with lines ls 101 \
     , '' using 1:(shift_bw($7), $0 < 1 ? 0 : bw1 - bw2) title 'writer process' with lines ls 102 \
     , '' using 1:(shift_be($9), $0 < 1 ? 0 : be1 - be2) title 'backends'       with lines ls 103

# graph 2: buffers_clean, maxwritten_clean
set title 'Background writer process'
set output 'gnuplot_png/pg_stat_bgwriter_writerprocess.png'
set ylabel 'Cleaned blocks'
set y2label 'Max written limit reached'
set ytics nomirror
set y2tics 
bw1 = bw2 = mw1 = mw2 = 0
shift_mw(x) = (mw2 = mw1, mw1 = x)
plot 'pgcluu_csv/pg_stat_bgwriter.csv' using 1:(shift_bw($7), $0 < 1 ? 0 : bw1 - bw2) title 'Cleaned blocks' with lines ls 101 \
   , '' using 1:(shift_mw($8), $0 < 1 ? 0 : mw1 - mw2) axes x1y2 title 'Max written limit reached' with lines ls 102

# graph 3: buffers_alloc
set title 'Allocated blocks'
set output 'gnuplot_png/pg_stat_bgwriter_buffersalloc.png'
set ylabel
set y2label
set noy2tics
set nokey
ba1 = ba2 = 0
shift_ba(x) = (ba2 = ba1, ba1 = x)
plot 'pgcluu_csv/pg_stat_bgwriter.csv' using 1:(shift_ba($11), $0 < 1 ? 0 : ba1 - ba2) with lines ls 101
