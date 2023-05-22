# Descomplicando o Kubernetes

Material desenvolvido no treinamento homônimo da LINUXTips

Neste repositório está contido as anotações, atividades, testes (e talvez erros grotescos) do Treinamento Descomplicando o Kubernetes da LinuxTips (https://www.linuxtips.io/course/descomplicando-o-kubernetes-expert-mode)


## Kubernetes: É de comer ou passar no cabelo?

Nem um nem outro! O projeto kubernetes foi desenvolvido pela Google para orquestrar os vários containers de suas aplicações. É tipo um Docker Swarm, só que diferente e maiorzão.

O Kubernetes ajuda a simplificar vários aspectos das infraestruturas orientadas a serviços, incluindo implantação, escalonamento e gerenciamento de aplicativos baseados em contêineres. Fornece uma maneira eficiente de gerenciar recursos de computação, rede e armazenamento para aplicativos em contêineres, permitindo que as equipes se concentrem no desenvolvimento de aplicativos em vez de gerenciamento de infraestrutura.

## E pra que eu vou usar isso?

Ora, pra migrar de monolitos pra microsserviços. Com isso é possivel reduzir o tempo de downtime da aplicação.
E aqui vai um fato: Toda aplicação falha! 

Vou fazer uma lista aqui de situações possíveis de serem resolvidas adotando microserviços orquestrados com kubernetes:

- Escalabilidade: Com uma aplicação monolítica, é difícil escalar partes específicas da aplicação individualmente. Ao migrar para microserviços no Kubernetes, você pode escalar cada serviço de forma independente, permitindo ser mais granular e eficiente. Isso significa que você pode alocar recursos onde são mais necessários e melhorar o desempenho geral da aplicação.

- Manutenção e desenvolvimento ágil: Uma aplicação monolítica geralmente tem todo o código em um único repositório, o que pode dificultar a manutenção e o desenvolvimento. Com microserviços no Kubernetes, cada serviço pode ser desenvolvido, testado e implantado independentemente. Isso facilita a adoção de práticas ágeis, como DevOps e CI/CD (Integração Contínua/Implantação Contínua), acelerando o ciclo de desenvolvimento e permitindo atualizações mais frequentes e confiáveis.

- Confiabilidade e resiliência: Com uma aplicação monolítica, uma falha em uma parte da aplicação pode causar o colapso de toda a aplicação. Ao migrar para microserviços com o Kubernetes, você pode distribuir os serviços em vários nós e réplicas, garantindo uma maior resiliência. Se um serviço falhar, os outros serviços ainda podem continuar funcionando, reduzindo o impacto global de uma falha. (Lembre-se: Toda aplicação falha, faça o possível para diminuir o downtime)

- Desacoplamento e autonomia das equipes: Uma aplicação monolítica geralmente requer que uma única equipe seja responsável por todo o desenvolvimento e manutenção. Com a arquitetura de microserviços, você pode dividir a aplicação em serviços menores e atribuir equipes independentes a cada serviço. Isso promove o desacoplamento e a autonomia das equipes, permitindo que trabalhem de forma mais independente, com tecnologias e práticas adequadas às suas necessidades específicas.

- Implantação contínua e atualizações sem interrupções: O Kubernetes facilita a implantação contínua de microserviços, permitindo atualizações sem interrupções. Você pode implantar novas versões de serviços sem afetar o funcionamento geral da aplicação. Isso resulta em atualizações mais suaves, sem tempo de inatividade para os usuários finais.

- Flexibilidade tecnológica: Ao migrar para microserviços no Kubernetes, você pode escolher tecnologias específicas para cada serviço com base nos requisitos e necessidades individuais. Isso permite que você adote novas tecnologias, idiomas ou estruturas sem afetar toda a aplicação. Dessa forma, você pode explorar novas soluções tecnológicas e manter-se atualizado com as últimas tendências do setor.

### Como é que roda isso?

Rapaz, é em cluster... Tem que ter pelo menos 1 node chefe (control-plane) e os carregadores de piano (workers (tm Badtux)). Dependendo da sua carga de trabalho, 
ou da necessidade da aplicação de se manter ativa a maior quantidade de tempo possível, é altamente recomendável que esse cluster tenha pelo menos 3 nodes control-plane. (ou seja com H.A, tbm conhecido como cluster de verdade).

#### Mas e o dev? tem que montar um cluster pra ele?

Óbvio que tem né... mas é na própria workstation do camarada! Pra isso usamos o kind, uma plataforma para construir cluster em cima do docker. Sucesso!

Para tanto basta seguir a documentação oficial: https://kind.sigs.k8s.io/docs/user/quick-start é mó fácil.
Esse cara aqui quase desenhou como faz tbm: https://blog.marcelocavalcante.net/criando-um-cluster-kubernetes-local-com-o-kind/

Com o kind instalado, é possível simular um cluster com 1 ou mais nodes (cuidado com seus recursos de hardware aí, bonitão)

(Deixei uns scripts aí no repositório que faz a instalação com um node control-plane e 2 workers, mas ainda nao testei eles)


## Arquitetura

O Kubernetes é composto por componentes que executam funções específicas:


| Componente        | Função |
| ----------------- | ------ |
| kube-apiserver	| O servidor da API é um componente da camada de gerenciamento do Kubernetes que expõe a API do Kubernetes. É o front end para a camada de gerenciamento do Kubernetes |
| etcd	            | Armazenamento do tipo chave-valor consistente e de alta-disponibilidade, usado como armazenamento de apoio do Kubernetes para todos os dados do cluster |
| kube-scheduler	| Componente da camada de gerenciamento que observa os Pods recém-criados e que ainda não foram atribuídos a um nó, e seleciona um nó para executá-los |
| kubelet	        | Um agente que é executado em cada nó no cluster. Ele garante que os contêineres estejam sendo executados em um Pod |
| kube-proxy        | Um proxy de rede executado em cada nó no seu cluster, implementando o conceito de serviço do Kubernetes e mantendo as regras de rede em nodes |

Várias portas são usadas para que a comunicação entre os componetentes, utilitários e apps possam ocorrer. Verifique a documentação ou o repositório do treinamento no github para consulta.

E por falar em ultilitários, para interagir, gerenciar ou tomar uma sarrafada do cluster, usamos o kubectl:

## O Kubectl

É através dessa ferramenta do tipo CLI (command line interface) que são feitas:

- Implantações de apps, usando definições em arquivos YAML;
- Gerencia de nodes e recursos do cluster;
- Acesso a logs;
- Obter detalhes de apps e recursos;

Versão resumida: O kubectl é usado pra fazer tudo.

