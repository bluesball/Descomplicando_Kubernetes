### O script a seguir foi convertido do .sh pelo chatgpt... ficou pior que o original aparentemente..

# Função para exibir uma mensagem
function Print-Message {
    param([string]$message)
    Write-Host "==> $message"
}

# Verifica se o Docker está instalado
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Print-Message "O Docker não está instalado. Instalando o Docker..."

    # Instala o Docker
    Invoke-WebRequest -Uri https://get.docker.com -OutFile get-docker.sh
    sudo sh get-docker.sh

    Print-Message "O Docker foi instalado com sucesso."
}
else {
    Print-Message "O Docker já está instalado."
}

# Verifica se o Docker está em execução
$dockerInfo = docker info -ErrorAction SilentlyContinue
if (-not $dockerInfo) {
    Print-Message "O Docker não está em execução. Iniciando o Docker..."

    # Inicia o Docker
    Start-Service docker

    Print-Message "O Docker foi iniciado com sucesso."
}
else {
    Print-Message "O Docker já está em execução."
}

# Instala o Kind
Print-Message "Instalando o Kind..."
Invoke-WebRequest -Uri "https://kind.sigs.k8s.io/dl/v0.11.1/kind-windows-amd64.exe" -OutFile kind.exe
Move-Item kind.exe -Destination "C:\Program Files\Kind\kind.exe"

Print-Message "O Kind foi instalado com sucesso."

# Criação do arquivo de configuração do cluster
Print-Message "Criando arquivo de configuração do cluster..."
@"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
"@ | Set-Content -Path kind-config.yaml

Print-Message "Arquivo de configuração do cluster criado."

# Criação do cluster Kind com os nós especificados no arquivo de configuração
Print-Message "Criando cluster Kind..."
kind create cluster --config=kind-config.yaml

# Configura o kubectl para usar o cluster Kind
$env:KUBECONFIG = (kind get kubeconfig-path)

# Verifica se o cluster foi criado corretamente
Print-Message "Verificando o cluster..."
kubectl cluster-info

# Verifica os nós do cluster
Print-Message "Listando os nós do cluster..."
kubectl get nodes

Print-Message "Script concluído."
