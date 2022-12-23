class Node {
    protected String element;
    protected Node next;

    Node(String input){
        element = input;
        next = null;
    }
}


class SLinkedList {
    protected Node head;
    protected int size;

    SLinkedList(){
        head = null;
        size = 0;
    }

    public void addFirst(String i){
        Node newNode = new Node(i);
        if (head != null) {
            newNode.next = head;
        }
        head = newNode;
        size++;
    }

    public void removeFirst() throws IllegalArgumentException{
        if(head == null){
            throw new IllegalArgumentException("list is empty");
        }
        Node temp = head;
        head = head.next;
        temp.next = null;
        size--;
    }

    public void printList(){
        if(size == 0){
            System.out.println("List is empty");
        }
        Node temp = head;
        while(temp != null){
            System.out.print(temp.element + " ");
            temp = temp.next;
        }
        System.out.println(" ");
    }
}
