# TaskApp

Aplicação fullstack de gerenciamento de tarefas com Backend e Frontend.

---

## Como usar?

1. Baixar o repositório e descompactar.

2. Entrar na pasta do projeto via PowerShell.
   
   - Botão direito na pasta -> "Abrir no Terminal" ou "Abrir no PowerShell"

3. Executar o script de intalação: 

```powershell
.\setup.ps1
```

- Este scipt instala todas as dependências necessárias para o backend e frontend, preparando o ambiente para execução da aplicação.

4. Quando a instalação terminar, executar o script de para correr a aplicação:

```powershell
.\start.ps1
```

5. A aplicação estará disponível em http://localhost:5173

---

## 📋 Pré-requisitos

- [Node.js](https://nodejs.org/) v16 ou superior
- npm (incluso com Node.js)
- PowerShell (Windows)

---

## 🌐 URLs da Aplicação

Após iniciar a aplicação:

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:4000

---

## 📜 Scripts Disponíveis

### setup.ps1
Configuração inicial completa - instala dependências e compila o projeto.

```powershell
.\setup.ps1
```

Para instalar automaticamente o MongoDB sem prompt:

```powershell
.\setup.ps1 -AutoInstallMongoDB
```

### start.ps1

Inicia o backend e frontend simultaneamente.

```powershell
.\start.ps1
```

### stop.ps1

Para os servidores backend e frontend.

```powershell
.\stop.ps1
```

### deploy.ps1

Instala dependências e compila backend e frontend.

```powershell
.\deploy.ps1
```

Para instalar automaticamente o MongoDB sem prompt:

```powershell
.\deploy.ps1 -AutoInstallMongoDB
```

### install-mongodb.ps1

Baixa e instala o MongoDB Memory Server binários.

```powershell
.\install-mongodb.ps1
```

Este script:
- Cria o diretório `backend/mongodb-binaries`
- Baixa o MongoDB versão 6.0.12
- Configura o MongoDB Memory Server.
- Pode demorar alguns minutos na primeira execução

### clean.ps1

Remove todos os node_modules e arquivos compilados (build, dist).

```powershell
.\clean.ps1
```

### run.ps1

Executa os servidores em modo de desenvolvimento.

```powershell
.\run.ps1
```

---

## 🐛 Resolução de Problemas

### Porta já em uso

```powershell
# Libertar portas
npx kill-port 4000 5173
```

### Dependências não instaladas

```powershell
.\deploy.ps1
# ou
npm run install:all
```

### Erro de política de execução (PowerShell)

- Pode ser necessário ajustar a política de execução do PowerShell para permitir a execução dos scripts. 
- Execute o seguinte comando no PowerShell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- Este comando permite a execução de scripts locais não assinados na sessão atual do usuário.

### MongoDB não está instalado ou não baixa automaticamente

Se o MongoDB Memory Server não foi baixado automaticamente:

```powershell
# Executar script de instalação manualmente
.\install-mongodb.ps1
```

Ou instalar durante o setup/deploy:

```powershell
.\deploy.ps1 -AutoInstallMongoDB
```

**Nota:** O MongoDB Memory Server baixa na primeira execução e pode demorar alguns minutos dependendo da sua conexão com a internet.

### Erro "MongooseError: The uri parameter to openUri() must be a string"

Isso significa que o arquivo `.env` não existe ou está mal configurado. Para corrigir:

1. Verifique se existe o arquivo `backend/.env`
2. Se não existir, copie o exemplo:

```powershell
Copy-Item backend\.env.example backend\.env
```

3. Ou crie manualmente com o conteúdo:

```env
NODE_ENV=development
PORT=4000
USE_MEMORY_DB=true
LOG_LEVEL=info
```

### Limpar e reinstalar tudo

Para remover todos os node_modules e arquivos compilados:

```powershell
.\clean.ps1
```
---

## Tecnologias Utilizadas

### Backend

- Node.js
- Express.js
- TypeScript
- MongoDB / MongoDB Memory Server

### Frontend

- React 19
- Vite

---
