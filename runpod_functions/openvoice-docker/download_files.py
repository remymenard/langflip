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


os.makedirs(output_dir, exist_ok=True)

# target_se, audio_name = se_extractor.get_se("./resources/demo_speaker0.mp3", tone_color_converter, vad=False)


# current_dir = os.path.dirname(os.path.abspath(__file__))

# # Get the parent directory
# parent_dir = os.path.abspath(os.path.join(current_dir, os.pardir))

# # Add the parent directory to sys.path
# sys.path.append(parent_dir)

# from MeloTTS.melo.api import TTS

# Retrieve text from command line argument or use a default text
# input_text = sys.argv[1] if len(sys.argv) > 1 else "Did you ever hear a folk tale about a giant turtle?"

# src_path = f'{output_dir}/tmp.wav'

# # Speed is adjustable
# speed_as_float = float(speed)

# print("Starting TTS")
# model = TTS(language=lang, device=device)
# speaker_ids = model.hps.data.spk2id

# for speaker_key in speaker_ids.keys():
#     speaker_id = speaker_ids[speaker_key]
#     speaker_key = speaker_key.lower().replace('_', '-')
    
    # source_se = torch.load(f'./checkpoints_v2/base_speakers/ses/{speaker_key}.pth', map_location=device)
    # model.tts_to_file(text, speaker_id, src_path, speed=speed_as_float)
    # save_path = f'{output_dir}/output_v2.wav'

    # # Run the tone color converter
    # encode_message = "@MyShell"
    # tone_color_converter.convert(
    #     audio_src_path=src_path,
    #     src_se=source_se, 
    #     tgt_se=target_se, 
    #     output_path=save_path,
    #     message=encode_message)