route="http://obsevabilityindeep.local/trace"

while true; do
    curl -X GET "$route" > /dev/null  
    echo "Requisição enviada para: $route"
    sleep 1  
done
