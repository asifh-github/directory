class BST {
    private BSTNode root;
    private int size;
//    // for median
    private int keyIndex;
    private int[] keys;

    public BST(){
        // root starts as external blank node
        this.root = new BSTNode();
        this.size = 0;
    }
    public BSTNode getRoot(){
        return this.root;
    }
    public int getSize(){
        return this.size;
    }
    public boolean isInternal(BSTNode n){
        if(n.left == null && n.right == null){
            return false;
        }
        return true;
    }
    public boolean isExternal(BSTNode n){
        if(n.left == null && n.right == null){
            return true;
        }
        return false;
    }
    public BSTNode treeSearch(int k, BSTNode r){
        // for external blank nodes
        if(isExternal(r)){
            return r;
        }

        if(k < r.key){
            return treeSearch(k, r.left);
        }
        else if(k > r.key){
            return treeSearch(k, r.right);
        }
        return r;
    }
    // wrapper for treeSearch(...)
    public BSTNode search(MyEntry e){
        return treeSearch(e.key, this.root);
    }
    public BSTNode treeInsert(int k, MyEntry e, BSTNode r){
        BSTNode node = treeSearch(k, r);
        if(isInternal(node)){
            // implements corner-case for identical keys
            return treeInsert(k, e, node.left);
        }
        node.key = k;
        node.entryNode= e;
        // adds blank external nodes
        node.left = new BSTNode();
        node.right = new BSTNode();
        node.left.parent = node;
        node.right.parent = node;
        this.size++;
        return r;
    }
    // wrapper for treeInsert(...)
    public BSTNode insert(MyEntry e){
        return treeInsert(e.key, e, this.root);
    }
    // helper for treeRemove(...)
    private BSTNode helperRemove(BSTNode n){
        if(isExternal(n)){
            return n.parent;
        }
        return helperRemove(n.left);
    }
    public BSTNode treeRemove(int k, BSTNode r){
        BSTNode node = treeSearch(k, r);
        // performs if node has 2 ext. nodes
        if(isExternal(node.left) && isExternal(node.right)){
            // converts node to ext. node & nulls the ext. nodes
            node.key = 0;
            node.entryNode = null;
            node.left = null;
            node.right = null;
        }
        // performs if node has 2 int. nodes
        else if(isInternal(node.left) && isInternal(node.right)){
            // gets the left-most descendant
            BSTNode leftMostD = helperRemove(node.right);
            // swaps the key and element with node (technically removing node)
            node.key = leftMostD.key;
            node.entryNode = leftMostD.entryNode;
            // removes left-most descendant
            // performs nothing if left-most descendant has 2 ext. nodes
            if(isExternal(leftMostD.left) && isExternal(leftMostD.right)){
            }
            // performs if left-most descendant has 1 ext. & 1 int. nodes
            else{
                // int. node replaces node
                // operations if left node is int.
                if(isInternal(leftMostD.left)){
                    if(leftMostD.parent.left.key == leftMostD.key){
                        leftMostD.parent.left = leftMostD.left;
                    }
                    else if(leftMostD.parent.right.key == leftMostD.key){
                        leftMostD.parent.right = leftMostD.left;
                    }
                    leftMostD.left.parent = leftMostD.parent;
                }
                // operations if right node is int.
                else if(isInternal(leftMostD.right)){
                    if(leftMostD.parent.left.key == leftMostD.key){
                        leftMostD.parent.left = leftMostD.right;
                    }
                    else if(leftMostD.parent.right.key == leftMostD.key){
                        leftMostD.parent.right = leftMostD.right;
                    }
                    leftMostD.right.parent = leftMostD.parent;
                    leftMostD.parent = null;
                }
                // converts left-most descendant to null
                leftMostD.key = 0;
                leftMostD.entryNode = null;
                leftMostD.left = null;
                leftMostD.right = null;
            }
        }
        // performs if node has 1 ext. & 1 int. nodes
        else{
            // int. node replaces node
            // operations if left node is int.
            if(isInternal(node.left)){
                if(node.parent.left.key == node.key){
                    node.parent.left = node.left;
                }
                else if(node.parent.right.key == node.key){
                    node.parent.right = node.left;
                }
                node.left.parent = node.parent;
            }
            // operations if right node is int.
            else if(isInternal(node.right)){
                if(node.parent.left.key == node.key){
                    node.parent.left = node.right;
                }
                else if(node.parent.right.key == node.key){
                    node.parent.right = node.right;
                }
                node.right.parent = node.parent;
            }
            // converts node to null
            node.key = 0;
            node.entryNode = null;
            node.parent = null;
            node.left = null;
            node.right = null;
        }
        this.size--;
        return r;
    }
    // wrapper for treeRemove(...)
    public BSTNode remove(MyEntry e){
        return treeRemove(e.key, this.root);
    }
    public int totalRecursive(BSTNode n){
        if(isExternal(n)){
            return 0;
        }
        return n.key + totalRecursive(n.left) + totalRecursive(n.right);
    }
    public float mean(){
        return (float)totalRecursive(this.root)/this.size;
    }
    // used global variables to calculate median~ not a good practice
//    public void medianRecursive(BSTNode n){
//        if(isExternal(n)){
//            return;
//        }
//
//        medianRecursive(n.left);
//        this.keys[this.keyIndex++] = n.key;
//        medianRecursive(n.right);
//    }
//    public float median(){
//        this.keyIndex = 0;
//        this.keys = new int[this.size];
//        medianRecursive(this.root);
//        int index = (this.size - 1)/2;
//        if(this.size % 2 == 1){
//            return keys[index];
//        }
//        else{
//            return (float)(keys[index] + keys[index+1])/2;
//        }
//    }
//    public int medianRecursive(int count, int index, int mid, int prev, BSTNode n){
//        if(isExternal(n)){
//            return 0;
//        }
//
//        count ++;
//        mid = n.key + prev;
//        medianRecursive(count,index, mid, n.key, n.left);
//        //prev = n.key;
//        System.out.println("*count: " + count + " *index: " +" *mid :" + mid + index + " *key: " + n.key + " *prev: " + prev);
//        if(count == index){
//            return mid;
//        }
//        medianRecursive(count,index,0, n.key, n.right);
//        return -1;
//    }
//    public float median(){
//        int index;
//        if(this.size % 2 != 0){
//            index = (this.size+1) / 2;
//        }
//        else{
//            index = (this.size/2) + 1;
//        }
//
//        System.out.println("index: " + index);
//        float mid = (float)medianRecursive(0, index, 0, 0, this.root);
//        System.out.println("*mid: " + mid);
//
//        if(this.size % 2 != 0){
//            return mid;
//        }
//        else{
//            return mid/2;
//        }
//    }
//    public BSTNode treeSearch(int k, BSTNode r){
//        // for external blank nodes
//        if(isExternal(r)){
//            return r;
//        }
//
//        if(k < r.key){
//            return treeSearch(k, r.left);
//        }
//        else if(k > r.key){
//            return treeSearch(k, r.right);
//        }
//        return r;
//    }
    public float medianRecursive(int count, int size, int prev, BSTNode n){
        if(isExternal(n)){
            return 0;
        }
        count++;
        medianRecursive(count, size, n.key, n.left);
        System.out.println("Count: " + count + " Size: " + size + " Key: " + n.key + " Prev: " + prev);
        int odd = (size+1)/2;
        int even = (size/2)+1;
        System.out.println("Size->Odd: " + odd + " Size->Even: " + even);
        if(size % 2 != 0 && count == odd){
            return (float)n.key;
        }
        else if(size % 2 == 0 && count == even){
            return  (float)(n.key+prev);
        }
        medianRecursive(count, size, n.key, n.right);
        return 0;
    }
//    public float medianIterative(int size, BSTNode n){
//        if(isExternal(n)){
//            return 0;
//        }
//
//        int count = 0;
//        BSTNode current = n;
//        BSTNode previous = null;
//        BSTNode predecessor = null;
//        while(isInternal(current)){
//            if(isExternal(current.left)){
//                count++;
//                System.out.println("Count: " + count + " Key: " + current.key);
//                if(size % 2 != 0 && count == (size+1)/2){
//                    return current.key;
//                }
//                else if(size % 2 == 0 && count == (size/2)+1){
//                    return (float)(previous.key+current.key)/2;
//                }
//                previous = current;
//                current = current.right;
//            }
//            else{
//                predecessor = current.left;
//                while(isInternal(predecessor.right) && predecessor.right != current){
//                    predecessor = predecessor.right;
//                }
//
//                if(isExternal(predecessor.right)){
//                    predecessor.right = current;
//                    current = current.left;
//                }
//                else{
//                    predecessor.right.left = null;
//                    predecessor.right.right = null;
//                    previous = predecessor;
//                    count++;
//                    System.out.println("Count: " + count + " Key: " + current.key);
//                    if(size % 2 != 0 && count == (size+1)/2){
//                        return current.key;
//                    }
//                    else if(size % 2 == 0 && count == (size/2)+1){
//                        return (float)(previous.key+current.key)/2;
//                    }
//                    previous = current;
//                    current = current.right;
//                }
//            }
//        }
//        return -1;
//    }
    public float median(){
        return medianRecursive(0, size, 0, root);
    }
    // ref: 2d print idea from geeksforgeeks
    public void printAntiInorder(BSTNode r, int dash){
        if(isExternal(r)){
            return;
        }

        dash += 10;
        printAntiInorder(r.right, dash);
        System.out.println(" ");
        for(int i=10; i<dash; i++){
            System.out.print(" ");
        }
        System.out.println(r.key);
        printAntiInorder(r.left, dash);
    }
    public void print(){
        System.out.println("2D print of BST...");
        System.out.println("***************RIGHT-SIDE****************");
        System.out.print("v-root");
        printAntiInorder(this.root, 0);
        System.out.println("***************LEFT-SIDE*****************");
        System.out.println("Size: " + getSize());
        System.out.println("Mean: " + mean());
        System.out.println("Median: " + median());
    }
}
