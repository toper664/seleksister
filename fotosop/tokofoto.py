import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule

import numpy as np
import cv2

cuda_module = SourceModule(open("kernel/kernel.cu").read())

# makasih banyak bang aw dah ngajarin
# buat kak asisten kalo ada yang "gk diubah" itu artinya saya kurang mengerti itu buat apa :P
# if it ain't broke don't fix it ygy

def filter(image: np.ndarray, filter: str, value:int=0):

    rows, cols, channels = image.shape

    image_gpu_input = cuda.mem_alloc(image.nbytes)
    image_gpu_output = cuda.mem_alloc(image.nbytes)

    if (filter == "grayscale"):

        grayscale = cuda_module.get_function("grayscale")
        
        cuda.memcpy_htod(image_gpu_input,image)
        grayscale(image_gpu_input,image_gpu_output, np.int32(rows), np.int32(cols), block=(16,16,2), grid=((cols // 16) + 1,(rows // 16) + 1))
        cuda.Context.synchronize()
        cuda.memcpy_dtoh(image,image_gpu_output)

    elif (filter == "contrast"):

        contrast = cuda_module.get_function("contrast")

        cuda.memcpy_htod(image_gpu_input,image)
        contrast(image_gpu_input, image_gpu_output,np.int32(rows), np.int32(cols), np.int32(value), block=(16, 16, 3), grid=((cols // 16) + 1, (rows // 16) + 1))
        cuda.Context.synchronize()
        cuda.memcpy_dtoh(image,image_gpu_output)

    elif (filter == "saturation"):

        saturation = cuda_module.get_function("saturation")

        image_gpu_input.free()
        image_gpu_output.free()

        image_hls = cv2.cvtColor(image.astype(np.uint8),cv2.COLOR_BGR2HLS)
        image_saturation = image_hls[:, :, 2].astype(np.float32)

        value = float(value) / 100
        value = np.float32(value)

        image_gpu_input = cuda.mem_alloc(image_saturation.nbytes)
        image_gpu_output = cuda.mem_alloc(image_saturation.nbytes)

        cuda.memcpy_htod(image_gpu_input,image_saturation)
        saturation(image_gpu_input, image_gpu_output, np.int32(rows), np.int32(cols), np.float32(value), block=(16, 16, 1), grid=((cols // 16) + 1,(rows // 16) + 1))
        cuda.Context.synchronize()
        cuda.memcpy_dtoh(image_saturation,image_gpu_output)

        image_hls[:, :, 2] = image_saturation
        image_hls = image_hls.astype(np.uint8)
        image = cv2.cvtColor(image_hls, cv2.COLOR_HLS2BGR)
    
    elif (filter == "blur"):

        blur = cuda_module.get_function("blur")

        cuda.memcpy_htod(image_gpu_input,image)
        blur(image_gpu_input, image_gpu_output, np.int32(rows), np.int32(cols), np.int32(value), block=(16,16,3), grid=((cols // 16) + 1,(rows // 16) + 1))
        cuda.Context.synchronize()
        cuda.memcpy_dtoh(image,image_gpu_output)

    elif (filter == "edge_detection"):

        edge_detection = cuda_module.get_function("edge_detection")

        cuda.memcpy_htod(image_gpu_input,image)
        edge_detection(image_gpu_input, image_gpu_output, np.int32(rows), np.int32(cols), block=(16,16,1), grid=((cols // 16) + 1,(rows // 16) + 1))
        cuda.Context.synchronize()
        cuda.memcpy_dtoh(image,image_gpu_output)

    image_gpu_input.free()
    image_gpu_output.free()

    return image.reshape(rows,cols,channels).astype(np.uint8)