! /bin/bash                                                                                                                                  

time=$(date +"%a %B %e %T %Z %Y")
echo "Tests run on " $time

dir1=test/infiles/
dir2=test/expOut/

#function to test the differences between files with same names from infiles & expOut                                                         
function test(){
if [[ -d "$dir1" && -d "$dir2" ]]; then
    for file in $dir1*
    do
        for file2 in $dir2*
        do
            if [ ${file##*/} == ${file2##*/} ];then
                #limit cpu seconds for diff command and limit characters output                                                               
                ulimit -t 10; ./driverx < ${file} | diff -w ${file2} - >/dev/null
                if [ $? -eq 1 ]; then
                    echo "${file##*/}: Failed"
                else
                    echo "${file##*/}: Passed"
                fi
            fi
        done
    done
fi
}

#main portion of the program                                                                                                                  
for file in $dir1*
do
    output="$(./driverx < ${file} 2>&1)"
    retv=$?
    #if the returned value is not 0 then the program crashed or doesnt exist
    if [ $retv -ne 0 ];then
	echo "There seems to be a problem with the program"
	break
    else
	#if it returns zero call the function to test
	#if not dont call the function at all
	test
	break
    fi
done
