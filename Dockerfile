FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

WORKDIR /app

COPY . /app/

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r gradio_demo/requirements.txt

RUN python gradio_demo/download_models.py

EXPOSE 7860

CMD ["python", "gradio_demo/app.py"]