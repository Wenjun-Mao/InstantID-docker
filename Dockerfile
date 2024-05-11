FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

ARG MODEL_URL=https://huggingface.co/wangqixun/YamerMIX_v8

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

COPY gradio_demo/requirements.txt /app/gradio_demo/requirements.txt
RUN pip install --no-cache-dir -r gradio_demo/requirements.txt

COPY gradio_demo/download_models.py /app/gradio_demo/download_models.py
RUN python gradio_demo/download_models.py

RUN git clone https://huggingface.co/latent-consistency/lcm-lora-sdxl
RUN git clone ${MODEL_URL} /app/local_sdmodel

COPY . /app/

EXPOSE 7860

CMD ["python", "gradio_demo/app.py", "--pretrained_model_name_or_path", "./local_sdmodel/"]