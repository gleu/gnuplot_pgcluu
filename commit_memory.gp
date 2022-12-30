# load common config
load 'common.gp'

# specific config
set timefmt epochfmt

# graph 1
set title 'Commit Memory'
set output 'gnuplot_png/commit_memory.png'
plot 'pgcluu_csv/commit_memory.csv' using 1:2 title 'Commit Limit' with lines ls 101 \
   , ''                             using 1:3 title 'Commit AS'    with lines ls 102
