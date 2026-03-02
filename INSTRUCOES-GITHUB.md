# 🚀 Como Subir Este Projeto para o GitHub

Este guia mostra **passo a passo** como criar um repositório GitHub limpo e fazer o primeiro release.

---

## 📋 O que você tem nesta pasta

✅ **Repositório Git limpo** (sem config.json, sem logs)
✅ **21 arquivos** prontos para publicar
✅ **Commit inicial** já criado
✅ **Tag v1.0.1** já criada
✅ **ZIP de código-fonte** pronto

**IMPORTANTE:** Este é um repositório **NOVO**, sem histórico do antigo!

---

## 🎯 PASSO A PASSO

### **1️⃣ Criar Repositório no GitHub**

1. Acesse: https://github.com/new

2. Preencha:
   - **Repository name**: `organizador-capturas` (ou outro nome)
   - **Description**: `📸 Organizador Automático de Capturas de Tela - Monitora e organiza screenshots por data com interface gráfica`
   - **Visibilidade**: ✅ **Public** (para que outros possam ver)
   - **NÃO marque**: "Add a README file"
   - **NÃO marque**: "Add .gitignore"
   - **NÃO marque**: "Choose a license"

3. Clique **"Create repository"**

---

### **2️⃣ Conectar Repositório Local ao GitHub**

No seu computador, abra o **Git Bash** ou **PowerShell** nesta pasta e execute:

```bash
# Conectar ao repositório remoto (SUBSTITUA SEU-USUARIO pelo seu username do GitHub)
git remote add origin https://github.com/SEU-USUARIO/organizador-capturas.git

# Verificar se conectou
git remote -v
```

**Exemplo:**
```bash
git remote add origin https://github.com/fabri2896/organizador-capturas.git
```

---

### **3️⃣ Fazer Push (Enviar Código)**

```bash
# Enviar o código e a tag
git push -u origin main
git push origin v1.0.1
```

Se pedir **autenticação**, use seu **Personal Access Token** (não senha):
- Gere em: https://github.com/settings/tokens
- Selecione: `repo` (acesso completo ao repositório)
- Use o token como senha

---

### **4️⃣ Criar Release no GitHub**

1. Acesse: `https://github.com/SEU-USUARIO/organizador-capturas/releases/new`

2. Preencha:

   **Tag version:** `v1.0.1` (já existe)

   **Release title:** `v1.0.1 - Organizador Automático de Capturas 📸`

   **Description:**
   ```markdown
   # 📸 Organizador Automático de Capturas de Tela v1.0.1
   
   Primeira versão oficial! 🎉
   
   ## ✨ Características
   
   - 🤖 **Monitoramento automático** de pasta de capturas
   - 📁 **Organização inteligente** por Ano/Mês-Nome/Dia
   - 🗑️ **Detecção de duplicatas** (hash MD5)
   - 🪟 **Interface gráfica** com ícone na bandeja (📁 verde/amarelo/vermelho)
   - 🚀 **Auto-start** no Windows (2 métodos: Registry + Startup)
   - 📊 **Logs em tempo real**
   - ⚙️ **Configuração flexível** via GUI
   - ✅ **Multi-plataforma** (Windows e Linux)
   
   ## 📦 Downloads
   
   ### Para Usuários (Windows):
   - **OrganizadorCapturas.exe** - Executável pronto para usar (NÃO precisa Python)
   
   ### Para Desenvolvedores:
   - **Source code (zip)** - Código-fonte completo
   - **Source code (tar.gz)** - Código-fonte completo
   
   ## 🚀 Como Usar
   
   ### Executável (Windows):
   1. Baixe `OrganizadorCapturas.exe`
   2. Duplo clique para executar
   3. Selecione a pasta para monitorar
   4. Pronto! Ícone 📁 aparecerá na bandeja
   
   ### Código-fonte (Python):
   1. Baixe e extraia o código-fonte
   2. Instale dependências: `pip install -r requirements.txt`
   3. Execute: `python organizador_tray.py`
   
   ### Compilar você mesmo:
   1. Baixe o código-fonte
   2. Execute: `compilar_para_exe.bat`
   3. EXE estará em `dist/OrganizadorCapturas.exe`
   
   ## ⚠️ Antivírus
   
   Alguns antivírus podem bloquear o EXE (falso positivo comum com PyInstaller).
   **Solução:** Veja o guia `ANTIVIRUS-BLOQUEOU.txt` incluído no código-fonte.
   
   ## 📚 Documentação
   
   Documentação completa em português incluída:
   - `README.md` - Visão geral completa
   - `COMPILAR-PARA-EXE.txt` - Como compilar
   - `COMO-USAR-EXE.txt` - Como usar o executável
   - `ANTIVIRUS-BLOQUEOU.txt` - Solução para bloqueios
   - `GERENCIAR-AUTO-START.txt` - Configurar inicialização
   
   ## 🐛 Reportar Problemas
   
   Encontrou um bug? Abra uma [issue](https://github.com/SEU-USUARIO/organizador-capturas/issues)!
   
   ## 📝 Licença
   
   MIT License - Código aberto e gratuito!
   ```

3. **Anexar arquivos:**

   Arraste e solte na área de anexos:
   - ✅ `OrganizadorCapturas-v1.0.1-Source.zip`
   - ✅ `OrganizadorCapturas.exe` (se você tiver compilado)

4. Clique **"Publish release"**

---

### **5️⃣ Pronto! ✅**

Seu projeto está no ar! 🎉

**URL do projeto:**
```
https://github.com/SEU-USUARIO/organizador-capturas
```

**URL do release:**
```
https://github.com/SEU-USUARIO/organizador-capturas/releases/tag/v1.0.1
```

---

## 📝 Sobre o EXE

⚠️ **IMPORTANTE:** O arquivo `.exe` **NÃO está** no código-fonte porque:
- É binário (muito grande ~15-30 MB)
- GitHub é para código, não binários
- Usuários podem compilar eles mesmos

**Você precisa:**
1. Compilar o EXE no seu Windows: `compilar_para_exe.bat`
2. Fazer upload manual do EXE no release do GitHub

---

## 🔄 Atualizações Futuras

Para versões futuras (v1.0.2, v1.1.0, etc.):

```bash
# 1. Faça modificações no código
# 2. Commit
git add .
git commit -m "Descrição das mudanças"

# 3. Crie nova tag
git tag -a v1.0.2 -m "Descrição da versão"

# 4. Push
git push origin main
git push origin v1.0.2

# 5. Crie novo release no GitHub
```

---

## 🎯 Checklist Final

Antes de publicar, verifique:

- [ ] Repositório criado no GitHub
- [ ] Remote conectado (`git remote -v`)
- [ ] Push feito com sucesso (`git push`)
- [ ] Tag enviada (`git push origin v1.0.1`)
- [ ] Release criado no GitHub
- [ ] ZIP de código-fonte anexado
- [ ] EXE compilado e anexado (opcional)
- [ ] Description do release preenchida
- [ ] Testado o download

---

## 📞 Precisa de Ajuda?

Se tiver dúvidas:
1. Veja a documentação do GitHub: https://docs.github.com
2. Tutorial de Git: https://git-scm.com/book/pt-br/v2

---

**Boa sorte com seu projeto! 🚀**
