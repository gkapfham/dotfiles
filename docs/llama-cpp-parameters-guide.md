# llama.cpp Parameters Guide for Gemma 4 on Mac Mini

## Core Model Parameters

| Parameter | Example Value | What It Means | Quality Impact | Speed Impact | Why Use It |
|-----------|---------------|---------------|----------------|--------------|------------|
| `-m` | `./models/gemma-4-E2B-it-Q4_K_M.gguf` | Path to the model file | High | None | Specifies which model to load - choose quantization based on your RAM/speed needs |
| `-ngl` | `99` | Number of GPU layers to offload to Metal | High | High | Offloads computation from CPU to Apple Silicon GPU - 99 means all layers |
| `--ctx-size` | `4096` or `8192` or `128000` | Context window size in tokens | High | Medium | Larger = more memory but can process longer texts - balance based on your use case |

## Optimization Parameters

| Parameter | Example Value | What It Means | Quality Impact | Speed Impact | Why Use It |
|-----------|---------------|---------------|----------------|--------------|------------|
| `-fa` | (flag) | Flash Attention - memory-efficient attention mechanism | None | Very High | Reduces memory bandwidth by 2-4x, essential for Apple Silicon - no quality loss |
| `-b` | `512` | Logical batch size (concurrent tokens processed) | None | High | Higher = better GPU utilization but more memory - 512 is sweet spot for Gemma 4 |
| `-ub` | `512` | Physical batch size (actual GPU batch size) | None | High | Should match `-b` for optimal performance - controls how many tokens process together |
| `--cache-type-k` | `q4_0` | Quantize Key cache to 4-bit | Slight | High | Reduces KV cache memory by 75% - slight quality impact but much faster |
| `--cache-type-v` | `q4_0` | Quantize Value cache to 4-bit | Slight | High | Same as above - combined with keys, saves massive memory for long contexts |
| `--mlock` | (flag) | Lock model in RAM (prevent swapping) | High | High | Prevents macOS from swapping model to disk - critical for consistent performance |
| `-t` | `8` | Number of CPU threads | None | Medium | For CPU fallback layers - 8 matches Mac Mini performance cores |

## Server Parameters

| Parameter | Example Value | What It Means | Quality Impact | Speed Impact | Why Use It |
|-----------|---------------|---------------|----------------|--------------|------------|
| `--port` | `8080` | HTTP server port | None | None | Standard port for API access - change if you have conflicts |
| `--host` | `0.0.0.0` | Bind address | None | None | 0.0.0.0 allows remote access (Tailscale/VPN), 127.0.0.1 for local only |
| `--parallel` | `1` | Number of parallel slots | None | Medium | 1 = sequential requests (faster per-request), higher = concurrent but slower each |

## Memory vs Quality Trade-offs

| Parameter | Lower Value | Higher Value | Recommendation |
|-----------|-------------|--------------|----------------|
| Quantization (in filename) | `Q8_0` = best quality, larger | `Q3_K_M` = lower quality, smaller | Use `Q4_K_M` or `Q4_0` for Gemma 4 E2B |
| `--ctx-size` | Less memory, shorter texts | More memory, longer texts | Start with 4096 for coding, 8192 for docs |
| `--cache-type-k/v` | `f16` = best quality, 2x memory | `q4_0` = good quality, 0.5x memory | Use `q4_0` for 16GB Mac Mini |
| `-ngl` | `0` = CPU only, very slow | `99` = full GPU, very fast | Always use `99` on Apple Silicon |

## Recommended Combinations

### For Maximum Speed (20+ tok/s)
```bash
llama-server \
  -m gemma-4-E2B-it-Q4_0.gguf \
  -ngl 99 -fa \
  --ctx-size 4096 \
  -b 512 -ub 512 \
  --cache-type-k q4_0 --cache-type-v q4_0 \
  --mlock --port 8080
```
**Why:** Q4_0 is fastest quantization, small context reduces memory pressure, quantized cache saves bandwidth

### For Maximum Quality
```bash
llama-server \
  -m gemma-4-E2B-it-Q8_0.gguf \
  -ngl 99 -fa \
  --ctx-size 128000 \
  -b 512 -ub 512 \
  --cache-type-k f16 --cache-type-v f16 \
  --mlock --port 8080
```
**Why:** Q8_0 is highest quality, huge context for long documents, full precision cache

### Balanced (Recommended for 16GB Mac Mini)
```bash
llama-server \
  -m gemma-4-E2B-it-Q4_K_M.gguf \
  -ngl 99 -fa \
  --ctx-size 8192 \
  -b 512 -ub 512 \
  --cache-type-k q4_0 --cache-type-v q4_0 \
  --mlock --port 8080
```
**Why:** Q4_K_M balances quality/speed, 8K context handles most coding tasks, quantized cache fits in 16GB

## Memory Usage Estimates (Gemma 4 E2B)

| Configuration | Model Size | KV Cache (4K ctx) | Total RAM | Speed Estimate |
|---------------|------------|-------------------|-----------|----------------|
| Q4_0 + q4_0 cache | ~2.5 GB | ~0.5 GB | ~3.5 GB | 25-35 tok/s |
| Q4_K_M + q4_0 cache | ~2.8 GB | ~0.5 GB | ~3.8 GB | 20-30 tok/s |
| Q8_0 + f16 cache | ~4.8 GB | ~2.0 GB | ~7.5 GB | 15-25 tok/s |
| Q4_0 + f16 cache (8K) | ~2.5 GB | ~2.0 GB | ~5.0 GB | 18-28 tok/s |

All fit comfortably in your 16GB Mac Mini with room for macOS and other apps!