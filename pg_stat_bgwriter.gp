# load common config
load 'common.gp'

# specific config
set yrange [0:]
set y2range [0:]

# graph 1: checkpointer, bgwriter, backends
set format y "%.0s %c"
set title 'Datafile writer processes'
set output png_filename_root.'_processes.png'
plot csv_filename_root.'.csv' using 1:(eval_a($6)) title 'checkpointer'   with lines ls 101 \
   , ''                       using 1:(eval_b($7)) title 'writer process' with lines ls 102 \
   , ''                       using 1:(eval_c($9)) title 'backends'       with lines ls 103

# graph 2: buffers_alloc
set nokey
set title 'Allocated blocks'
set output png_filename_root.'_buffersalloc.png'
plot csv_filename_root.'.csv' using 1:(eval_c($11)) with lines ls 101

# graph 3: buffers_clean, maxwritten_clean
set key outside center bottom horizontal
set title 'Background writer process'
set output png_filename_root.'_writerprocess.png'
set ylabel 'Cleaned blocks'
set y2label 'Max written limit reached'
set ytics nomirror
set y2tics 
a1 = a2 = b1 = b2 = 0
plot csv_filename_root.'.csv' using 1:(eval_a($7)) axes x1y1 title 'Cleaned blocks'            with lines ls 101 \
   , ''                       using 1:(eval_b($8)) axes x1y2 title 'Max written limit reached' with lines ls 102
