__global__ void grayscale(const float* image_in, float* image_out, int rows, int cols) {

    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;

    if (row < rows && col < cols) {

        int i = (row * cols + col) * 3;
        
        float gray = static_cast<float>(image_in[i] + image_in[i + 1] + image_in[i + 2]) / 3.0;

        image_out[i] = gray;
        image_out[i + 1] = gray;
        image_out[i + 2] = gray;

    }

}

__global__ void contrast(const float* image_in, float* image_out, int rows, int cols, int c) {

    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;
    int rgb = threadIdx.z;

    if (row < rows && col < cols) {

        int i = (row * cols + col) * 3 + rgb;
        
        float f = static_cast<float>(259 * (c + 255)) / static_cast<float>(255 * (259 - c));

        float result = f * (image_in[i] - 128) + 128;
        result = (result > 255) ? 255 : result;
        result = (result < 0) ? 0 : result;

        image_out[i] = result;

    }

}

__global__ void saturation(const float* image_in, float* image_out, int rows, int cols, float s) {

    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;

    if (row < rows && col < cols) {

        int i = (row * cols + col);
        
        image_out[i] = image_in[i] * s;

    }

}

// makasih bang aw hehehe
__global__ void blur(const float* image_in, float* image_out, int rows, int cols, int v) {

    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;
    int rgb = threadIdx.z;

    int lim = v * 3;

    if (row < rows && col < cols) {

        int idx = (row * cols + col) * 3 + rgb;

        int sum = 0;

        if (col < lim || col >= ((cols * 3) - lim)) {
            for (int i = -v; i <= v; i++) {
                for (int j = -lim; j <= lim; j+= 3) {
                    if (row + i >= 0) {
                        sum += image_in[idx + (i * (cols * 3) - j)];
                    }
                }
            }
            image_out[idx] = sum / (1 + v*2) / (1 + v*2);
        } else if (row < v || row >= (rows - v)) {
            for (int i = -v; i <= v; i++) {
                for (int j = -lim; j <= lim; j+= 3) {
                    if (col + j >= 0) {
                        sum += image_in[idx + ((-1)*i * (cols * 3) - j)];
                    }
                }
            }
            image_out[idx] = sum / (1 + v*2) / (1 + v*2);
        } else {
            for (int i = -v; i <= v; i++) {
                for (int j = -lim; j <= lim; j+= 3) {
                    sum += image_in[idx + (i * (cols * 3) + j)];
                }
            }
            image_out[idx] = sum / (1 + v*2) / (1 + v*2);
        }

    }

}

// makasih bang AW hehehe
__constant__ float sobel_x[9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
__constant__ float sobel_y[9] = {1, 2, 1, 0, 0, 0, -1, -2, -1};

__global__ void edge_detection(const float* image_in, float* image_out, int rows, int cols) {

    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;

    float dx, dy;
    if (row < rows && col < cols) {

        int idx = (row * cols + col) * 3; 
        
        if ( !(col < 3 || col >= ((cols * 3) - 3) || row < 1 || row >= (rows - 1)) ){
            int previdx = idx - (cols * 3);
            int nextidx = idx + (cols * 3);
            
            float val0 = image_in[previdx - 3] + image_in[previdx - 2] + image_in[previdx - 1];
            float val1 = image_in[previdx] + image_in[idx + 1] + image_in[previdx + 2];
            float val2 = image_in[previdx + 3] + image_in[previdx + 4] + image_in[previdx + 5];

            float val3 = image_in[idx - 3] + image_in[idx - 2] + image_in[idx - 1];

            float val5 = image_in[idx + 3] + image_in[idx + 4] + image_in[idx + 5];
            
            float val6 = image_in[nextidx - 3] + image_in[nextidx - 2] + image_in[nextidx - 1];
            float val7 = image_in[nextidx] + image_in[nextidx + 1] + image_in[nextidx + 2];
            float val8 = image_in[nextidx + 3] + image_in[nextidx + 4] + image_in[nextidx + 5];

            float xval = (sobel_x[0] * val0) + (sobel_x[2] * val2) + (sobel_x[3] * val3) + (sobel_x[5] * val5) + (sobel_x[6] * val6) + (sobel_x[8] * val8);
            float yval = (sobel_y[0] * val0) + (sobel_y[1] * val1) + (sobel_y[2] * val2) + (sobel_y[6] * val6) + (sobel_y[7] * val7) + (sobel_y[8] * val8);
            
            float magnitude = abs(xval) + abs(yval);
            
            image_out[idx] = magnitude;
            image_out[idx + 1] = magnitude;
            image_out[idx + 2] = magnitude;
        }

    }

}