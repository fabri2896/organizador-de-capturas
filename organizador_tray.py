#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Organizador Automático de Capturas de Tela - v2.0
Aplicativo com ícone na bandeja do sistema
Agora com configuração de pasta e GUI de logs!
"""

import os
import sys
import re
import shutil
import time
import threading
import logging
import json
import hashlib
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext, ttk
from pathlib import Path
from datetime import datetime
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from PIL import Image, ImageDraw
import pystray

# Para Windows registry (auto-start)
if sys.platform == 'win32':
    import winreg

# Mapeamento de meses em português
MESES = {
    '01': 'Janeiro', '02': 'Fevereiro', '03': 'Março',
    '04': 'Abril', '05': 'Maio', '06': 'Junho',
    '07': 'Julho', '08': 'Agosto', '09': 'Setembro',
    '10': 'Outubro', '11': 'Novembro', '12': 'Dezembro'
}


class WindowsAutoStart:
    """Gerencia auto-start no Windows via Registry"""
    
    APP_NAME = "OrganizadorCapturas"
    
    @staticmethod
    def esta_habilitado():
        """Verifica se auto-start está habilitado"""
        if sys.platform != 'win32':
            return False
        
        try:
            key = winreg.OpenKey(
                winreg.HKEY_CURRENT_USER,
                r"Software\Microsoft\Windows\CurrentVersion\Run",
                0,
                winreg.KEY_READ
            )
            try:
                winreg.QueryValueEx(key, WindowsAutoStart.APP_NAME)
                winreg.CloseKey(key)
                return True
            except FileNotFoundError:
                winreg.CloseKey(key)
                return False
        except Exception:
            return False
    
    @staticmethod
    def habilitar(script_path):
        """Habilita auto-start no Windows"""
        if sys.platform != 'win32':
            return False, "Sistema operacional não é Windows"
        
        try:
            # Comando para executar com pythonw (sem janela)
            comando = f'pythonw "{script_path}"'
            
            key = winreg.OpenKey(
                winreg.HKEY_CURRENT_USER,
                r"Software\Microsoft\Windows\CurrentVersion\Run",
                0,
                winreg.KEY_SET_VALUE
            )
            winreg.SetValueEx(key, WindowsAutoStart.APP_NAME, 0, winreg.REG_SZ, comando)
            winreg.CloseKey(key)
            
            return True, "Auto-start habilitado com sucesso!"
        except Exception as e:
            return False, f"Erro ao habilitar auto-start: {e}"
    
    @staticmethod
    def desabilitar():
        """Desabilita auto-start no Windows"""
        if sys.platform != 'win32':
            return False, "Sistema operacional não é Windows"
        
        try:
            key = winreg.OpenKey(
                winreg.HKEY_CURRENT_USER,
                r"Software\Microsoft\Windows\CurrentVersion\Run",
                0,
                winreg.KEY_SET_VALUE
            )
            try:
                winreg.DeleteValue(key, WindowsAutoStart.APP_NAME)
                winreg.CloseKey(key)
                return True, "Auto-start desabilitado com sucesso!"
            except FileNotFoundError:
                winreg.CloseKey(key)
                return True, "Auto-start já estava desabilitado"
        except Exception as e:
            return False, f"Erro ao desabilitar auto-start: {e}"


class ConfigManager:
    """Gerencia a configuração do aplicativo"""
    
    def __init__(self, config_file="config.json"):
        self.script_dir = Path(__file__).parent
        self.config_file = self.script_dir / config_file
        self.config = self.load_config()
    
    def load_config(self):
        """Carrega configuração do arquivo"""
        if self.config_file.exists():
            try:
                with open(self.config_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except Exception as e:
                print(f"Erro ao carregar configuração: {e}")
                return {}
        return {}
    
    def save_config(self):
        """Salva configuração no arquivo"""
        try:
            with open(self.config_file, 'w', encoding='utf-8') as f:
                json.dump(self.config, f, indent=4, ensure_ascii=False)
        except Exception as e:
            print(f"Erro ao salvar configuração: {e}")
    
    def get_pasta_monitorada(self):
        """Retorna a pasta monitorada configurada"""
        return self.config.get('pasta_monitorada')
    
    def set_pasta_monitorada(self, pasta):
        """Define a pasta monitorada"""
        self.config['pasta_monitorada'] = str(pasta)
        self.save_config()


class LogHandler(logging.Handler):
    """Handler customizado para enviar logs para a GUI"""
    
    def __init__(self):
        super().__init__()
        self.log_callback = None
    
    def emit(self, record):
        if self.log_callback:
            msg = self.format(record)
            self.log_callback(msg)


class LogWindow:
    """Janela de visualização de logs"""
    
    def __init__(self, organizador):
        self.organizador = organizador
        self.window = None
        self.text_area = None
        self.max_lines = 500
    
    def create_window(self):
        """Cria a janela de logs"""
        if self.window is not None:
            try:
                self.window.lift()
                self.window.focus_force()
                return
            except:
                pass
        
        self.window = tk.Tk()
        self.window.title("Organizador de Capturas - Logs e Status")
        self.window.geometry("700x500")
        
        # Frame de status
        status_frame = ttk.LabelFrame(self.window, text="Status", padding=10)
        status_frame.pack(fill=tk.X, padx=10, pady=5)
        
        status_info = f"""
Estado: {'⏸️ PAUSADO' if self.organizador.pausado else '✅ ATIVO'}
Pasta Monitorada: {self.organizador.pasta_monitorada}
Arquivos Organizados: {self.organizador.total_organizados}
Log File: {self.organizador.log_file}
        """.strip()
        
        status_label = ttk.Label(status_frame, text=status_info, justify=tk.LEFT)
        status_label.pack()
        
        # Frame de logs
        log_frame = ttk.LabelFrame(self.window, text="Logs em Tempo Real", padding=10)
        log_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        # Área de texto com scroll
        self.text_area = scrolledtext.ScrolledText(
            log_frame,
            wrap=tk.WORD,
            font=("Consolas", 9),
            bg="#1e1e1e",
            fg="#d4d4d4"
        )
        self.text_area.pack(fill=tk.BOTH, expand=True)
        
        # Carrega últimas linhas do log
        self.load_recent_logs()
        
        # Frame de botões
        button_frame = ttk.Frame(self.window)
        button_frame.pack(fill=tk.X, padx=10, pady=5)
        
        ttk.Button(button_frame, text="Limpar", command=self.clear_logs).pack(side=tk.LEFT, padx=5)
        ttk.Button(button_frame, text="Atualizar", command=self.refresh_status).pack(side=tk.LEFT, padx=5)
        ttk.Button(button_frame, text="Abrir Pasta", command=self.open_folder).pack(side=tk.LEFT, padx=5)
        ttk.Button(button_frame, text="Fechar", command=self.close_window).pack(side=tk.RIGHT, padx=5)
        
        self.window.protocol("WM_DELETE_WINDOW", self.close_window)
        
        # Conecta o callback de logs
        self.organizador.log_handler.log_callback = self.append_log
        
        self.window.mainloop()
    
    def load_recent_logs(self):
        """Carrega últimas linhas do arquivo de log"""
        if self.organizador.log_file.exists():
            try:
                with open(self.organizador.log_file, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    recent_lines = lines[-100:]  # Últimas 100 linhas
                    for line in recent_lines:
                        self.text_area.insert(tk.END, line)
                    self.text_area.see(tk.END)
            except Exception as e:
                self.append_log(f"Erro ao carregar logs: {e}\n")
    
    def append_log(self, message):
        """Adiciona mensagem ao log"""
        if self.text_area:
            try:
                self.text_area.insert(tk.END, message + "\n")
                self.text_area.see(tk.END)
                
                # Limita número de linhas
                lines = int(self.text_area.index('end-1c').split('.')[0])
                if lines > self.max_lines:
                    self.text_area.delete('1.0', f'{lines - self.max_lines}.0')
            except:
                pass
    
    def clear_logs(self):
        """Limpa a área de logs"""
        if self.text_area:
            self.text_area.delete('1.0', tk.END)
    
    def refresh_status(self):
        """Atualiza informações de status"""
        self.close_window()
        self.create_window()
    
    def open_folder(self):
        """Abre a pasta monitorada no explorer"""
        try:
            if sys.platform == 'win32':
                os.startfile(self.organizador.pasta_monitorada)
            elif sys.platform == 'darwin':
                os.system(f'open "{self.organizador.pasta_monitorada}"')
            else:
                os.system(f'xdg-open "{self.organizador.pasta_monitorada}"')
        except Exception as e:
            messagebox.showerror("Erro", f"Não foi possível abrir a pasta:\n{e}")
    
    def close_window(self):
        """Fecha a janela"""
        if self.window:
            self.organizador.log_handler.log_callback = None
            self.window.destroy()
            self.window = None
            self.text_area = None


class OrganizadorCapturas:
    def __init__(self, pasta_monitorada, script_dir):
        self.pasta_monitorada = Path(pasta_monitorada)
        self.script_dir = Path(script_dir)
        self.ativo = True
        self.pausado = False
        self.total_organizados = 0
        self.observer = None
        
        # Configura logging (agora salva no diretório do script)
        self.log_file = self.script_dir / 'organizador.log'
        
        # Cria logger dedicado (evita conflitos de basicConfig)
        self.logger = logging.getLogger('OrganizadorCapturas')
        self.logger.setLevel(logging.INFO)
        
        # Remove handlers antigos (caso script seja reiniciado)
        if self.logger.handlers:
            self.logger.handlers.clear()
        
        # Handler customizado para GUI
        self.log_handler = LogHandler()
        self.log_handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
        
        # Handler para arquivo
        file_handler = logging.FileHandler(self.log_file, encoding='utf-8')
        file_handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
        
        # Handler para console
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
        
        # Adiciona todos os handlers
        self.logger.addHandler(file_handler)
        self.logger.addHandler(console_handler)
        self.logger.addHandler(self.log_handler)
        
        # Evita propagação para o logger raiz
        self.logger.propagate = False
        
    def extrair_data_do_nome(self, nome_arquivo):
        """Extrai a data do nome do arquivo"""
        padrao = r'(\d{4})-(\d{2})-(\d{2})'
        match = re.search(padrao, nome_arquivo)
        if match:
            return match.groups()
        return None, None, None
    
    def obter_data_modificacao(self, caminho_arquivo):
        """Obtém a data de modificação do arquivo"""
        timestamp = os.path.getmtime(caminho_arquivo)
        data = datetime.fromtimestamp(timestamp)
        return str(data.year), f"{data.month:02d}", f"{data.day:02d}"
    
    def gerar_hash(self, caminho):
        """
        Gera hash MD5 do arquivo para detectar duplicatas.
        
        Args:
            caminho: Caminho do arquivo
            
        Returns:
            String com hash MD5 ou None se erro
        """
        try:
            hash_md5 = hashlib.md5()
            with open(caminho, "rb") as f:
                for chunk in iter(lambda: f.read(4096), b""):
                    hash_md5.update(chunk)
            return hash_md5.hexdigest()
        except Exception as e:
            self.logger.error(f"❌ Erro ao gerar hash de '{caminho}': {e}")
            return None
    
    def arquivo_duplicado_existe(self, hash_arquivo, pasta_destino):
        """
        Verifica se já existe arquivo com mesmo hash na pasta destino.
        
        Args:
            hash_arquivo: Hash MD5 do arquivo
            pasta_destino: Pasta onde procurar duplicatas
            
        Returns:
            Path do arquivo duplicado ou None
        """
        if not pasta_destino.exists():
            return None
        
        try:
            for arquivo_existente in pasta_destino.glob('*'):
                if arquivo_existente.is_file():
                    hash_existente = self.gerar_hash(str(arquivo_existente))
                    if hash_existente == hash_arquivo:
                        return arquivo_existente
        except Exception as e:
            self.logger.error(f"❌ Erro ao verificar duplicatas: {e}")
        
        return None
    
    def esperar_arquivo_estavel(self, caminho, timeout=10):
        """
        Espera até que o arquivo esteja completamente escrito.
        Verifica se o tamanho do arquivo se estabilizou.
        
        Args:
            caminho: Caminho do arquivo
            timeout: Tempo máximo de espera em segundos
            
        Returns:
            True se arquivo está estável, False se timeout
        """
        tamanho_anterior = -1
        inicio = time.time()
        
        while time.time() - inicio < timeout:
            try:
                # Verifica se arquivo ainda existe
                if not os.path.exists(caminho):
                    self.logger.warning(f"⚠️  Arquivo desapareceu: {caminho}")
                    return False
                
                tamanho_atual = os.path.getsize(caminho)
                
                # Se tamanho não mudou, arquivo está pronto
                if tamanho_atual == tamanho_anterior and tamanho_atual > 0:
                    return True
                
                tamanho_anterior = tamanho_atual
                time.sleep(0.3)
                
            except (OSError, FileNotFoundError) as e:
                self.logger.warning(f"⚠️  Erro ao verificar arquivo: {e}")
                return False
        
        # Timeout - mas arquivo pode estar OK se for muito grande
        self.logger.warning(f"⚠️  Timeout ao aguardar estabilização de {caminho}")
        return True  # Tenta processar mesmo assim
    
    def organizar_arquivo(self, caminho_arquivo):
        """Organiza um arquivo específico"""
        if self.pausado:
            return
        
        arquivo = Path(caminho_arquivo)
        
        # Extensões de imagem suportadas
        extensoes_imagem = {'.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp'}
        
        if arquivo.suffix.lower() not in extensoes_imagem:
            return
        
        # Ignora arquivos que já estão dentro da pasta organizada (mais robusto)
        try:
            if self.pasta_monitorada in arquivo.parents:
                # Verifica se está em subpasta (já organizado)
                if len(arquivo.relative_to(self.pasta_monitorada).parts) > 1:
                    return
        except (ValueError, OSError):
            # Se não conseguir verificar, continua processando
            pass
        
        # Tenta extrair data do nome
        ano, mes, dia = self.extrair_data_do_nome(arquivo.name)
        
        # Se não conseguir, usa data de modificação
        if not ano:
            ano, mes, dia = self.obter_data_modificacao(arquivo)
        
        # Cria estrutura de pastas
        mes_nome = MESES.get(mes, mes)
        pasta_destino = self.pasta_monitorada / ano / f"{mes}-{mes_nome}" / dia
        pasta_destino.mkdir(parents=True, exist_ok=True)
        
        # Move o arquivo
        destino = pasta_destino / arquivo.name
        
        # Evita sobrescrever
        contador = 1
        while destino.exists():
            nome_base = arquivo.stem
            extensao = arquivo.suffix
            destino = pasta_destino / f"{nome_base}_{contador}{extensao}"
            contador += 1
        
        try:
            # Verifica se arquivo está completamente escrito (robusto para arquivos grandes)
            if not self.esperar_arquivo_estavel(str(arquivo)):
                self.logger.warning(f"⚠️  Arquivo ainda está sendo escrito, pulando: {arquivo.name}")
                return
            
            # Verifica se arquivo ainda existe (pode ter sido movido/deletado)
            if not arquivo.exists():
                self.logger.warning(f"⚠️  Arquivo não existe mais: {arquivo.name}")
                return
            
            # ANTI-DUPLICADO: Verifica se já existe arquivo idêntico na pasta destino
            hash_arquivo = self.gerar_hash(str(arquivo))
            if hash_arquivo:
                arquivo_duplicado = self.arquivo_duplicado_existe(hash_arquivo, pasta_destino)
                if arquivo_duplicado:
                    self.logger.warning(
                        f"🗑️  Duplicata detectada: '{arquivo.name}' é idêntico a '{arquivo_duplicado.name}' - Removendo duplicata"
                    )
                    try:
                        arquivo.unlink()  # Remove o arquivo duplicado
                        self.logger.info(f"✅ Arquivo duplicado removido: {arquivo.name}")
                        return
                    except Exception as e:
                        self.logger.error(f"❌ Erro ao remover duplicata '{arquivo.name}': {e}")
                        # Continua para mover mesmo assim
            
            # Move o arquivo
            shutil.move(str(arquivo), str(destino))
            self.total_organizados += 1
            self.logger.info(f"✅ Organizado: {arquivo.name} → {ano}/{mes}-{mes_nome}/{dia}/")
            
        except PermissionError:
            self.logger.error(f"❌ Sem permissão para mover '{arquivo.name}' (arquivo em uso?)")
        except FileNotFoundError:
            self.logger.error(f"❌ Arquivo não encontrado: '{arquivo.name}'")
        except Exception as e:
            self.logger.error(f"❌ Erro ao organizar '{arquivo.name}': {e}")
    
    def pausar(self):
        """Pausa o monitoramento"""
        self.pausado = True
        self.logger.info("⏸️  Monitoramento pausado")
    
    def retomar(self):
        """Retoma o monitoramento"""
        self.pausado = False
        self.logger.info("▶️  Monitoramento retomado")
    
    def parar(self):
        """Para o monitoramento"""
        self.ativo = False
        if self.observer:
            self.observer.stop()
            self.observer.join()
        self.logger.info(f"🛑 Monitoramento encerrado. Total organizado: {self.total_organizados}")


class ManipuladorArquivos(FileSystemEventHandler):
    """Manipulador de eventos do watchdog"""
    
    def __init__(self, organizador):
        self.organizador = organizador
    
    def on_created(self, event):
        """Chamado quando um arquivo é criado"""
        if not event.is_directory:
            self.organizador.logger.info(f"🆕 Novo arquivo detectado: {event.src_path}")
            self.organizador.organizar_arquivo(event.src_path)
    
    def on_moved(self, event):
        """Chamado quando um arquivo é movido"""
        if not event.is_directory:
            # Verifica se o arquivo foi movido PARA a pasta monitorada
            dest_path = Path(event.dest_path)
            if dest_path.parent == self.organizador.pasta_monitorada:
                self.organizador.logger.info(f"📁 Arquivo movido para pasta: {event.dest_path}")
                self.organizador.organizar_arquivo(event.dest_path)


class AplicativoTray:
    """Aplicativo com ícone na bandeja do sistema"""
    
    def __init__(self, pasta_monitorada, script_dir):
        self.script_dir = script_dir
        self.organizador = OrganizadorCapturas(pasta_monitorada, script_dir)
        self.icon = None
        self.log_window = LogWindow(self.organizador)
        
    def criar_icone(self, cor="green"):
        """Cria um ícone com emoji de pasta 📁"""
        # Cria uma imagem 64x64 com transparência
        img = Image.new('RGBA', (64, 64), color=(255, 255, 255, 0))
        draw = ImageDraw.Draw(img)
        
        # Cores dinâmicas
        cores = {
            "green": "#4CAF50",
            "yellow": "#FFC107",
            "red": "#F44336"
        }
        cor_atual = cores.get(cor, "#4CAF50")
        
        # Desenha a pasta (corpo principal)
        draw.rounded_rectangle([10, 20, 54, 54], radius=3, fill=cor_atual)
        
        # Desenha a aba da pasta
        draw.rounded_rectangle([10, 16, 35, 24], radius=2, fill=cor_atual)
        
        # Adiciona um brilho/destaque
        draw.rounded_rectangle([14, 24, 50, 30], radius=2, fill=(255, 255, 255, 80))
        
        # Desenha linhas simulando documentos dentro da pasta
        linha_cor = (255, 255, 255, 150)
        draw.line([20, 36, 44, 36], fill=linha_cor, width=2)
        draw.line([20, 42, 44, 42], fill=linha_cor, width=2)
        draw.line([20, 48, 38, 48], fill=linha_cor, width=2)
        
        return img
    
    def iniciar_monitoramento(self):
        """Inicia o monitoramento em thread separada"""
        event_handler = ManipuladorArquivos(self.organizador)
        self.organizador.observer = Observer()
        self.organizador.observer.schedule(
            event_handler,
            str(self.organizador.pasta_monitorada),
            recursive=False
        )
        self.organizador.observer.start()
        self.organizador.logger.info(f"👁️  Monitorando: {self.organizador.pasta_monitorada}")
    
    def pausar_monitoramento(self, icon, item):
        """Pausa o monitoramento"""
        self.organizador.pausar()
        self.atualizar_icone("yellow")
    
    def retomar_monitoramento(self, icon, item):
        """Retoma o monitoramento"""
        self.organizador.retomar()
        self.atualizar_icone("green")
    
    def mostrar_status(self, icon, item):
        """Abre janela de logs e status"""
        # Cria thread para GUI (para não bloquear o ícone)
        thread = threading.Thread(target=self.log_window.create_window, daemon=True)
        thread.start()
    
    def configurar_pasta(self, icon, item):
        """Permite reconfigurar a pasta monitorada"""
        root = tk.Tk()
        root.withdraw()
        
        nova_pasta = filedialog.askdirectory(
            title="Selecione a pasta para monitorar",
            initialdir=self.organizador.pasta_monitorada
        )
        
        if nova_pasta:
            # Salva nova configuração
            config_manager = ConfigManager()
            config_manager.set_pasta_monitorada(nova_pasta)
            
            messagebox.showinfo(
                "Configuração Atualizada",
                f"Nova pasta configurada:\n{nova_pasta}\n\n"
                "Reinicie o aplicativo para aplicar as mudanças."
            )
        
        root.destroy()
    
    def toggle_autostart(self, icon, item):
        """Habilita/desabilita auto-start no Windows"""
        if sys.platform != 'win32':
            messagebox.showerror(
                "Não Disponível",
                "Auto-start só está disponível no Windows."
            )
            return
        
        script_path = Path(__file__).resolve()
        
        if WindowsAutoStart.esta_habilitado():
            # Desabilitar
            sucesso, mensagem = WindowsAutoStart.desabilitar()
            if sucesso:
                self.organizador.logger.info(f"⚙️  Auto-start desabilitado")
                messagebox.showinfo("Auto-start Desabilitado", mensagem)
            else:
                messagebox.showerror("Erro", mensagem)
        else:
            # Habilitar
            sucesso, mensagem = WindowsAutoStart.habilitar(str(script_path))
            if sucesso:
                self.organizador.logger.info(f"⚙️  Auto-start habilitado")
                messagebox.showinfo(
                    "Auto-start Habilitado",
                    f"{mensagem}\n\nO organizador iniciará automaticamente quando você ligar o computador!"
                )
            else:
                # Se falhar (acesso negado), oferecer método alternativo
                if "Acesso negado" in mensagem or "WinError 5" in mensagem:
                    resposta = messagebox.askyesno(
                        "Permissão Necessária",
                        "❌ Erro de permissão ao acessar o Registry.\n\n"
                        "SOLUÇÃO 1 (Recomendada):\n"
                        "• Feche o organizador\n"
                        "• Clique com BOTÃO DIREITO no EXE\n"
                        "• Selecione 'Executar como Administrador'\n"
                        "• Configure o auto-start novamente\n\n"
                        "SOLUÇÃO 2 (Alternativa):\n"
                        "Usar pasta Inicializar do Windows?\n"
                        "(Menos confiável, mas não precisa de admin)\n\n"
                        "Deseja tentar a Solução 2 agora?"
                    )
                    
                    if resposta:
                        # Método alternativo: criar atalho na pasta Startup
                        sucesso_alt = self.criar_atalho_startup(script_path)
                        if sucesso_alt:
                            messagebox.showinfo(
                                "Auto-start Configurado!",
                                "✅ Atalho criado na pasta Inicializar!\n\n"
                                "O organizador iniciará automaticamente na próxima vez que você ligar o PC.\n\n"
                                "Localização:\n"
                                "%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
                            )
                        else:
                            messagebox.showerror(
                                "Erro",
                                "Não foi possível criar o atalho.\n"
                                "Tente executar como Administrador."
                            )
                else:
                    messagebox.showerror("Erro", mensagem)
    
    def criar_atalho_startup(self, script_path):
        """Cria atalho na pasta Startup do Windows (método alternativo)"""
        try:
            import win32com.client
            
            # Obtém pasta Startup
            startup_folder = Path(os.environ['APPDATA']) / 'Microsoft' / 'Windows' / 'Start Menu' / 'Programs' / 'Startup'
            shortcut_path = startup_folder / 'OrganizadorCapturas.lnk'
            
            # Cria o atalho
            shell = win32com.client.Dispatch("WScript.Shell")
            shortcut = shell.CreateShortCut(str(shortcut_path))
            shortcut.Targetpath = str(script_path)
            shortcut.WorkingDirectory = str(script_path.parent)
            shortcut.WindowStyle = 7  # Minimizado
            shortcut.Description = "Organizador Automático de Capturas de Tela"
            shortcut.save()
            
            return True
        except Exception as e:
            self.organizador.logger.error(f"Erro ao criar atalho: {e}")
            
            # Se win32com não estiver disponível, tenta método simples
            try:
                startup_folder = Path(os.environ['APPDATA']) / 'Microsoft' / 'Windows' / 'Start Menu' / 'Programs' / 'Startup'
                shortcut_path = startup_folder / 'OrganizadorCapturas.lnk'
                
                # Usa comando PowerShell como fallback
                import subprocess
                ps_command = f'''
                $WshShell = New-Object -ComObject WScript.Shell
                $Shortcut = $WshShell.CreateShortcut("{shortcut_path}")
                $Shortcut.TargetPath = "{script_path}"
                $Shortcut.WorkingDirectory = "{script_path.parent}"
                $Shortcut.WindowStyle = 7
                $Shortcut.Save()
                '''
                subprocess.run(['powershell', '-Command', ps_command], check=True, capture_output=True)
                return True
            except Exception as e2:
                self.organizador.logger.error(f"Erro no fallback: {e2}")
                return False
    
    def sair(self, icon, item):
        """Encerra o aplicativo"""
        self.organizador.logger.info("👋 Encerrando aplicativo...")
        self.organizador.parar()
        icon.stop()
    
    def atualizar_icone(self, cor):
        """Atualiza a cor do ícone"""
        if self.icon:
            self.icon.icon = self.criar_icone(cor)
    
    def executar(self):
        """Executa o aplicativo"""
        # Inicia o monitoramento
        self.iniciar_monitoramento()
        
        # Cria o menu (com checkbox dinâmico para auto-start)
        menu = pystray.Menu(
            pystray.MenuItem(
                "Organizador de Capturas",
                self.mostrar_status,
                default=True
            ),
            pystray.Menu.SEPARATOR,
            pystray.MenuItem(
                "📊 Ver Logs e Status",
                self.mostrar_status
            ),
            pystray.MenuItem(
                "⏸️ Pausar",
                self.pausar_monitoramento
            ),
            pystray.MenuItem(
                "▶️ Retomar",
                self.retomar_monitoramento
            ),
            pystray.Menu.SEPARATOR,
            pystray.MenuItem(
                "⚙️ Configurar Pasta",
                self.configurar_pasta
            ),
            pystray.MenuItem(
                "🚀 Iniciar com Windows",
                self.toggle_autostart,
                checked=lambda item: WindowsAutoStart.esta_habilitado() if sys.platform == 'win32' else False
            ),
            pystray.Menu.SEPARATOR,
            pystray.MenuItem(
                "🚪 Sair",
                self.sair
            )
        )
        
        # Cria o ícone na bandeja
        self.icon = pystray.Icon(
            "organizador_capturas",
            self.criar_icone("green"),
            "Organizador de Capturas - Ativo",
            menu
        )
        
        self.organizador.logger.info("="*60)
        self.organizador.logger.info("🚀 ORGANIZADOR DE CAPTURAS INICIADO")
        self.organizador.logger.info("="*60)
        self.organizador.logger.info(f"📁 Pasta monitorada: {self.organizador.pasta_monitorada}")
        self.organizador.logger.info(f"📝 Log salvo em: {self.organizador.log_file}")
        self.organizador.logger.info("💡 O aplicativo está rodando na bandeja do sistema")
        self.organizador.logger.info("💡 Clique com botão direito no ícone para ver opções")
        self.organizador.logger.info("="*60)
        
        # Roda o aplicativo
        self.icon.run()


def selecionar_pasta_inicial():
    """Interface para selecionar pasta na primeira execução"""
    root = tk.Tk()
    root.withdraw()
    
    messagebox.showinfo(
        "Bem-vindo ao Organizador de Capturas!",
        "Primeira execução detectada.\n\n"
        "Por favor, selecione a pasta que você deseja monitorar.\n"
        "Suas capturas de tela serão organizadas automaticamente."
    )
    
    pasta = filedialog.askdirectory(
        title="Selecione a pasta para monitorar (ex: pasta do Box, Downloads, Pictures...)"
    )
    
    root.destroy()
    
    return pasta


if __name__ == "__main__":
    # Diretório do script
    script_dir = Path(__file__).parent
    
    # Gerenciador de configuração
    config_manager = ConfigManager()
    pasta_monitorada = config_manager.get_pasta_monitorada()
    
    # Se não tiver pasta configurada, pede ao usuário
    if not pasta_monitorada:
        pasta_monitorada = selecionar_pasta_inicial()
        
        if not pasta_monitorada:
            print("❌ Nenhuma pasta selecionada. Encerrando...")
            sys.exit(1)
        
        config_manager.set_pasta_monitorada(pasta_monitorada)
        print(f"✅ Pasta configurada: {pasta_monitorada}")
    
    # Verifica se a pasta existe
    if not Path(pasta_monitorada).exists():
        print(f"⚠️  Pasta configurada não existe: {pasta_monitorada}")
        print("Por favor, reconfigure...")
        
        pasta_monitorada = selecionar_pasta_inicial()
        if not pasta_monitorada:
            sys.exit(1)
        
        config_manager.set_pasta_monitorada(pasta_monitorada)
    
    # Verifica se há suporte gráfico
    try:
        app = AplicativoTray(pasta_monitorada, script_dir)
        app.executar()
    except Exception as e:
        print(f"❌ Erro ao iniciar interface gráfica: {e}")
        print("💡 Seu sistema pode não ter suporte gráfico ou faltam bibliotecas")
        print("💡 Tente executar em um ambiente com interface gráfica")
        sys.exit(1)
