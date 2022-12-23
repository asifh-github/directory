import java.util.Iterator;
import java.util.LinkedList;

class MyEntry {
    protected String task;
    protected int rank;

    public MyEntry(TNode n){
        task = n.getTask();
        rank = n.getRank();
    }
}

class MyPriorityQueue {
    private LinkedList<MyEntry> pq_list;

    public MyPriorityQueue(MyTree t){
        pq_list = new LinkedList<MyEntry>();
        insert_tree(t);
    }
    public int size(){
        return pq_list.size();
    }
    private void insert_tree_helper(TNode r){
        if(r == null){
            return;
        }

        MyEntry temp = new MyEntry(r);
        insert_entry(temp);

        if(r.children == null){
            return;
        }
        else {
            Iterator<TNode> iter = r.children.iterator();
            while (iter.hasNext()) {
                insert_tree_helper(iter.next());
            }
        }
    }
    public void insert_entry(MyEntry e){
        System.out.println("Adding entry to priority queue...");
        if(pq_list.size() == 0){
            pq_list.addFirst(e);
            System.out.println("Successful.");
        }
        else {
            int key = e.rank;
            for (int i = 0; i < pq_list.size(); i++) {
                int curr_key = pq_list.get(i).rank;
                int curr_position = i;
                if(curr_position >= 0 && key > curr_key){
                    pq_list.add(i, e);
                    System.out.println("Successful.");
                    return;
                }
                else if(i == pq_list.size()-1){
                    pq_list.addLast(e);
                    System.out.println("Successful.");
                    return;
                }
            }
        }
    }
    public void insert_tree(MyTree t){
        System.out.println("Adding tree to priority queue...");
        if(t.root == null){
            System.out.println("Tree is null");
        }
        insert_tree_helper(t.root);
        System.out.println("Successful.");
    }
    public String remove() throws RuntimeException {
        if(pq_list.size() == 0){
            throw new RuntimeException("PQList is empty");
        }
        System.out.print("Current high priority task: ");
        MyEntry temp = pq_list.removeFirst();
        return (temp.task + ',' + " Rank: " + temp.rank);
    }
}
