# Release v1.0.1 - Versão Estável 🚀

Esta é a primeira versão oficial do **Organizador de Capturas de Tela**. Esta versão foca em estabilidade, facilidade de uso e melhorias na detecção por antivírus.

## ✨ O que há de novo?
- **Interface na Bandeja do Sistema:** Ícone em formato de pasta (📁) que muda de cor conforme o status.
- **Organização Inteligente:** Capturas são movidas automaticamente para pastas estruturadas: `Ano > Mês > Dia`.
- **Remoção de Duplicatas:** Sistema baseado em hash MD5 para economizar espaço em disco.
- **Instalação Profissional:** Script de instalação Inno Setup incluído.
- **Bypass de Antivírus:** Compilação otimizada para evitar falsos positivos no Kaspersky e outros.
- **Auto-Inicialização Flexível:** Suporte para registro do Windows e fallback para pasta 'Startup' caso não tenha permissão de admin.

## 📦 Como instalar
1. Baixe o arquivo `OrganizadorCapturas-v1.0.1-Windows.zip` abaixo.
2. Extraia o conteúdo em uma pasta de sua preferência.
3. Execute o `instalador.exe` ou simplesmente abra a pasta extraída e execute o `Organizador_Tray.exe`.

## 🛠️ Notas Técnicas
- **Método de Compilação:** `--onedir` para melhor compatibilidade com antivírus.
- **Dependências:** O pacote já inclui todas as bibliotecas necessárias (Watchdog, Pystray, Pillow).

---
**Desenvolvido por:** [Fabrício Moreira Pires](https://github.com/fabri2896)
