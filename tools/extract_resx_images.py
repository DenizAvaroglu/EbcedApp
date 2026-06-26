import re
import base64
import os

ROOT = r"C:\Users\deniz\Desktop\VefkTeksirHavas\VefkTeksirHavas"
BASE = os.path.join(ROOT, "ek bilgiler")
OUT = r"C:\Users\deniz\Desktop\EbcedApp\assets\vefk_ref"
OUT_STAR = r"C:\Users\deniz\Desktop\EbcedApp\assets\vefk"

FILES = [
    ("Melekler/Melek.resx", "melek"),
    ("günler/Gunler.resx", "gunler"),
    ("gezegenler/Gezegen.resx", "gezegen"),
]

STAR_FILES = [
    ("3lu vefkler/hexagram.resx", "hexagram"),
    ("4lu vefkler/septagram.resx", "septagram"),
    ("5li vefkler/octagram.resx", "octagram"),
]


def extract_first(resx_path: str, out_dir: str, out_name: str) -> None:
    text = open(resx_path, encoding="utf-8").read()
    pattern = r'<data name="(pictureBox\d+)\.Image"[^>]*>\s*<value>\s*([^<]+?)\s*</value>'
    blocks = re.findall(pattern, text, re.DOTALL)
    if not blocks:
        print(f"NO IMAGE in {resx_path}")
        return
    _, b64 = blocks[0]
    img = base64.b64decode(re.sub(r"\s+", "", b64))
    outpath = os.path.join(out_dir, out_name)
    with open(outpath, "wb") as f:
        f.write(img)
    print(f"Wrote {outpath} ({len(img)} bytes)")


def extract_all(resx_path: str, prefix: str) -> None:
    text = open(resx_path, encoding="utf-8").read()
    pattern = r'<data name="(pictureBox\d+)\.Image"[^>]*>\s*<value>\s*([^<]+?)\s*</value>'
    blocks = re.findall(pattern, text, re.DOTALL)
    for name, b64 in blocks:
        img = base64.b64decode(re.sub(r"\s+", "", b64))
        outpath = os.path.join(OUT, f"{prefix}_{name}.png")
        with open(outpath, "wb") as f:
            f.write(img)
        print(f"Wrote {outpath} ({len(img)} bytes)")


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(OUT_STAR, exist_ok=True)
    for rel, prefix in FILES:
        extract_all(os.path.join(BASE, rel), prefix)
    for rel, prefix in STAR_FILES:
        extract_first(os.path.join(ROOT, rel), OUT_STAR, f"{prefix}.png")


if __name__ == "__main__":
    main()
