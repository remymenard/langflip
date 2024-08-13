import sys
import os

if __name__ == '__main__':

    current_dir = os.path.dirname(os.path.abspath(__file__))
    parent_dir = os.path.abspath(os.path.join(current_dir, os.pardir))
    sys.path.append(parent_dir)
    from melo.api import TTS
    device = 'auto'
    models = {
        'EN': TTS(language='EN', device=device),
        'ES': TTS(language='ES', device=device),
        'FR': TTS(language='FR', device=device),
        'ZH': TTS(language='ZH', device=device),
        'JP': TTS(language='JP', device=device),
        'KR': TTS(language='KR', device=device),
    }