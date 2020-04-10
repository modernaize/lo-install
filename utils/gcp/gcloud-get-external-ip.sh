# myServiceLB=ingress-nginx-ingress-controller 
while true; do                                                                     
    successCond="$(kubectl get svc ingress-nginx-ingress-controller --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")"        
    if [[ -z "$successCond" ]]; then                                               
        echo "Waiting for endpoint readiness..."                                   
        sleep 10                                                                   
    else                                                                           
        sleep 2                                                                    
        export lbIngAdd="$successCond"                                             
        echo ""
        echo  "    The LoadBalancer is up on external IP : $successCond "
        echo ""                                                                    
        break                                                                      
    fi                                                                             
done