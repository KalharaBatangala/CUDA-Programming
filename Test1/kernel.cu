
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <iostream>

using namespace std;

__global__ void hello() {
    
    // print the block and thread IDs
    printf("\nThe block ID is %d --- The thread ID is %d", blockIdx.x, threadIdx.x);
}


int main()
{
    hello << <2, 8 >> > ();

    return 0;
}
