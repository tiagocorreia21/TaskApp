## Scripts Disponíveis

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

### install-nodejs.ps1

Baixa e instala o Node.js localmente no projeto (sem afetar o sistema).

```powershell
.\install-nodejs.ps1
```

Este script:
- Baixa o Node.js versão 20.11.0 (LTS)
- Instala na pasta `nodejs-local` do projeto
- É executado automaticamente pelo `setup.ps1` se o Node.js não estiver instalado
- Permite usar a aplicação sem instalar Node.js no sistema

**Uso manual:**
```powershell
# Instalar versão específica
.\install-nodejs.ps1 -NodeVersion "20.11.0"
```

### clean.ps1

Remove todos os node_modules e arquivos compilados (build, dist).

```powershell
.\clean.ps1
```

---