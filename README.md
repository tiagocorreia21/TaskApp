# TaskApp

Aplicação fullstack de gestão de tarefas com Backend e Frontend.

---

## 1. Pré-requisitos

- [Node.js](https://nodejs.org/) v16 ou superior
- npm (incluso com Node.js)
- PowerShell (Windows)

---

## 2. Como usar?

1. Baixar o repositório e descompactar.

2. Entrar na pasta do projeto via PowerShell.
   
   - Botão direito na pasta -> "Abrir no Terminal" ou "Abrir no PowerShell"

3. Executar o script de intalação: 

```powershell
.\setup.ps1 -AutoInstallMongoDB
```

- Este scipt instala todas as dependências necessárias para o backend, frontend e base de dados preparando o ambiente para execução da aplicação.
- Nota: Este procedimento pode demorar alguns minutos dependendo da velocidade da internet e do computador.

4. Quando a instalação terminar, executar o script de para correr a aplicação:

```powershell
.\start.ps1
```

5. A aplicação estará disponível no link: http://localhost:5173

---

## 3. URLs da Aplicação

Após iniciar a aplicação:

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:4000

---

## 4. Tecnologias Utilizadas

### Backend

- Node.js
- Express.js
- TypeScript
- MongoDB / MongoDB Memory Server

### Frontend

- React 19
- Vite

---

## 5. Possíveis Problemas

- Um coisa que pode acontecer é o terminal bloquear a execução de scripts por questões de segurança do PowerShell. 
  Nesse caso, execute o seguinte comando no PowerShell para permitir a execução de scripts locais 
  (somente para a sessão atual do terminal):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

- Depois, tente executar novamente o script pretendido.

- Para mais problemas comuns e suas soluções, consulte o arquivo [docs/POSSIBLE_PROBLEMS.md](docs/POSSIBLE_PROBLEMS.md).

---

## 6. Scripts Disponíveis

- Para mais detalhes sobre os scripts disponíveis, consulte o arquivo [docs/SCRIPTS.md](docs/SCRIPTS.md).

---
