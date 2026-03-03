# 🚀 GUIA RÁPIDO: PUBLICAR NO GITHUB

Este guia mostra os passos exatos para publicar seu projeto no GitHub pela primeira vez.

---

## PASSO 1: Compilar o Projeto (Windows)

Abra o terminal na pasta do projeto e execute:

```bash
cd organizador-capturas-github
scripts\compilar_para_exe.bat
```

**Aguarde a compilação terminar.** O EXE será criado em `dist/OrganizadorCapturas/`.

---

## PASSO 2: Preparar o Pacote de Release

Execute o script de preparação:

```bash
scripts\preparar_release.bat
```

Este script irá:
- ✅ Copiar o EXE compilado para `release-package/`
- ✅ Criar o arquivo ZIP: `OrganizadorCapturas-v1.0.1-Windows.zip`
- ✅ Calcular o hash SHA256 do arquivo

---

## PASSO 3: Criar Repositório no GitHub

1. Acesse: https://github.com/new
2. Preencha:
   - **Repository name:** `organizador-capturas`
   - **Description:** `Organizador automático de capturas de tela com interface na bandeja do sistema`
   - **Visibility:** Public
   - **NÃO marque:** "Add a README file" (já temos um)
3. Clique em **"Create repository"**

---

## PASSO 4: Conectar o Repositório Local ao GitHub

No terminal (dentro da pasta `organizador-capturas-github`):

```bash
git remote add origin https://github.com/fabri2896/organizador-capturas.git
git branch -M main
git push -u origin main
```

**Nota:** Substitua `fabri2896` pelo seu nome de usuário do GitHub se for diferente.

---

## PASSO 5: Enviar a Tag de Versão

```bash
git push origin v1.0.1
```

---

## PASSO 6: Criar a Release no GitHub

1. Acesse: https://github.com/fabri2896/organizador-capturas/releases/new
2. Preencha:
   - **Choose a tag:** Selecione `v1.0.1`
   - **Release title:** `v1.0.1 - Versão Estável`
   - **Description:** Copie o conteúdo de `docs/GITHUB_RELEASE_TEMPLATE.md`
3. Clique em **"Attach binaries by dropping them here or selecting them"**
4. Anexe o arquivo: `OrganizadorCapturas-v1.0.1-Windows.zip`
5. Marque: ☑️ **"Set as the latest release"**
6. Clique em **"Publish release"**

---

## ✅ PRONTO!

Seu projeto agora está público no GitHub com uma release profissional!

**URL do projeto:** https://github.com/fabri2896/organizador-capturas

---

## 📌 Comandos Úteis para Futuras Atualizações

### Criar nova versão (exemplo: v1.0.2)

```bash
# 1. Faça suas alterações no código
# 2. Compile novamente
scripts\compilar_para_exe.bat

# 3. Prepare o release
scripts\preparar_release.bat

# 4. Commit e tag
git add .
git commit -m "Versão 1.0.2 - Descrição das mudanças"
git tag -a v1.0.2 -m "Versão 1.0.2"

# 5. Push
git push origin main
git push origin v1.0.2

# 6. Crie nova Release no GitHub e anexe o novo ZIP
```

---

**Desenvolvido por:** Fabrício Moreira Pires
**GitHub:** https://github.com/fabri2896
