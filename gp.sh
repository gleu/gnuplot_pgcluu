#!/bin/sh

Help()
{
   # Display Help
   echo "Syntax: $0 [-i|w|o|v|h]"
   echo "Description: This project aims to build better graphics with the CSV files from pgcluu."
   echo "Options:"
   echo "i     Input: path to pgcluu's csv file directory (default: ${PCDIR}, env. var.: PCDIR)."
   echo "w     Path for the work directory for csv file (default: ${GPDIR}, env. var.: GPDIR)."
   echo "o     Output: path to gnuplot's png file directory (default: ${PNGDIR}, env. var.: PNGDIR)."
   echo "v     Verbose mode."
   echo "h     Print this Help."
   echo
   echo "https://github.com/gleu/gnuplot_pgcluu"
}

msg_verbose() {
  test -n "$VERBOSE" && echo "$*"
}

msg_error() {
  echo "ERROR: $*"
}


# get values from env or set default
test -z "$PCDIR" && PCDIR="pgcluu_csv"
test -z "$GPDIR" && GPDIR="gnuplot_csv"
test -z "$PNGDIR" && PNGDIR="gnuplot_png"

# fetch option values
while getopts "i:w:o:hv" option; do
   case $option in
      i) # source csv
         PCDIR=$OPTARG;;
      w) # gnuplot csv
         GPDIR=$OPTARG;;
      o) # gnuplot png
         PNGDIR=$OPTARG;;
      v) # verbose
         VERBOSE=1;;
      h) # display Help
         Help
         exit;;
      *)
         Help
         exit;;
   esac
done

test -d "$GPDIR" || mkdir -p "$GPDIR"
test -d "$PNGDIR" || mkdir -p "$PNGDIR"

msg_verbose "Script directories:"
msg_verbose "* Input directory for pgcluu's csv: $PCDIR"
msg_verbose "* Work direcotry for gluplots's csv: $GPDIR"
msg_verbose "* Output directory for gnuplot's png: $PNGDIR"
msg_verbose

# ---------- Commit Memory
echo "Building commit memory graph"
cp $PCDIR/commit_memory.csv $GPDIR
gnuplot -e "csv_filename_root='$GPDIR/commit_memory'" \
        -e "png_filename_root='$PNGDIR/commit_memory'" \
        commit_memory.gp

# ---------- Database size (all)
echo "Building database size graph (all)"
NB=$(awk -F ";" '{ x[$3] = 1 } END { print length(x) }' $PCDIR/pg_database_size.csv)
awk -F ";" '
    {
      pivot[$1][$3]=$4;
      db[$3]=1;
    }
END {
      # print header
      line="date";
      for (y in db)
      {
           line=line";"y;
      }
      print line;

      # print items
      for (x in pivot)
      {
        line=x;
        for (y in db)
        {
           line=line";"pivot[x][y];
        }
        print line;
      }
    }
' $PCDIR/pg_database_size.csv > $GPDIR/pg_database_size.csv
gnuplot -e "csv_filename_root='$GPDIR/pg_database_size'" \
        -e "png_filename_root='$PNGDIR/pg_database_size'" \
        -e "nb=$NB" \
        pg_database_size.gp

# ---------- Database size (each)
echo "Building database size graph (each)"
awk -F";" '{ print $3 }' $PCDIR/pg_database_size.csv | sort -u | while read db
do
  msg_verbose "= Building database size graph for $db"
  test -d $PNGDIR/$db || mkdir -p $PNGDIR/$db
  grep $db $PCDIR/pg_database_size.csv > $GPDIR/pg_database_${db}_size.csv
  gnuplot -e "csv_filename_root='$GPDIR/pg_database_${db}_size'" \
          -e "png_filename_root='$PNGDIR/${db}/pg_database_size'" \
          -e "db='$db'" pg_database_X_size.gp
done

# ---------- Archiver
echo "Building archiver graph"
cp $PCDIR/pg_stat_archiver.csv $GPDIR
gnuplot -e "csv_filename_root='$GPDIR/pg_stat_archiver'" \
        -e "png_filename_root='$PNGDIR/pg_stat_archiver'" \
        pg_stat_archiver.gp

# ---------- Writer processes
echo "Building writer processes graph"
cp $PCDIR/pg_stat_bgwriter.csv $GPDIR
gnuplot -e "csv_filename_root='$GPDIR/pg_stat_bgwriter'" \
        -e "png_filename_root='$PNGDIR/pg_stat_bgwriter'" \
        pg_stat_bgwriter.gp

# ---------- Connections
echo "Building connections graph"
awk -F";" '{ print $6 }' $PCDIR/pg_stat_connections.csv | sort -u | while read db
do
  msg_verbose "= Building connections graph for $db"
  test -d $PNGDIR/$db || mkdir -p $PNGDIR/$db
  grep $db $PCDIR/pg_stat_connections.csv > $GPDIR/pg_stat_connections_${db}.csv
  gnuplot -e "csv_filename_root='$GPDIR/pg_stat_connections_${db}'" \
          -e "png_filename_root='$PNGDIR/${db}/pg_stat_connections'" \
          -e "db='$db'" \
          pg_stat_connections_X.gp
done

# ---------- Database stats
echo "Building database stats graph"
awk -F";" '{ print $3 }' $PCDIR/pg_stat_database.csv | sort -u | while read db
do
  msg_verbose "= Building database stats graph for $db"
  test -d $PNGDIR/$db || mkdir -p $PNGDIR/$db
  grep $db $PCDIR/pg_stat_database.csv > $GPDIR/pg_stat_database_${db}.csv
  gnuplot -e "csv_filename_root='$GPDIR/pg_stat_database_${db}'" \
          -e "png_filename_root='$PNGDIR/${db}/pg_stat_database'" \
          -e "db='$db'" pg_stat_database_X.gp
done

# ---------- Locks stats
echo "Building locks stats graph"
awk -F";" '{ print $2 }' $PCDIR/pg_stat_locks.csv | sort -u | while read db
do
  msg_verbose "= Building locks stats graph for $db"
  test -d $PNGDIR/$db || mkdir -p $PNGDIR/$db
  grep "$db;lock_granted;" $PCDIR/pg_stat_locks.csv > $GPDIR/pg_stat_locks_${db}.csv
  gnuplot -e "csv_filename_root='$GPDIR/pg_stat_locks_${db}'" \
          -e "png_filename_root='$PNGDIR/${db}/pg_stat_locks'" \
          -e "db='$db'" pg_stat_locks_X.gp
done

# ---------- XLOG stats
echo "Building xlog graph"
cp $PCDIR/pg_xlog_stat.csv $GPDIR
gnuplot -e "csv_filename_root='$GPDIR/pg_xlog_stat'" \
        -e "png_filename_root='$PNGDIR/pg_xlog_stat'" \
        pg_xlog_stat.gp

# ---------- Tablespace size
echo "Building tablespace size graph"
NB=$(awk -F ";" '{ x[$2] = 1 } END { print length(x) }' $PCDIR/pg_tablespace_size.csv)
awk -F ";" '
    {
      pivot[$1][$2]=$3;
      tbs[$2]=1;
    }
END {
      # print header
      line="date";
      for (y in tbs)
      {
           line=line";"y;
      }
      print line;

      # print items
      for (x in pivot)
      {
        line=x;
        for (y in tbs)
        {
           line=line";"pivot[x][y];
        }
        print line;
      }
    }
' $PCDIR/pg_tablespace_size.csv > $GPDIR/pg_tablespace_size.csv
gnuplot -e "csv_filename_root='$GPDIR/pg_tablespace_size'" \
        -e "png_filename_root='$PNGDIR/pg_tablespace_size'" \
        -e "nb=$NB" \
        pg_tablespace_size.gp
