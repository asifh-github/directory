import java.util.Scanner;

public class Main {
    public static void main(String[] args){
        //---Problem 2.1---
        System.out.println("---Problem 2.1---");

        //creates tree with initial node, 11
        System.out.println("***Creating tree..***");
        MyTree tree = new MyTree();

        //creates nodes for tree
        System.out.println(" ");
        System.out.println("***Creating nodes...***");
        TNode n11 = new TNode("Collect litter", 5);
        TNode n12 = new TNode("Direct visitors", 8);
        TNode n13 = new TNode("Plant saplings", 3);
        TNode n21 = new TNode("Report smoke sightings", 10);
        TNode n22 = new TNode("Record wildlife sightings", 7);
        TNode n23 = new TNode("Clean the station", 2);
        TNode n101 = new TNode("Buy snacks", 1);
        TNode n201 = new TNode("Prepare for bbq weekend", 4);

        //adds nodes to the tree
        System.out.println(" ");
        System.out.println("***Adding nodes...***");
        tree.addNode(n11);
        tree.addNode(n12);
        tree.addNode(n13);
        tree.addNode(n11, n21);
        tree.addNode(n11, n22);
        tree.addNode(n12, n23);
        tree.addNode(n101);
        tree.addNode(n101, n201);

        //prints the tree
        System.out.println(" ");
        System.out.println("***Printing tree...***");
        tree.print();

        //removes an internal node
        System.out.println(" ");
        System.out.println("***Removing an internal node...***");
        System.out.println(n101.getTask() + ".parent: " + n101.parent.getTask());
        System.out.println(n201.getTask() + ".parent: " + n201.parent.getTask());
        tree.removeNode(n101);
        System.out.println(" ");
        System.out.println("***Printing tree...***");
        tree.print();

        //removes an external node
        System.out.println(" ");
        System.out.println("***Removing an external node...***");
        System.out.println(n201.getTask() + ".parent: " + n201.parent.getTask());
        tree.removeNode(n201);
        System.out.println(" ");
        System.out.println("***Printing tree...***");
        tree.print();

        //size of tree
        System.out.println(" ");
        System.out.println("Size: " + tree.size());
        //records of tasks
        tree.tasks_record();


        //---Problem 2.2---
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.2---");

        //creates priority queue
        System.out.println(" ");
        System.out.println("***Creating priority queue...***");
        MyPriorityQueue pq = new MyPriorityQueue(tree);

        //creates an entry
        System.out.println(" ");
        System.out.println("***Creating an entry...***");
        MyEntry e1 = new MyEntry(n201);

        //adds an element to pq
        System.out.println(" ");
        System.out.println("***Adding an element to priority queue...***");
        pq.insert_entry(e1);
        System.out.println(" ");
        System.out.println("Size: " + pq.size());

        //removes element from pq
        System.out.println(" ");
        System.out.println("***Removing elements from priority queue...***");
        System.out.println(pq.remove());
        System.out.println(pq.remove());
        System.out.println(pq.remove());
        System.out.println(pq.remove());
        System.out.println(pq.remove());
        System.out.println(pq.remove());
        System.out.println(pq.remove());


        //---Problem 2.3---
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.3---");
    }
}
