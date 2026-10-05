# ==========================================
# Estágio 1: Build da aplicação TypeScript
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Copia manifestos de dependência
COPY package*.json tsconfig.json ./

# Instala todas as dependências (incluindo devDependencies para o build)
RUN npm ci

# Copia o código-fonte e compila
COPY src ./src
RUN npm run build

# ==========================================
# Estágio 2: Imagem final enxuta para Produção
# ==========================================
FROM node:20-alpine AS production

WORKDIR /usr/src/app

ENV NODE_ENV=production

# Instala apenas dependências de produção
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copia os arquivos compilados do estágio anterior
COPY --from=builder /usr/src/app/dist ./dist

# Segurança: Executa como usuário sem privilégios administrativos
USER node

EXPOSE 3000

CMD ["node", "dist/server.js"]