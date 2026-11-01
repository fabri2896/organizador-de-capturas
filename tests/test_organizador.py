"""
Testes unitários para o Organizador de Capturas de Tela.
Execute com:  python -m pytest tests/ -v
ou:           python tests/test_organizador.py
"""
import os
import sys
import tempfile
import hashlib
from pathlib import Path

# Adiciona a raiz do projeto ao path para importar o módulo
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from organizador_tray import OrganizadorCapturas, MESES


def test_meses_portugues():
    """Verifica se todos os 12 meses estao mapeados em portugues."""
    assert len(MESES) == 12
    assert MESES['01'] == 'Janeiro'
    assert MESES['02'] == 'Fevereiro'
    assert MESES['12'] == 'Dezembro'


def test_extrair_data_do_nome():
    """Testa extração de data do nome do arquivo (YYYY-MM-DD)."""
    organizador = OrganizadorCapturas.__new__(OrganizadorCapturas)

    # Data no inicio do nome
    ano, mes, dia = organizador.extrair_data_do_nome("2026-05-15 captura.png")
    assert (ano, mes, dia) == ("2026", "05", "15")

    # Data no meio do nome
    ano, mes, dia = organizador.extrair_data_do_nome("reuniao_2026-02-20_erro.png")
    assert (ano, mes, dia) == ("2026", "02", "20")

    # Sem data
    ano, mes, dia = organizador.extrair_data_do_nome("captura_sem_data.png")
    assert (ano, mes, dia) == (None, None, None)

    # Formato invalido (apenas numeros nao sao data valida)
    ano, mes, dia = organizador.extrair_data_do_nome("arquivo_123.png")
    assert (ano, mes, dia) == (None, None, None)


def test_gerar_hash():
    """Testa geracao de hash MD5 de um arquivo."""
    organizador = OrganizadorCapturas.__new__(OrganizadorCapturas)

    with tempfile.NamedTemporaryFile(delete=False, suffix=".png") as f:
        f.write(b"conteudo de teste para hash")
        tmp_path = f.name

    try:
        hash1 = organizador.gerar_hash(tmp_path)
        hash2 = organizador.gerar_hash(tmp_path)

        # Mesmo arquivo deve gerar o mesmo hash
        assert hash1 == hash2
        assert len(hash1) == 32  # MD5 = 32 hex chars
        assert hash1 == hashlib.md5(b"conteudo de teste para hash").hexdigest()
    finally:
        os.unlink(tmp_path)


def test_gerar_hash_arquivo_inexistente():
    """Hash de arquivo que nao existe deve retornar None."""
    organizador = OrganizadorCapturas.__new__(OrganizadorCapturas)
    resultado = organizador.gerar_hash("C:/arquivo/que/nao/existe.png")
    assert resultado is None


def test_obter_data_modificacao():
    """Testa obtencao de data de modificacao do arquivo."""
    organizador = OrganizadorCapturas.__new__(OrganizadorCapturas)

    with tempfile.NamedTemporaryFile(delete=False, suffix=".png") as f:
        f.write(b"dados")
        tmp_path = f.name

    try:
        ano, mes, dia = organizador.obter_data_modificacao(tmp_path)
        assert ano.isdigit() and len(ano) == 4
        assert mes.isdigit() and len(mes) == 2
        assert dia.isdigit() and len(dia) == 2
    finally:
        os.unlink(tmp_path)


def test_config_manager_sem_arquivo():
    """ConfigManager deve retornar dicionario vazio se nao houver config.json."""
    from organizador_tray import ConfigManager
    cm = ConfigManager(config_file="config_nao_existe_xyz.json")
    assert cm.config == {}
    assert cm.get_pasta_monitorada() is None


if __name__ == "__main__":
    # Permite executar direto com python
    test_meses_portugues()
    print("OK test_meses_portugues passou")

    test_extrair_data_do_nome()
    print("OK test_extrair_data_do_nome passou")

    test_gerar_hash()
    print("OK test_gerar_hash passou")

    test_gerar_hash_arquivo_inexistente()
    print("OK test_gerar_hash_arquivo_inexistente passou")

    test_obter_data_modificacao()
    print("OK test_obter_data_modificacao passou")

    test_config_manager_sem_arquivo()
    print("OK test_config_manager_sem_arquivo passou")

    print("\nTodos os testes passaram!")
