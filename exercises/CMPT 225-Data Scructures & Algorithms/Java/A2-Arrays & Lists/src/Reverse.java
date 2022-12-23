class Reverse {
    public static SLinkedList iterative(SLinkedList list){
        Node head = list.head;
        if(head == null || head.next == null){
            return list;
        }

        Node currentList = head.next;
        head.next = null;
        Node reverseList = head;
        while(currentList != null){
            Node temp = currentList;
            currentList = currentList.next;
            temp.next = reverseList;
            reverseList = temp;
        }
        list.head = reverseList;
        return list;
    }


    public static SLinkedList recursive(SLinkedList list){
        if(list.head == null || list.head.next == null){
            return list;
        }

        SLinkedList l_temp = new SLinkedList();
        l_temp.head = list.head.next;
        SLinkedList newList = recursive(l_temp);
        return newList;
    }
}
