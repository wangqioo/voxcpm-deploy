#!/bin/bash
set -e

MODEL_DIR="${MODEL_DIR:-}"
PORT="${PORT:-8808}"

echo "=== VoxCPM starting ==="
echo "PORT: $PORT"
echo "MODEL_DIR: ${MODEL_DIR:-auto-download}"

python3 -c "
import torch
print(f'PyTorch: {torch.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'GPU: {torch.cuda.get_device_name(0)}')
"

# Patch app.py to disable cuDNN (GB10 cuDNN kernel compatibility)
cp /app/app.py /tmp/app_patched.py
python3 - << 'PYEOF'
with open('/tmp/app_patched.py', 'r') as f:
    content = f.read()

cudnn_patch = """import torch
torch.backends.cudnn.enabled = False
torch.backends.cudnn.benchmark = False
"""

# Insert after the first import block
import re
content = re.sub(r'^(import torch)', cudnn_patch + r'\1', content, count=1, flags=re.MULTILINE)

with open('/tmp/app_patched.py', 'w') as f:
    f.write(content)
print("cuDNN patch applied")
PYEOF

if [ -n "$MODEL_DIR" ]; then
    exec python3 /tmp/app_patched.py --port "$PORT" --model-dir "$MODEL_DIR"
else
    exec python3 /tmp/app_patched.py --port "$PORT"
fi