# TaskApp

Aplicação fullstack de gerenciamento de tarefas com Backend (Node.js/Express/TypeScript) e Frontend (React/Vite).

## 🚀 Quick Start

### Opção 1: Usando PowerShell Scripts (Recomendado para Windows)

```powershell
# 1. Deploy (primeira vez)
.\deploy.ps1

# 2. Executar aplicação
.\start.ps1
```

### Opção 2: Usando npm Scripts

```powershell
# 1. Instalar concurrently (apenas primeira vez)
npm install

# 2. Deploy
npm run deploy

# 3. Executar aplicação
npm run dev
```

### Opção 3: Manual

```powershell
# Backend
cd backend
npm install
npm run build
npm start

# Frontend (em outro terminal)
cd frontend
npm install
npm run dev
```

---

## 📁 Estrutura do Projeto

```
TaskApp/
├── backend/              # API Backend (Node.js + Express + TypeScript)
│   ├── src/             # Código fonte TypeScript
│   ├── build/           # Código compilado
│   ├── tests/           # Testes unitários e integração
│   └── package.json
│
├── frontend/            # Frontend (React + Vite)
│   ├── src/            # Código fonte React
│   ├── dist/           # Build de produção
│   └── package.json
│
├── deploy.ps1          # Script de deploy completo
├── start.ps1           # Script para executar (simples)
├── run.ps1             # Script para executar (avançado)
├── package.json        # Scripts npm do projeto raiz
└── SCRIPTS_README.md   # Documentação dos scripts
```

---

## 📋 Pré-requisitos

- [Node.js](https://nodejs.org/) v16 ou superior
- npm (incluso com Node.js)
- PowerShell (Windows)

---

## 🛠️ Scripts Disponíveis

### Scripts PowerShell

| Script | Comando | Descrição |
|--------|---------|-----------|
| Setup | `.\setup.ps1` | Configuração inicial completa (primeira vez) |
| Deploy | `.\deploy.ps1` | Instala dependências e compila backend + frontend |
| Start (Simples) | `.\start.ps1` | Executa aplicação com concurrently |
| Run (Avançado) | `.\run.ps1` | Executa aplicação com monitoramento de jobs |
| Stop | `.\stop.ps1` | Para todos os servidores e libera portas |

### Scripts npm (Root)

| Comando | Descrição |
|---------|-----------|
| `npm run setup` | Configuração inicial (primeira vez) |
| `npm run deploy` | Deploy completo (install + build) |
| `npm run dev` | Executar em modo desenvolvimento |
| `npm run start` | Executar usando start.ps1 |
| `npm run stop` | Parar todos os servidores |
| `npm run build` | Build de backend e frontend |
| `npm run install:all` | Instalar todas as dependências |
| `npm run clean` | Limpar node_modules e builds |
| `npm test:backend` | Executar testes do backend |

### Scripts npm (Backend)

| Comando | Descrição |
|---------|-----------|
| `npm start` | Iniciar servidor em modo desenvolvimento |
| `npm run build` | Compilar TypeScript |
| `npm test` | Executar todos os testes |
| `npm run test:unit` | Executar testes unitários |
| `npm run test:integration` | Executar testes de integração |

### Scripts npm (Frontend)

| Comando | Descrição |
|---------|-----------|
| `npm run dev` | Iniciar dev server |
| `npm run build` | Build de produção |
| `npm run preview` | Preview do build |
| `npm run lint` | Executar linter |

---

## 🌐 URLs da Aplicação

Após iniciar a aplicação:

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:4000
- **Swagger Docs:** http://localhost:4000/api-docs (se configurado)

---

## ⚙️ Configuração

### Backend (.env)

O backend usa as seguintes variáveis de ambiente (arquivo `backend/.env`):

```env
NODE_ENV=development
PORT=4000
USE_MEMORY_DB=true
LOG_LEVEL=info
```

- `USE_MEMORY_DB=true`: Usa MongoDB in-memory (desenvolvimento)
- `USE_MEMORY_DB=false`: Requer MongoDB real (produção)

---

## 🧪 Testes

### Backend

```powershell
cd backend
npm test                    # Todos os testes
npm run test:unit          # Testes unitários
npm run test:integration   # Testes de integração
```

---

## 📦 Deploy para Produção

### Build de Produção

```powershell
# Opção 1: Usando script
.\deploy.ps1

# Opção 2: Usando npm
npm run build
```

### Variáveis de Ambiente (Produção)

Ajuste o arquivo `backend/.env` para produção:

```env
NODE_ENV=production
PORT=4000
USE_MEMORY_DB=false
MONGODB_URI=your_mongodb_connection_string
LOG_LEVEL=warn
```

---

## 🐛 Resolução de Problemas

### Porta já em uso

```powershell
# Liberar portas
npx kill-port 4000 5173
```

### Dependências não instaladas

```powershell
.\deploy.ps1
# ou
npm run install:all
```

### Erro de política de execução (PowerShell)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Limpar e reinstalar tudo

```powershell
npm run clean
npm run deploy
```

---

## 🏗️ Tecnologias Utilizadas

### Backend
- Node.js
- Express.js
- TypeScript
- MongoDB / MongoDB Memory Server
- Swagger (documentação API)
- Jest/Mocha (testes)

### Frontend
- React 19
- Vite
- ESLint

---

## 📝 Desenvolvimento

### Adicionar Nova Feature

1. Backend:
   ```powershell
   cd backend
   # Criar service, controller, route, etc.
   npm test
   ```

2. Frontend:
   ```powershell
   cd frontend
   # Criar componente
   npm run lint
   ```

### Convenções de Código

- Backend: Domain-Driven Design (DDD)
- TypeScript strict mode
- ESLint para padronização

---

## 📄 Documentação Adicional

- [SCRIPTS_README.md](./SCRIPTS_README.md) - Documentação detalhada dos scripts
- [Backend README](./backend/README.md) - Documentação específica do backend (se existir)
- [Frontend README](./frontend/README.md) - Documentação específica do frontend

---

## 🤝 Contribuindo

1. Clone o repositório
2. Execute `.\deploy.ps1`
3. Crie uma branch para sua feature
4. Faça suas alterações e teste
5. Submit pull request

---

## 📞 Suporte

Para problemas ou dúvidas:
1. Verifique a seção de [Resolução de Problemas](#-resolução-de-problemas)
2. Consulte [SCRIPTS_README.md](./SCRIPTS_README.md)
3. Abra uma issue no repositório

---

## 📜 Licença

ISC

---

**Desenvolvido com ❤️ para ISEP**
