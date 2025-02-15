# Tempo
is a repository to learn tempo and trancing

# Install

 ```bash
chmod +x ./scripts/*.sh
make install
```


### utilits commands
- Post foward para acessar o grafana
 ```bash
kubectl port-forward {grafana pod}  3000:3000
```

- Pegando secret da senha de acesso admin do grafana
```bash
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
