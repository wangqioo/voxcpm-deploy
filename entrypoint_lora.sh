#!/bin/bash
set -e
LORA_PORT="${LORA_PORT:-8809}"
MODEL_DIR="${MODEL_DIR:-/models/voxcpm/VoxCPM2}"
echo "=== VoxCPM LoRA WebUI starting ==="
echo "PORT: $LORA_PORT"
echo "MODEL_DIR: $MODEL_DIR"
cp /app/lora_ft_webui.py /tmp/lora_ft_webui_patched.py
sed -i 's|str(project_root / "models" / "openbmb__VoxCPM1.5")|os.environ.get("MODEL_DIR","/models/voxcpm/VoxCPM2")|g' /tmp/lora_ft_webui_patched.py
sed -i "s|server_port=7860|server_port=${LORA_PORT}|g" /tmp/lora_ft_webui_patched.py
python3 /entrypoint_css_fix.py
cd /lora_data
exec python3 /tmp/lora_ft_webui_patched.py