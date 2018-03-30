#include <iostream>


using namespace std;

__global__ void add(int a, int b, int *c) {
    *c = a + b;

}

int main() {
    int c(32);
    int *dev_c;
    cudaError_t alloc = cudaMalloc((void**)&dev_c, sizeof(int));
    if (alloc != cudaSuccess) {
        cerr << "Impossible to allocate memory: " << cudaGetErrorString(alloc) << endl;
        exit(EXIT_FAILURE);
    }
    add<<<1, 1>>>(2, 7, dev_c);

    cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);
    cout << "2 + 7 = " << c << endl;

    cudaFree(dev_c);

    cout << "CUDA" << endl;

    int count;
    cudaGetDeviceCount(&count);
    cout << "nb CUDA compatible devices: " << count << endl;

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);

    cout << "Properties" << endl;
    cout << "major: " << prop.major << endl;
    cout << "minor: " << prop.minor << endl;
    cout << "texture max dim: " << prop.maxTexture2D[0] << " " << prop.maxTexture2D[1] << endl;
    cout << "nb multiprocessors: " << prop.multiProcessorCount << endl;
    cout << "max threads per block " << prop.maxThreadsPerBlock << endl;
    cout << "max thread dim: " << prop.maxThreadsDim[0] << " " << prop.maxThreadsDim[1] << "  " << prop.maxThreadsDim[2] << endl;
    cout << "max grid dim: " << prop.maxGridSize[0] << " " << prop.maxGridSize[1] << "  " << prop.maxGridSize[2] << endl;

    cout << "device name: " << prop.name << endl;
    cout << "total global mem " << prop.totalGlobalMem << endl;
    cout << "max shared mem per block: " << prop.sharedMemPerBlock << endl;
    cout << "nb registers per block: " << prop.regsPerBlock << endl;
    cout << "nb thread in a warp: " << prop.warpSize << endl;



    return 0;
}
