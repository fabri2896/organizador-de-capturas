"""
Gera os assets gráficos a partir de desenhar_icone():

  - app.ico                (ícone do EXE, 8 resoluções)
  - scripts/wizard.png     (arte lateral do instalador, 164x314)
  - scripts/wizsmall.png   (arte pequena do instalador, 55x55)

Assim o ícone tem uma única fonte de verdade: o código em organizador_tray.py.
Rode com: python scripts/gerar_assets.py
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw

RAIZ = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RAIZ))

from organizador_tray import desenhar_icone  # noqa: E402

CLARO = (67, 160, 71)   # #43A047
ESCURO = (20, 64, 26)   # #14401A
RESOLUCOES = [256, 128, 96, 64, 48, 32, 24, 16]


def gradiente(largura, altura):
    """Degradê vertical da cor clara para a escura."""
    img = Image.new("RGB", (largura, altura))
    draw = ImageDraw.Draw(img)
    for y in range(altura):
        t = y / (altura - 1)
        cor = tuple(int(CLARO[i] + (ESCURO[i] - CLARO[i]) * t) for i in range(3))
        draw.line([(0, y), (largura, y)], fill=cor)
    return img


def main():
    # 1) Ícone do executável
    icone_ico = RAIZ / "app.ico"
    desenhar_icone(256).save(icone_ico, format="ICO", sizes=[(t, t) for t in RESOLUCOES])
    print(f"app.ico            {icone_ico}")

    # 2) Imagem grande do assistente
    largura, altura = 164, 314
    wizard = gradiente(largura, altura).convert("RGBA")
    draw = ImageDraw.Draw(wizard, "RGBA")
    for cx, cy, r, alfa in [(30, 60, 70, 22), (150, 250, 90, 18), (120, 40, 40, 14)]:
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(255, 255, 255, alfa))
    grande = desenhar_icone(180)
    wizard.paste(grande, ((largura - 180) // 2, 62), grande)
    destino = RAIZ / "scripts" / "wizard.png"
    wizard.convert("RGB").save(destino)
    print(f"scripts/wizard.png {destino} ({largura}x{altura})")

    # 3) Imagem pequena
    pequena = Image.new("RGB", (55, 55), ESCURO)
    mini = desenhar_icone(44)
    pequena.paste(mini, (5, 5), mini)
    destino = RAIZ / "scripts" / "wizsmall.png"
    pequena.save(destino)
    print(f"scripts/wizsmall.png {destino} (55x55)")


if __name__ == "__main__":
    main()
