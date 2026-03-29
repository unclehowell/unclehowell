# ElevenLabs Skill

This skill allows the agent to interact with the ElevenLabs API for text-to-speech (TTS) generation.

## Capabilities

- **Text-to-Speech:** Convert provided text into spoken audio.
- **Voice Selection:** Choose from available ElevenLabs voices.
- **Audio Output:** Save the generated audio to a file or stream it.

## Usage

To use this skill, provide the text you want to convert to speech and optionally specify a voice.

Example:
`tts elevenlabs "Hello, world!" --voice "Adam"`

This will generate audio for "Hello, world!" using the "Adam" voice.

## Configuration

- **API Key:** An ElevenLabs API key is required. Store it securely (e.g., in environment variables).
- **Default Voice:** A default voice can be set if not specified in the command.
- **Output Format:** Specify audio format (e.g., MP3, WAV).