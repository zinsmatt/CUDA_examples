#include <iostream>


using namespace std;

__global__ void kernel(void) {

}

int main() {

	kernel<<<1, 1>>>();
	cout << "CUDA" << endl;

	return 0;
}
