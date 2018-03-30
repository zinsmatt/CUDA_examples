#include <iostream>
#include <cstdlib>

using namespace std;

__global__ void add_vector(int* a, int* b, int* c, int size)
{
    int id = blockIdx.x * 96 + threadIdx.x;
    if (id<size)
    {
        c[id] = a[id] + b[id];
    }
}


int main()
{
    int v1, v2;
    cout << "First value ?  " << endl;
    cin >> v1;
    cout << "Second value ? " << endl;
    cin >> v2;
    cout << "v1 = " << v1 << endl;
    cout << "v2 = " << v2 << endl;
    const int size = 20000;


    int *a = new int[size];
    int *b = new int[size];
    int *c = new int[size];

    for (int i=0; i<size; ++i)
    {
        a[i] = v1;
        b[i] = v2;
    }

    int *a_dev, *b_dev, *c_dev;

    if (cudaSuccess != cudaMalloc((void**)&a_dev, sizeof(int) * size))
    {
        cerr << "error allocation a_dev" << endl;
    }
    if (cudaSuccess != cudaMalloc((void**)&b_dev, sizeof(int) * size))
    {
        cerr << "error allocation b_dev" << endl;
    }
    if (cudaSuccess != cudaMalloc((void**)&c_dev, sizeof(int) * size))
    {
        cerr << "error allocation c_dev" << endl;
    }

    if (cudaSuccess != cudaMemcpy(a_dev, a, sizeof(int) * size, cudaMemcpyHostToDevice))
    {
        cerr << "error cuda mem copy" << endl;
    }

    if (cudaSuccess != cudaMemcpy(b_dev, b, sizeof(int) * size, cudaMemcpyHostToDevice))
    {
        cerr << "error cuda mem copy" << endl;
    }


    // dim3 block_dim(1, 1, 1);
    // dim3 threads_per_block(size, 1, 1);
    int nb_blocks = size / 96;

    add_vector<<<nb_blocks+1, 96>>>(a_dev, b_dev, c_dev, size);

    if (cudaSuccess != cudaMemcpy(c, c_dev, sizeof(int) * size, cudaMemcpyDeviceToHost))
    {
        cerr << "error cuda mem copy back" << endl;
    }

    for (int i=0; i<size; ++i)
    {
        cout << c[i] << " ";
    }
    cout << endl;

    delete[] a;
    delete[] b;
    delete[] c;
    cudaFree(a_dev);
    cudaFree(b_dev);
    cudaFree(c_dev);
    return 0;
}
