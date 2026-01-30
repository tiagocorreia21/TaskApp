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
