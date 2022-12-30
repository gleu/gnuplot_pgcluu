# load common config
load 'common.gp'

# graph 1: transactions per seconds
set nokey
set format y "%.0s %c"
set title 'Transactions per seconds on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_xactpersec.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' using 1:(evalsec_a($5+$6)) with lines ls 101

# graph 2: written tuples
set key outside center bottom horizontal
set title 'Tuples on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_tuples.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' using 1:(eval_b($11)) title "Inserted" with lines ls 101 \
   , ''                                        using 1:(eval_c($12)) title "Updated"  with lines ls 102 \
   , ''                                        using 1:(eval_d($13)) title "Deleted"  with lines ls 103

# graph 3: conflicts
set nokey
unset format y
set title 'Conflicts on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_conflicts.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' using 1:(eval_e($14)) with lines ls 101

# reinit variables
a1 = a2 = b1 = b2 = c1 = c2 = d1 = d2 = e1 = e2 = 0

# graph 4: deadlocks
set nokey
set title 'Deadlocks on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_deadlocks.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' using 1:(eval_a($18)) with lines ls 101

# graph 5: read/write time
set key outside center bottom horizontal
set title 'I/O duration on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_ioduration.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' using 1:(eval_b($19)) title "Reads"  with lines ls 101 \
   , ''                                        using 1:(eval_c($20)) title "Writes" with lines ls 102

# specific config with y2
set key outside center bottom horizontal
set ytics nomirror
set y2tics

# reinit variables
a1 = a2 = b1 = b2 = c1 = c2 = d1 = d2 = e1 = e2 = 0

# graph 5: blocks read and hit
set ylabel "Blocks"
set y2label "Ratio"
set format y "%.0s %c"
set format y2 '%g %%'
set y2range [0:]
set title 'Block reads/hits and ratio on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_hitread.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(eval_a($7)) title 'Blocks read' with lines ls 101 \
  , '' using 1:(eval_b($8)) title 'Blocks hit' with lines ls 102 \
  , '' using 1:($0 < 1 ? NaN : (b1 - b2) * 100. / ((b1+a1) - (b2+a2))) title 'Hit ratio' axes x1y2 with lines ls 103

# graph 6: temp files/bytes
set ylabel "Files"
set y2label "Bytes"
unset format y
set format y2 "%.0s %co"
set title 'Temporary files on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_tempfiles.png'
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' using 1:(eval_c($16)) title 'Temp files' axes x1y1 with lines ls 101 \
   , ''                                        using 1:(eval_d($17)) title 'Temp bytes' axes x1y2 with lines ls 102
