class Sorter {
    private static void mergeHelper(int[] arr, int[] left, int[] right){
        int i = 0, j = 0, k = 0;
        while(i < left.length && j < right.length){
            if(left[i] <= right[j]){
                arr[k++] = left[i++];
            }
            else{
                arr[k++] = right[j++];
            }
        }
        while(i < left.length){
            arr[k++] = left[i++];
        }
        while(j < right.length){
            arr[k++] = right[j++];
        }
    }
    public static void mergeRecursive(int[] arr){
        if(arr.length < 2){
            return;
        }

        int mid = arr.length/2;
        int[] left = new int[mid];
        int[] right = new int[arr.length-mid];
        for(int i=0; i<mid; i++){
            left[i] = arr[i];
        }
        for(int i=mid; i<arr.length; i++){
            right[i-mid] = arr[i];
        }

        mergeRecursive(left);
        mergeRecursive(right);

        mergeHelper(arr, left, right);
    }
    public static void mergeSort(int[][] arr, int n){
        for(int i=0; i<n; i++){
            mergeRecursive(arr[i]);
        }
    }

    private static void quickHelper(int[] arr, int[] less, int[] equal, int[] greater){
        int i = 0, j = 0, k = 0, l = 0;
        while(i < less.length){
            arr[l++] = less[i++];
        }
        while(j < equal.length){
            arr[l++] = equal[j++];
        }
        while(k < greater.length){
            arr[l++] = greater[k++];
        }
    }
    public static void quickRecursive(int[] arr){
        if(arr.length <= 1){
            return;
        }

        int pivot = arr[arr.length-1];
        int size_l = 0, size_e = 0, size_g = 0;
        for(int i=0; i<arr.length; i++){
            if(arr[i] < pivot){
                size_l++;
            }
            else if(arr[i] == pivot){
                size_e++;
            }
            else{
                size_g++;
            }
        }
        int[] less = new int[size_l];
        int[] equal = new int[size_e];
        int[] greater = new int[size_g];

        int i = 0, j = 0, k = 0, l = 0;
        while(l < arr.length){
            if(arr[l] < pivot){
                less[i++] = arr[l++];
            }
            else if(arr[l] == pivot){
                equal[j++] = arr[l++];
            }
            else{
                greater[k++] = arr[l++];
            }
        }

        quickRecursive(less);
        quickRecursive(greater);

        quickHelper(arr, less, equal, greater);
    }
    public static void quickSort(int[][] arr, int n){
        for(int i=0; i<n; i++){
            quickRecursive(arr[i]);
        }
    }
}
