
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <chrono>
#include <iostream>
#include <cuda.h>

#define SIZE 8192

using namespace std;
using namespace std::chrono;

__global__ void hello() {
    
    int warp_ID = threadIdx.x / warpSize;
    
    int global_thread_id = blockIdx.x * blockDim.x + threadIdx.x;
    printf("\nGlobal thread ID : %d -- Warp ID : %d", global_thread_id, warp_ID);
    
}

    //printf("\nThe block ID is %d --- The thread ID is %d --- The warp ID %d", blockIdx.x, threadIdx.x,warp_ID );

__global__ void vectorAdd(int* A, int* B, int* C, int n)
{
    int global_thread_id = blockIdx.x * blockDim.x + threadIdx.x;
    int i = global_thread_id;
    C[i] = A[i] + B[i];
}





int main()
{
    /*hello << <2, 64 >> > ();
    cudaDeviceSynchronize();*/

    //hello << <2, 512 >> > ();
    const int vector_size = 8192;

    int vect1[vector_size];
    int vect2[vector_size];
    int out[vector_size];
    for (int i = 0; i < vector_size; i++)
    {
        vect1[i] = i * 2 + 3;
    }
    cout << "\nSuccessfully initialized vector 1" << endl;
    for (int j = 0; j < vector_size; j++)
    {
        vect2[j] = j * 3 + 2;
    }
    cout << "\nSuccessfully initialized vector 2" << endl;
    //
    //
    ////function of addition in CPU
    auto start1 = high_resolution_clock::now();
    for (int k = 0; k < vector_size; k++)
    {
        out[k] = vect1[k] + vect2[k];
    }
    cout << "Addtion completed !" << endl;
    auto stop1 = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop1 - start1);

    cout << "\nDuration for CPU is : " << duration.count() << endl;


    int* A, * B, * C; 
    int* d_A, * d_B, * d_C;
    int size = SIZE * sizeof(int);

    A = (int*)malloc(size);
    B = (int*)malloc(size);
    C = (int*)malloc(size);

    //allocate memory in GPU
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);


    //initialize the inputs
    for (int i = 0; i < SIZE; i++)
    {
        A[i] = i;
        B[i] = SIZE - i;
    }

    //Create Events for timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    //copy host memory to device
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

    cudaEventRecord(start);
    vectorAdd << <8, 1024 >> > (d_A, d_B, d_C, SIZE);
    cudaEventRecord(stop);

    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);
    
    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    printf("Execution time : %f milliseconds\n", milliseconds);
   

    printf("\nExecution Finished !");
    /*for (int i = 0; i < SIZE; i++)
    {
        printf("%d + %d = %d", A[i], B[i], C[i]);
        printf("\n");
    }*/

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    free(A);
    free(B);
    free(C);










    return 0;
}
