#!/bin/sh

ef=.env
edf=""
input="1"


ClearData(){
    [ -e .env1 ] && rm .env1
    [ -e .env2 ] && rm .env2
    [ -e .env1d ] && rm .env1d
    [ -e .env2d ] && rm .env2d
    [ -e .env1v ] && rm .env1v
    [ -e .env2v ] && rm .env2v
}

ClearData

if [[ $1 == '--review' ]]
then
    ef=.env.review
    echo "=================================================================================="
    echo -e "Enter number for compare .env.review file to" 
    echo -e "(1) .env-demo (2) .env.staging"
    read -p  "Please enter your choice : " input
    echo "=================================================================================="
    echo "=================================================================================="
else
    echo "=================================================================================="
    echo -e "Enter number for compare .env file to" 
    echo -e "(1) .env-demo (2) .env.prod"
    read -p  "Please enter your choice : " input
    echo "=================================================================================="
    echo "=================================================================================="
fi

if [[ $input > 0 && $input < 3 ]] && [[ $input == [0-2] ]] 
then
    :
else
    echo "Invalid input"
    echo "=================================================================================="
    exit 0
fi

if [[ $1 == '--review' ]]
then 
    if [[ ! -f .env.review ]]; then  
        echo ".env.review file not found"
        exit 0    
    fi  
fi


if [[ $input == "1" ]]
then 
    edf=.env-demo
    if [[ ! -f $edf ]]; then  
        echo "$edf file not found"
        exit 0    
    fi  
fi

if [[ $input == "2" ]]
then 
    if [[ $1 == '--review' ]]
    then 
        edf=.env.staging
    else
        edf=.env.prod
    fi
    if [[ ! -f $edf ]]; then          
        echo "$edf file not found"
        exit 0    
    fi  
fi

grep -v "^#" $ef | while read LINE
do
  a=${LINE//[[:space:]]/}
  echo "${a%=*}" >> .env1
  echo $a >> .env1v
  sort -o .env1v .env1v
done

grep -v "^#" $edf | while read LINE
do
  a=${LINE//[[:space:]]/}
  echo "${a%=*}" >> .env2
  echo $a >> .env2v
  sort -o .env2v .env2v
done


sort -o .env1 .env1
sort -o .env2 .env2


if [ "$(uname)" == "Darwin" ]; then
    sed -i '' "/^$/d" .env1
    sed -i '' "/^$/d" .env2
    sed -i '' "/^$/d" .env1v
    sed -i '' "/^$/d" .env2v       
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sed -i '/^$/d' .env1
    sed -i '/^$/d' .env2
    sed -i '/^$/d' .env1v
    sed -i '/^$/d' .env2v
fi

sort .env1 | uniq -d > .env1d
sort .env2 | uniq -d > .env2d

if [ "$(uname)" == "Darwin" ]; then
    aa=`wc -l < .env1d`
    bb=`wc -l < .env2d`
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    aa=`wc --lines < .env1d`
    bb=`wc --lines < .env2d`
fi

if [ $aa != 0 ]
then
    string="value is"
    echo  -e "The $ef file contains duplicate values"
    if [ $aa == 1 ]
    then
        string="value is"
    else
        string="values are"
    fi
    echo -e "The duplicate $string \n"
    sort .env1 | uniq -d
    echo "=================================================================================="
    ClearData
    exit 0
fi

if [ $bb != 0 ]
then
    string="value is"
    echo  -e "The $edf file contains duplicate values"
    if [ $bb == 1 ]
    then
        string="value is"
    else
        string="values are"
    fi
    echo -e "The duplicate $string \n"
    sort .env2 | uniq -d
    echo "=================================================================================="
    ClearData
    exit 0
fi


if cmp -s ".env1" ".env2"
then
    :
else
   echo -e "Warning!⛔, Your $ef file is not matched with $edf file"
   echo -e "The following parameters are not matched\n"
   cat .env2 .env1 | sort | uniq --unique 
   echo "=================================================================================="
    ClearData
   exit 0
fi


if cmp -s ".env1v" ".env2v"
then
   echo  -e "Congratulations🎉, Your $ef file is matched with $edf file"
   echo "=================================================================================="
    ClearData
   exit 0
else
   echo -e "Warning!⛔, Your $ef file is not matched with $edf file"
   echo -e "The following values are not matched\n"
   cat .env2v .env1v | sort | uniq --unique 
   echo "=================================================================================="
fi

ClearData

exit 0

