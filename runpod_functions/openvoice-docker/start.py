import os
import sys
import torch
import argparse
from openvoice import se_extractor
from openvoice.api import ToneColorConverter

ckpt_converter = './checkpoints_v2/converter'
device = "cuda:0" if torch.cuda.is_available() else "cpu"
output_dir = './outputs_v2'

tone_color_converter = ToneColorConverter(f'{ckpt_converter}/config.json', device=device)
tone_color_converter.load_ckpt(f'{ckpt_converter}/checkpoint.pth')

# Setup argparse
parser = argparse.ArgumentParser(description='Process some inputs.')
parser.add_argument('--lang', type=str, required=True, help='Language of the text')
parser.add_argument('--text', type=str, required=True, help='Text to be synthesized')
parser.add_argument('--reference', type=str, required=True, help='Reference speaker for SE extraction')
parser.add_argument('--speed', type=str, required=True, help='Speed of the audio file')

os.makedirs(output_dir, exist_ok=True)

args = parser.parse_args()

lang = args.lang
text = args.text
reference_speaker = args.reference
speed = args.speed
target_se, audio_name = se_extractor.get_se(reference_speaker, tone_color_converter, vad=False)


current_dir = os.path.dirname(os.path.abspath(__file__))

# Get the parent directory
parent_dir = os.path.abspath(os.path.join(current_dir, os.pardir))

# Add the parent directory to sys.path
sys.path.append(parent_dir)

from MeloTTS.melo.api import TTS

# Retrieve text from command line argument or use a default text
input_text = sys.argv[1] if len(sys.argv) > 1 else "Did you ever hear a folk tale about a giant turtle?"

src_path = f'{output_dir}/tmp.wav'

# Speed is adjustable
speed_as_float = float(speed)

print("Starting TTS")
model = TTS(language=lang, device=device)
speaker_ids = model.hps.data.spk2id

for speaker_key in speaker_ids.keys():
    speaker_id = speaker_ids[speaker_key]
    speaker_key = speaker_key.lower().replace('_', '-')
    
    source_se = torch.load(f'./checkpoints_v2/base_speakers/ses/{speaker_key}.pth', map_location=device)
    model.tts_to_file(text, speaker_id, src_path, speed=speed_as_float)
    save_path = f'{output_dir}/output_v2.wav'

    # Run the tone color converter
    encode_message = "@MyShell"
    tone_color_converter.convert(
        audio_src_path=src_path,
        src_se=source_se, 
        tgt_se=target_se, 
        output_path=save_path,
        message=encode_message)