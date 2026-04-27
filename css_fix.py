import re

CSS_FIX = """
/* TEXT VISIBILITY FIX */
.gradio-container label span,
.gradio-container .block label > span,
.gradio-container .wrap span,
.gradio-container p, .gradio-container li,
.gradio-container h4, .gradio-container h5 {
    color: #333 !important;
}
.gradio-container textarea,
.gradio-container input[type=text],
.gradio-container input[type=number] {
    color: #222 !important;
    background-color: #fff !important;
}
.gradio-container .tab-nav button { color: #555 !important; }
.gradio-container .tab-nav button.selected { color: #667eea !important; }
.gradio-container details > summary { color: #333 !important; }
"""

with open('/tmp/lora_ft_webui_patched.py', 'r') as f:
    content = f.read()

content = re.sub(
    r'(custom_css\s*=\s*\"\"\")(.*?)(\"\"\"\s*\nwith\s+gr\.Blocks)',
    lambda m: m.group(1) + m.group(2) + CSS_FIX + m.group(3),
    content,
    flags=re.DOTALL
)

with open('/tmp/lora_ft_webui_patched.py', 'w') as f:
    f.write(content)
print("CSS fix applied")