# VoxCPM Deploy

Deployment configuration for [VoxCPM](https://github.com/OpenBMB/VoxCPM) on Spark2 (NVIDIA GB10, ARM64).

## Server

- Host: Spark2 (NVIDIA GB10 / aarch64)
- TTS inference: port **8808**  `http://150.158.146.192:8808`
- LoRA training WebUI: port **8809**  `http://150.158.146.192:8809`

## Files

| File | Description |
|---|---|
| `docker-compose.yml` | Two-container setup (voxcpm + voxcpm-lora) |
| `entrypoint.sh` | TTS inference startup script |
| `entrypoint_lora.sh` | LoRA WebUI startup script |
| `css_fix.py` | CSS text visibility patch for LoRA WebUI |

## Key Notes

- `TORCHDYNAMO_DISABLE=1` required — Triton JIT not supported on ARM64
- Model: `/models/voxcpm/VoxCPM2`
- Python venv: `/home/wq/apps/voxcpm/venv`

## Quick Start

```bash
cd /home/wq/apps/voxcpm
docker compose up -d
```
