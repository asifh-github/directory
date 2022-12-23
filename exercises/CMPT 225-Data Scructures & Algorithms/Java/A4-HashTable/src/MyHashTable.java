import java.security.InvalidKeyException;

class HashEntry<K,V> {
    protected K key;
    protected V value;
    protected HashEntry<K,V> next;

    public HashEntry(K k, V v){
        key = k;
        value = v;
        next = null;
    }
}

class MyHashTable<K,V> {
    private int size;
    private int capacity;
    private HashEntry<K,V>[] bucket;

    public MyHashTable(int cap){
        size = 0;
        capacity = cap;
        bucket = new HashEntry[cap];
    }
    public int getSize(){
        return size;
    }
    public int getCapacity(){
        return capacity;
    }
    public boolean isEmpty(){
        if(size == 0){
            return true;
        }
        return false;
    }
    private int hashFunction(K key) {
        String k = key.toString();
        int hash_code = 0;
        for (int i = 0; i < k.length(); i++) {
            char temp = k.charAt(i);
            hash_code += (int)temp;
        }
        int bucket_index = hash_code % capacity;
        // if hash bucket_index == -ve
        bucket_index = bucket_index < 0 ? bucket_index * -1 : bucket_index;
        System.out.println("index: " + bucket_index);
        return bucket_index;
    }
    private int hashFunction_2(K key){
        String k = key.toString();
        int hash_code = 0;
        for (int i = 0; i < k.length(); i++) {
            char temp = k.charAt(i);
            hash_code += (((int)temp) * ((41)^(k.length()-1-i)));
        }
        int bucket_index = hash_code % capacity;
        // if hash bucket_index == -ve
        bucket_index = bucket_index < 0 ? bucket_index * -1 : bucket_index;
        System.out.println("index(2): " + bucket_index);
        return bucket_index;
    }
    private void checkKey(K key) throws InvalidKeyException{
        if(key == null){
            throw new InvalidKeyException("Key is null...");
        }
    }
    private void checkHash(int index) throws ArrayIndexOutOfBoundsException{
        if(index >= capacity || index < 0) {
            throw new ArrayIndexOutOfBoundsException("Generated key-index is out-of-bound...");
        }
    }
    private void rehash() throws InvalidKeyException {
        System.out.println("Rehashing/doubling the capacity of bucket...");
        System.out.println(" ");
        HashEntry<K,V>[] old = bucket;
        size = 0;
        capacity = 2 * capacity;
        bucket = new HashEntry[capacity];
        for(int i=0; i<old.length; i++){
            HashEntry<K,V> head = old[i];
            while(head != null){
                addEntry(head.key, head.value);
                head = head.next;
            }
        }
    }
    private void rehash_2() throws InvalidKeyException {
        System.out.println("Rehashing/doubling the capacity of bucket...");
        System.out.println(" ");
        HashEntry<K,V>[] old = bucket;
        size = 0;
        capacity = 2 * capacity;
        bucket = new HashEntry[capacity];
        for(int i=0; i<old.length; i++){
            HashEntry<K,V> head = old[i];
            while(head != null){
                addEntry_2(head.key, head.value);
                head = head.next;
            }
        }
    }
    public V getEntry(K key) throws InvalidKeyException{
        checkKey(key);
        int bIndex = hashFunction(key);
        checkHash(bIndex);
        HashEntry<K,V> head = bucket[bIndex];
        while(head != null){
            if(head.key.equals(key)){
                return head.value;
            }
            head = head.next;
        }
        return null;
    }
    public V getEntry_2(K key) throws InvalidKeyException{
        checkKey(key);
        int bIndex = hashFunction_2(key);
        checkHash(bIndex);
        HashEntry<K,V> head = bucket[bIndex];
        while(head != null){
            if(head.key.equals(key)){
                return head.value;
            }
            head = head.next;
        }
        return null;
    }
    public void addEntry(K key, V value) throws InvalidKeyException{
        checkKey(key);
        int bIndex = hashFunction(key);
        checkHash(bIndex);
        HashEntry<K,V> head = bucket[bIndex];
        while(head != null){
            if(head.key.equals(key)){
                head.value = value;
                return;
            }
            head = head.next;
        }
        head = bucket[bIndex];
        HashEntry<K,V> newEntry = new HashEntry<K,V>(key, value);
        newEntry.next = head;
        bucket[bIndex] = newEntry;
        size++;
        //implements load-factor
        if((1.0*size)/capacity >= 0.9){
            rehash();
        }
    }
    public void addEntry_2(K key, V value) throws InvalidKeyException{
        checkKey(key);
        int bIndex = hashFunction_2(key);
        checkHash(bIndex);
        HashEntry<K,V> head = bucket[bIndex];
        while(head != null){
            if(head.key.equals(key)){
                head.value = value;
                return;
            }
            head = head.next;
        }
        head = bucket[bIndex];
        HashEntry<K,V> newEntry = new HashEntry<K,V>(key, value);
        newEntry.next = head;
        bucket[bIndex] = newEntry;
        size++;
        //implements load-factor
        if((1.0*size)/capacity >= 0.9){
            rehash_2();
        }
    }
    public V removeEntry(K key) throws InvalidKeyException{
        checkKey(key);
        int bIndex = hashFunction(key);
        checkHash(bIndex);
        HashEntry<K,V> head = bucket[bIndex];
        HashEntry<K,V> previous = null;
        while(head != null){
            if(head.key.equals(key)){
                break;
            }
            previous = head;
            head = head.next;
        }
        if(head == null){
            return null;
        }
        if(previous != null){
            previous.next = head.next;
        }
        else{
            bucket[bIndex] = head.next;
        }
        size--;
        return head.value;
    }
    public V removeEntry_2(K key) throws InvalidKeyException{
        checkKey(key);
        int bIndex = hashFunction_2(key);
        checkHash(bIndex);
        HashEntry<K,V> head = bucket[bIndex];
        HashEntry<K,V> previous = null;
        while(head != null){
            if(head.key.equals(key)){
                break;
            }
            previous = head;
            head = head.next;
        }
        if(head == null){
            return null;
        }
        if(previous != null){
            previous.next = head.next;
        }
        else{
            bucket[bIndex] = head.next;
        }
        size--;
        return head.value;
    }
    public int n_Rehash(){
        int r = (capacity/size) - 1;
        return r;
    }
    public int n_LongestChain(){
        int max = 0;
        for(int i=0; i<bucket.length; i++){
            int h = 0;
            HashEntry<K,V> head = bucket[i];
            while(head != null){
                h++;
                head = head.next;
            }
            if(h >= max){
                max = h;
            }
        }
        return max;
    }
    public int occupied(){
        int filled = 0;
        for(int i=0; i<bucket.length; i++){
            if(bucket[i] != null){
                filled++;
            }
        }
        return filled;
    }
    public int free(){
        int empty = capacity-occupied();
        return empty;
    }
    public int collisions(){
        int c = size-occupied();
        return c;
    }
}
