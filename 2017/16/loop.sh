start="abcdefghijklmnop"

function step() {
   echo "$1" | ./16
}

var=$start
prev=""
for i in `seq 1 1000000000`;
do
  var=$(step $var)
  if [ $var == $prev ]; then
    echo $var;
  fi
  prev=$var
done  
echo $var
