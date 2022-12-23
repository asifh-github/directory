import java.util.Iterator;
import java.util.LinkedList;

class TNode {
    protected String task;
    protected int rank;
    protected TNode parent;
    protected LinkedList<TNode> children;

    public TNode(String s, int i){
        task = s;
        rank = i;
        parent = null;
        children = null;
    }
    public String getTask(){
        return task;
    }
    public int getRank(){
        return rank;
    }
}

class MyTree {
    protected TNode root;
    private int size;
    private int arr[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    public MyTree(){
        TNode rootNode = new TNode("Open up in the morning", 11);
        root = rootNode;
        size = 1;
        arr[10] = 1;
    }
    public int size(){
        return size;
    }
    public boolean isEmpty(){
        if(size == 0){
            return true;
        }
        return false;
    }
    public  boolean isInternal(TNode node){
        if(node.children == null){
            return false;
        }
        return true;
    }
    public  boolean isExternal(TNode node){
        if(node.children == null){
            return true;
        }
        return false;
    }
    public void tasks_record(){
        for(int i=0; i<arr.length; i++){
           System.out.println("Task level " + (i+1) + ": " + arr[i]);
        }

    }
    private void addNode_helper(TNode r, TNode ref, TNode node){
        if(r == null){
            return;
        }

        if(r.getTask() == ref.getTask()){
            if(r.children == null){
                r.children = new LinkedList<TNode>();
            }
            r.children.addLast(node);
            node.parent = r;
            size++;
            arr[node.getRank()-1]++;
            return;
        }

        if(r.children == null){
            return;
        }
        else {
            Iterator<TNode> iter = r.children.iterator();
            while (iter.hasNext()) {
                addNode_helper(iter.next(), ref, node);
            }
        }
    }
    public void addNode(TNode n){
        System.out.println("Adding task...");
        if(root == null){
            System.out.println("Root is null");
            return;
        }

        if(root.children == null){
            root.children = new LinkedList<TNode>();
        }
        root.children.addLast(n);
        n.parent = root;
        size++;
        arr[n.getRank()-1]++;
        System.out.println("Successful.");
    }
    public void addNode(TNode p, TNode n){
        System.out.println("Adding task...");
        if(root == null){
            System.out.println("Root is null");
            return;
        }
        addNode_helper(root, p, n);
        System.out.println("Successful.");
    }
    private void removeNode_helper(TNode r, TNode node){
        if(r == null){
            return;
        }

        if(r.getTask() == node.getTask()){
            if(isExternal(r)){
                r.parent.children.remove(node);
                r.parent = null;
            }
            else{
                for(int i=0; i<r.children.size(); i++){
                    TNode temp = r.children.get(i);
                    r.parent.children.addLast(temp);
                    temp.parent = r.parent;
                }
                r.parent.children.remove(node);
                r.parent = null;
                r.children = null;
            }
            size--;
            arr[node.getRank()-1]--;
            return;
        }

        if(r.children == null){
            return;
        }
        else {
            Iterator<TNode> iter = r.children.iterator();
            while (iter.hasNext()) {
                removeNode_helper(iter.next(), node);
            }
        }
    }
    public void removeNode(TNode n){
        System.out.println("Removing task...");
        if(root == null){
            System.out.println("Root is null");
            return;
        }
        removeNode_helper(root, n);
        System.out.println("Successful.");
    }
    private void print_preorder(TNode r){
        if(r == null){
            return;
        }

        System.out.println(r.getTask());

        if(r.children == null){
            return;
        }
        else {
            Iterator<TNode> iter = r.children.iterator();
            while (iter.hasNext()) {
                print_preorder(iter.next());
            }
        }
    }
    public void print(){
        System.out.println("Printing tree of tasks in pre-order...");
        print_preorder(root);
        System.out.println("Done.");
    }
}
