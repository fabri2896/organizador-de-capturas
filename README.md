# 📸 Organizador Automático de Capturas de Tela

<div align="center">

![Python](https://img.shields.io/badge/Python-3.6+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Release](https://img.shields.io/github/v/release/fabri2896/organizador-de-capturas?label=Release)
[![Downloads](https://img.shields.io/github/downloads/fabri2896/organizador-de-capturas/total?style=flat-square&color=blue)](https://github.com/fabri2896/organizador-de-capturas/releases)

**Organize suas capturas de tela automaticamente por data, detecte duplicatas e mantenha tudo limpo!**

[Características](#-características) • [Instalação](#-instalação) • [Uso](#-uso) • [Configuração](#-configuração) • [Contribuir](#-contribuir)

</div>

---

## 🎯 O Problema

Você já teve uma pasta de capturas de tela assim?

```
📁 Screenshots/
├── Captura de tela (1).png
├── Captura de tela (2).png
├── Captura de tela (3).png
├── ...
└── Captura de tela (9847).png  😱
```

**Impossível** de encontrar aquela captura importante de semana passada, certo?

## ✨ A Solução

Este organizador monitora automaticamente sua pasta de capturas e organiza tudo por **ano/mês/dia**:

```
📁 Screenshots/
├── 2026/
│   ├── 01-Janeiro/
│   │   ├── 15/
│   │   │   ├── captura_reuniao.png
│   │   │   └── captura_erro.png
│   │   └── 20/
│   │       └── captura_dashboard.png
│   └── 02-Fevereiro/
│       ├── 24/
│       └── 25/
```

Agora você **lembra do dia** e encontra em **3 cliques**! 🎉

---

## 🚀 Características

### 🤖 Monitoramento Automático
- ✅ Detecta automaticamente novos arquivos
- ✅ Organiza instantaneamente ao salvar captura
- ✅ Roda completamente em segundo plano
- ✅ Ícone na área de notificação (system tray)

### 📁 Organização Inteligente
- ✅ Estrutura: `Ano/Mês-Nome/Dia/`
- ✅ Usa data do nome do arquivo (formato: `YYYY-MM-DD`)
- ✅ Fallback para data de modificação
- ✅ Nomes em português (ex: `02-Fevereiro`)

### 🗑️ Anti-Duplicatas (Hash MD5)
- ✅ Detecta capturas idênticas automaticamente
- ✅ Remove duplicatas e registra no log
- ✅ Economiza espaço em disco

### 🪟 Interface Gráfica
- ✅ Janela de logs em tempo real
- ✅ Visualização de status e estatísticas
- ✅ Menu intuitivo no ícone da bandeja
- ✅ Botões para pausar/retomar/configurar

### ⚙️ Configuração Flexível
- ✅ Script pode ficar em **qualquer lugar**
- ✅ Monitora a pasta que **você escolher**
- ✅ Configuração salva em `config.json`
- ✅ Fácil reconfiguração via GUI

### 🚀 Auto-Start (Windows)
- ✅ Um clique para iniciar com Windows
- ✅ Configuração via menu do ícone
- ✅ Gerenciamento via Registry

### 🛡️ Robusto e Seguro
- ✅ Detecta arquivos completamente escritos (não tenta mover arquivo parcial)
- ✅ Tratamento de erros completo
- ✅ Logs detalhados de todas as operações
- ✅ Sistema de logging isolado (sem conflitos)

---

## 📋 Requisitos

### Python
- Python 3.6 ou superior
- Pip (gerenciador de pacotes)

### Dependências Python
```bash
pip install watchdog pystray pillow
```

### Sistemas Operacionais
- ✅ **Windows** 10/11 (totalmente suportado)
- ✅ **Linux** (Ubuntu, Debian, Fedora, etc.)
- ⚠️ **macOS** (não testado, mas deve funcionar)

---

## 💾 Instalação

### Opção 1: Instalador Windows (Recomendado) 🎯

**Sem necessidade de instalar Python.**

1. **Baixe o instalador mais recente:**
   - Acesse: [Releases](https://github.com/fabri2896/organizador-de-capturas/releases/latest)
   - Baixe: `OrganizadorCapturas.exe`

2. **Execute e siga o assistente:**
   - Escolha **"Instalar para todos os usuários"** (pede admin) ou **"Apenas para mim"** (sem admin)
   - Confirme ou **altere a pasta de instalação**
   - Marque **"Iniciar o Organizador automaticamente com o Windows"** se quiser que ele abra junto com o sistema
   - Opcional: atalho na Área de Trabalho

O instalador cria atalhos no Menu Iniciar, registra a entrada de auto-start no
`HKCU\Software\Microsoft\Windows\CurrentVersion\Run` e inclui desinstalador
(**Configurações → Aplicativos → Organizador de Capturas**).

### Opção 2: Código Fonte (Python)

**Para desenvolvedores ou usuários Linux:**

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/fabri2896/organizador-de-capturas.git
   cd organizador-de-capturas
   ```

2. **Instale as dependências:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Execute:**
   ```bash
   # Windows
   python organizador_tray.py
   
   # Linux
   python3 organizador_tray.py
   ```

---

## 🎮 Uso

### Windows (versão instalada)

Depois de instalar, o programa já sobe e fica na bandeja. O ícone é uma pasta
verde com uma foto dentro — no Windows 11 ele pode começar no menu **"︿"**
(ícones ocultos), ao lado do relógio.

**Menu do ícone (botão direito):**

| Item | O que faz |
|---|---|
| **Ver Logs e Status** | janela com o que foi organizado (duplo clique também abre) |
| **⏸️ Pausar / ▶️ Retomar** | interrompe e retoma a organização |
| **⚙️ Configurar Pasta** | troca a pasta monitorada e organiza a nova |
| **🚀 Iniciar com Windows** | liga/desliga o auto-start (marca "∨" quando ativo) |
| **🚪 Sair** | encerra o programa |

**Cores do ícone:** verde = monitorando · amarelo = pausado · vermelho = parado.

### Linux (código fonte)

**Iniciar:**
```bash
python3 organizador_tray.py
```

**Controle via terminal:**
```bash
./scripts/controle.sh start    # Inicia em background
./scripts/controle.sh stop     # Para o organizador
./scripts/controle.sh restart  # Reinicia
./scripts/controle.sh status   # Verifica se está rodando
./scripts/controle.sh log      # Vê logs em tempo real
```

---

## ⚙️ Configuração

### Primeira Execução

Na primeira vez, o organizador perguntará qual pasta monitorar:

```
┌─────────────────────────────────────────┐
│  Bem-vindo ao Organizador de Capturas!  │
├─────────────────────────────────────────┤
│                                         │
│  Selecione a pasta para monitorar:     │
│                                         │
│  📁 C:\Users\Você\Box\Screenshots       │
│  📁 C:\Users\Você\Pictures\Screenshots  │
│  📁 Outra pasta...                      │
│                                         │
└─────────────────────────────────────────┘
```

### Reconfigurar Pasta

1. Clique com botão direito no ícone da bandeja
2. Selecione **"⚙️ Configurar Pasta"**
3. Escolha nova pasta
4. Reinicie o organizador

### Arquivo de Configuração

O arquivo `config.json` é criado automaticamente em:

```
%APPDATA%\OrganizadorCapturas\config.json
```

Junto dele ficam `organizador.log` (log rotativo) e `hash_cache.json`
(cache de duplicatas). Ficam fora da pasta de instalação justamente para
funcionarem quando o app é instalado em `Program Files`.

```json
{
    "pasta_monitorada": "C:\\Users\\Você\\Box\\Screenshots"
}
```

Você pode editá-lo manualmente se preferir. Versões antigas que salvavam o
`config.json` ao lado do executável são migradas automaticamente na primeira execução.

---

## 🎨 Menu do Ícone

Clique com **botão direito** no ícone da bandeja:

```
📌 Organizador de Capturas
━━━━━━━━━━━━━━━━━━━━━━━
📊 Ver Logs e Status
⏸️ Pausar
▶️ Retomar
━━━━━━━━━━━━━━━━━━━━━━━
⚙️ Configurar Pasta
✓ 🚀 Iniciar com Windows
━━━━━━━━━━━━━━━━━━━━━━━
🚪 Sair
```

### Opções do Menu

- **📊 Ver Logs e Status** - Abre janela com logs em tempo real e estatísticas
- **⏸️ Pausar** - Pausa temporariamente o monitoramento
- **▶️ Retomar** - Retoma o monitoramento
- **⚙️ Configurar Pasta** - Escolhe nova pasta para monitorar
- **🚀 Iniciar com Windows** - Habilita/desabilita auto-start (Windows)
- **🚪 Sair** - Encerra o organizador

---

## 📊 Janela de Logs

A janela de logs mostra:

```
┌────────────────────────────────────────────┐
│ Status                                     │
├────────────────────────────────────────────┤
│ Estado: ✅ ATIVO                           │
│ Pasta Monitorada: C:\...\Screenshots      │
│ Arquivos Organizados: 157                 │
│ Log File: organizador.log                 │
└────────────────────────────────────────────┘

┌────────────────────────────────────────────┐
│ Logs em Tempo Real                         │
├────────────────────────────────────────────┤
│ 2026-02-25 10:30:15 - 🆕 Novo arquivo...   │
│ 2026-02-25 10:30:16 - ✅ Organizado...     │
│ 2026-02-25 10:32:20 - 🗑️ Duplicata...     │
│                                            │
└────────────────────────────────────────────┘

[Limpar] [Atualizar] [Abrir Pasta] [Fechar]
```

---

## 🔧 Como Funciona

### 1. Monitoramento
O organizador usa a biblioteca **watchdog** para monitorar eventos de sistema de arquivos em tempo real:
- Detecta quando um arquivo é criado
- Detecta quando um arquivo é movido para a pasta

### 2. Validação
Antes de processar:
- ✅ Verifica se é uma imagem (`.png`, `.jpg`, `.jpeg`, `.gif`, `.bmp`, `.webp`)
- ✅ Espera arquivo ser completamente escrito (tamanho estável)
- ✅ Verifica se arquivo ainda existe

### 3. Anti-Duplicatas
- Gera hash MD5 do arquivo
- Compara com arquivos existentes na pasta destino
- Se duplicata detectada: remove e loga

### 4. Organização
- Extrai data do nome do arquivo (`YYYY-MM-DD`)
- Ou usa data de modificação como fallback
- Cria estrutura: `Ano/Mês-Nome/Dia/`
- Move arquivo para pasta correta

### 5. Logging
Todas as operações são registradas:
```
2026-02-25 10:30:15 - 👁️ Monitorando: C:\Users\...\Screenshots
2026-02-25 10:30:16 - 🆕 Novo arquivo detectado: captura.png
2026-02-25 10:30:16 - ✅ Organizado: captura.png → 2026/02-Fevereiro/25/
2026-02-25 10:32:20 - 🗑️ Duplicata detectada: captura_copia.png - Removendo
```

---

## 🌟 Integração com Greenshot

O organizador funciona perfeitamente com **Greenshot** (ou qualquer ferramenta de captura):

### Configuração Greenshot:

1. Abra **Greenshot Preferences**
2. Vá em **Output** → **Destination**
3. Marque **"Save as"**
4. Configure o caminho para a pasta monitorada
5. Em **Filename pattern**, use:
   ```
   ${YYYY}-${MM}-${DD} ${hh}_${mm}_${ss}-${title}
   ```

Agora toda captura que você fizer será **automaticamente organizada**! 🎉

---

## 📂 Estrutura do Projeto

```
organizador-de-capturas/
├── organizador_tray.py          # Programa principal (tray + organização)
├── OrganizadorCapturas.spec     # Receita do PyInstaller
├── app.ico                      # Ícone do EXE (gerado por scripts/gerar_assets.py)
├── version_info.txt             # Metadados de versão do EXE
├── requirements.txt             # Dependências Python
├── README.md                    # Este arquivo
├── LICENSE                      # Licença MIT
├── docs/                        # Documentação para o usuário
│   ├── LEIA-ME.txt
│   ├── COMO-USAR.txt
│   ├── INSTRUCOES-WINDOWS.txt
│   ├── GERENCIAR-AUTO-START.txt
│   ├── ANTIVIRUS-BLOQUEOU.txt
│   └── COMO-ASSINAR-EXE.txt
├── scripts/
│   ├── build.bat                # Build completo: EXE + instalador
│   ├── gerar_assets.py          # Gera app.ico e artes do instalador
│   ├── installer.iss            # Instalador (Inno Setup 6)
│   ├── wizard.png               # Arte do assistente (gerada)
│   ├── wizsmall.png             # Arte pequena (gerada)
│   ├── iniciar_organizador.bat  # Iniciar sem instalar (código fonte)
│   ├── iniciar_organizador.sh   # Iniciar no Linux
│   └── controle.sh              # start/stop/status/log (Linux)
└── tests/
    └── test_organizador.py      # Testes (rode sem pytest, veja abaixo)
```

**Arquivos criados em tempo de execução** (em `%APPDATA%\OrganizadorCapturas\`):

```
config.json         # Pasta monitorada e preferências
organizador.log     # Log de operações (rotativo)
hash_cache.json     # Cache de duplicatas
```

### Desenvolvimento

```bash
# Testes (não precisa de pytest, roda direto)
python tests/test_organizador.py

# Build completo: gera o EXE e o instalador
scripts\build.bat
```

O `build.bat` roda `scripts/gerar_assets.py` (ícone a partir do código),
o PyInstaller e o Inno Setup, nessa ordem. O resultado do instalador sai em
`Output\OrganizadorCapturas-<versão>-Setup.exe`.

---

## 🤝 Contribuir

Contribuições são muito bem-vindas! 🎉

### Como contribuir:

1. Fork este repositório
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Add: Minha feature incrível'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Ideias de melhorias:

- [ ] Suporte para mais formatos de arquivo (vídeos, documentos)
- [ ] Monitoramento de multiplas pastas
- [ ] Interface web para visualizar capturas organizadas
- [ ] Compressão automática de imagens antigas
- [ ] Integração com serviços de nuvem (Google Drive, Dropbox)
- [ ] Modo "galeria" para visualização rápida
- [ ] Temas personalizáveis para a GUI

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 🙏 Créditos

**Idealização, testes e decisões de produto:** [fabri2896](https://github.com/fabri2896)

**Implementação, correções e documentação:** fabri2896 + **DeepSeek** (modelo de IA, via DeepSeek Harness)

O programa, o ícone (desenhado por código em `desenhar_icone`), o instalador e a
documentação foram feitos nessa parceria. O histórico completo fica nos commits.

### Bibliotecas utilizadas:
- [watchdog](https://github.com/gorakhargosh/watchdog) - Monitoramento de sistema de arquivos
- [pystray](https://github.com/moses-palmer/pystray) - Ícone na bandeja do sistema
- [Pillow](https://github.com/python-pillow/Pillow) - Processamento de imagens

---

## ❓ FAQ

### O organizador funciona com capturas do Greenshot?
✅ Sim! Funciona com qualquer ferramenta de captura. Configure para salvar na pasta monitorada.

### Posso monitorar várias pastas?
⚠️ Atualmente apenas uma pasta. E na att 2.0.4 impede multipla instacias .

### O que acontece se eu desligar o computador?
✅ Se configurou auto-start, o organizador inicia automaticamente na próxima vez.

### Ele organiza capturas antigas?
⚠️ Não automaticamente. Ele só monitora novos arquivos. Mas você pode mover capturas antigas para a pasta e ele organizará.

### Posso desabilitar a detecção de duplicatas?
Atualmente não há opção, mas é fácil modificar o código (comentar a seção de hash).

### O script consome muitos recursos?
❌ Não! Usa menos de 30MB de RAM e CPU mínima (só processa quando detecta arquivo novo).

---

## 📧 Contato

Tem dúvidas? Sugestões? Bugs?

- 🐛 **Issues**: [GitHub Issues](https://github.com/fabri2896/organizador-de-capturas/issues)
- 💬 **Discussões**: [GitHub Discussions](https://github.com/fabri2896/organizador-de-capturas/discussions)

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela no GitHub! ⭐**

Made with ❤️ and Python 🐍

</div>
