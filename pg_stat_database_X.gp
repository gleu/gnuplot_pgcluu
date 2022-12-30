# load common config
load 'common.gp'

# graph 1: transactions per seconds
set nokey
set title 'Transactions per seconds on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_xactpersec.png'
total1 = total2 = 0
shift_total(x) = (total2 = total1, total1 = x)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_total($5+$6), $0 < 1 ? NaN : (total1 - total2) / 60) with lines ls 101

# graph 2: written tuples
set key outside center bottom horizontal
set title 'Tuples on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_tuples.png'
ins1 = ins2 = upd1 = upd2 = del1 = del2 = 0
shift_ins(x) = (ins2 = ins1, ins1 = x)
shift_upd(x) = (upd2 = upd1, upd1 = x)
shift_del(x) = (del2 = del1, del1 = x)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_ins($11), $0 < 1 ? NaN : ins1 - ins2) title "Inserted" with lines ls 101 \
  , '' using 1:(shift_upd($12), $0 < 1 ? NaN : ins1 - ins2) title "Updated" with lines ls 102 \
  , '' using 1:(shift_del($13), $0 < 1 ? NaN : ins1 - ins2) title "Deleted" with lines ls 103

# graph 3: conflicts
set nokey
set title 'Conflicts on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_conflicts.png'
c1 = c2 = 0
shift_c(x) = (c2 = c1, c1 = x)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_c($14), $0 < 1 ? NaN : c1 - c2) with lines ls 101

# graph 4: deadlocks
set nokey
set title 'Deadlocks on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_deadlocks.png'
d1 = d2 = 0
shift_d(x) = (d2 = d1, d1 = x)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_d($18), $0 < 1 ? NaN : d1 - d2) with lines ls 101

# graph 5: read/write time
set key outside center bottom horizontal
set title 'I/O duration on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_ioduration.png'
r1 = r2 = w1 = w2 = 0
shift_read(x) = (r2 = r1, r1 = x)
shift_write(x) = (w2 = w1, w1 = x)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_read($19), $0 < 1 ? NaN : r1 - r2) title "Reads" with lines ls 101 \
  , '' using 1:(shift_write($20), $0 < 1 ? NaN : w1 - w2) title "Writes" with lines ls 102

# specific config with y2
set key outside center bottom horizontal
set ytics nomirror
set y2tics

# graph 5: blocks read and hit
set ylabel "Blocks"
set y2label "Ratio"
set format y "%.0s %c"
set format y2 '%g %%'
set y2range [0:]
set title 'Block reads/hits and ratio on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_hitread.png'
r1 = r2 = h1 = h2 = 0
shift_r(r) = (r2 = r1, r1 = r)
shift_h(h) = (h2 = h1, h1 = h)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_r($7), $0 < 1 ? NaN : r1 - r2) title 'Blocks read' with lines ls 101 \
  , '' using 1:(shift_h($8), $0 < 1 ? NaN : h1 - h2) title 'Blocks hit' with lines ls 102 \
  , '' using 1:($0 < 1 ? NaN : (h1 - h2) * 100. / ((h1+r1) - (h2+r2))) title 'Hit ratio' axes x1y2 with lines ls 103

# graph 6: temp files/bytes
set ylabel "Files"
set y2label "Bytes"
unset format y
set format y2 "%.0s %co"
set title 'Temporary files on '.db
set output 'gnuplot_png/'.db.'/pg_stat_database_tempfiles.png'
tf1 = tf2 = tb1 = tb2 = 0
shift_tf(x) = (tf2 = tf1, tf1 = x)
shift_tb(x) = (tb2 = tb1, tb1 = x)
plot 'gnuplot_csv/pg_stat_database_'.db.'.csv' \
  using 1:(shift_tf($16), $0 < 1 ? NaN : tf1 - tf2) title 'Temp files' with lines ls 101 \
  , '' using 1:(shift_tb($17), $0 < 1 ? NaN : tb1 - tb2) title 'Temp bytes' axes x1y2 with lines ls 102
