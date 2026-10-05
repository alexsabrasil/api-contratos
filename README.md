# 📄 API de Contratos — Infraestrutura e Operações DevOps

Microsserviço responsável pela gestão, emissão e ciclo de vida de contratos corporativos, projetado com foco em resiliência, observabilidade e entrega contínua segura (DevSecOps).

---

## 🛠️ Tecnologias Utilizadas

A solução foi construída utilizando uma stack moderna, robusta e aderente aos padrões de mercado:

### Core & Aplicação
* **Node.js & TypeScript**: Plataforma de execução assíncrona tipada estaticamente para garantir consistência e prevenção de erros em tempo de compilação.
* **Express.js**: Framework minimalista para exposição de rotas e APIs RESTful.
* **Jest**: Framework para testes unitários e de integração com cobertura de código.

### Persistência & Cache
* **PostgreSQL / TypeORM**: Banco de dados relacional para persistência transacional de dados contratuais com integridade referencial.
* **Redis**: Camada de armazenamento em memória para caching distribuído, otimizando o tempo de resposta e reduzindo carga no banco de dados.

### Observabilidade & Métricas
* **Prometheus Client (`prom-client`)**: Instrumentação de métricas nativas HTTP expostas através do middleware de métricas (`/metrics`) para monitoramento de latência, taxa de erros e throughput.

### Infraestrutura, Conteinerização & DevSecOps
* **Docker & Multi-Stage Builds**: Empacotamento de imagem mínima utilizando base Linux enxuta (`Alpine`) e execução sob usuário sem privilégios administrativos (`non-root`).
* **Docker Compose**: Orquestração local para provisionamento da aplicação, Redis e banco de dados com isolamento por rede interna.
* **GitHub Actions**: Pipeline de CI/CD para automação de testes, linting, build e varredura estática de segurança em contêineres.

---

## 🏗️ Justificativa de Arquitetura

Conforme as diretrizes e boas práticas de DevOps e DevSecOps:

1. **Escalabilidade e Baixa Latência**: A separação das responsabilidades com **Redis** para cache alivia a carga de consultas frequentes sobre os contratos, permitindo que a API escale horizontalmente sem estrangular o banco de dados.
2. **Observabilidade Nativa (Site Reliability Engineering)**: O uso de métricas via `prom-client` viabiliza o acompanhamento em tempo real de SLOs/SLIs (como erro rate e tempo de resposta) integrado com Prometheus/Grafana.
3. **Segurança de Imagens em Camadas**: 
   - Adoção de imagem base mínima (`node:alpine`) para mitigar superfícies de ataque decorrentes de pacotes extras do sistema operacional.
   - Aplicação estrita do **Princípio do Menor Privilégio (PoLP)** dentro do contêiner, executando os processos com o usuário `node` em vez do usuário `root`.
4. **Gerenciamento Seguro de Segredos**:
   - Eliminação de qualquer *hardcoding* de senhas, credenciais de banco ou portas no código.
   - Configurações e segredos são injetados exclusivamente em tempo de execução via **Variáveis de Ambiente** (`.env` ou secrets do CI/CD), atendendo às recomendações de conformidade e governança.

---

## 📋 Pré-requisitos

* [Git](https://git-scm.com/)
* [Node.js 18+](https://nodejs.org/) (para execução e testes locais fora de contêiner)
* [Docker](https://www.docker.com/) e [Docker Compose](https://docs.docker.com/compose/)

---

## ⚙️ Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto com base no modelo:

```env
PORT=3000
NODE_ENV=development

# Banco de Dados
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=contratos_db

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

---

## Como executar o projeto

1. Execução Local com Docker Compose (Recomendado)
Suba toda a infraestrutura (API, Banco e Redis) com apenas um comando:

# Construir a imagem e iniciar os contêineres
docker compose up -d --build

# Visualizar logs em tempo real
docker compose logs -f api

A API estará acessível em: http://localhost:3000

2. Execução Local para Desenvolvimento (Sem Docker)

# Instalar as dependências
npm install

# Compilar o TypeScript e rodar em modo desenvolvimento
npm run dev

## Testes Automatizados

O repositório conta com testes unitários focados nas regras de negócio dos serviços:

# Executar a suíte de testes
npm test

# Executar com relatório de cobertura (coverage)
npm test -- --coverage

## Endpoints Principais

MétodoRotaDescriçãoGET/healthHealthcheck da aplicaçãoGET/metricsMétricas operacionais em formato PrometheusGET/contractsLista contratos cadastradosPOST/contractsCria um novo contratoGET/contracts/:idConsulta detalhes de um contrato

## Práticas de Segurança Aplicada

- Não-Root User: Contêiner configurado com instrução USER node.
- Análise Estática de Vulnerabilidades: Pipeline integrado com ferramentas como Grype/Trivy para detecção precoce de CVEs em dependências e camadas Docker.
- Proteção de Segredos: Arquivo .gitignore devidamente configurado para evitar o vazamento de arquivos .env e credenciais sensíveis no histórico do Git.

---

### Como salvar e commitar:
No terminal da pasta `api-contratos`:

```powershell
# Crie/atualize o README.md e envie para o GitHub:
git add README.md
git commit -m "docs: add comprehensive DevOps README and architecture justification"
git push

