## Resolução de Problemas

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