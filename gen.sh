# usage: gen.sh [day number]
if [ -z "$1" ];then
    echo "please specify day number"
    exit 1
fi

touch input$1.txt
cp template.rb $1.rb
