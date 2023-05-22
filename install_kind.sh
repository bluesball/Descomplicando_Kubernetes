#!/bin/bash

## Olá, copiei e colei trechos de código que já tinha aqui e editei porcamente... 
## Teste e altere pfv

# Função para exibir mensagem (podia ter usado echo, podia... mas eu tava aprendendo a fazer funcoes, tinha que gastar)
print_message() {
  echo "==> $1"
}

# Verifica se o Docker está instalado
if ! command -v docker &> /dev/null; then
  print_message "O Docker não está instalado. Instalando o Docker..."
  
  # Instala o Docker
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh

  print_message "O Docker foi instalado com sucesso."
else
  print_message "O Docker já está instalado."
fi

# Verifica se o Docker está em execução
if ! docker info &> /dev/null; then
  print_message "O Docker não está em execução. Iniciando o Docker..."
  
  # Inicia o Docker
  sudo systemctl start docker

  print_message "O Docker foi iniciado com sucesso."
else
  print_message "O Docker já está em execução."
fi

# Instala o Kind
print_message "Instalando o Kind..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

print_message "O Kind foi instalado com sucesso."

# Criação do arquivo de configuração do cluster
print_message "Criando arquivo de configuração do cluster..."
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

print_message "Arquivo de configuração do cluster criado."

# Criação do cluster Kind com os nós especificados no arquivo de configuração
print_message "Criando cluster Kind..."
kind create cluster --config=kind-config.yaml

# Configura o kubectl para usar o cluster Kind
export KUBECONFIG="$(kind get kubeconfig-path)"

# Verifica se o cluster foi criado corretamente
print_message "Verificando o cluster..."
kubectl cluster-info

# Verifica os nós do cluster
print_message "Listando os nós do cluster..."
kubectl get nodes

print_message "Script concluído."
