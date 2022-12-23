import java.util.Random;

class Main {
    public static void main(String[] args){
        // problem 2.1
        System.out.println("---Problem 2.1---");

        // creates 10 entries with integer keys and prints them
        System.out.println(" ");
        System.out.println("~Creating 10 entries of characters from Naruto with integer keys...");
        MyEntry e1 = new MyEntry("Kakashi", 7);
        System.out.println("e1: " + e1.getElement()+ ", " + e1.getKey());
        MyEntry e2 = new MyEntry("Gara", 2);
        System.out.println("e2: " + e2.getElement()+ ", " + e2.getKey());
        MyEntry e3 = new MyEntry("Bee", 5);
        System.out.println("e3: " + e3.getElement()+ ", " + e3.getKey());
        MyEntry e4 = new MyEntry("Naruto", 1);
        System.out.println("e4: " + e4.getElement()+ ", " + e4.getKey());
        MyEntry e5 = new MyEntry("Sasuke", 15);
        System.out.println("e5: " + e5.getElement()+ ", " + e5.getKey());
        MyEntry e6 = new MyEntry("Lee", 19);
        System.out.println("e6: " + e6.getElement()+ ", " + e6.getKey());
        MyEntry e7 = new MyEntry("Hinata", 9);
        System.out.println("e7: " + e7.getElement()+ ", " + e7.getKey());
        MyEntry e8 = new MyEntry("Itachi", 11);
        System.out.println("e8: " + e8.getElement()+ ", " + e8.getKey());
        MyEntry e9 = new MyEntry("Madara", 4);
        System.out.println("e9: " + e9.getElement()+ ", " + e9.getKey());
        MyEntry e10 = new MyEntry("Jiraiya", 44);
        System.out.println("e10: " + e10.getElement()+ ", " + e10.getKey());

        // creates a bst
        System.out.println(" ");
        System.out.println("~Creating a bst...");
        BST myTree = new BST();

        // inserts 10 entries to bst
        System.out.println(" ");
        System.out.println("~Inserting e1, key 7...");
        myTree.insert(e1);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e2, key 2...");
        myTree.insert(e2);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e3, key 5...");
        myTree.insert(e3);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e4, key 1...");
        myTree.insert(e4);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e5, key 15...");
        myTree.insert(e5);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e6, key 19...");
        myTree.insert(e6);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e7, key 9...");
        myTree.insert(e7);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e8, key 11...");
        myTree.insert(e8);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e9, key 4...");
        myTree.insert(e9);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Inserting e10, key 44...");
        myTree.insert(e10);
        myTree.print();

        // searches for a entry in bst
        System.out.println(" ");
        System.out.println("~Searching BST for entry e10, key 44...");
        System.out.println(myTree.search(e10).key + ", " + myTree.search(e10).entryNode.element);

        // removes 3 entries from bst
        System.out.println(" ");
        System.out.println("~Removing e4, key 1 with 2 external nodes...");
        myTree.remove(e4);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Removing e6, key 19 with 1 external & 1 internal nodes...");
        myTree.remove(e6);
        myTree.print();
        System.out.println(" ");
        System.out.println("~Removing e1, key 7 with 2 internal nodes...");
        myTree.remove(e1);
        myTree.print();

        // inserts e11 with identical key
        MyEntry e11 = new MyEntry("Obito", 5);
        System.out.println(" ");
        System.out.println("*e11: " + e11.getElement()+ ", " + e11.getKey());
        System.out.println("~Inserting e11, identical key 5...");
        myTree.insert(e11);
        myTree.print();

        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Done---");


        // problem 2.2
        System.out.println(" ");
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.2---");

        // creates an array of size 100*32
        System.out.println(" ");
        System.out.println("~Creating an 2D array of size 100*32...");
        int sequence = 100;
        int bits = 32;
        int[][] myArray = new int[sequence][bits];

        // fills array with 0 and 1
        System.out.println(" ");
        System.out.println("~Filling array with randomly generated 0 and 1...");
        Random rand = new Random();
        int upperbound = 2;
        for(int i=0; i<sequence; i++){
            for(int j=0; j<bits; j++){
                myArray[i][j] = rand.nextInt(upperbound);
            }
        }

        // prints array
        System.out.println(" ");
        System.out.println("~Printing array...");
        System.out.println("(Array)");
        for(int i=0; i<sequence; i++){
            System.out.print(i+1 + ": ");
            for(int j=0; j<bits; j++){
                System.out.print(myArray[i][j] + " ");
            }
            System.out.println(" ");
        }
        System.out.println(" ");

        // copies filled array to a new array
        System.out.println(" ");
        System.out.println("~Copying randomly filled array to a new array manually...");
        int[][] myArray_copy = new int[sequence][bits];
        for(int i=0; i<sequence; i++){
            for(int j=0; j<bits; j++){
                myArray_copy[i][j] = myArray[i][j];
            }
        }

        // prints copy array
        System.out.println(" ");
        System.out.println("~Printing copy array...");
        System.out.println("(Copy Array)");
        for(int i=0; i<sequence; i++){
            System.out.print(i+1 + ": ");
            for(int j=0; j<bits; j++){
                System.out.print(myArray_copy[i][j] + " ");
            }
            System.out.println(" ");
        }
        System.out.println(" ");

        // sorts array using merge-sort
        System.out.println(" ");
        System.out.println("~Sorting array using *merge-sort*...");
        Sorter.mergeSort(myArray, sequence);
        // prints sorted array- ms
        System.out.println(" ");
        System.out.println("Printing sorted array...");
        System.out.println("(Merge-sort)");
        for(int i=0; i<sequence; i++){
            System.out.print(i+1 + ": ");
            for(int j=0; j<bits; j++){
                System.out.print(myArray[i][j] + " ");
            }
            System.out.println(" ");
        }
        System.out.println(" ");

        // sorts array using quick-sort
        System.out.println(" ");
        System.out.println("~Sorting copy array using *quick-sort*...");
        Sorter.quickSort(myArray_copy, sequence);
        // prints sorted array- qs
        System.out.println(" ");
        System.out.println("Printing sorted copy array...");
        System.out.println("(Quick-sort)");
        for(int i=0; i<sequence; i++){
            System.out.print(i+1 + ": ");
            for(int j=0; j<bits; j++){
                System.out.print(myArray_copy[i][j] + " ");
            }
            System.out.println(" ");
        }
        System.out.println(" ");

        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---END---");
    }
}
