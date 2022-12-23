class MyEntry {
    protected String element;
    protected int key;

    public MyEntry(String s, int k){
        this.element = s;
        this.key = k;
    }
    public String getElement(){
        return this.element;
    }
    public int getKey(){
        return this.key;
    }
}

class BSTNode {
    protected int key;
    protected MyEntry entryNode;
    protected BSTNode parent;
    protected BSTNode left;
    protected BSTNode right;

    public BSTNode(){
    }
    public BSTNode(MyEntry e){
        this.key = e.key;
        this.entryNode = e;
        this.parent = null;
        this.left = null;
        this.right = null;
    }
}
