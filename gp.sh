#!/bin/sh

PCDIR=pgcluu_csv
GPDIR=gnuplot_csv
PNGDIR=gnuplot_png

test -d "$GPDIR" || mkdir -p "$GPDIR"
test -d "$PNGDIR" || mkdir -p "$PNGDIR"

# ---------- Commit Memory
cp $PCDIR/commit_memory.csv $GPDIR
gnuplot commit_memory.gp

# ---------- Database size
awk -F";" '{ print $3 }' $PCDIR/pg_database_size.csv | sort | uniq | while read db
do
  grep $db $PCDIR/pg_database_size.csv > $GPDIR/pg_database_${db}_size.csv
  gnuplot -e "db='$db'" pg_database_X_size.gp
done

# ---------- Archiver
cp $PCDIR/pg_stat_archiver.csv $GPDIR
gnuplot pg_stat_archiver.gp

# ---------- Archiver
cp $PCDIR/pg_stat_bgwriter.csv $GPDIR
gnuplot pg_stat_bgwriter.gp

# ---------- Connections
awk -F";" '{ print $6 }' $PCDIR/pg_stat_connections.csv | sort | uniq | while read db
do
  grep $db $PCDIR/pg_stat_connections.csv > $GPDIR/pg_stat_connections_${db}.csv
  gnuplot -e "db='$db'" pg_stat_connections_X.gp
done

