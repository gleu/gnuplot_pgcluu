#!/bin/sh

PCDIR=pgcluu_csv
GPDIR=gnuplot_csv
PNGDIR=gnuplot_png

test -d "$GPDIR" || mkdir -p "$GPDIR"
test -d "$PNGDIR" || mkdir -p "$PNGDIR"

# ---------- Commit Memory
echo "Building commit memory graph"
cp $PCDIR/commit_memory.csv $GPDIR
gnuplot commit_memory.gp

# ---------- Database size
echo "Building database size graph"
awk -F";" '{ print $3 }' $PCDIR/pg_database_size.csv | sort | uniq | while read db
do
  test -d $PNGDIR/$db || mkdir -p $PNGDIR/$db
  grep $db $PCDIR/pg_database_size.csv > $GPDIR/pg_database_${db}_size.csv
  gnuplot -e "db='$db'" pg_database_X_size.gp
done

# ---------- Archiver
echo "Building archiver graph"
cp $PCDIR/pg_stat_archiver.csv $GPDIR
gnuplot pg_stat_archiver.gp

# ---------- Writer processes
echo "Building writer processes graph"
cp $PCDIR/pg_stat_bgwriter.csv $GPDIR
gnuplot pg_stat_bgwriter.gp

# ---------- Connections
echo "Building connections graph"
awk -F";" '{ print $6 }' $PCDIR/pg_stat_connections.csv | sort | uniq | while read db
do
  test -d $PNGDIR/$db || mkdir -p $PNGDIR/$db
  grep $db $PCDIR/pg_stat_connections.csv > $GPDIR/pg_stat_connections_${db}.csv
  gnuplot -e "db='$db'" pg_stat_connections_X.gp
done

