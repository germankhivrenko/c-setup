> tests/tests.log

for i in tests/*.test
do
  if test -f $i
  then
    if $VALGRIND ./$i 2>> tests/tests.log
    then
      echo $i PASS
    else
      exit 1
    fi
  fi
done
