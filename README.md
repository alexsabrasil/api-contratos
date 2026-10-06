# API de Contratos - Infraestrutura DevOps

Projeto desenvolvido para executar uma API de contratos em ambiente containerizado, aplicando práticas de infraestrutura, automação e operação DevOps.

## Arquitetura

A solução utiliza:

- Node.js, TypeScript e Express para a API
- PostgreSQL para persistência
- Redis para cache
- Docker e Docker Compose para containerização
- Jest para testes automatizados
- GitHub Actions para Integração Contínua (CI)
- prom-client para exposição de métricas

```text
Cliente
   |
API Node.js
   |
   +-- PostgreSQL
   +-- Redis
   +-- /metrics
```

## Como executar

Clone o repositório:

```bash
git clone https://github.com/alexsabrasil/api-contratos.git
cd api-contratos
```

Crie o arquivo de ambiente:

```bash
cp .env.example .env
```

Defina uma senha em `POSTGRES_PASSWORD` no arquivo `.env` e inicie os serviços:

```bash
docker compose up -d --build
docker compose ps
```

A API ficará disponível em `http://localhost:3000`.

## Como testar

Métricas da aplicação:

```bash
curl http://localhost:3000/metrics
```

Criação de contrato:

```bash
curl -X POST http://localhost:3000/contracts \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Contrato Teste",
    "userId": "user-001",
    "description": "Teste da infraestrutura",
    "value": 1500
  }'
```

Testes automatizados e build:

```bash
npm ci
npm test
npm run build
```

## Automação

O workflow `.github/workflows/ci.yml` executa automaticamente em pushes e pull requests para a branch `main`:

```text
npm ci -> npm test -> npm run build -> Docker build
```

## Justificativa da Arquitetura

**Escalabilidade:** API, PostgreSQL e Redis são serviços separados, facilitando a evolução dos componentes. O Redis fornece cache para reduzir acessos repetitivos ao banco.

**Segurança:** As credenciais são fornecidas por variáveis de ambiente. O arquivo `.env` não é versionado e a aplicação executa no contêiner com usuário não-root.

**Confiabilidade:** PostgreSQL e Redis possuem volumes persistentes, o PostgreSQL utiliza healthcheck e os serviços possuem política de reinicialização. Os testes automatizados validam a aplicação e a CI verifica os testes, a compilação e a construção da imagem Docker. 



## Encerrar o ambiente

```bash
docker compose down
```

---

## Atividade Prática do curso DevOps | FAP 

### Professor
Bruno Álexys

### Aluna/Treinanda
Alê Tavares

