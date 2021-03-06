#/bin/bash
set -e

ENVPATH=$1
ADDRESS=$2
PORT=$3
PARAMNR=$4
ENVNAME=`basename $ENVPATH`
RANDOM=$PARAMNR

export LFC_HOME=XXLFCHOMEXX
export LFC_HOST=lfc.grid.sara.nl

#Wait a random time to not overload the server after submission of a number of jobs.
WAIT=$[ ($RANDOM % 300) ]
echo "Waiting for $WAIT seconds..."
sleep $WAIT
echo "Waiting period over for $PARAMNR, starting bootstrap."

if [ -n "$TMPDIR" ]
then
    echo "Scratch directory is $TMPDIR"
else
    TMPDIR=`pwd`
    echo "Set scratch directory to $TMPDIR"
fi

echo "Running ulimit"
ulimit;


#load environment
chmod 744 ./gcp
./gcp $ENVPATH $TMPDIR
cp ipcontroller-engine.json $TMPDIR
cd $TMPDIR
tar -xzf $ENVNAME
CURDIR=`pwd`

cd sys_enhance
cat _paths | sed s#ONAME#$CURDIR#g > paths
echo "Where is bash?"
which bash
echo "File created?"
ls -lh ./paths
. ./paths
echo "Environment loaded for $PARAMNR, starting work."

#run job
cd work
./ipengine_chief -a $ADDRESS -p $PORT -l -t GRID

#cleaning
echo "Work for $PARAMNR finished, cleaning up..."
cd /
rm -rf $CURDIR/sys_enhance
echo "Done"

