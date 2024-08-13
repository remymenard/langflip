# LangFlip: AI-Powered Video Translation and Lip-Syncing

LangFlip is an advanced cloud-based application that leverages artificial intelligence to translate videos into multiple languages while maintaining lip synchronization. This project combines various technologies to provide a seamless video translation experience.

## Try It Out

You can test the LangFlip application at:

[https://app.langflip.com](https://app.langflip.com)

Experience the power of AI-driven video translation and lip-syncing firsthand!

## Features

- Video translation to multiple target languages
- AI-powered lip-syncing for natural-looking results
- Cloud-based processing for scalability
- Integration with various AI services (Google Vertex AI, ElevenLabs, etc.)
- Automatic caption generation and translation

## Technology Stack

- Python
- Firebase Functions
- Google Cloud Storage
- Google Vertex AI
- ElevenLabs API
- MoviePy
- PyDub
- FFmpeg

## Key Components

1. **Video Processing**: Handles video and audio manipulation.
2. **Translation**: Utilizes Google Vertex AI for high-quality translations.
3. **Text-to-Speech**: Generates translated audio using ElevenLabs API.
4. **Lip-Syncing**: Applies advanced algorithms to match lip movements with translated audio.

## Getting Started

1. Clone the repository
2. Set up Firebase project and obtain credentials
3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```
4. Set up environment variables for API keys and project configurations
5. Deploy Firebase Functions:
   ```
   firebase deploy --only functions
   ```

## Usage

The main functionality is exposed through Firebase Functions. The primary function `startLipSync` initiates the translation and lip-syncing process:
