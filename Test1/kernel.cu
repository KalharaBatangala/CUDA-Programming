
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <chrono>
#include <iostream>
#include <cuda.h>

#define SIZE 8192

using namespace std;
using namespace std::chrono;






int main()
{
    //CUDA Runtime API
    int DeviceCount;
    cudaGetDeviceCount(&DeviceCount);
    cout << "Number of Device : " << DeviceCount << endl;

    cudaDeviceProp prop;    //structure that stores device properties
    cudaGetDeviceProperties(&prop, 0);
    printf("\nDevice name : %s", prop.name);
    printf("\nMultiprocessor Count : %d ", prop.multiProcessorCount);
    printf("\nMemory Clock Rate (KHz) : %d", prop.memoryClockRate/(1000*1000));
    printf("\nMemory Pool Supported : %d", prop.memoryPoolsSupported);
    printf("\nTotal Global Memory : %d MB", prop.totalGlobalMem/(1024*1024));

    return 0;
}
