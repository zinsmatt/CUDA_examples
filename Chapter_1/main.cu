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

    return 0;
}
